import 'package:flutter_test/flutter_test.dart';
import 'package:nehal_teacher_ai_mobile/models/teacher.dart';
import 'package:nehal_teacher_ai_mobile/services/teacher_service.dart';
import 'package:nehal_teacher_ai_mobile/models/multimodal.dart';
import 'package:nehal_teacher_ai_mobile/services/multimodal_service.dart';
import 'package:nehal_teacher_ai_mobile/models/english_speaking.dart';
import 'package:nehal_teacher_ai_mobile/services/english_speaking_service.dart';

void main() {
  group('Offline / Fallback Local AI Engine Tests', () {
    test('TeacherService generates dynamic offline responses for various topics', () async {
      final service = TeacherService(baseUrl: 'http://10.0.2.2:9999/api/v1'); // Unreachable port

      // Test Greeting Query
      final greetingReq = TeacherChatRequest(
        studentId: 'test_student',
        message: 'Hello Suman Teacher!',
        language: 'en',
      );
      final greetingRes = await service.sendChatMessage(greetingReq);
      expect(greetingRes.responseText, contains('Suman Teacher'));
      expect(greetingRes.language, equals('en'));

      // Test PM Modi GK Query
      final modiReq = TeacherChatRequest(
        studentId: 'test_student',
        message: 'Who is Modi?',
        language: 'hi',
      );
      final modiRes = await service.sendChatMessage(modiReq);
      expect(modiRes.richCard, isNotNull);
      expect(modiRes.richCard!.entityName, equals('Narendra Modi'));

      // Test Math Query
      final mathReq = TeacherChatRequest(
        studentId: 'test_student',
        message: 'How to do addition 3+5?',
        language: 'en',
      );
      final mathRes = await service.sendChatMessage(mathReq);
      expect(mathRes.responseText, contains('3 + 5 = 8'));
      expect(mathRes.visualCueTrigger, isNotNull);

      // Test Story Query
      final storyReq = TeacherChatRequest(
        studentId: 'test_student',
        message: 'Tell me a story about lion and mouse',
        language: 'hi',
      );
      final storyRes = await service.sendChatMessage(storyReq);
      expect(storyRes.responseText, contains('शेर और चूहा'));

      // Test Confusion Fallback
      final confusedReq = TeacherChatRequest(
        studentId: 'test_student',
        message: 'I do not understand',
        language: 'en',
        isConfused: true,
      );
      final confusedRes = await service.sendChatMessage(confusedReq);
      expect(confusedRes.isFallbackExplanation, isTrue);
    });

    test('MultiModalService provides offline fallback for STT, TTS, and Homework Scan', () async {
      final multimodal = MultiModalService(baseUrl: 'http://10.0.2.2:9999/api/v1');

      // STT Fallback
      final sttPayload = STTAudioPayload(
        studentId: 'test_student',
        languageHint: 'hi',
      );
      final sttRes = await multimodal.transcribeSpeech(sttPayload);
      expect(sttRes.transcribedText, contains('नमस्ते सुमन टीचर'));
      expect(sttRes.offlineFallback, isTrue);

      // OCR Homework Scan Fallback
      final ocrPayload = ImageScanPayload(
        studentId: 'test_student',
        subjectHint: 'math',
      );
      final ocrRes = await multimodal.scanHomeworkPhoto(ocrPayload);
      expect(ocrRes.detectedText, contains('3 + 5'));
      expect(ocrRes.piiRedacted, isTrue);
      expect(ocrRes.offlineFallback, isTrue);
    });

    test('EnglishSpeakingService provides offline fallback for prompts and evaluation', () async {
      final speaking = EnglishSpeakingService(baseUrl: 'http://10.0.2.2:9999/api/v1');

      final prompts = await speaking.fetchPrompts(tier: 'tier_1');
      expect(prompts, isNotEmpty);
      expect(prompts.first.targetSentence, equals('Good Morning Teacher!'));

      final evalReq = SpeakingEvaluationRequest(
        studentId: 'test_student',
        promptId: prompts.first.promptId,
        spokenTranscript: 'Good Morning Teacher!',
      );
      final evalRes = await speaking.evaluateAttempt(evalReq);
      expect(evalRes.accuracy.overallAccuracy, greaterThan(80.0));
      expect(evalRes.offlineFallback, isTrue);
    });
  });
}
