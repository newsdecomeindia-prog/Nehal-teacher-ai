import uuid
from typing import Dict, List, Optional, Tuple

from backend.app.schemas.english_speaking import (
    AccuracyScore,
    ChildFeedbackTag,
    DifficultyTier,
    ErrorCategory,
    FluencyMetrics,
    GentleFeedback,
    SpeakingEvaluationRequest,
    SpeakingEvaluationResponse,
    SpeakingPrompt,
    TargetPhoneticGuide,
    WordEvaluationDetail,
)

# Built-in sample daily & lesson speaking practice prompts bank across 3 tiers
SAMPLE_PROMPTS: List[SpeakingPrompt] = [
    # Tier Level 1: 2-3 word phrases
    SpeakingPrompt(
        prompt_id="prompt-l1-001",
        tier=DifficultyTier.LEVEL_1,
        target_sentence="Good morning",
        translation_hindi="शुभ प्रभात",
        translation_marathi="शुभ सकाळ",
        phonetics=[
            TargetPhoneticGuide(word="Good", phonetic_ipa="/ɡʊd/", simple_phonetic="GOOD"),
            TargetPhoneticGuide(
                word="morning", phonetic_ipa="/ˈmɔːrnɪŋ/", simple_phonetic="MOR-ning"
            ),
        ],
        theme="greetings",
    ),
    SpeakingPrompt(
        prompt_id="prompt-l1-002",
        tier=DifficultyTier.LEVEL_1,
        target_sentence="Red apple",
        translation_hindi="लाल सेब",
        translation_marathi="लाल सफरचंद",
        phonetics=[
            TargetPhoneticGuide(word="Red", phonetic_ipa="/rɛd/", simple_phonetic="RED"),
            TargetPhoneticGuide(word="apple", phonetic_ipa="/ˈæpəl/", simple_phonetic="AP-puhl"),
        ],
        theme="objects",
    ),
    SpeakingPrompt(
        prompt_id="prompt-l1-003",
        tier=DifficultyTier.LEVEL_1,
        target_sentence="Thank you",
        translation_hindi="धन्यवाद",
        translation_marathi="धन्यवाद",
        phonetics=[
            TargetPhoneticGuide(word="Thank", phonetic_ipa="/θæŋk/", simple_phonetic="THANK"),
            TargetPhoneticGuide(word="you", phonetic_ipa="/juː/", simple_phonetic="YOO"),
        ],
        theme="courtesy",
    ),
    # Tier Level 2: 4-5 word simple sentences
    SpeakingPrompt(
        prompt_id="prompt-l2-001",
        tier=DifficultyTier.LEVEL_2,
        target_sentence="This is a cat",
        translation_hindi="यह एक बिल्ली है",
        translation_marathi="ही एक मांजर आहे",
        phonetics=[
            TargetPhoneticGuide(word="This", phonetic_ipa="/ðɪs/", simple_phonetic="THIS"),
            TargetPhoneticGuide(word="is", phonetic_ipa="/ɪz/", simple_phonetic="IZ"),
            TargetPhoneticGuide(word="a", phonetic_ipa="/ə/", simple_phonetic="UH"),
            TargetPhoneticGuide(word="cat", phonetic_ipa="/kæt/", simple_phonetic="KAT"),
        ],
        theme="animals",
    ),
    SpeakingPrompt(
        prompt_id="prompt-l2-002",
        tier=DifficultyTier.LEVEL_2,
        target_sentence="I like to play",
        translation_hindi="मुझे खेलना पसंद है",
        translation_marathi="मला खेळायला आवडते",
        phonetics=[
            TargetPhoneticGuide(word="I", phonetic_ipa="/aɪ/", simple_phonetic="EYE"),
            TargetPhoneticGuide(word="like", phonetic_ipa="/laɪk/", simple_phonetic="LYKE"),
            TargetPhoneticGuide(word="to", phonetic_ipa="/tuː/", simple_phonetic="TOO"),
            TargetPhoneticGuide(word="play", phonetic_ipa="/pleɪ/", simple_phonetic="PLAY"),
        ],
        theme="activities",
    ),
    SpeakingPrompt(
        prompt_id="prompt-l2-003",
        tier=DifficultyTier.LEVEL_2,
        target_sentence="The sun is bright",
        translation_hindi="सूरज चमकदार है",
        translation_marathi="सूर्य तेजस्वी आहे",
        phonetics=[
            TargetPhoneticGuide(word="The", phonetic_ipa="/ðə/", simple_phonetic="THUH"),
            TargetPhoneticGuide(word="sun", phonetic_ipa="/sʌn/", simple_phonetic="SUN"),
            TargetPhoneticGuide(word="is", phonetic_ipa="/ɪz/", simple_phonetic="IZ"),
            TargetPhoneticGuide(word="bright", phonetic_ipa="/braɪt/", simple_phonetic="BRYTE"),
        ],
        theme="nature",
    ),
    # Tier Level 3: interactive conversational responses
    SpeakingPrompt(
        prompt_id="prompt-l3-001",
        tier=DifficultyTier.LEVEL_3,
        target_sentence="My name is Suman teacher",
        translation_hindi="मेरा नाम सुमन टीचर है",
        translation_marathi="माझे नाव सुमन टीचर आहे",
        phonetics=[
            TargetPhoneticGuide(word="My", phonetic_ipa="/maɪ/", simple_phonetic="MY"),
            TargetPhoneticGuide(word="name", phonetic_ipa="/neɪm/", simple_phonetic="NAYM"),
            TargetPhoneticGuide(word="is", phonetic_ipa="/ɪz/", simple_phonetic="IZ"),
            TargetPhoneticGuide(word="Suman", phonetic_ipa="/suːmən/", simple_phonetic="SOO-mun"),
            TargetPhoneticGuide(
                word="teacher", phonetic_ipa="/ˈtiːtʃər/", simple_phonetic="TEE-cher"
            ),
        ],
        theme="introductions",
    ),
    SpeakingPrompt(
        prompt_id="prompt-l3-002",
        tier=DifficultyTier.LEVEL_3,
        target_sentence="I live in a big house",
        translation_hindi="मैं एक बड़े घर में रहता हूँ",
        translation_marathi="मी एका मोठ्या घरात राहतो",
        phonetics=[
            TargetPhoneticGuide(word="I", phonetic_ipa="/aɪ/", simple_phonetic="EYE"),
            TargetPhoneticGuide(word="live", phonetic_ipa="/lɪv/", simple_phonetic="LIV"),
            TargetPhoneticGuide(word="in", phonetic_ipa="/ɪn/", simple_phonetic="IN"),
            TargetPhoneticGuide(word="a", phonetic_ipa="/ə/", simple_phonetic="UH"),
            TargetPhoneticGuide(word="big", phonetic_ipa="/bɪɡ/", simple_phonetic="BIG"),
            TargetPhoneticGuide(word="house", phonetic_ipa="/haʊs/", simple_phonetic="HOWSS"),
        ],
        theme="home",
    ),
]


