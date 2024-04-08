import 'package:meeting_copilot_flutter/entity/nls/response/response_body.dart';
import 'package:meeting_copilot_flutter/entity/nls/response/transcription_result_changed.dart';

class SentenceEnd extends ResponseBody {
  static const String name = 'SentenceEnd';

  final int beginTime;
  final String result;
  final double confidence;
  final List<Word> words;
  final int status;
  final StashResult stashResult;

  SentenceEnd({
    required super.index,
    required super.time,
    required this.beginTime,
    required this.result,
    required this.confidence,
    required this.words,
    required this.status,
    required this.stashResult,
  });

  factory SentenceEnd.fromMap(Map<String, dynamic> map) {
    return SentenceEnd(
      index: map['index'] as int,
      time: map['time'] as int,
      beginTime: map['beginTime'] as int,
      result: map['result'] as String,
      confidence: map['confidence'] as double,
      words: (map['words'] as List).map((word) => Word.fromMap(word)).toList(),
      status: map['status'] as int,
      stashResult: StashResult.fromMap(map['stash_result']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'time': time,
      'beginTime': beginTime,
      'result': result,
      'confidence': confidence,
      'words': words.map((word) => word.toJson()).toList(),
      'status': status,
      'stash_result': stashResult.toJson(),
    };
  }
}

class StashResult {
  final int sentenceId;
  final int beginTime;
  final String text;
  final int currentTime;

  StashResult({
    required this.sentenceId,
    required this.beginTime,
    required this.text,
    required this.currentTime,
  });

  factory StashResult.fromMap(Map<String, dynamic> map) {
    return StashResult(
      sentenceId: map['sentenceId'] as int,
      beginTime: map['beginTime'] as int,
      text: map['text'] as String,
      currentTime: map['currentTime'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sentenceId': sentenceId,
      'beginTime': beginTime,
      'text': text,
      'currentTime': currentTime,
    };
  }
}
