class StartTranscription {
  final String format;
  final String sampleRate;
  final bool enableIntermediateResult;
  final bool enablePunctuationPrediction;
  final bool enableInverseTextNormalization;
  final String customizationId;
  final String vocabularyId;
  final String maxSentenceSilence;
  final bool enableWords;
  final bool disfluency;
  final double speechNoiseThreshold;
  final bool enableSemanticSentenceDetection;

  StartTranscription({
    required this.format,
    required this.sampleRate,
    required this.enableIntermediateResult,
    required this.enablePunctuationPrediction,
    required this.enableInverseTextNormalization,
    required this.customizationId,
    required this.vocabularyId,
    required this.maxSentenceSilence,
    required this.enableWords,
    required this.disfluency,
    required this.speechNoiseThreshold,
    required this.enableSemanticSentenceDetection,
  });

  factory StartTranscription.fromMap(Map<String, dynamic> map) {
    return StartTranscription(
      format: map['format'] as String,
      sampleRate: map['sample_rate'] as String,
      enableIntermediateResult: map['enable_intermediate_result'] as bool,
      enablePunctuationPrediction: map['enable_punctuation_prediction'] as bool,
      enableInverseTextNormalization:
          map['enable_inverse_text_normalization'] as bool,
      customizationId: map['customization_id'] as String,
      vocabularyId: map['vocabulary_id'] as String,
      maxSentenceSilence: map['max_sentence_silence'] as String,
      enableWords: map['enable_words'] as bool,
      disfluency: map['disfluency'] as bool,
      speechNoiseThreshold: map['speech_noise_threshold'] as double,
      enableSemanticSentenceDetection:
          map['enable_semantic_sentence_detection'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'format': format,
      'sample_rate': sampleRate,
      'enable_intermediate_result': enableIntermediateResult,
      'enable_punctuation_prediction': enablePunctuationPrediction,
      'enable_inverse_text_normalization': enableInverseTextNormalization,
      'customization_id': customizationId,
      'vocabulary_id': vocabularyId,
      'max_sentence_silence': maxSentenceSilence,
      'enable_words': enableWords,
      'disfluency': disfluency,
      'speech_noise_threshold': speechNoiseThreshold,
      'enable_semantic_sentence_detection': enableSemanticSentenceDetection,
    };
  }
}
