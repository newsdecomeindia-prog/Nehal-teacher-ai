enum SubjectCode {
  english,
  hindi,
  marathi,
  mathematics,
  evsGk,
}

enum ExerciseType {
  multipleChoice,
  visualMatch,
  fillInBlank,
  trueFalse,
}

class LearningOutcome {
  final String id;
  final String outcomeCode;
  final String description;
  final String bloomsLevel;
  final String understandingFirstPrinciple;
  final String cbseAcademicYear;

  LearningOutcome({
    required this.id,
    required this.outcomeCode,
    required this.description,
    required this.bloomsLevel,
    required this.understandingFirstPrinciple,
    this.cbseAcademicYear = '2026-27',
  });

  factory LearningOutcome.fromJson(Map<String, dynamic> json) {
    return LearningOutcome(
      id: json['id'] as String,
      outcomeCode: json['outcome_code'] as String,
      description: json['description'] as String,
      bloomsLevel: json['blooms_level'] as String,
      understandingFirstPrinciple:
          json['understanding_first_principle'] as String,
      cbseAcademicYear:
          json['cbse_academic_year'] as String? ?? '2026-27',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'outcome_code': outcomeCode,
        'description': description,
        'blooms_level': bloomsLevel,
        'understanding_first_principle': understandingFirstPrinciple,
        'cbse_academic_year': cbseAcademicYear,
      };
}

class Concept {
  final String id;
  final String title;
  final String explanation;
  final List<String> visualCues;
  final List<LearningOutcome> learningOutcomes;
  final String cbseAcademicYear;

  Concept({
    required this.id,
    required this.title,
    required this.explanation,
    required this.visualCues,
    required this.learningOutcomes,
    this.cbseAcademicYear = '2026-27',
  });

