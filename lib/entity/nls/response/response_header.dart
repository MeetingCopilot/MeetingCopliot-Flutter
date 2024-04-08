import 'dart:ffi';

class ResponseHeader {
  final String messageId;
  final String taskId;
  final String namespace;
  final String name;
  final int status;
  final String statusMessage;

  ResponseHeader({
    required this.messageId,
    required this.taskId,
    required this.namespace,
    required this.name,
    required this.status,
    required this.statusMessage,
  });

  factory ResponseHeader.fromMap(Map<String, dynamic> map) {
    return ResponseHeader(
      messageId: map['message_id'] as String,
      taskId: map['task_id'] as String,
      namespace: map['namespace'] as String,
      name: map['name'] as String,
      status: map['status'] as int,
      statusMessage: map['status_message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'task_id': taskId,
      'namespace': namespace,
      'name': name,
      'status': status,
      'status_message': statusMessage,
    };
  }
}
