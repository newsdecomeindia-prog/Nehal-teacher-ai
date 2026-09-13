/// English Speaking Models for Class 1 Speaking Practice & Soft Assessment
library;

enum DifficultyTier {
  level_1, // 2-3 word phrases
  level_2, // 4-5 word simple sentences
  level_3, // interactive conversational responses
}

enum ErrorCategory {
  pronunciation,
  missingWord,
  extraWord,
  fluencyPause,
  none,
}

enum ChildFeedbackTag {
  starPerformer,
  greatEffort,
  keepTrying,
  superClear,
  tryAgainGently,
}

class TargetPhoneticGuide {
  final String word;
  final String phoneticIpa;
  final String simplePhonetic;
  final String? audioSampleUrl;

  TargetPhoneticGuide({
    required this.word,
    required this.phoneticIpa,
    required this.simplePhonetic,
    this.audioSampleUrl,
  });

  factory TargetPhoneticGuide.fromJson(Map<String, dynamic> json) {
    return TargetPhoneticGuide(
      word: json['word'] as String,
      phoneticIpa: json['phonetic_ipa'] as String,
      simplePhonetic: json['simple_phonetic'] as String,
      audioSampleUrl: json['audio_sample_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'phonetic_ipa': phoneticIpa,
        'simple_phonetic': simplePhonetic,
        'audio_sample_url': audioSampleUrl,
      };
}

class SpeakingPrompt {
  final String promptId;
  final String tier;
  final String targetSentence;
  final String? translationHindi;
  final String? translationMarathi;
  final List<TargetPhoneticGuide> phonetics;
  final String theme;

  SpeakingPrompt({
    required this.promptId,
    required this.tier,
    required this.targetSentence,
    this.translationHindi,
    this.translationMarathi,
    this.phonetics = const [],
    this.theme = 'daily_life',
  });

  factory SpeakingPrompt.fromJson(Map<String, dynamic> json) {
    return SpeakingPrompt(
      promptId: json['prompt_id'] as String,
      tier: json['tier'] as String,
      targetSentence: json['target_sentence'] as String,
      translationHindi: json['translation_hindi'] as String?,
      translationMarathi: json['translation_marathi'] as String?,
      phonetics: (json['phonetics'] as List<dynamic>?)
              ?.map((e) => TargetPhoneticGuide.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      theme: json['theme'] as String? ?? 'daily_life',
    );
  }

  Map<String, dynamic> toJson() => {
        'prompt_id': promptId,
        'tier': tier,
        'target_sentence': targetSentence,
        'translation_hindi': translationHindi,
        'translation_marathi': translationMarathi,
        'phonetics': phonetics.map((e) => e.toJson()).toList(),
        'theme': theme,
      };
}

class WordEvaluationDetail {
  final String targetWord;
  final String? spokenWord;
  final double score;
  final String errorCategory;
  final String? childTip;

  WordEvaluationDetail({
    required this.targetWord,
    this.spokenWord,
    required this.score,
    required this.errorCategory,
    this.childTip,
  });

  factory WordEvaluationDetail.fromJson(Map<String, dynamic> json) {
    return WordEvaluationDetail(
      targetWord: json['target_word'] as String,
      spokenWord: json['spoken_word'] as String?,
      score: (json['score'] as num).toDouble(),
      errorCategory: json['error_category'] as String,
      childTip: json['child_tip'] as String?,
    );
  }
}

class AccuracyScore {
  final double overallAccuracy;
  final double wordAccuracy;
  final double phoneticMatchPercentage;

  AccuracyScore({
    required this.overallAccuracy,
    required this.wordAccuracy,
    required this.phoneticMatchPercentage,
  });

  factory AccuracyScore.fromJson(Map<String, dynamic> json) {
    return AccuracyScore(
      overallAccuracy: (json['overall_accuracy'] as num).toDouble(),
      wordAccuracy: (json['word_accuracy'] as num).toDouble(),
      phoneticMatchPercentage: (json['phonetic_match_percentage'] as num).toDouble(),
    );
  }
}

class FluencyMetrics {
  final double wordsPerMinute;
  final int pauseCount;
  final double fluencyScore;

  FluencyMetrics({
    required this.wordsPerMinute,
    required this.pauseCount,
    required this.fluencyScore,
  });

  factory FluencyMetrics.fromJson(Map<String, dynamic> json) {
    return FluencyMetrics(
      wordsPerMinute: (json['words_per_minute'] as num).toDouble(),
      pauseCount: json['pause_count'] as int,
      fluencyScore: (json['fluency_score'] as num).toDouble(),
    );
  }
}

class GentleFeedback {
  final String encouragementMessage;
  final String feedbackTag;
  final int starsEarned;
  final List<String> improvements;
  final List<String> praisePoints;

  GentleFeedback({
    required this.encouragementMessage,
    required this.feedbackTag,
    required this.starsEarned,
    this.improvements = const [],
    this.praisePoints = const [],
  });

  factory GentleFeedback.fromJson(Map<String, dynamic> json) {
    return GentleFeedback(
      encouragementMessage: json['encouragement_message'] as String,
      feedbackTag: json['feedback_tag'] as String,
      starsEarned: json['stars_earned'] as int,
      improvements: (json['improvements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      praisePoints: (json['praise_points'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class SpeakingEvaluationRequest {
  final String studentId;
  final String promptId;
  final String spokenTranscript;
  final String? targetSentence;
  final double durationSeconds;

  SpeakingEvaluationRequest({
    required this.studentId,
    required this.promptId,
    required this.spokenTranscript,
    this.targetSentence,
    this.durationSeconds = 2.5,
  });

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'prompt_id': promptId,
        'spoken_transcript': spokenTranscript,
        'target_sentence': targetSentence,
        'duration_seconds': durationSeconds,
      };
}

class SpeakingEvaluationResponse {
  final String evaluationId;
  final String studentId;
  final String promptId;
  final String targetSentence;
  final String spokenTranscript;
  final AccuracyScore accuracy;
  final FluencyMetrics fluency;
  final List<WordEvaluationDetail> wordDetails;
  final GentleFeedback feedback;
  final bool offlineFallback;

  SpeakingEvaluationResponse({
    required this.evaluationId,
    required this.studentId,
    required this.promptId,
    required this.targetSentence,
    required this.spokenTranscript,
    required this.accuracy,
    required this.fluency,
    required this.wordDetails,
    required this.feedback,
    this.offlineFallback = false,
  });

  factory SpeakingEvaluationResponse.fromJson(Map<String, dynamic> json) {
    return SpeakingEvaluationResponse(
      evaluationId: json['evaluation_id'] as String,
      studentId: json['student_id'] as String,
      promptId: json['prompt_id'] as String,
      targetSentence: json['target_sentence'] as String,
      spokenTranscript: json['spoken_transcript'] as String,
      accuracy: AccuracyScore.fromJson(json['accuracy'] as Map<String, dynamic>),
      fluency: FluencyMetrics.fromJson(json['fluency'] as Map<String, dynamic>),
      wordDetails: (json['word_details'] as List<dynamic>?)
              ?.map((e) => WordEvaluationDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      feedback: GentleFeedback.fromJson(json['feedback'] as Map<String, dynamic>),
      offlineFallback: json['offline_fallback'] as bool? ?? false,
    );
  }
}
