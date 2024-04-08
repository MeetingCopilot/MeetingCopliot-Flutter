class RequestHeader {
  String appKey;

  String messageId;

  String taskId;

  String namespace;

  String name;

  RequestHeader({
    required this.appKey,
    required this.messageId,
    required this.taskId,
    required this.namespace,
    required this.name,
  });

  factory RequestHeader.fromMap(Map<String, dynamic> map) {
    return RequestHeader(
      appKey: map['appkey'] as String,
      messageId: map['message_id'] as String,
      taskId: map['task_id'] as String,
      namespace: map['namespace'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'appkey': appKey,
        'message_id': messageId,
        'task_id': taskId,
        'namespace': namespace,
        'name': name,
      };
}
