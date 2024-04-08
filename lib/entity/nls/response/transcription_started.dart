class TranscriptionStarted {
  static const String name = 'TranscriptionStarted';

  final String sessionId;

  TranscriptionStarted({
    required this.sessionId,
  });

  factory TranscriptionStarted.fromMap(Map<String, dynamic> map) {
    return TranscriptionStarted(
      sessionId: map['session_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
    };
  }
}
