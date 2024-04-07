import 'dart:async';
import 'dart:isolate';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meeting_copilot_flutter/entity/conversation.dart';

class GeminiWorker {
  final ReceivePort _responses;
  final SendPort _commands;

  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  static final List<Content> _history = [];

  static final StreamController<Conversation> _conversation =
      StreamController<Conversation>();

  Stream<Conversation> get conversationStream => _conversation.stream;

  void chat(String question) {
    if (_closed) {
      throw StateError('Closed');
    }
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, question));
  }

  static Future<GeminiWorker> spawn(List<Content> history) async {
    _history.addAll(history);
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();

    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };
    try {
      await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    return GeminiWorker._(sendPort, receivePort);
  }

  GeminiWorker._(this._commands, this._responses) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  void _handleResponsesFromIsolate(dynamic conversation) {
    final (int id, Conversation? response) =
        conversation as (int, Conversation?);
    final completer = _activeRequests.remove(id)!;

    if (response is RemoteError) {
      completer.completeError(response as Object);
      _conversation.sink
          .add(Conversation(question: response!.question, answer: '处理失败'));
    } else {
      completer.complete(response);
      _conversation.sink.add(response!);
    }

    if (_closed && _activeRequests.isEmpty) {
      _responses.close();
      _conversation.close();
    }
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    final ChatSession chatSession = _initChatSession();
    _handleCommandsToIsolate(receivePort, sendPort, chatSession);
  }

  static void _handleCommandsToIsolate(
      ReceivePort receivePort, SendPort sendPort, ChatSession chatSession) {
    receivePort.listen((message) {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }
      final (int id, String question) = message as (int, String);
      try {
        _chat(chatSession, question)
            .then((conversation) => sendPort.send((id, conversation)));
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  static Future<Conversation?> _chat(
      ChatSession chatSession, String question) async {
    var content = Content.text(question);
    try {
      GenerateContentResponse response = await chatSession.sendMessage(content);
      return Conversation(question: question, answer: response.text ?? '处理失败');
    } catch (e) {
      return Conversation(question: question, answer: '处理失败');
    }
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) {
        _responses.close();
        _conversation.close();
      }
    }
  }

  static ChatSession _initChatSession() {
    const String apiKey = 'AIzaSyDw5jXunz0bX3q5gu8TaSkRgIk88G1T940';
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 2000),
    );

    return model.startChat(history: _history);
  }
}
