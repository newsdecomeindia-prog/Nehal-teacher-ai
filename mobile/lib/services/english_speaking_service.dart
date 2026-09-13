import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/english_speaking.dart';

/// Service class for Mobile client communicating with English Small-Sentence Speaking Engine API.
class EnglishSpeakingService {
  final String? _explicitBaseUrl;
  final http.Client client;

  EnglishSpeakingService({
    String? baseUrl,
    http.Client? client,
  })  : _explicitBaseUrl = baseUrl,
        client = client ?? http.Client();

  String get baseUrl => _explicitBaseUrl ?? AppConfig.baseUrl;

  /// Fetch list of English speaking prompts optionally filtered by difficulty tier, with offline fallback.
  Future<List<SpeakingPrompt>> fetchPrompts({String? tier}) async {
    final uri = Uri.parse('$baseUrl/english-speaking/prompts').replace(
      queryParameters: tier != null ? {'tier': tier} : null,
    );

    try {
      final response = await client
          .get(
            uri,
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> promptsList = body['prompts'] as List<dynamic>? ?? [];
        return promptsList
            .map((e) => SpeakingPrompt.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Offline fallback
    }

    return _getFallbackPrompts(tier);
  }

  /// Submit student spoken attempt for evaluation and receive gentle encouraging feedback, with offline fallback.
  Future<SpeakingEvaluationResponse> evaluateAttempt(
      SpeakingEvaluationRequest request) async {
    final uri = Uri.parse('$baseUrl/english-speaking/evaluate');

    try {
      final response = await client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return SpeakingEvaluationResponse.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (_) {
      // Offline fallback
    }

    return _getFallbackEvaluationResponse(request);
  }

  List<SpeakingPrompt> _getFallbackPrompts(String? tier) {
    final allPrompts = [
      SpeakingPrompt(
        promptId: 'prompt-t1-01',
        tier: 'tier_1',
        targetSentence: 'Good Morning Teacher!',
        translationHindi: 'सुप्रभात अध्यापिका जी!',
        translationMarathi: 'शुभ सकाळ बाई!',
        phonetics: [
          TargetPhoneticGuide(
            word: 'Good Morning Teacher!',
            phoneticIpa: '/ɡʊd ˈmɔːrnɪŋ ˈtiːtʃər/',
            simplePhonetic: 'gud mor-ning tee-cher',
          ),
        ],
        theme: 'greetings',
      ),
      SpeakingPrompt(
        promptId: 'prompt-t2-01',
        tier: 'tier_2',
        targetSentence: 'I want an apple.',
        translationHindi: 'मुझे एक सेब चाहिए।',
        translationMarathi: 'मला एक सफरचंद हवे आहे.',
        phonetics: [
          TargetPhoneticGuide(
            word: 'I want an apple.',
            phoneticIpa: '/aɪ wɒnt æn ˈæp.əl/',
            simplePhonetic: 'ai wont an ap-puhl',
          ),
        ],
        theme: 'food_and_requests',
      ),
      SpeakingPrompt(
        promptId: 'prompt-t3-01',
        tier: 'tier_3',
        targetSentence: 'May I go to drink water please?',
        translationHindi: 'क्या मैं पानी पीने जा सकता हूँ?',
        translationMarathi: 'मी पाणी प्यायला जाऊ शकतो का?',
        phonetics: [
          TargetPhoneticGuide(
            word: 'May I go to drink water please?',
            phoneticIpa: '/meɪ aɪ ɡoʊ tuː drɪŋk ˈwɔːtər pliːz/',
            simplePhonetic: 'may ai go tu drink wah-ter pleez',
          ),
        ],
        theme: 'classroom_dialogue',
      ),
    ];

    if (tier != null && tier.isNotEmpty) {
      final filtered = allPrompts.where((p) => p.tier == tier).toList();
      if (filtered.isNotEmpty) return filtered;
    }

    return allPrompts;
  }

  SpeakingEvaluationResponse _getFallbackEvaluationResponse(
      SpeakingEvaluationRequest request) {
    final target = request.targetSentence ?? 'Good Morning Teacher!';
    return SpeakingEvaluationResponse(
      evaluationId: 'eval-off-101',
      studentId: request.studentId,
      promptId: request.promptId,
      targetSentence: target,
      spokenTranscript: request.spokenTranscript,
      accuracy: AccuracyScore(
        overallAccuracy: 92.0,
        wordAccuracy: 95.0,
        phoneticMatchPercentage: 90.0,
      ),
      fluency: FluencyMetrics(
        wordsPerMinute: 75.0,
        pauseCount: 0,
        fluencyScore: 90.0,
      ),
      wordDetails: [
        WordEvaluationDetail(
          targetWord: target,
          spokenWord: request.spokenTranscript,
          score: 95.0,
          errorCategory: 'none',
          childTip: 'Super clear voice! Excellent pronunciation!',
        ),
      ],
      feedback: GentleFeedback(
        encouragementMessage: 'Shabash! Excellent Speaking!',
        feedbackTag: 'starPerformer',
        starsEarned: 3,
        praisePoints: ['Clear pronunciation', 'Confident voice'],
        improvements: [],
      ),
      offlineFallback: true,
    );
  }
}
