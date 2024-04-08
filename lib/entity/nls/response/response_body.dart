class ResponseBody {
  final int index;
  final int time;

  ResponseBody({
    required this.index,
    required this.time,
  });

  factory ResponseBody.fromMap(Map<String, dynamic> map) {
    return ResponseBody(
      index: map['index'] as int,
      time: map['time'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'time': time,
    };
  }
}
