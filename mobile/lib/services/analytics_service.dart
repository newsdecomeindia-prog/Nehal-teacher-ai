// Mobile service for handling exams, analytics, and parent portal APIs

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/analytics.dart';

class AnalyticsService {
  final String? _explicitBaseUrl;
  final http.Client client;

  AnalyticsService({
    String? baseUrl,
    http.Client? client,
  })  : _explicitBaseUrl = baseUrl,
        client = client ?? http.Client();

  String get baseUrl => _explicitBaseUrl ?? AppConfig.baseUrl;

  /// Fetches diagnostic or formative exam paper for student
  Future<ExamPaper> generateExam({
    required String studentId,
    int gradeLevel = 1,
    SubjectCategory subject = SubjectCategory.math,
    ExamType examType = ExamType.diagnostic,
    int numQuestions = 5,
  }) async {
    final uri = Uri.parse('$baseUrl/analytics/generate-exam').replace(
      queryParameters: {
        'student_id': studentId,
        'grade_level': gradeLevel.toString(),
        'subject': subject.name,
        'exam_type': examType.name,
        'num_questions': numQuestions.toString(),
      },
    );

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ExamPaper.fromJson(data);
      }
    } catch (_) {
      // Fallback offline mock exam
    }
    return _getMockExamPaper(studentId, gradeLevel, subject);
  }

  /// Submits student exam answers and receives score evaluation
  Future<ExamSubmissionResponse> submitExam({
    required String studentId,
    required String examId,
    required int gradeLevel,
    required SubjectCategory subject,
    required List<Map<String, dynamic>> answers,
  }) async {
    final uri = Uri.parse('$baseUrl/analytics/submit-exam');
    try {
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_id': studentId,
          'exam_id': examId,
          'grade_level': gradeLevel,
          'subject': subject.name,
          'answers': answers,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ExamSubmissionResponse.fromJson(data);
      }
    } catch (_) {
      // Offline fallback processing
    }

    return _getMockExamSubmissionResponse(studentId, examId, subject, answers);
  }

  /// Fetches aggregated parent dashboard report
  Future<ParentDashboardResponse> getParentDashboard({
    required String studentId,
    String parentId = 'parent-01',
  }) async {
    final uri = Uri.parse('$baseUrl/analytics/parent-dashboard').replace(
      queryParameters: {
        'student_id': studentId,
        'parent_id': parentId,
      },
    );

    try {
      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ParentDashboardResponse.fromJson(data);
      }
    } catch (_) {
      // Offline fallback
    }

    return _getMockParentDashboard(studentId, parentId);
  }

  ExamPaper _getMockExamPaper(String studentId, int gradeLevel, SubjectCategory subject) {
    return ExamPaper(
      examId: 'exam-mock-01',
      title: 'Class $gradeLevel Practice Test (${subject.name.toUpperCase()})',
      examType: ExamType.diagnostic,
      targetGrade: gradeLevel,
      subject: subject,
      durationMinutes: 10,
      totalQuestions: 3,
      totalMarks: 30,
      allowAiHints: false,
      isTimedQuiz: true,
      chapterId: 'ch-01',
      questions: [
        ExamQuestion(
          questionId: 'q-m1-01',
          questionText: 'What is 3 + 4?',
          questionType: QuestionType.multipleChoice,
          subject: subject,
          topic: 'Addition',
          targetGrade: gradeLevel,
          correctAnswer: 'opt-m1-01b',
          options: [
            ExamQuestionOption(optionId: 'opt-m1-01a', text: '5'),
            ExamQuestionOption(optionId: 'opt-m1-01b', text: '7', isCorrect: true),
            ExamQuestionOption(optionId: 'opt-m1-01c', text: '8'),
          ],
          explanation: '3 + 4 = 7.',
          points: 10,
        ),
        ExamQuestion(
          questionId: 'q-m1-02',
          questionText: 'Which shape has 3 sides?',
          questionType: QuestionType.multipleChoice,
          subject: subject,
          topic: 'Shapes',
          targetGrade: gradeLevel,
          correctAnswer: 'opt-m1-02b',
          options: [
            ExamQuestionOption(optionId: 'opt-m1-02a', text: 'Square'),
            ExamQuestionOption(optionId: 'opt-m1-02b', text: 'Triangle', isCorrect: true),
            ExamQuestionOption(optionId: 'opt-m1-02c', text: 'Circle'),
          ],
          explanation: 'A triangle has 3 sides.',
          points: 10,
        ),
        ExamQuestion(
          questionId: 'q-m1-03',
          questionText: 'Fill missing number: 2, 4, 6, __, 10',
          questionType: QuestionType.fillInBlank,
          subject: subject,
          topic: 'Pattern Recognition',
          targetGrade: gradeLevel,
          correctAnswer: '8',
          explanation: 'The pattern counts up by 2.',
          points: 10,
        ),
      ],
    );
  }

  ExamSubmissionResponse _getMockExamSubmissionResponse(
    String studentId,
    String examId,
    SubjectCategory subject,
    List<Map<String, dynamic>> answers,
  ) {
    int totalScore = 20;
    int maxScore = 30;
    double percentage = 66.7;

    return ExamSubmissionResponse(
      submissionId: 'sub-mock-101',
      studentId: studentId,
      examId: examId,
      subject: subject,
      totalScore: totalScore,
      maxScore: maxScore,
      percentage: percentage,
      timeTakenSeconds: 120.0,
      aiHintsUsed: 0,
      strengthAreas: ['Addition', 'Shapes'],
      weaknessAreas: ['Pattern Recognition'],
      questionEvaluations: [
        QuestionEvaluation(
          questionId: 'q-m1-01',
          isCorrect: true,
          pointsAwarded: 10,
          maxPoints: 10,
          studentAnswer: 'opt-m1-01b',
          correctAnswer: 'opt-m1-01b',
          explanation: '3 + 4 = 7.',
        ),
        QuestionEvaluation(
          questionId: 'q-m1-02',
          isCorrect: true,
          pointsAwarded: 10,
          maxPoints: 10,
          studentAnswer: 'opt-m1-02b',
          correctAnswer: 'opt-m1-02b',
          explanation: 'A triangle has 3 sides.',
        ),
        QuestionEvaluation(
          questionId: 'q-m1-03',
          isCorrect: false,
          pointsAwarded: 0,
          maxPoints: 10,
          studentAnswer: '7',
          correctAnswer: '8',
          explanation: 'Sequence increases by 2.',
        ),
      ],
      feedbackMessage: 'Great effort! You are making good progress!',
      sureshAnalysis: 'Suresh AI Analysis: Strong addition & geometry skills. Practice skip-counting by 2s for pattern recognition.',
    );
  }

  ParentDashboardResponse _getMockParentDashboard(String studentId, String parentId) {
    return ParentDashboardResponse(
      parentId: parentId,
      childStudentId: studentId,
      childName: 'Nehal',
      gradeLevel: 1,
      overallMasteryPercentage: 82.5,
      totalLearningHours: 12.5,
      totalExamsTaken: 6,
      subjectMastery: [
        SubjectMastery(
          subject: SubjectCategory.math,
          scorePercentage: 85.0,
          masteryLevel: 'Proficient',
          topicsMastered: ['Addition', 'Shapes & Geometry'],
          topicsNeedingImprovement: ['Pattern Recognition'],
          timeSpentMinutes: 240.0,
          accuracyRate: 85.0,
          totalQuestionsAttempted: 45,
        ),
        SubjectMastery(
          subject: SubjectCategory.hindi,
          scorePercentage: 90.0,
          masteryLevel: 'Master',
          topicsMastered: ['Vowels & Phonology', 'Consonants'],
          topicsNeedingImprovement: [],
          timeSpentMinutes: 180.0,
          accuracyRate: 90.0,
          totalQuestionsAttempted: 38,
        ),
        SubjectMastery(
          subject: SubjectCategory.english,
          scorePercentage: 75.0,
          masteryLevel: 'Developing',
          topicsMastered: ['Alphabet Recognition'],
          topicsNeedingImprovement: ['Plurals', 'Pronunciation'],
          timeSpentMinutes: 210.0,
          accuracyRate: 75.0,
          totalQuestionsAttempted: 50,
        ),
      ],
      sureshAiInsights: [
        'Suresh AI Study Analytics: Nehal demonstrates 90% peak accuracy in Hindi Phonology during morning sessions.',
        'Weak Area Alert: Practice 10 minutes on English Plurals & Math Pattern Recognition this week.',
        'Study Recommendation: Complete 1 timed chapter quiz in Math Jungle to boost skip-counting speed.',
      ],
      weeklySummary: WeeklySummary(
        activeDaysCount: 5,
        totalStudyMinutes: 180.0,
        quizzesCompleted: 4,
        averageAccuracyPercentage: 88.5,
      ),
      learningGaps: [
        LearningGapIndicator(
          subject: SubjectCategory.math,
          topic: 'Pattern Recognition',
          severity: GapSeverity.low,
          gapDescription: 'Child takes slightly longer on skipping numbers by 2.',
          recommendedAction: 'Practice skip counting in Math Jungle.',
        ),
        LearningGapIndicator(
          subject: SubjectCategory.english,
          topic: 'Plurals',
          severity: GapSeverity.medium,
          gapDescription: 'Needs guidance distinguishing singular and plural word endings.',
          recommendedAction: 'Practice with Suman Ma\'am on simple plural words.',
        ),
      ],
      strengths: [
        'Hindi Vowel & Phonology Mastery',
        'Class 1 Addition Accuracy',
        'EVS Body Parts Identification',
      ],
      consentSettings: DPDPParentConsent(
        parentId: parentId,
        childStudentId: studentId,
        dpdpConsentGranted: true,
        coppaConsentGranted: true,
        allowVoiceDataProcessing: false,
        allowAnalyticsAggregation: true,
        dataRetentionDays: 30,
        consentStatus: ConsentStatus.granted,
      ),
      dailyScreenTimeLimitMinutes: 45,
    );
  }

  /// Updates parental consent settings (DPDP / COPPA)
  Future<DPDPParentConsent> updateParentConsent(DPDPParentConsent consent) async {
    final uri = Uri.parse('$baseUrl/analytics/parent-consent');
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(consent.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return DPDPParentConsent.fromJson(data);
    } else {
      throw Exception('Failed to update consent: ${response.statusCode}');
    }
  }
}