  factory Concept.fromJson(Map<String, dynamic> json) {
    return Concept(
      id: json['id'] as String,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      visualCues: (json['visual_cues'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      learningOutcomes: (json['learning_outcomes'] as List<dynamic>?)
              ?.map((e) => LearningOutcome.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cbseAcademicYear:
          json['cbse_academic_year'] as String? ?? '2026-27',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'explanation': explanation,
        'visual_cues': visualCues,
        'learning_outcomes': learningOutcomes.map((e) => e.toJson()).toList(),
        'cbse_academic_year': cbseAcademicYear,
      };
}

class ExerciseItem {
  final String id;
  final String type;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? hint;
  final String? explanation;
  final String cbseAcademicYear;

  ExerciseItem({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.hint,
    this.explanation,
    this.cbseAcademicYear = '2026-27',
  });

  factory ExerciseItem.fromJson(Map<String, dynamic> json) {
    return ExerciseItem(
      id: json['id'] as String,
      type: json['type'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      correctAnswer: json['correct_answer'] as String,
      hint: json['hint'] as String?,
      explanation: json['explanation'] as String?,
      cbseAcademicYear:
          json['cbse_academic_year'] as String? ?? '2026-27',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'question': question,
        'options': options,
        'correct_answer': correctAnswer,
        'hint': hint,
        'explanation': explanation,
        'cbse_academic_year': cbseAcademicYear,
      };
}

class AssessmentItem {
  final String id;
  final ExerciseItem exercise;
  final double weightage;
  final String cbseAcademicYear;

  AssessmentItem({
    required this.id,
    required this.exercise,
    this.weightage = 1.0,
    this.cbseAcademicYear = '2026-27',
  });

  factory AssessmentItem.fromJson(Map<String, dynamic> json) {
    return AssessmentItem(
      id: json['id'] as String,
      exercise:
          ExerciseItem.fromJson(json['exercise'] as Map<String, dynamic>),
      weightage: (json['weightage'] as num?)?.toDouble() ?? 1.0,
      cbseAcademicYear:
          json['cbse_academic_year'] as String? ?? '2026-27',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'exercise': exercise.toJson(),
        'weightage': weightage,
        'cbse_academic_year': cbseAcademicYear,
      };
}

class Subtopic {
  final String id;
  final String title;
  final int sequenceOrder;
  final List<Concept> concepts;
  final List<ExerciseItem> exercises;
  final String cbseAcademicYear;

  Subtopic({
    required this.id,
    required this.title,
    required this.sequenceOrder,
    required this.concepts,
    required this.exercises,
    this.cbseAcademicYear = '2026-27',
  });

  factory Subtopic.fromJson(Map<String, dynamic> json) {
    return Subtopic(
      id: json['id'] as String,
      title: json['title'] as String,
      sequenceOrder: json['sequence_order'] as int,
      concepts: (json['concepts'] as List<dynamic>?)
              ?.map((e) => Concept.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => ExerciseItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cbseAcademicYear:
          json['cbse_academic_year'] as String? ?? '2026-27',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'sequence_order': sequenceOrder,
        'concepts': concepts.map((e) => e.toJson()).toList(),
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'cbse_academic_year': cbseAcademicYear,
      };
}

class Topic {
  final String id;
  final String title;
  final int sequenceOrder;
  final List<Subtopic> subtopics;
  final String cbseAcademicYear;

  Topic({
    required this.id,
    required this.title,
    required this.sequenceOrder,
    required this.subtopics,
    this.cbseAcademicYear = '2026-27',
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as String,
      title: json['title'] as String,
      sequenceOrder: json['sequence_order'] as int,
      subtopics: (json['subtopics'] as List<dynamic>?)
              ?.map((e) => Subtopic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cbseAcademicYear:
          json['cbse_academic_year'] as String? ?? '2026-27',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'sequence_order': sequenceOrder,
        'subtopics': subtopics.map((e) => e.toJson()).toList(),
        'cbse_academic_year': cbseAcademicYear,
      };
}

class Subject {
  final String id;
  final String code;
  final String titleEn;
  final String titleNative;
  final String description;
  final String language;
  final int gradeLevel;
  final List<Topic> topics;
  final String cbseAcademicYear;

  Subject({
    required this.id,
    required this.code,
    required this.titleEn,
    required this.titleNative,
    required this.description,
    required this.language,
    required this.gradeLevel,
    required this.topics,
    this.cbseAcademicYear = '2026-27',
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String,
      code: json['code'] as String,
      titleEn: json['title_en'] as String,
      titleNative: json['title_native'] as String,
      description: json['description'] as String,
      language: json['language'] as String,
      gradeLevel: json['grade_level'] as int? ?? 1,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cbseAcademicYear:
          json['cbse_academic_year'] as String? ?? '2026-27',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'title_en': titleEn,
        'title_native': titleNative,
        'description': description,
        'language': language,
        'grade_level': gradeLevel,
        'topics': topics.map((e) => e.toJson()).toList(),
        'cbse_academic_year': cbseAcademicYear,
      };
}

class LessonBlueprint {
  final String id;
  final String subjectCode;
  final int gradeLevel;
  final String title;
  final String topicId;
  final String subtopicId;
  final List<Concept> concepts;
  final List<AssessmentItem> assessmentItems;
  final String curriculumVersion;
  final String cbseAcademicYear;

  LessonBlueprint({
    required this.id,
    required this.subjectCode,
    required this.gradeLevel,
    required this.title,
    required this.topicId,
    required this.subtopicId,
    required this.concepts,
    required this.assessmentItems,
    required this.curriculumVersion,
    this.cbseAcademicYear = '2026-27',
  });

  factory LessonBlueprint.fromJson(Map<String, dynamic> json) {
    return LessonBlueprint(
      id: json['id'] as String,
      subjectCode: json['subject_code'] as String,
      gradeLevel: json['grade_level'] as int? ?? 1,
      title: json['title'] as String,
      topicId: json['topic_id'] as String,
      subtopicId: json['subtopic_id'] as String,
      concepts: (json['concepts'] as List<dynamic>?)
              ?.map((e) => Concept.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      assessmentItems: (json['assessment_items'] as List<dynamic>?)
              ?.map((e) => AssessmentItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      curriculumVersion: json['curriculum_version'] as String? ?? '1.0.0',
      cbseAcademicYear:
          json['cbse_academic_year'] as String? ?? '2026-27',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject_code': subjectCode,
        'grade_level': gradeLevel,
        'title': title,
        'topic_id': topicId,
        'subtopic_id': subtopicId,
        'concepts': concepts.map((e) => e.toJson()).toList(),
        'assessment_items': assessmentItems.map((e) => e.toJson()).toList(),
        'curriculum_version': curriculumVersion,
        'cbse_academic_year': cbseAcademicYear,
      };
}

class CurriculumVersion {
  final String version;
  final String releaseDate;
  final int gradeLevel;
  final bool cbseCompliant;
  final String cbseAcademicYear;
  final List<String> supportedSubjects;

  CurriculumVersion({
    required this.version,
    required this.releaseDate,
    this.gradeLevel = 1,
    this.cbseCompliant = true,
    this.cbseAcademicYear = '2026-27',
    required this.supportedSubjects,
  });

  factory CurriculumVersion.fromJson(Map<String, dynamic> json) {
    return CurriculumVersion(
      version: json['version'] as String,
      releaseDate: json['release_date'] as String,
      gradeLevel: json['grade_level'] as int? ?? 1,
      cbseCompliant: json['cbse_compliant'] as bool? ?? true,
      cbseAcademicYear:
          json['cbse_academic_year'] as String? ?? '2026-27',
      supportedSubjects: (json['supported_subjects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'release_date': releaseDate,
        'grade_level': gradeLevel,
        'cbse_compliant': cbseCompliant,
        'cbse_academic_year': cbseAcademicYear,
        'supported_subjects': supportedSubjects,
      };
}
