from fastapi import APIRouter, status

from backend.app.core.suman_persona import SUMAN_PERSONA_NAME
from backend.app.schemas.teacher import (
    TeacherChatRequest,
    TeacherChatResponse,
    TeacherPersonaConfig,
)
from backend.app.services.ai_teacher_service import AITeacherService

router = APIRouter(prefix="/teacher", tags=["Suman AI Teacher"])


@router.get("/persona", response_model=TeacherPersonaConfig)
def get_teacher_persona(language: str = "en") -> TeacherPersonaConfig:
    """Retrieve Suman AI Teacher persona configuration and language metadata."""
    return TeacherPersonaConfig(
        name=SUMAN_PERSONA_NAME,
        language=language,
        tone="warm, supportive, patient",
        grade_level=1,
    )


@router.post(
    "/chat",
    response_model=TeacherChatResponse,
    status_code=status.HTTP_200_OK,
)
def chat_with_teacher(request: TeacherChatRequest) -> TeacherChatResponse:
    """
    Process interactive chat query with Suman AI Teacher.
    Applies curriculum grounding, child safety filters, and fallback explanation engine.
    """
    return AITeacherService.process_chat_query(request)
