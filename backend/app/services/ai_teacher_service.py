"""
Service layer for Suman AI Teacher handling prompt construction,
RAG curriculum grounding context retrieval, safety filtering,
Rich Visual Cards generation, understanding-first pedagogical structure,
and fallback explanation logic.
"""

import re
from typing import List, Optional, Tuple

from backend.app.core.prompts import build_system_prompt, get_fallback_explanation_prompt
from backend.app.core.suman_persona import get_language_config
from backend.app.schemas.curriculum import Concept, SubjectCode
from backend.app.schemas.teacher import (
    InteractionMode,
    RichVisualCardPayload,
    RichVisualCardTitles,
    TeacherChatRequest,
    TeacherChatResponse,
)
from backend.app.services.curriculum_service import CurriculumService

# Keywords indicating child confusion or "I don't understand" triggers
CONFUSION_KEYWORDS = [
    "i don't understand",
    "dont understand",
    "don't understand",
    "confused",
    "i'm confused",
    "im confused",
    "hard",
    "too difficult",
    "what does this mean",
    "समझ नहीं आया",
    "समझ में नहीं आया",
    "कठिन",
    "समजले नाही",
    "कठीण आहे",
]

# Unsafe/harmful keywords that require strict child safety filtering
UNSAFE_KEYWORDS = [
    "violence",
    "kill",
    "fight",
    "weapon",
    "blood",
    "hate",
    "abuse",
    "porn",
    "sexy",
    "drug",
    "gambling",
    "gun",
    "knife",
    "murder",
    "suicide",
    "beer",
    "alcohol",
    "tobacco",
    "cigarette",
]

# Sample Multi-Modal Rich Visual Cards Store
RICH_VISUAL_CARDS_DB = {
    "modi": RichVisualCardPayload(
        entity_name="Narendra Modi",
        image_url="https://assets.nehalai.com/images/pm_modi.jpg",
        titles=RichVisualCardTitles(
            english="Narendra Modi",
            hindi="नरेंद्र मोदी",
            marathi="नरेंद्र मोदी",
        ),
        pronunciation_audio="https://assets.nehalai.com/audio/pm_modi_pron.mp3",
        simple_explanation=(
            "नरेंद्र मोदी भारत के वर्तमान प्रधानमंत्री हैं। वे देश के विकास और बच्चों की शिक्षा के लिए काम करते हैं।"
        ),
        checking_question="क्या आप जानते हैं कि भारत की राजधानी (Capital) कौन सी है?",
        class_level=1,
    ),
    "apple": RichVisualCardPayload(
        entity_name="Apple",
        image_url="https://assets.nehalai.com/images/apple.jpg",
        titles=RichVisualCardTitles(
            english="Apple",
            hindi="सेब",
            marathi="सफरचंद",
        ),
        pronunciation_audio="https://assets.nehalai.com/audio/apple_pron.mp3",
        simple_explanation="सेब एक मीठा और लाल फल है। यह सेहत के लिए बहुत अच्छा होता है!",
        checking_question="सेब का रंग कौन सा होता है?",
        class_level=1,
    ),
    "peacock": RichVisualCardPayload(
        entity_name="Peacock",
        image_url="https://assets.nehalai.com/images/peacock.jpg",
        titles=RichVisualCardTitles(
            english="Peacock",
            hindi="मोर",
            marathi="मोर",
        ),
        pronunciation_audio="https://assets.nehalai.com/audio/peacock_pron.mp3",
        simple_explanation=("मोर भारत का राष्ट्रीय पक्षी है। इसके पंख बहुत सुंदर और रंग-बिरंगे होते हैं।"),
        checking_question="क्या आपने बारिश में मोर को नाचते देखा है?",
        class_level=1,
    ),
}


