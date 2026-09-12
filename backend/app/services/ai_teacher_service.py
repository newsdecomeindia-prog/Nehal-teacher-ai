"""
Service layer for Suman AI Teacher handling prompt construction,
RAG curriculum grounding context retrieval, safety filtering,
Rich Visual Cards generation, and response parsing.
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
            "नरेंद्र मोदी भारत के वर्तमान प्रधानमंत्री हैं। वे "
            "देश के विकास और बच्चों की शिक्षा के लिए काम करते हैं।"
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
        simple_explanation=(
            "मोर भारत का राष्ट्रीय पक्षी है। इसके पंख बहुत सुंदर और रंग-बिरंगे होते हैं।"
        ),
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
        RAG grounding, Rich Visual Card detection, and fallback explanation logic.
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

        if rich_card and not is_confused:
            mode = InteractionMode.STANDARD
            if lang == "hi":
                response_text = "नरेंद्र मोदी भारत के वर्तमान प्रधानमंत्री हैं। यहाँ उनके बारे में कार्ड देखें:"
            elif lang == "mr":
                response_text = "नरेंद्र मोदी हे भारताचे सध्याचे पंतप्रधान आहेत। खालील कार्ड पहा:"
            else:
                response_text = (
                    "Narendra Modi is the current Prime Minister of India. "
                    "Here is a rich visual card for you:"
                )
        elif is_confused:
            mode = InteractionMode.FALLBACK_EXPLANATION
            _prompt_payload = get_fallback_explanation_prompt(
                student_query=request.message,
                language=lang,
                concept_title=concept_title,
            )

            # Generate deterministic fallback answer based on concept & language
            if lang == "hi":
                response_text = (
                    f"{lang_config['fallback_prefix']} "
                    f"मान लीजिए आपके पास 3 लाल सेब हैं। "
                    f"अगर आप 1 सेब दोस्त को देंगे, तो आपके पास 2 सेब बचेंगे! "
                    f"इसी तरह {concept_title or 'यह विषय'} काम करता है। "
                    f"[Visual Cue: Three bright red apples on a wooden table]"
                )
            elif lang == "mr":
                response_text = (
                    f"{lang_config['fallback_prefix']} "
                    f"समजा तुझ्याकडे ३ गोड आंबे आहेत। "
                    f"त्यातील १ आंबा मित्राला दिला, तर तुझ्याकडे २ आंबे राहतात! "
                    f"{concept_title or 'हा घटक'} अगदी असाच सोपा आहे। "
                    f"[Visual Cue: Three ripe yellow mangoes in a basket]"
                )
            else:
                response_text = (
                    f"{lang_config['fallback_prefix']} "
                    f"Imagine you have 3 red apples on your table. "
                    f"If you eat 1 apple, you have 2 apples left! "
                    f"That is how {concept_title or 'this concept'} works. "
                    f"[Visual Cue: Three shiny red apples sitting on a table]"
                )
        else:
            mode = InteractionMode.STANDARD
            if concept_obj:
                if lang == "hi":
                    response_text = (
                        f"{concept_obj.explanation} "
                        f"क्या आप कोई उदाहरण देखना चाहेंगे?"
                    )
                elif lang == "mr":
                    response_text = (
                        f"{concept_obj.explanation} "
                        f"तुला याबद्दल आणखी काही विचारायचे आहे का?"
                    )
                else:
                    response_text = (
                        f"{concept_obj.explanation} "
                        f"Would you like to try a fun exercise on this?"
                    )
            else:
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
        )
