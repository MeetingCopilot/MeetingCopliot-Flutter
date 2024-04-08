import 'package:meeting_copilot_flutter/entity/nls/response/response_body.dart';

class SentenceBegin extends ResponseBody {
  static const String name = 'SentenceBegin';

  SentenceBegin({required super.index, required super.time});

  factory SentenceBegin.fromMap(Map<String, dynamic> map) {
    return SentenceBegin(
      index: map['index'] as int,
      time: map['time'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'time': time,
    };
  }
}