class AITeacherService:
    @staticmethod
    def is_unsafe_content(message: str) -> bool:
        """Check if message contains unsafe or inappropriate keywords for children."""
        msg_lower = message.lower()
        return any(kw in msg_lower for kw in UNSAFE_KEYWORDS)

    @staticmethod
    def detect_confusion(message: str, is_confused_flag: bool) -> bool:
        """Determines if the student is expressing confusion or asked for simple breakdown."""
        if is_confused_flag:
            return True
        msg_lower = message.lower()
        return any(kw in msg_lower for kw in CONFUSION_KEYWORDS)

    @staticmethod
    def detect_rich_card(message: str) -> Optional[RichVisualCardPayload]:
        """Check query for entity keywords to attach a Multi-Modal Rich Visual Card."""
        msg_lower = message.lower()
        if "modi" in msg_lower or "प्रधानमंत्री" in msg_lower or "prime minister" in msg_lower:
            return RICH_VISUAL_CARDS_DB["modi"]
        if "apple" in msg_lower or "सेब" in msg_lower or "सफरचंद" in msg_lower:
            return RICH_VISUAL_CARDS_DB["apple"]
        if "peacock" in msg_lower or "मोर" in msg_lower or "national bird" in msg_lower:
            return RICH_VISUAL_CARDS_DB["peacock"]
        return None

    @staticmethod
    def get_curriculum_grounding(
        subject_code: Optional[SubjectCode],
        topic_id: Optional[str],
        concept_id: Optional[str],
    ) -> Tuple[Optional[str], Optional[Concept], List[str]]:
        """Retrieve RAG context details from CurriculumService."""
        subject_str = subject_code.value if subject_code else None
        concept_obj: Optional[Concept] = None
        learning_outcomes: List[str] = []

        if subject_code:
            subject = CurriculumService.get_subject_by_code(subject_code)
            if subject:
                subject_str = f"{subject.title_en} ({subject.title_native})"
                # Search for concept if concept_id is provided
                if topic_id or concept_id:
                    for topic in subject.topics:
                        if topic_id and topic.id != topic_id:
                            continue
                        for subtopic in topic.subtopics:
                            for c in subtopic.concepts:
                                if concept_id is None or c.id == concept_id:
                                    concept_obj = c
                                    learning_outcomes = [
                                        lo.description for lo in c.learning_outcomes
                                    ]
                                    break
                            if concept_obj:
                                break
                        if concept_obj:
                            break

        return subject_str, concept_obj, learning_outcomes

    @classmethod
    def process_chat_query(cls, request: TeacherChatRequest) -> TeacherChatResponse:
        """
        Process incoming student chat request through safety filtering,
        RAG grounding, Rich Visual Card detection, understanding-first pedagogical structure,
        and fallback explanation logic.
        """
        lang = request.language if request.language in ["en", "hi", "mr"] else "en"
        lang_config = get_language_config(lang)

        # 1. Child Safety Filter Check
        if cls.is_unsafe_content(request.message):
            return TeacherChatResponse(
                response_text=lang_config["out_of_scope"],
                language=lang,
                interaction_mode=InteractionMode.STANDARD,
                is_fallback_explanation=False,
                visual_cue_trigger=None,
                rich_card=None,
                grounded_concept_id=None,
                safety_filtered=True,
                encouragement_phrase=lang_config["encouragement"],
                simple_explanation="Safety filter active.",
                real_life_example=None,
                checking_question=None,
                child_response_evaluation=None,
                supportive_correction=None,
                teaching_strategy="safety_override",
            )

        # 2. Extract RAG curriculum grounding context & Rich Card match
        subject_str, concept_obj, outcomes = cls.get_curriculum_grounding(
            request.subject_code, request.topic_id, request.concept_id
        )
        rich_card = cls.detect_rich_card(request.message)

        concept_title = concept_obj.title if concept_obj else None
        concept_exp = concept_obj.explanation if concept_obj else None
        grounded_id = concept_obj.id if concept_obj else None

        # 3. Detect confusion and determine mode
        is_confused = cls.detect_confusion(request.message, request.is_confused)

        # 4. Generate system prompt (internal RAG prompt construction)
        _system_prompt = build_system_prompt(
            language=lang,
            subject_context=subject_str,
            concept_context=f"{concept_title}: {concept_exp}" if concept_title else None,
            learning_outcomes=outcomes,
        )

        simple_exp: Optional[str] = None
        real_life_ex: Optional[str] = None
        checking_q: Optional[str] = None
        child_eval: Optional[str] = None
        supportive_corr: Optional[str] = None
        teaching_strat = "standard_analogy"

        if rich_card and not is_confused:
            mode = InteractionMode.STANDARD
            simple_exp = rich_card.simple_explanation
            real_life_ex = f"Recognize {rich_card.entity_name} in pictures and daily books."
            checking_q = rich_card.checking_question
            child_eval = "Good job pointing out!"
            supportive_corr = "Let's learn more about this together."

            if lang == "hi":
                response_text = (
                    "नरेंद्र मोदी भारत के वर्तमान प्रधानमंत्री हैं। "
                    "वे देश के विकास और बच्चों की शिक्षा के लिए काम करते हैं। "
                    "उदाहरण: जैसे घर में मम्मी-पापा ध्यान रखते हैं, वैसे ही प्रधानमंत्री ध्यान रखते हैं। "
                    "प्रश्न: क्या आप जानते हैं कि भारत की राजधानी कौन सी है?"
                )
            elif lang == "mr":
                response_text = (
                    "नरेंद्र मोदी हे भारताचे सध्याचे पंतप्रधान आहेत। "
                    "उदाहरण: जसे घरात आपले पालक काळजी घेतात, तसेच पंतप्रधान देशाची काळजी घेतात. "
                    "प्रश्न: खालील कार्ड पाहून सांगा!"
                )
            else:
                response_text = (
                    "Narendra Modi is the current Prime Minister of India. "
                    "Example: Just like parents care for a family, PM guides the country. "
                    "Question: Do you know the capital city of India?"
                )

        elif is_confused:
            mode = InteractionMode.FALLBACK_EXPLANATION
            _prompt_payload = get_fallback_explanation_prompt(
                student_query=request.message,
                language=lang,
                concept_title=concept_title,
            )

            # Alternative teaching strategy fallback: Story / Simpler Analogy / Visual
            if "story" in request.message.lower() or "कहानी" in request.message:
                teaching_strat = "story"
                if lang == "hi":
                    simple_exp = "चलो एक छोटी सी कहानी सुनते हैं!"
                    real_life_ex = "जंगल में एक नन्हा खरगोश और 3 मीठे गाजर थे।"
                    checking_q = "अगर खरगोश ने 1 गाजर खा लिया, तो कितने बचे?"
                    child_eval = "कहानी ध्यान से सुनने के लिए शाबाश!"
                    supportive_corr = "गिनती बहुत आसान है, आप बिल्कुल सही जा रहे हैं!"
                    response_text = (
                        f"{lang_config['fallback_prefix']} "
                        f"चलो एक छोटी सी कहानी सुनते हैं! जंगल में नन्हे खरगोश के पास 3 मीठे गाजर थे। "
                        f"1 गाजर उसने खा लिया, तो 2 गाजर बचे! "
                        f"क्या आप बता सकते हैं 3 - 1 कितना हुआ? "
                        f"[Visual Cue: Little rabbit enjoying carrots in a green forest]"
                    )
                elif lang == "mr":
                    simple_exp = "चला एक छोटी गोष्ट ऐकूया!"
                    real_life_ex = "जंगलात सशाकडे ३ गोड गाजरे होती."
                    checking_q = "सशाने १ गाजर खाल्ले, तर किती उरले?"
                    child_eval = "छान प्रयास!"
                    supportive_corr = "अगदी सोपे आहे!"
                    response_text = (
                        f"{lang_config['fallback_prefix']} "
                        f"चला एक छोटी गोष्ट ऐकूया! जंगलात सशाकडे ३ गोड गाजरे होती. "
                        f"१ गाजर त्याने खाल्ले, तर २ गाजरे उरली! "
                        f"[Visual Cue: Playful bunny eating carrots]"
                    )
                else:
                    simple_exp = "Let's listen to a short story!"
                    real_life_ex = "A little bunny had 3 crunchy carrots in the forest."
                    checking_q = "If bunny eats 1 carrot, how many remain?"
                    child_eval = "Great story listening!"
                    supportive_corr = "Counting is fun and easy!"
                    response_text = (
                        f"{lang_config['fallback_prefix']} "
                        f"Let's hear a short story! A bunny had 3 carrots in the green forest. "
                        f"When bunny eats 1 carrot, 2 carrots are left! "
                        f"So 3 take away 1 leaves 2! "
                        f"[Visual Cue: Cute rabbit in forest with 3 carrots]"
                    )
            else:
                teaching_strat = "simpler_analogy"
                if lang == "hi":
                    simple_exp = "कोई बात नहीं! इसे और भी आसान उदाहरण से समझते हैं।"
                    real_life_ex = "मान लीजिए आपके पास 3 लाल सेब हैं।"
                    checking_q = "अगर आप 1 सेब दोस्त को देंगे, तो आपके पास कितने सेब बचेंगे?"
                    child_eval = "घबराइए मत, सुमन मैम आपके साथ हैं।"
                    supportive_corr = "धीरे-धीरे गिनें: एक, दो, तीन!"
                    response_text = (
                        f"{lang_config['fallback_prefix']} "
                        f"मान लीजिए आपके पास 3 लाल सेब हैं। "
                        f"अगर आप 1 सेब दोस्त को देंगे, तो आपके पास 2 सेब बचेंगे! "
                        f"इसी तरह {concept_title or 'यह विषय'} काम करता है। "
                        f"बताइए, 3 में से 1 घटाने पर कितने सेब बचे? "
                        f"[Visual Cue: Three bright red apples on a wooden table]"
                    )
                elif lang == "mr":
                    simple_exp = "काही हरकत नाही! आपण आणखी सोप्या उदाहरणाने शिकूया."
                    real_life_ex = "समजा तुझ्याकडे ३ गोड आंबे आहेत."
                    checking_q = "१ आंबा मित्राला दिला, तर तुझ्याकडे किती राहतील?"
                    child_eval = "छान प्रयत्न!"
                    supportive_corr = "हळूहळू मोजा."
                    response_text = (
                        f"{lang_config['fallback_prefix']} "
                        f"समजा तुझ्याकडे ३ गोड आंबे आहेत. "
                        f"त्यातील १ आंबा मित्राला दिला, तर तुझ्याकडे २ आंबे राहतात! "
                        f"{concept_title or 'हा घटक'} अगदी असाच सोपा आहे. "
                        f"[Visual Cue: Three ripe yellow mangoes in a basket]"
                    )
                else:
                    simple_exp = "No worries at all! Let's make it super simple."
                    real_life_ex = "Imagine you have 3 red apples on your table."
                    checking_q = "If you give 1 apple to a friend, how many are left?"
                    child_eval = "You are doing great!"
                    supportive_corr = "Let's count together step by step."
                    response_text = (
                        f"{lang_config['fallback_prefix']} "
                        f"Imagine you have 3 red apples on your table. "
                        f"If you give 1 apple to your friend, you have 2 apples left! "
                        f"That is how {concept_title or 'this concept'} works. "
                        f"How many apples remain? "
                        f"[Visual Cue: Three shiny red apples sitting on a table]"
                    )

        else:
            mode = InteractionMode.STANDARD
            teaching_strat = "standard_analogy"
            if concept_obj:
                simple_exp = concept_obj.explanation
                title = concept_obj.title
                real_life_ex = f"Look around your house or classroom for examples of {title}."
                checking_q = f"Can you give one example of {title}?"
                child_eval = "Excellent curiosity!"
                supportive_corr = "Practice makes you a master star student!"

                if lang == "hi":
                    response_text = (
                        f"व्याख्या: {concept_obj.explanation}\n"
                        f"उदाहरण: अपने घर के आसपास की चीज़ों में इसे देखें।\n"
                        f"प्रश्न: क्या आप एक उदाहरण दे सकते हैं?"
                    )
                elif lang == "mr":
                    response_text = (
                        f"स्पष्टीकरण: {concept_obj.explanation}\n"
                        f"उदाहरण: आपल्या घरातील वस्तू पहा.\n"
                        f"प्रश्न: मला एक उदाहरण सांगशील का?"
                    )
                else:
                    response_text = (
                        f"Explanation: {concept_obj.explanation}\n"
                        f"Example: Look at everyday items around your room.\n"
                        f"Question: Would you like to try a fun exercise on this?"
                    )
            else:
                simple_exp = lang_config["greeting"]
                real_life_ex = "We learn new things every day!"
                checking_q = "What subject do you want to learn today?"
                child_eval = "Welcome back!"
                supportive_corr = "Let's start learning together!"
                response_text = lang_config["greeting"]

        # Extract visual cue trigger if formatted in bracket
        visual_cue = None
        visual_match = re.search(r"\[Visual Cue:\s*(.*?)\]", response_text)
        if visual_match:
            visual_cue = visual_match.group(1).strip()

        return TeacherChatResponse(
            response_text=response_text,
            language=lang,
            interaction_mode=mode,
            is_fallback_explanation=is_confused,
            visual_cue_trigger=visual_cue,
            rich_card=rich_card,
            grounded_concept_id=grounded_id,
            safety_filtered=False,
            encouragement_phrase=lang_config["encouragement"],
            simple_explanation=simple_exp,
            real_life_example=real_life_ex,
            checking_question=checking_q,
            child_response_evaluation=child_eval,
            supportive_correction=supportive_corr,
            teaching_strategy=teaching_strat,
        )
