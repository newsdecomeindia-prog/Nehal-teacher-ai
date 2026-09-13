import 'package:nehal_teacher_ai_mobile/widgets/rich_visual_card.dart';

enum InteractionMode {
  standard,
  fallbackExplanation,
  assessmentHint,
}

class TeacherChatMessage {
  final String id;
  final String sender; // 'student' or 'teacher'
  final String messageText;
  final DateTime timestamp;
  final bool isFallbackExplanation;
  final String? visualCueTrigger;
  final RichVisualCardData? richCard;
  final String? simpleExplanation;
  final String? realLifeExample;
  final String? checkingQuestion;
  final String? childResponseEvaluation;
  final String? supportiveCorrection;
  final String teachingStrategy;

  TeacherChatMessage({
    required this.id,
    required this.sender,
    required this.messageText,
    required this.timestamp,
    this.isFallbackExplanation = false,
    this.visualCueTrigger,
    this.richCard,
    this.simpleExplanation,
    this.realLifeExample,
    this.checkingQuestion,
    this.childResponseEvaluation,
    this.supportiveCorrection,
    this.teachingStrategy = 'standard_analogy',
  });

  factory TeacherChatMessage.fromJson(Map<String, dynamic> json) {
    return TeacherChatMessage(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      sender: json['sender'] as String? ?? 'teacher',
      messageText: json['message_text'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      isFallbackExplanation: json['is_fallback_explanation'] as bool? ?? false,
      visualCueTrigger: json['visual_cue_trigger'] as String?,
      richCard: json['rich_card'] != null
          ? RichVisualCardData.fromJson(json['rich_card'] as Map<String, dynamic>)
          : null,
      simpleExplanation: json['simple_explanation'] as String?,
      realLifeExample: json['real_life_example'] as String?,
      checkingQuestion: json['checking_question'] as String?,
      childResponseEvaluation: json['child_response_evaluation'] as String?,
      supportiveCorrection: json['supportive_correction'] as String?,
      teachingStrategy: json['teaching_strategy'] as String? ?? 'standard_analogy',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'message_text': messageText,
        'timestamp': timestamp.toIso8601String(),
        'is_fallback_explanation': isFallbackExplanation,
        'visual_cue_trigger': visualCueTrigger,
        'simple_explanation': simpleExplanation,
        'real_life_example': realLifeExample,
        'checking_question': checkingQuestion,
        'child_response_evaluation': childResponseEvaluation,
        'supportive_correction': supportiveCorrection,
        'teaching_strategy': teachingStrategy,
      };
}

class TeacherChatRequest {
  final String studentId;
  final String message;
  final String language;
  final String? subjectCode;
  final String? topicId;
  final String? subtopicId;
  final String? conceptId;
  final bool isConfused;

  TeacherChatRequest({
    required this.studentId,
    required this.message,
    this.language = 'en',
    this.subjectCode,
    this.topicId,
    this.subtopicId,
    this.conceptId,
    this.isConfused = false,
  });

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'message': message,
        'language': language,
        'subject_code': subjectCode,
        'topic_id': topicId,
        'subtopic_id': subtopicId,
        'concept_id': conceptId,
        'is_confused': isConfused,
      };
}

class TeacherChatResponse {
  final String responseText;
  final String language;
  final String interactionMode;
  final bool isFallbackExplanation;
  final String? visualCueTrigger;
  final RichVisualCardData? richCard;
  final String? groundedConceptId;
  final bool safetyFiltered;
  final String? encouragementPhrase;
  final String? simpleExplanation;
  final String? realLifeExample;
  final String? checkingQuestion;
  final String? childResponseEvaluation;
  final String? supportiveCorrection;
  final String teachingStrategy;

  TeacherChatResponse({
    required this.responseText,
    required this.language,
    required this.interactionMode,
    this.isFallbackExplanation = false,
    this.visualCueTrigger,
    this.richCard,
    this.groundedConceptId,
    this.safetyFiltered = false,
    this.encouragementPhrase,
    this.simpleExplanation,
    this.realLifeExample,
    this.checkingQuestion,
    this.childResponseEvaluation,
    this.supportiveCorrection,
    this.teachingStrategy = 'standard_analogy',
  });

  factory TeacherChatResponse.fromJson(Map<String, dynamic> json) {
    return TeacherChatResponse(
      responseText: json['response_text'] as String,
      language: json['language'] as String,
      interactionMode: json['interaction_mode'] as String? ?? 'standard',
      isFallbackExplanation: json['is_fallback_explanation'] as bool? ?? false,
      visualCueTrigger: json['visual_cue_trigger'] as String?,
      richCard: json['rich_card'] != null
          ? RichVisualCardData.fromJson(json['rich_card'] as Map<String, dynamic>)
          : null,
      groundedConceptId: json['grounded_concept_id'] as String?,
      safetyFiltered: json['safety_filtered'] as bool? ?? false,
      encouragementPhrase: json['encouragement_phrase'] as String?,
      simpleExplanation: json['simple_explanation'] as String?,
      realLifeExample: json['real_life_example'] as String?,
      checkingQuestion: json['checking_question'] as String?,
      childResponseEvaluation: json['child_response_evaluation'] as String?,
      supportiveCorrection: json['supportive_correction'] as String?,
      teachingStrategy: json['teaching_strategy'] as String? ?? 'standard_analogy',
    );
  }

  Map<String, dynamic> toJson() => {
        'response_text': responseText,
        'language': language,
        'interaction_mode': interactionMode,
        'is_fallback_explanation': isFallbackExplanation,
        'visual_cue_trigger': visualCueTrigger,
        'grounded_concept_id': groundedConceptId,
        'safety_filtered': safetyFiltered,
        'encouragement_phrase': encouragementPhrase,
        'simple_explanation': simpleExplanation,
        'real_life_example': realLifeExample,
        'checking_question': checkingQuestion,
        'child_response_evaluation': childResponseEvaluation,
        'supportive_correction': supportiveCorrection,
        'teaching_strategy': teachingStrategy,
      };
}

class TeacherPersonaConfig {
  final String name;
  final String language;
  final String tone;
  final int gradeLevel;

  TeacherPersonaConfig({
    required this.name,
    required this.language,
    required this.tone,
    required this.gradeLevel,
  });

  factory TeacherPersonaConfig.fromJson(Map<String, dynamic> json) {
    return TeacherPersonaConfig(
      name: json['name'] as String? ?? 'Suman AI',
      language: json['language'] as String? ?? 'en',
      tone: json['tone'] as String? ?? 'warm, supportive, patient',
      gradeLevel: json['grade_level'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'language': language,
        'tone': tone,
        'grade_level': gradeLevel,
      };
}
