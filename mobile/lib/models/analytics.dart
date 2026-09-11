// Mobile models for Phase 7 Exams, Analytics, and Parent Portal Architecture

enum ExamType {
  diagnostic,
  formative,
  summative,
}

enum QuestionType {
  multipleChoice,
  fillInBlank,
  shortAnswer,
}

enum SubjectCategory {
  math,
  hindi,
  english,
  evs,
  general,
}

enum GapSeverity {
  low,
  medium,
  high,
}

enum ConsentStatus {
  granted,
  revoked,
  pending,
}

class ExamQuestionOption {
  final String optionId;
  final String text;
  final bool isCorrect;

  ExamQuestionOption({
    required this.optionId,
    required this.text,
    this.isCorrect = false,
  });

  factory ExamQuestionOption.fromJson(Map<String, dynamic> json) {
    return ExamQuestionOption(
      optionId: json['option_id'] as String,
      text: json['text'] as String,
      isCorrect: json['is_correct'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'option_id': optionId,
      'text': text,
      'is_correct': isCorrect,
    };
  }
}

class ExamQuestion {
  final String questionId;
  final String questionText;
  final QuestionType questionType;
  final SubjectCategory subject;
  final String topic;
  final int targetGrade;
  final List<ExamQuestionOption>? options;
  final String correctAnswer;
  final String? explanation;
  final int points;

  ExamQuestion({
    required this.questionId,
    required this.questionText,
    this.questionType = QuestionType.multipleChoice,
    required this.subject,
    required this.topic,
    this.targetGrade = 1,
    this.options,
    required this.correctAnswer,
    this.explanation,
    this.points = 10,
  });

