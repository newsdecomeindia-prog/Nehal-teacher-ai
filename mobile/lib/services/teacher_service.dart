import '../models/teacher.dart';
import '../widgets/rich_visual_card.dart';

class TeacherService {
  final String baseUrl;

  TeacherService({this.baseUrl = 'http://localhost:8000/api/v1'});

  Future<TeacherPersonaConfig> getTeacherPersona({String language = 'en'}) async {
    return TeacherPersonaConfig(
      name: 'Suman AI',
      language: language,
      tone: 'warm, supportive, patient',
      gradeLevel: 1,
    );
  }

  Future<TeacherChatResponse> sendChatMessage(TeacherChatRequest request) async {
    try {
      return _generateOfflineFallbackResponse(request);
    } catch (e) {
      return _generateOfflineFallbackResponse(request);
    }
  }

  TeacherChatResponse _generateOfflineFallbackResponse(TeacherChatRequest request) {
    final msgLower = request.message.toLowerCase();

    // PM Modi entity match query
    if (msgLower.contains('modi') || msgLower.contains('प्रधानमंत्री') || msgLower.contains('prime minister')) {
      final richCard = RichVisualCardData(
        entityName: 'Narendra Modi',
        imageUrl: 'https://assets.nehalai.com/images/pm_modi.jpg',
        titles: {
          'english': 'Narendra Modi',
          'hindi': 'नरेंद्र मोदी',
          'marathi': 'नरेंद्र मोदी',
        },
        pronunciationAudio: 'https://assets.nehalai.com/audio/pm_modi_pron.mp3',
        simpleExplanation: 'नरेंद्र मोदी भारत के वर्तमान प्रधानमंत्री हैं। वे देश के विकास और बच्चों की शिक्षा के लिए काम करते हैं।',
        checkingQuestion: 'क्या आप जानते हैं कि भारत की राजधानी (Capital) कौन सी है?',
        classLevel: 1,
      );

      return TeacherChatResponse(
        responseText: request.language == 'hi'
            ? 'नरेंद्र मोदी भारत के वर्तमान प्रधानमंत्री हैं। यहाँ उनके बारे में कार्ड देखें:'
            : request.language == 'mr'
                ? 'नरेंद्र मोदी हे भारताचे सध्याचे पंतप्रधान आहेत. खालील कार्ड पहा:'
                : 'Narendra Modi is the current Prime Minister of India. Here is a rich visual card for you:',
        language: request.language,
        interactionMode: 'standard',
        isFallbackExplanation: false,
        richCard: richCard,
        visualCueTrigger: 'Narendra Modi',
        groundedConceptId: request.conceptId,
        safetyFiltered: false,
        encouragementPhrase: 'Shabash!',
      );
    }

    if (request.isConfused || msgLower.contains('understand')) {
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
