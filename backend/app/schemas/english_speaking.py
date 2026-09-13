from enum import Enum
from typing import List, Optional

from pydantic import BaseModel, Field


class DifficultyTier(str, Enum):
    LEVEL_1 = "level_1"  # 2-3 word phrases
    LEVEL_2 = "level_2"  # 4-5 word simple sentences
    LEVEL_3 = "level_3"  # Interactive conversational responses


class ErrorCategory(str, Enum):
    PRONUNCIATION = "pronunciation"
    MISSING_WORD = "missing_word"
    EXTRA_WORD = "extra_word"
    FLUENCY_PAUSE = "fluency_pause"
    NONE = "none"


class ChildFeedbackTag(str, Enum):
    STAR_PERFORMER = "star_performer"  # Excellent attempt (90-100%)
    GREAT_EFFORT = "great_effort"  # Good attempt with minor soft errors (70-89%)
    KEEP_TRYING = "keep_trying"  # Needs practice (<70%), gentle encouraging feedback
    SUPER_CLEAR = "super_clear"  # Excellent pronunciation tag
    TRY_AGAIN_GENTLY = "try_again_gently"


class TargetPhoneticGuide(BaseModel):
    word: str = Field(..., description="Target English word")
    phonetic_ipa: str = Field(..., description="IPA phonetic representation")
    simple_phonetic: str = Field(
        ..., description="Child-friendly phonetic breakdown (e.g., 'MAHN-go')"
    )
    audio_sample_url: Optional[str] = Field(None, description="Audio reference URL for target word")


class SpeakingPrompt(BaseModel):
    prompt_id: str = Field(..., description="Unique prompt identifier")
    tier: DifficultyTier = Field(..., description="Difficulty tier (level_1, level_2, level_3)")
    target_sentence: str = Field(..., description="Target sentence for student to speak")
    translation_hindi: Optional[str] = Field(None, description="Hindi translation for context")
    translation_marathi: Optional[str] = Field(None, description="Marathi translation for context")
    phonetics: List[TargetPhoneticGuide] = Field(
        default_factory=list, description="Phonetic breakdown per word"
    )
    theme: str = Field(
        default="daily_life", description="Topic/theme ('family', 'animals', 'greetings', etc.)"
    )


class StudentAudioAttempt(BaseModel):
    student_id: str = Field(..., description="Unique student identifier")
    prompt_id: str = Field(..., description="Prompt ID being attempted")
    audio_base64: Optional[str] = Field(None, description="Base64 encoded student audio recording")
    spoken_transcript: Optional[str] = Field(
        None, description="Transcribed text if STT already processed"
    )
    duration_seconds: float = Field(
        default=0.0, ge=0.0, description="Recording duration in seconds"
    )
    audio_format: str = Field(default="wav", description="Audio format ('wav', 'mp3', 'ogg')")


class WordEvaluationDetail(BaseModel):
    target_word: str = Field(..., description="Target expected word")
    spoken_word: Optional[str] = Field(None, description="Actual spoken word recorded")
    score: float = Field(..., ge=0.0, le=100.0, description="Word-level accuracy score (0-100)")
    error_category: ErrorCategory = Field(
        default=ErrorCategory.NONE, description="Type of soft error detected"
    )
    child_tip: Optional[str] = Field(None, description="Child-friendly gentle pronunciation tip")


class AccuracyScore(BaseModel):
    overall_accuracy: float = Field(
        ..., ge=0.0, le=100.0, description="Overall accuracy percentage (0-100)"
    )
    word_accuracy: float = Field(..., ge=0.0, le=100.0, description="Word level accuracy score")
    phonetic_match_percentage: float = Field(
        ..., ge=0.0, le=100.0, description="Phonetic match percentage score"
    )


class FluencyMetrics(BaseModel):
    words_per_minute: float = Field(
        default=0.0, ge=0.0, description="Estimated speaking rate (WPM)"
    )
    pause_count: int = Field(default=0, ge=0, description="Number of hesitant pauses detected")
    fluency_score: float = Field(
        ..., ge=0.0, le=100.0, description="Overall fluency rating (0-100)"
    )


class GentleFeedback(BaseModel):
    encouragement_message: str = Field(
        ..., description="Warm, positive, child-friendly feedback message"
    )
    feedback_tag: ChildFeedbackTag = Field(..., description="Categorized feedback tag")
    stars_earned: int = Field(..., ge=1, le=3, description="Stars awarded (1-3 stars)")
    improvements: List[str] = Field(default_factory=list, description="Gentle tips for improvement")
    praise_points: List[str] = Field(
        default_factory=list, description="Specific things the student did well"
    )


class SpeakingEvaluationRequest(BaseModel):
    student_id: str = Field(..., description="Unique student identifier")
    prompt_id: str = Field(..., description="Prompt ID attempted")
    spoken_transcript: str = Field(..., description="Spoken transcript to evaluate")
    target_sentence: Optional[str] = Field(
        None, description="Target sentence (optional if prompt_id is registered)"
    )
    duration_seconds: float = Field(default=2.5, ge=0.0, description="Audio duration")


class SpeakingEvaluationResponse(BaseModel):
    evaluation_id: str = Field(..., description="Unique evaluation result ID")
    student_id: str = Field(..., description="Student ID")
    prompt_id: str = Field(..., description="Prompt ID")
    target_sentence: str = Field(..., description="Expected target sentence")
    spoken_transcript: str = Field(..., description="Student spoken transcript")
    accuracy: AccuracyScore = Field(..., description="Accuracy breakdown scores")
    fluency: FluencyMetrics = Field(..., description="Fluency assessment metrics")
    word_details: List[WordEvaluationDetail] = Field(
        default_factory=list, description="Word-by-word soft evaluation"
    )
    feedback: GentleFeedback = Field(..., description="Child-friendly encouraging feedback")
    offline_fallback: bool = Field(
        default=False, description="True if local offline evaluation fallback was used"
    )


class PromptsListResponse(BaseModel):
    tier: Optional[DifficultyTier] = Field(None, description="Filtered tier, if specified")
    prompts: List[SpeakingPrompt] = Field(
        ..., description="List of available speaking practice prompts"
    )
    total_count: int = Field(..., description="Total count of prompts returned")
