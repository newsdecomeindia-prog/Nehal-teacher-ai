/// Multi-modal models for Voice (STT/TTS) and Image/Homework Scan integration.

enum AudioFormat {
  wav,
  mp3,
  aac,
  ogg,
  flac,
}

enum TTSPlayerState {
  stopped,
  buffering,
  playing,
  paused,
  completed,
  error,
}

enum ChildSafetyScanStatus {
  safe,
  flaggedNonEducational,
  flaggedPiiDetected,
  rejected,
}

class ChildVoiceParameters {
  final double pitchFrequencyHz;
  final double speedRate;
  final String ageGroup;

  ChildVoiceParameters({
    this.pitchFrequencyHz = 250.0,
    this.speedRate = 0.85,
    this.ageGroup = '6-7',
  });

  Map<String, dynamic> toJson() => {
        'pitch_frequency_hz': pitchFrequencyHz,
        'speed_rate': speedRate,
        'age_group': ageGroup,
      };

  factory ChildVoiceParameters.fromJson(Map<String, dynamic> json) {
    return ChildVoiceParameters(
      pitchFrequencyHz: (json['pitch_frequency_hz'] as num?)?.toDouble() ?? 250.0,
      speedRate: (json['speed_rate'] as num?)?.toDouble() ?? 0.85,
      ageGroup: json['age_group'] as String? ?? '6-7',
    );
  }
}

class STTAudioPayload {
  final String studentId;
  final String? audioBase64;
  final String? audioUrl;
  final String audioFormat;
  final int sampleRate;
  final String languageHint;
  final ChildVoiceParameters? childVoiceParams;

  STTAudioPayload({
    required this.studentId,
    this.audioBase64,
    this.audioUrl,
    this.audioFormat = 'wav',
    this.sampleRate = 16000,
    this.languageHint = 'en',
    this.childVoiceParams,
  });

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'audio_base64': audioBase64,
        'audio_url': audioUrl,
        'audio_format': audioFormat,
        'sample_rate': sampleRate,
        'language_hint': languageHint,
        'child_voice_params': (childVoiceParams ?? ChildVoiceParameters()).toJson(),
      };
}

class STTResponse {
  final String transcribedText;
  final String detectedLanguage;
  final double confidence;
  final double durationSeconds;
  final bool piiStripped;
  final bool offlineFallback;

  STTResponse({
    required this.transcribedText,
    required this.detectedLanguage,
    required this.confidence,
    required this.durationSeconds,
    this.piiStripped = true,
    this.offlineFallback = false,
  });

  factory STTResponse.fromJson(Map<String, dynamic> json) {
    return STTResponse(
      transcribedText: json['transcribed_text'] as String,
      detectedLanguage: json['detected_language'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      durationSeconds: (json['duration_seconds'] as num).toDouble(),
      piiStripped: json['pii_stripped'] as bool? ?? true,
      offlineFallback: json['offline_fallback'] as bool? ?? false,
    );
  }
}

class TTSRequest {
  final String studentId;
  final String text;
  final String language;
  final String voicePersona;
  final double speed;
  final double pitch;
  final String audioFormat;

  TTSRequest({
    required this.studentId,
    required this.text,
    this.language = 'en',
    this.voicePersona = 'suman_warm',
    this.speed = 0.85,
    this.pitch = 1.0,
    this.audioFormat = 'mp3',
  });

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'text': text,
        'language': language,
        'voice_persona': voicePersona,
        'voice_params': {
          'speed': speed,
          'pitch': pitch,
          'volume': 1.0,
        },
        'audio_format': audioFormat,
      };
}

class WordTimestamp {
  final String word;
  final double startTime;
  final double endTime;

  WordTimestamp({
    required this.word,
    required this.startTime,
    required this.endTime,
  });

