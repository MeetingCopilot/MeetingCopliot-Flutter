import 'package:meeting_copilot_flutter/entity/nls/response/response_body.dart';
import 'package:meeting_copilot_flutter/entity/nls/response/response_header.dart';

class ResponseParam {
  final ResponseHeader header;
  final ResponseBody payload;

  ResponseParam({
    required this.header,
    required this.payload,
  });

  factory ResponseParam.fromMap(Map<String, dynamic> map) {
    return ResponseParam(
      header: ResponseHeader.fromMap(map['header']),
      payload: ResponseBody.fromMap(map['payload']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'header': header.toJson(),
      'payload': payload.toJson(),
    };
  }
}
