import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiChatHandler {
  late final GenerativeModel _model;

  final List<Content> _history = [];

  GeminiChatHandler() {
    const apiKey = 'AIzaSyDw5jXunz0bX3q5gu8TaSkRgIk88G1T940';
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 2000),
    );
  }

  Future<String?> chat(String question) async {
    final chat = _model.startChat(history: _history);
    var content = Content.text(question);
    var response = await chat.sendMessage(content);
    return response.text;
  }
}
