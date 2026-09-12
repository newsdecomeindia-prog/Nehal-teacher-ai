// Mobile service for handling exams, analytics, and parent portal APIs

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/analytics.dart';

class AnalyticsService {
  final String baseUrl;
  final http.Client client;

  AnalyticsService({
    this.baseUrl = 'http://10.0.2.2:8000/api/v1',
    http.Client? client,
  }) : client = client ?? http.Client();

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

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ExamPaper.fromJson(data);
    } else {
      throw Exception('Failed to generate exam: ${response.statusCode}');
    }
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
    } else {
      throw Exception('Failed to submit exam: ${response.statusCode}');
    }
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

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ParentDashboardResponse.fromJson(data);
    } else {
      throw Exception('Failed to load parent dashboard: ${response.statusCode}');
    }
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
