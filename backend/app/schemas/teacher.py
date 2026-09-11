from enum import Enum
from typing import Optional

from pydantic import BaseModel, Field

from backend.app.schemas.curriculum import SubjectCode


class InteractionMode(str, Enum):
    STANDARD = "standard"
    FALLBACK_EXPLANATION = "fallback_explanation"
    ASSESSMENT_HINT = "assessment_hint"


class TeacherPersonaConfig(BaseModel):
    name: str = Field(default="Suman AI")
    language: str = Field(default="en", description="Target language: 'en', 'hi', or 'mr'")
    tone: str = Field(default="warm, supportive, patient")
    grade_level: int = Field(default=1)


class TeacherChatRequest(BaseModel):
    student_id: str = Field(..., description="Unique student/user identifier")
    message: str = Field(..., description="Student query or response")
    language: str = Field(default="en", description="Preferred language ('en', 'hi', 'mr')")
    subject_code: Optional[SubjectCode] = Field(None, description="Active subject context")
    topic_id: Optional[str] = Field(None, description="Active topic context")
    subtopic_id: Optional[str] = Field(None, description="Active subtopic context")
    concept_id: Optional[str] = Field(None, description="Active concept context")
    is_confused: bool = Field(
        default=False,
        description="Explicit flag if student clicks 'I don't understand' button",
    )


class TeacherChatResponse(BaseModel):
    response_text: str = Field(..., description="Suman AI Teacher response message")
    language: str = Field(..., description="Language of response")
    interaction_mode: InteractionMode = Field(
        default=InteractionMode.STANDARD, description="Mode of response generated"
    )
    is_fallback_explanation: bool = Field(
        default=False, description="True if response was generated via fallback engine"
    )
    visual_cue_trigger: Optional[str] = Field(
        None, description="Extracted visual cue graphic hint if present"
    )
    grounded_concept_id: Optional[str] = Field(
        None, description="Concept ID response was grounded on"
    )
    safety_filtered: bool = Field(
        default=False, description="True if response/query triggered child safety filter"
    )
    encouragement_phrase: Optional[str] = Field(None, description="Warm supportive phrase")
