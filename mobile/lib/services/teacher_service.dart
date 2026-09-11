import '../models/teacher.dart';

class TeacherService {
  final String baseUrl;

  TeacherService({this.baseUrl = 'http://localhost:8000/api/v1'});

  Future<TeacherPersonaConfig> getTeacherPersona({String language = 'en'}) async {
    // Client-side service layer wrapper for fetching Suman AI Teacher persona
    return TeacherPersonaConfig(
      name: 'Suman AI',
      language: language,
      tone: 'warm, supportive, patient',
      gradeLevel: 1,
    );
  }

  Future<TeacherChatResponse> sendChatMessage(TeacherChatRequest request) async {
    // Mobile client service method for sending query to /api/v1/teacher/chat
    // Falls back to structured offline response when backend is unreachable
    try {
      // HTTP call placeholder
      return _generateOfflineFallbackResponse(request);
    } catch (e) {
      return _generateOfflineFallbackResponse(request);
    }
  }

  TeacherChatResponse _generateOfflineFallbackResponse(TeacherChatRequest request) {
    if (request.isConfused || request.message.toLowerCase().contains('understand')) {
      return TeacherChatResponse(
        responseText: request.language == 'hi'
            ? 'चलो इसे एक आसान उदाहरण के साथ समझते हैं! [Visual Cue: सेब का चित्र]'
            : request.language == 'mr'
                ? 'चला, हे सोप्या पद्धतीने समजून घेऊया! [Visual Cue: आंब्याचे चित्र]'
                : 'Let us try understanding this in a simpler way! [Visual Cue: Three red apples]',
        language: request.language,
        interactionMode: 'fallback_explanation',
        isFallbackExplanation: true,
        visualCueTrigger: 'Three red apples',
        groundedConceptId: request.conceptId,
        safetyFiltered: false,
        encouragementPhrase: 'Great effort!',
      );
    }

    return TeacherChatResponse(
      responseText: request.language == 'hi'
          ? 'नमस्ते! मैं सुमन टीचर हूँ। चलिए साथ मिलकर सीखते हैं!'
          : request.language == 'mr'
              ? 'नमस्कार! मी तुमची सुमन बाई आहे. चला एकत्र शिकूया!'
              : 'Hello dear! I am Suman Teacher. What shall we learn together today?',
      language: request.language,
      interactionMode: 'standard',
      isFallbackExplanation: false,
      visualCueTrigger: null,
      groundedConceptId: request.conceptId,
      safetyFiltered: false,
      encouragementPhrase: 'Keep learning!',
    );
  }
}
