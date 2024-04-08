import 'package:meeting_copilot_flutter/entity/nls/response/response_body.dart';

class TranscriptionResultChanged extends ResponseBody {
  static const String name = 'TranscriptionResultChanged';

  final String result;
  final List<Word> words;

  TranscriptionResultChanged({
    required super.index,
    required super.time,
    required this.result,
    required this.words,
  });

  factory TranscriptionResultChanged.fromMap(Map<String, dynamic> map) {
    return TranscriptionResultChanged(
      index: map['index'] as int,
      time: map['time'] as int,
      result: map['result'] as String,
      words: (map['words'] as List).map((word) => Word.fromMap(word)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'time': time,
      'result': result,
      'words': words.map((word) => word.toJson()).toList(),
    };
  }
}

class Word {
  final String text;
  final int startTime;
  final int endTime;

  Word({
    required this.text,
    required this.startTime,
    required this.endTime,
  });

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      text: map['text'] as String,
      startTime: map['startTime'] as int,
      endTime: map['endTime'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
