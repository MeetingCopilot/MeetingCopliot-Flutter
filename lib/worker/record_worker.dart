import 'dart:async';
import 'dart:isolate';

import 'package:record/record.dart';

class RecordWorker {
  final ReceivePort _responses;
  final SendPort _commands;

  bool _closed = false;

  static String _deviceId = '';

  static final AudioRecorder _audioRecorder = AudioRecorder();

  static final StreamController<String> _transcriberStream =
      StreamController<String>();

  Stream<String> get conversationStream => _transcriberStream.stream;

  static Future<List<InputDevice>> listDevices() async {
    List<InputDevice> devices = await _audioRecorder.listInputDevices();
    return devices;
  }

  void startRecord() {
    if (_closed) {
      throw StateError('Closed');
    }
    _commands.send(('startRecord'));
  }

  static Future<RecordWorker> spawn(String deviceId) async {
    _deviceId = deviceId;
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

    return RecordWorker._(sendPort, receivePort);
  }

  RecordWorker._(this._commands, this._responses) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  static void _handleCommandsToIsolate(
      ReceivePort receivePort, SendPort sendPort) {
    receivePort.listen((message) {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }

      if (message == 'startRecord') {
        RecordConfig config = RecordConfig(
          sampleRate: 16000,
          numChannels: 1,
          encoder: AudioEncoder.pcm16bits,
          device: InputDevice(id: _deviceId, label: 'Microphone'),
        );

        _audioRecorder.startStream(config).then((stream) => {
              stream.listen((data) {
                // send to transcriber
                sendPort.send(data);
              })
            });
        String transcriberResult = '';

        try {
          sendPort.send(transcriberResult);
        } catch (e) {
          sendPort.send((RemoteError(e.toString(), '')));
        }
      }
    });
  }

  void _handleResponsesFromIsolate(dynamic result) {
    if (result is RemoteError) {
      _transcriberStream.sink.add('处理失败');
    } else {
      _transcriberStream.sink.add(result as String);
    }
    if (_closed) {
      _responses.close();
      _transcriberStream.close();
    }
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      _responses.close();
      _transcriberStream.close();
    }
  }
}
