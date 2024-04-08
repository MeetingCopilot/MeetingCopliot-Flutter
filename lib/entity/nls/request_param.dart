import 'package:meeting_copilot_flutter/entity/nls/request/request_header.dart';
import 'package:meeting_copilot_flutter/entity/nls/request/start_transcription.dart';

class RequestParam {
  RequestHeader header;

  StartTranscription payload;

  RequestParam({
    required this.header,
    required this.payload,
  });

  factory RequestParam.fromMap(Map<String, dynamic> map) {
    return RequestParam(
      header: RequestHeader.fromMap(map['header']),
      payload: StartTranscription.fromMap(map['payload']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'header': header.toJson(),
      'payload': payload.toJson(),
    };
  }
}