  factory ExamQuestion.fromJson(Map<String, dynamic> json) {
    return ExamQuestion(
      questionId: json['question_id'] as String,
      questionText: json['question_text'] as String,
      questionType: QuestionType.values.firstWhere(
        (e) => e.name == json['question_type'],
        orElse: () => QuestionType.multipleChoice,
      ),
      subject: SubjectCategory.values.firstWhere(
        (e) => e.name == json['subject'],
        orElse: () => SubjectCategory.math,
      ),
      topic: json['topic'] as String,
      targetGrade: json['target_grade'] as int? ?? 1,
      options: json['options'] != null
          ? (json['options'] as List)
              .map((e) => ExamQuestionOption.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      correctAnswer: json['correct_answer'] as String,
      explanation: json['explanation'] as String?,
      points: json['points'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'question_text': questionText,
      'question_type': questionType.name,
      'subject': subject.name,
      'topic': topic,
      'target_grade': targetGrade,
      'options': options?.map((e) => e.toJson()).toList(),
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'points': points,
    };
  }
}

class ExamPaper {
  final String examId;
  final String title;
  final ExamType examType;
  final int targetGrade;
  final SubjectCategory subject;
  final int durationMinutes;
  final int totalQuestions;
  final int totalMarks;
  final List<ExamQuestion> questions;

  ExamPaper({
    required this.examId,
    required this.title,
    this.examType = ExamType.diagnostic,
    this.targetGrade = 1,
    required this.subject,
    this.durationMinutes = 15,
    this.totalQuestions = 5,
    this.totalMarks = 50,
    required this.questions,
  });

  factory ExamPaper.fromJson(Map<String, dynamic> json) {
    return ExamPaper(
      examId: json['exam_id'] as String,
      title: json['title'] as String,
      examType: ExamType.values.firstWhere(
        (e) => e.name == json['exam_type'],
        orElse: () => ExamType.diagnostic,
      ),
      targetGrade: json['target_grade'] as int? ?? 1,
      subject: SubjectCategory.values.firstWhere(
        (e) => e.name == json['subject'],
        orElse: () => SubjectCategory.math,
      ),
      durationMinutes: json['duration_minutes'] as int? ?? 15,
      totalQuestions: json['total_questions'] as int? ?? 5,
      totalMarks: json['total_marks'] as int? ?? 50,
      questions: (json['questions'] as List)
          .map((e) => ExamQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_id': examId,
      'title': title,
      'exam_type': examType.name,
      'target_grade': targetGrade,
      'subject': subject.name,
      'duration_minutes': durationMinutes,
      'total_questions': totalQuestions,
      'total_marks': totalMarks,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}

class QuestionEvaluation {
  final String questionId;
  final bool isCorrect;
  final int pointsAwarded;
  final int maxPoints;
  final String studentAnswer;
  final String correctAnswer;
  final String? explanation;

  QuestionEvaluation({
    required this.questionId,
    required this.isCorrect,
    required this.pointsAwarded,
    required this.maxPoints,
    required this.studentAnswer,
    required this.correctAnswer,
    this.explanation,
  });

  factory QuestionEvaluation.fromJson(Map<String, dynamic> json) {
    return QuestionEvaluation(
      questionId: json['question_id'] as String,
      isCorrect: json['is_correct'] as bool,
      pointsAwarded: json['points_awarded'] as int,
      maxPoints: json['max_points'] as int,
      studentAnswer: json['student_answer'] as String,
      correctAnswer: json['correct_answer'] as String,
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'is_correct': isCorrect,
      'points_awarded': pointsAwarded,
      'max_points': maxPoints,
      'student_answer': studentAnswer,
      'correct_answer': correctAnswer,
      'explanation': explanation,
    };
  }
}

class ExamSubmissionResponse {
  final String submissionId;
  final String studentId;
  final String examId;
  final SubjectCategory subject;
  final int totalScore;
  final int maxScore;
  final double percentage;
  final List<String> strengthAreas;
  final List<String> weaknessAreas;
  final List<QuestionEvaluation> questionEvaluations;
  final String feedbackMessage;

  ExamSubmissionResponse({
    required this.submissionId,
    required this.studentId,
    required this.examId,
    required this.subject,
    required this.totalScore,
    required this.maxScore,
    required this.percentage,
    required this.strengthAreas,
    required this.weaknessAreas,
    required this.questionEvaluations,
    required this.feedbackMessage,
  });

  factory ExamSubmissionResponse.fromJson(Map<String, dynamic> json) {
    return ExamSubmissionResponse(
      submissionId: json['submission_id'] as String,
      studentId: json['student_id'] as String,
      examId: json['exam_id'] as String,
      subject: SubjectCategory.values.firstWhere(
        (e) => e.name == json['subject'],
        orElse: () => SubjectCategory.math,
      ),
      totalScore: json['total_score'] as int,
      maxScore: json['max_score'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      strengthAreas: List<String>.from(json['strength_areas'] ?? []),
      weaknessAreas: List<String>.from(json['weakness_areas'] ?? []),
      questionEvaluations: (json['question_evaluations'] as List)
          .map((e) => QuestionEvaluation.fromJson(e as Map<String, dynamic>))
          .toList(),
      feedbackMessage: json['feedback_message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submission_id': submissionId,
      'student_id': studentId,
      'exam_id': examId,
      'subject': subject.name,
      'total_score': totalScore,
      'max_score': maxScore,
      'percentage': percentage,
      'strength_areas': strengthAreas,
      'weakness_areas': weaknessAreas,
      'question_evaluations': questionEvaluations.map((e) => e.toJson()).toList(),
      'feedback_message': feedbackMessage,
    };
  }
}

class SubjectMastery {
  final SubjectCategory subject;
  final double scorePercentage;
  final String masteryLevel;
  final List<String> topicsMastered;
  final List<String> topicsNeedingImprovement;

  SubjectMastery({
    required this.subject,
    required this.scorePercentage,
    required this.masteryLevel,
    required this.topicsMastered,
    required this.topicsNeedingImprovement,
  });

  factory SubjectMastery.fromJson(Map<String, dynamic> json) {
    return SubjectMastery(
      subject: SubjectCategory.values.firstWhere(
        (e) => e.name == json['subject'],
        orElse: () => SubjectCategory.math,
      ),
      scorePercentage: (json['score_percentage'] as num).toDouble(),
      masteryLevel: json['mastery_level'] as String,
      topicsMastered: List<String>.from(json['topics_mastered'] ?? []),
      topicsNeedingImprovement:
          List<String>.from(json['topics_needing_improvement'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject.name,
      'score_percentage': scorePercentage,
      'mastery_level': masteryLevel,
      'topics_mastered': topicsMastered,
      'topics_needing_improvement': topicsNeedingImprovement,
    };
  }
}

class LearningGapIndicator {
  final SubjectCategory subject;
  final String topic;
  final GapSeverity severity;
  final String gapDescription;
  final String recommendedAction;

  LearningGapIndicator({
    required this.subject,
    required this.topic,
    this.severity = GapSeverity.medium,
    required this.gapDescription,
    required this.recommendedAction,
  });

  factory LearningGapIndicator.fromJson(Map<String, dynamic> json) {
    return LearningGapIndicator(
      subject: SubjectCategory.values.firstWhere(
        (e) => e.name == json['subject'],
        orElse: () => SubjectCategory.math,
      ),
      topic: json['topic'] as String,
      severity: GapSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => GapSeverity.medium,
      ),
      gapDescription: json['gap_description'] as String,
      recommendedAction: json['recommended_action'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject.name,
      'topic': topic,
      'severity': severity.name,
      'gap_description': gapDescription,
      'recommended_action': recommendedAction,
    };
  }
}

class DPDPParentConsent {
  final String parentId;
  final String childStudentId;
  final bool dpdpConsentGranted;
  final bool coppaConsentGranted;
  final bool allowVoiceDataProcessing;
  final bool allowAnalyticsAggregation;
  final int dataRetentionDays;
  final ConsentStatus consentStatus;

  DPDPParentConsent({
    required this.parentId,
    required this.childStudentId,
    this.dpdpConsentGranted = true,
    this.coppaConsentGranted = true,
    this.allowVoiceDataProcessing = false,
    this.allowAnalyticsAggregation = true,
    this.dataRetentionDays = 30,
    this.consentStatus = ConsentStatus.granted,
  });

  factory DPDPParentConsent.fromJson(Map<String, dynamic> json) {
    return DPDPParentConsent(
      parentId: json['parent_id'] as String,
      childStudentId: json['child_student_id'] as String,
      dpdpConsentGranted: json['dpdp_consent_granted'] as bool? ?? true,
      coppaConsentGranted: json['coppa_consent_granted'] as bool? ?? true,
      allowVoiceDataProcessing:
          json['allow_voice_data_processing'] as bool? ?? false,
      allowAnalyticsAggregation:
          json['allow_analytics_aggregation'] as bool? ?? true,
      dataRetentionDays: json['data_retention_days'] as int? ?? 30,
      consentStatus: ConsentStatus.values.firstWhere(
        (e) => e.name == json['consent_status'],
        orElse: () => ConsentStatus.granted,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentId,
      'child_student_id': childStudentId,
      'dpdp_consent_granted': dpdpConsentGranted,
      'coppa_consent_granted': coppaConsentGranted,
      'allow_voice_data_processing': allowVoiceDataProcessing,
      'allow_analytics_aggregation': allowAnalyticsAggregation,
      'data_retention_days': dataRetentionDays,
      'consent_status': consentStatus.name,
    };
  }
}

class ParentDashboardResponse {
  final String parentId;
  final String childStudentId;
  final String childName;
  final int gradeLevel;
  final double overallMasteryPercentage;
  final double totalLearningHours;
  final int totalExamsTaken;
  final List<SubjectMastery> subjectMastery;
  final List<LearningGapIndicator> learningGaps;
  final List<String> strengths;
  final DPDPParentConsent consentSettings;

  ParentDashboardResponse({
    required this.parentId,
    required this.childStudentId,
    required this.childName,
    this.gradeLevel = 1,
    required this.overallMasteryPercentage,
    this.totalLearningHours = 0.0,
    this.totalExamsTaken = 0,
    required this.subjectMastery,
    required this.learningGaps,
    required this.strengths,
    required this.consentSettings,
  });

  factory ParentDashboardResponse.fromJson(Map<String, dynamic> json) {
    return ParentDashboardResponse(
      parentId: json['parent_id'] as String,
      childStudentId: json['child_student_id'] as String,
      childName: json['child_name'] as String,
      gradeLevel: json['grade_level'] as int? ?? 1,
      overallMasteryPercentage:
          (json['overall_mastery_percentage'] as num).toDouble(),
      totalLearningHours: (json['total_learning_hours'] as num?)?.toDouble() ?? 0.0,
      totalExamsTaken: json['total_exams_taken'] as int? ?? 0,
      subjectMastery: (json['subject_mastery'] as List)
          .map((e) => SubjectMastery.fromJson(e as Map<String, dynamic>))
          .toList(),
      learningGaps: (json['learning_gaps'] as List)
          .map((e) => LearningGapIndicator.fromJson(e as Map<String, dynamic>))
          .toList(),
      strengths: List<String>.from(json['strengths'] ?? []),
      consentSettings: DPDPParentConsent.fromJson(
          json['consent_settings'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentId,
      'child_student_id': childStudentId,
      'child_name': childName,
      'grade_level': gradeLevel,
      'overall_mastery_percentage': overallMasteryPercentage,
      'total_learning_hours': totalLearningHours,
      'total_exams_taken': totalExamsTaken,
      'subject_mastery': subjectMastery.map((e) => e.toJson()).toList(),
      'learning_gaps': learningGaps.map((e) => e.toJson()).toList(),
      'strengths': strengths,
      'consent_settings': consentSettings.toJson(),
    };
  }
}