  factory WordTimestamp.fromJson(Map<String, dynamic> json) {
    return WordTimestamp(
      word: json['word'] as String,
      startTime: (json['start_time'] as num).toDouble(),
      endTime: (json['end_time'] as num).toDouble(),
    );
  }
}

class TTSResponse {
  final String audioBase64;
  final String audioFormat;
  final double durationSeconds;
  final int sampleRate;
  final List<WordTimestamp> wordTimestamps;
  final bool offlineFallback;

  TTSResponse({
    required this.audioBase64,
    required this.audioFormat,
    required this.durationSeconds,
    required this.sampleRate,
    required this.wordTimestamps,
    this.offlineFallback = false,
  });

  factory TTSResponse.fromJson(Map<String, dynamic> json) {
    return TTSResponse(
      audioBase64: json['audio_base64'] as String,
      audioFormat: json['audio_format'] as String,
      durationSeconds: (json['duration_seconds'] as num).toDouble(),
      sampleRate: json['sample_rate'] as int? ?? 22050,
      wordTimestamps: (json['word_timestamps'] as List<dynamic>?)
              ?.map((e) => WordTimestamp.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      offlineFallback: json['offline_fallback'] as bool? ?? false,
    );
  }
}

class BoundingBox {
  final double xMin;
  final double yMin;
  final double xMax;
  final double yMax;

  BoundingBox({
    required this.xMin,
    required this.yMin,
    required this.xMax,
    required this.yMax,
  });

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      xMin: (json['x_min'] as num).toDouble(),
      yMin: (json['y_min'] as num).toDouble(),
      xMax: (json['x_max'] as num).toDouble(),
      yMax: (json['y_max'] as num).toDouble(),
    );
  }
}

class OCRTextRegion {
  final String text;
  final double confidence;
  final BoundingBox boundingBox;
  final int lineNumber;

  OCRTextRegion({
    required this.text,
    required this.confidence,
    required this.boundingBox,
    required this.lineNumber,
  });

  factory OCRTextRegion.fromJson(Map<String, dynamic> json) {
    return OCRTextRegion(
      text: json['text'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      boundingBox: BoundingBox.fromJson(json['bounding_box'] as Map<String, dynamic>),
      lineNumber: json['line_number'] as int,
    );
  }
}

class ImageScanPayload {
  final String studentId;
  final String? imageBase64;
  final String? imageUrl;
  final String mimeType;
  final String? subjectHint;

  ImageScanPayload({
    required this.studentId,
    this.imageBase64,
    this.imageUrl,
    this.mimeType = 'image/jpeg',
    this.subjectHint,
  });

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'image_base64': imageBase64,
        'image_url': imageUrl,
        'mime_type': mimeType,
        'subject_hint': subjectHint,
      };
}

class ImageScanResult {
  final String scanId;
  final bool isEducational;
  final String safetyStatus;
  final String detectedText;
  final List<OCRTextRegion> textRegions;
  final String homeworkType;
  final List<String> childSafetyTags;
  final bool piiRedacted;
  final bool offlineFallback;

  ImageScanResult({
    required this.scanId,
    required this.isEducational,
    required this.safetyStatus,
    required this.detectedText,
    required this.textRegions,
    required this.homeworkType,
    required this.childSafetyTags,
    this.piiRedacted = true,
    this.offlineFallback = false,
  });

  factory ImageScanResult.fromJson(Map<String, dynamic> json) {
    return ImageScanResult(
      scanId: json['scan_id'] as String,
      isEducational: json['is_educational'] as bool,
      safetyStatus: json['safety_status'] as String,
      detectedText: json['detected_text'] as String,
      textRegions: (json['text_regions'] as List<dynamic>?)
              ?.map((e) => OCRTextRegion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      homeworkType: json['homework_type'] as String? ?? 'worksheet',
      childSafetyTags: (json['child_safety_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      piiRedacted: json['pii_redacted'] as bool? ?? true,
      offlineFallback: json['offline_fallback'] as bool? ?? false,
    );
  }
}