class EnglishSpeakingService:
    """Service handling English small-sentence evaluation and progression for Class 1 students."""

    def __init__(self, prompt_db: Optional[List[SpeakingPrompt]] = None):
        self._prompts_db: Dict[str, SpeakingPrompt] = {
            p.prompt_id: p for p in (prompt_db or SAMPLE_PROMPTS)
        }

    def get_prompts(self, tier: Optional[DifficultyTier] = None) -> List[SpeakingPrompt]:
        """Fetch speaking practice prompts, optionally filtered by tier."""
        prompts = list(self._prompts_db.values())
        if tier:
            prompts = [p for p in prompts if p.tier == tier]
        return prompts

    def get_prompt_by_id(self, prompt_id: str) -> Optional[SpeakingPrompt]:
        """Fetch a specific speaking prompt by ID."""
        return self._prompts_db.get(prompt_id)

    def evaluate_speaking_attempt(
        self, request: SpeakingEvaluationRequest
    ) -> SpeakingEvaluationResponse:
        """Evaluate spoken transcript against target sentence using child-friendly soft scoring."""
        target_prompt = self._prompts_db.get(request.prompt_id)
        if target_prompt:
            target_sentence = target_prompt.target_sentence
        elif request.target_sentence:
            target_sentence = request.target_sentence
        else:
            target_sentence = "Good morning"

        # Clean words
        target_words = self._clean_and_tokenize(target_sentence)
        spoken_words = self._clean_and_tokenize(request.spoken_transcript)

        # Word-level soft comparison
        word_details, matched_count = self._compare_words(target_words, spoken_words)

        # Calculate accuracy score
        if len(target_words) > 0:
            word_acc = (matched_count / len(target_words)) * 100.0
        else:
            word_acc = 100.0

        # Phonetic match calculation stub
        phonetic_match = min(100.0, word_acc + 5.0) if word_acc > 0 else 0.0
        overall_acc = round((word_acc * 0.7) + (phonetic_match * 0.3), 1)

        accuracy_score = AccuracyScore(
            overall_accuracy=overall_acc,
            word_accuracy=round(word_acc, 1),
            phonetic_match_percentage=round(phonetic_match, 1),
        )

        # Calculate fluency metrics
        wpm = (
            round((len(spoken_words) / request.duration_seconds) * 60.0, 1)
            if request.duration_seconds > 0
            else 0.0
        )
        pause_count = max(0, len(target_words) - len(spoken_words))
        fluency_rating = max(50.0, min(100.0, 100.0 - (pause_count * 10.0)))

        fluency_metrics = FluencyMetrics(
            words_per_minute=wpm,
            pause_count=pause_count,
            fluency_score=round(fluency_rating, 1),
        )

        # Generate gentle child-friendly feedback
        feedback = self._generate_gentle_feedback(
            overall_acc=overall_acc, word_details=word_details
        )

        return SpeakingEvaluationResponse(
            evaluation_id=f"eval-{uuid.uuid4().hex[:8]}",
            student_id=request.student_id,
            prompt_id=request.prompt_id,
            target_sentence=target_sentence,
            spoken_transcript=request.spoken_transcript,
            accuracy=accuracy_score,
            fluency=fluency_metrics,
            word_details=word_details,
            feedback=feedback,
            offline_fallback=True,  # Offline fallback mock/stub evaluation
        )

    def _clean_and_tokenize(self, text: str) -> List[str]:
        """Normalize and tokenize text into clean word list."""
        import re

        clean = re.sub(r"[^\w\s]", "", text.lower()).strip()
        return [w for w in clean.split() if w]

    def _compare_words(
        self, target_words: List[str], spoken_words: List[str]
    ) -> Tuple[List[WordEvaluationDetail], int]:
        """Soft gentle comparison of target words vs spoken words."""
        details: List[WordEvaluationDetail] = []
        matched_count = 0

        spoken_index = 0
        for idx, tw in enumerate(target_words):
            if spoken_index < len(spoken_words):
                sw = spoken_words[spoken_index]
                if tw == sw:
                    details.append(
                        WordEvaluationDetail(
                            target_word=tw,
                            spoken_word=sw,
                            score=100.0,
                            error_category=ErrorCategory.NONE,
                            child_tip=f"Super clear pronunciation for '{tw}'!",
                        )
                    )
                    matched_count += 1
                    spoken_index += 1
                elif self._is_similar(tw, sw):
                    # Soft pronunciation tip
                    details.append(
                        WordEvaluationDetail(
                            target_word=tw,
                            spoken_word=sw,
                            score=80.0,
                            error_category=ErrorCategory.PRONUNCIATION,
                            child_tip=f"Almost got '{tw}'! Say it softly like '{tw}'.",
                        )
                    )
                    matched_count += 1
                    spoken_index += 1
                else:
                    details.append(
                        WordEvaluationDetail(
                            target_word=tw,
                            spoken_word=sw,
                            score=50.0,
                            error_category=ErrorCategory.PRONUNCIATION,
                            child_tip=f"Try saying '{tw}' again!",
                        )
                    )
                    spoken_index += 1
            else:
                details.append(
                    WordEvaluationDetail(
                        target_word=tw,
                        spoken_word=None,
                        score=0.0,
                        error_category=ErrorCategory.MISSING_WORD,
                        child_tip=f"Don't forget to say '{tw}'!",
                    )
                )

        # Check extra words spoken
        while spoken_index < len(spoken_words):
            sw = spoken_words[spoken_index]
            details.append(
                WordEvaluationDetail(
                    target_word="",
                    spoken_word=sw,
                    score=60.0,
                    error_category=ErrorCategory.EXTRA_WORD,
                    child_tip=f"Extra word '{sw}' heard - keep it simple!",
                )
            )
            spoken_index += 1

        return details, matched_count

    def _is_similar(self, w1: str, w2: str) -> bool:
        """Simple prefix or edit distance similarity check for primary child attempts."""
        if len(w1) > 2 and len(w2) > 2:
            return w1[:2] == w2[:2] or w1[-2:] == w2[-2:]
        return False

    def _generate_gentle_feedback(
        self, overall_acc: float, word_details: List[WordEvaluationDetail]
    ) -> GentleFeedback:
        """Generate encouraging child-friendly feedback with stars and warm messaging."""
        praise_points = []
        improvements = []

        for detail in word_details:
            if detail.error_category == ErrorCategory.NONE:
                praise_points.append(f"You said '{detail.target_word}' perfectly!")
            elif detail.child_tip:
                improvements.append(detail.child_tip)

        if overall_acc >= 90.0:
            stars = 3
            tag = ChildFeedbackTag.STAR_PERFORMER
            msg = "Aadhabhut! Super Star! You spoke the sentence wonderfully! 🌟"
        elif overall_acc >= 70.0:
            stars = 2
            tag = ChildFeedbackTag.GREAT_EFFORT
            msg = "Shabash! Great job! You are speaking English so nicely! ⭐"
        else:
            stars = 1
            tag = ChildFeedbackTag.KEEP_TRYING
            msg = "Bahut Achha Try! Keep practicing with Suman teacher, you can do it! 💪"

        if not praise_points:
            praise_points.append("Great confidence in attempting to speak!")
        if not improvements and overall_acc >= 90.0:
            improvements.append("Ready to try the next level sentence!")

        return GentleFeedback(
            encouragement_message=msg,
            feedback_tag=tag,
            stars_earned=stars,
            improvements=improvements[:3],  # Keep tips concise for children
            praise_points=praise_points[:3],
        )
