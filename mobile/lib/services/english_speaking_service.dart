import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/english_speaking.dart';

/// Service class for Mobile client communicating with English Small-Sentence Speaking Engine API.
class EnglishSpeakingService {
  final String baseUrl;
  final http.Client client;

  EnglishSpeakingService({
    String? baseUrl,
    http.Client? client,
  })  : baseUrl = baseUrl ?? AppConfig.baseUrl,
        client = client ?? http.Client();

  /// Fetch list of English speaking prompts optionally filtered by difficulty tier.
  Future<List<SpeakingPrompt>> fetchPrompts({String? tier}) async {
    final uri = Uri.parse('$baseUrl/english-speaking/prompts').replace(
      queryParameters: tier != null ? {'tier': tier} : null,
    );

    final response = await client.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> promptsList = body['prompts'] as List<dynamic>? ?? [];
      return promptsList
          .map((e) => SpeakingPrompt.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Failed to fetch speaking prompts: ${response.statusCode} - ${response.body}');
    }
  }

  /// Submit student spoken attempt for evaluation and receive gentle encouraging feedback.
  Future<SpeakingEvaluationResponse> evaluateAttempt(
      SpeakingEvaluationRequest request) async {
    final uri = Uri.parse('$baseUrl/english-speaking/evaluate');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return SpeakingEvaluationResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception(
          'Failed to evaluate speaking attempt: ${response.statusCode} - ${response.body}');
    }
  }
}
