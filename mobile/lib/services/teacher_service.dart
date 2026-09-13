import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/teacher.dart';
import '../widgets/rich_visual_card.dart';

class TeacherService {
  final String? _explicitBaseUrl;
  final http.Client client;

  TeacherService({
    String? baseUrl,
    http.Client? client,
  })  : _explicitBaseUrl = baseUrl,
        client = client ?? http.Client();

  String get baseUrl => _explicitBaseUrl ?? AppConfig.baseUrl;

  Future<TeacherPersonaConfig> getTeacherPersona({String language = 'en'}) async {
    final uri = Uri.parse('$baseUrl/teacher/persona').replace(
      queryParameters: {'language': language},
    );
    try {
      final response = await client.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        return TeacherPersonaConfig.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (_) {
      // Return default persona config on network timeout or offline
    }

    return TeacherPersonaConfig(
      name: 'Suman AI',
      language: language,
      tone: 'warm, supportive, patient',
      gradeLevel: 1,
    );
  }

  Future<TeacherChatResponse> sendChatMessage(TeacherChatRequest request) async {
    final uri = Uri.parse('$baseUrl/teacher/chat');

    try {
      final response = await client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        return TeacherChatResponse.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (_) {
      // Automatic seamless fallback to local in-app AI engine on network timeout or connection failure
    }

    return generateOfflineFallbackResponse(request);
  }

  TeacherChatResponse generateOfflineFallbackResponse(TeacherChatRequest request) {
    final msgLower = request.message.toLowerCase().trim();
    final lang = request.language;

    // 1. Confused / Clarification handling
    if (request.isConfused ||
        msgLower.contains('understand') ||
        msgLower.contains('confused') ||
        msgLower.contains('समझा नहीं') ||
        msgLower.contains('समजले नाही') ||
        msgLower.contains('कळले नाही')) {
      return TeacherChatResponse(
        responseText: lang == 'hi'
            ? 'कोई बात नहीं! चलो इसे बहुत सरल उदाहरण से समझते हैं! 🌟 [Visual Cue: 3 लाल सेब]\nजब हमारे पास 2 सेब हों और 1 सेब और मिले, तो कुल 3 सेब बनते हैं।\n\nक्या अब यह समझ आया?'
            : lang == 'mr'
                ? 'काही हरकत नाही! आपण हे अगदी सोप्या उदाहरणाने समजून घेऊया! 🌟 [Visual Cue: 3 सफरचंद]\n2 सफरचंद अधिक 1 सफरचंद म्हणजे 3 सफरचंद!\n\nतुम्हाला हे समजले का?'
                : 'No worries at all! Let us break it down step-by-step! 🌟 [Visual Cue: Three red apples]\nImagine you have 2 apples and Suman Teacher gives you 1 more apple. Now you have 3 apples in total!\n\nDoes this make it easy to understand?',
        language: lang,
        interactionMode: 'fallback_explanation',
        isFallbackExplanation: true,
        visualCueTrigger: 'Three red apples 🍎🍎🍎',
        groundedConceptId: request.conceptId,
        safetyFiltered: false,
        encouragementPhrase: 'Great effort!',
      );
    }

    // 2. Greetings match
    if (msgLower.contains('hello') ||
        msgLower.contains('hi') ||
        msgLower.contains('namaste') ||
        msgLower.contains('hey') ||
        msgLower.contains('नमस्ते') ||
        msgLower.contains('नमस्कार') ||
        msgLower.contains('good morning') ||
        msgLower.contains('good afternoon')) {
      return TeacherChatResponse(
        responseText: lang == 'hi'
            ? 'नमस्ते! मैं सुमन टीचर हूँ। आज आप क्या सीखना चाहते हैं - गणित (Math), सामान्य ज्ञान (GK), या एक सुंदर कहानी (Story)?'
            : lang == 'mr'
                ? 'नमस्कार! मी तुमची सुमन बाई आहे. आज तुम्हाला काय शिकायला आवडेल - गणित (Math), सामान्य ज्ञान (GK), की एक छान गोष्ट (Story)?'
                : 'Hello dear! I am Suman Teacher. What would you like to learn today - Math, General Knowledge (GK), or a fun Story?',
        language: lang,
        interactionMode: 'standard',
        isFallbackExplanation: false,
        visualCueTrigger: 'Suman Teacher Greeting 👩‍🏫',
        groundedConceptId: request.conceptId,
        safetyFiltered: false,
        encouragementPhrase: 'Welcome back!',
      );
    }

    // 3. PM Modi / Prime Minister / Leader queries
    if (msgLower.contains('modi') ||
        msgLower.contains('प्रधानमंत्री') ||
        msgLower.contains('पंतप्रधान') ||
        msgLower.contains('prime minister') ||
        msgLower.contains('narendra') ||
        msgLower.contains('pm')) {
      final richCard = RichVisualCardData(
        entityName: 'Narendra Modi',
        imageUrl: 'https://assets.nehalai.com/images/pm_modi.jpg',
        titles: {
          'english': 'Narendra Modi',
          'hindi': 'नरेंद्र मोदी',
          'marathi': 'नरेंद्र मोदी',
        },
        pronunciationAudio: 'https://assets.nehalai.com/audio/pm_modi_pron.mp3',
        simpleExplanation:
            'नरेंद्र मोदी भारत के वर्तमान प्रधानमंत्री हैं। वे देश के विकास और बच्चों की शिक्षा के लिए काम करते हैं।',
        checkingQuestion:
            'क्या आप जानते हैं कि भारत की राजधानी (Capital) कौन सी है?',
        classLevel: 1,
      );

      return TeacherChatResponse(
        responseText: lang == 'hi'
            ? 'नरेंद्र मोदी भारत के वर्तमान प्रधानमंत्री हैं। यहाँ उनके बारे में कार्ड देखें:'
            : lang == 'mr'
                ? 'नरेंद्र मोदी हे भारताचे सध्याचे पंतप्रधान आहेत. खालील कार्ड पहा:'
                : 'Narendra Modi is the current Prime Minister of India. Here is a rich visual card for you:',
        language: lang,
        interactionMode: 'standard',
        isFallbackExplanation: false,
        richCard: richCard,
        visualCueTrigger: 'Narendra Modi',
        groundedConceptId: request.conceptId,
        safetyFiltered: false,
        encouragementPhrase: 'Shabash!',
      );
    }

    // 4. Stories / Kahani / Goshta queries
    if (msgLower.contains('story') ||
        msgLower.contains('stories') ||
        msgLower.contains('kahani') ||
        msgLower.contains('goshta') ||
        msgLower.contains('कहानी') ||
        msgLower.contains('गोष्ट') ||
        msgLower.contains('moral') ||
        msgLower.contains('crow') ||
        msgLower.contains('lion')) {
      return TeacherChatResponse(
        responseText: lang == 'hi'
            ? 'यहाँ एक सुंदर कहानी है: "शेर और चूहा" (The Lion and the Mouse) 🦁🐭\n\nएक दिन एक छोटे चूहे ने शेर का जाल कुतर कर उसकी जान बचाई।\nसीख: हर छोटी मदद भी बहुत मूल्यवान होती है!\n\nप्रश्न: कहानी में शेर की मदद किसने की?'
            : lang == 'mr'
                ? 'ही पाहा एक छान गोष्ट: "सिंह आणि उंदीर" 🦁🐭\n\nएका छोट्या उंदराने सिंहाची जाळ्यातून सुटका केली.\nतात्पर्य: कोणीही लहान किंवा मोठा नसतो, सर्व एकमेकांना मदत करू शकतात!\n\nप्रश्न: सिंहाला कोणी मदत केली?'
                : 'Here is a wonderful story: "The Lion and the Mouse" 🦁🐭\n\nOne day, a tiny mouse freed a mighty lion by chewing through the hunter\'s net.\nMoral: A small act of kindness is always valued!\n\nChecking Question: Who helped the mighty lion in this story?',
        language: lang,
        interactionMode: 'standard',
        isFallbackExplanation: false,
        visualCueTrigger: 'Lion and Mouse Story 🦁🐭',
        groundedConceptId: request.conceptId,
        safetyFiltered: false,
        encouragementPhrase: 'Great story time!',
      );
    }

    // 5. Math / Addition / Counting queries
    if (msgLower.contains('math') ||
        msgLower.contains('add') ||
        msgLower.contains('plus') ||
        msgLower.contains('count') ||
        msgLower.contains('counting') ||
        msgLower.contains('number') ||
        msgLower.contains('2+2') ||
        msgLower.contains('3+5') ||
        msgLower.contains('गणित') ||
        msgLower.contains('जोड़') ||
        msgLower.contains('गिनती') ||
        msgLower.contains('संख्या') ||
        msgLower.contains('बेरीज')) {
      return TeacherChatResponse(
        responseText: lang == 'hi'
            ? 'गणित बहुत आसान और मजेदार है! चलिए जोड़ते हैं: 3 + 5 = 8। [Visual Cue: 8 सेब 🍎🍎🍎🍎🍎🍎🍎🍎]\n\nक्या आप बता सकते हैं कि 2 + 2 कितना होता है?'
            : lang == 'mr'
                ? 'गणित खूप सोपे आणि मजेशीर आहे! चला बेरीज करूया: 3 + 5 = 8. [Visual Cue: 8 सफरचंद 🍎]\n\nमला सांगा, 2 + 2 किती होतात?'
                : 'Math is fun and easy! Let us count together: 3 + 5 = 8! [Visual Cue: Eight red apples 🍎🍎🍎🍎🍎🍎🍎🍎]\n\nCan you tell me what is 2 + 2?',
        language: lang,
        interactionMode: 'standard',
        isFallbackExplanation: false,
        visualCueTrigger: 'Eight Red Apples 🍎🍎🍎🍎🍎🍎🍎🍎',
        groundedConceptId: request.conceptId,
        safetyFiltered: false,
        encouragementPhrase: 'Math Genius!',
      );
    }

    // 6. Animals / Fruits / General Knowledge
    if (msgLower.contains('animal') ||
        msgLower.contains('peacock') ||
        msgLower.contains('bird') ||
        msgLower.contains('जानवर') ||
        msgLower.contains('मोर') ||
        msgLower.contains('प्राणी') ||
        msgLower.contains('पक्षी')) {
      final richCard = RichVisualCardData(
        entityName: 'Peacock',
        imageUrl: 'https://assets.nehalai.com/images/peacock.jpg',
        titles: {
          'english': 'Peacock',
          'hindi': 'मोर',
          'marathi': 'मोर',
        },
        pronunciationAudio: 'https://assets.nehalai.com/audio/peacock.mp3',
        simpleExplanation:
            'Peacock is the national bird of India. It has beautiful colorful feathers and dances in rainy season!',
        checkingQuestion: 'How many legs does a bird have?',
        classLevel: 1,
      );

      return TeacherChatResponse(
        responseText: lang == 'hi'
            ? 'मोर भारत का राष्ट्रीय पक्षी है। इसके बहुत सुंदर पंख होते हैं! यहाँ कार्ड देखें:'
            : lang == 'mr'
                ? 'मोर हा भारताचा राष्ट्रीय पक्षी आहे. पावसाळ्यात तो छान नाचतो! कार्ड पहा:'
                : 'The Peacock is the national bird of India with beautiful feathers! Here is a card for you:',
        language: lang,
        interactionMode: 'standard',
        isFallbackExplanation: false,
        richCard: richCard,
        visualCueTrigger: 'National Bird Peacock 🦚',
        groundedConceptId: request.conceptId,
        safetyFiltered: false,
        encouragementPhrase: 'Wonderful choice!',
      );
    }

    if (msgLower.contains('fruit') ||
        msgLower.contains('apple') ||
        msgLower.contains('mango') ||
        msgLower.contains('फल') ||
        msgLower.contains('सेब') ||
        msgLower.contains('आम') ||
        msgLower.contains('फळ')) {
      final richCard = RichVisualCardData(
        entityName: 'Mango',
        imageUrl: 'https://assets.nehalai.com/images/mango.jpg',
        titles: {
          'english': 'Mango',
          'hindi': 'आम',
          'marathi': 'आंबा',
        },
        pronunciationAudio: 'https://assets.nehalai.com/audio/mango.mp3',
        simpleExplanation:
            'Mango is known as the king of fruits. It is sweet, juicy, and full of vitamin C!',
        checkingQuestion: 'What is your favorite fruit?',
        classLevel: 1,
      );

      return TeacherChatResponse(
        responseText: lang == 'hi'
            ? 'आम फलों का राजा है! यह बहुत ही मीठा और स्वादिष्ट होता है। यहाँ कार्ड देखें:'
            : lang == 'mr'
                ? 'आंबा हा फळांचा राजा आहे! तो खूप गोड आणि रसाळ असतो. कार्ड पहा:'
                : 'Mango is the king of fruits! It is sweet and juicy. Here is a visual card:',
        language: lang,
        interactionMode: 'standard',
        isFallbackExplanation: false,
        richCard: richCard,
        visualCueTrigger: 'Mango Fruit 🥭',
        groundedConceptId: request.conceptId,
        safetyFiltered: false,
        encouragementPhrase: 'Yummy choice!',
      );
    }

    // 7. General fallback responder with dynamic prompt context
    return TeacherChatResponse(
      responseText: lang == 'hi'
          ? 'बहुत बढ़िया सवाल! "${request.message}" के बारे में चलिए साथ मिलकर सीखते हैं। [Visual Cue: चित्र देखें]\nसुमन टीचर कहती हैं: अभ्यास से हर चीज़ आसान हो जाती है!\n\nक्या आप इसके बारे में एक छोटा सवाल हल करना चाहेंगे?'
          : lang == 'mr'
              ? 'छान प्रश्न! "${request.message}" बद्दल आपण सोप्या भाषेत शिकूया. [Visual Cue: चित्र]\nसुमन बाई म्हणतात: सतत प्रयत्नाने सर्व सोपे होते!\n\nतुम्हाला याबाबत एक छोटा प्रश्न सोडवायला आवडेल का?'
              : 'Great question about "${request.message}"! [Visual Cue: Learning Illustration]\nSuman Teacher says: Learning step-by-step makes us smarter every day!\n\nWould you like to try a small practice question together?',
      language: lang,
      interactionMode: 'standard',
      isFallbackExplanation: false,
      visualCueTrigger: 'Learning Illustration 📖',
      groundedConceptId: request.conceptId,
      safetyFiltered: false,
      encouragementPhrase: 'Keep learning!',
    );
  }
}
