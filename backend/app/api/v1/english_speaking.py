from typing import Optional

from fastapi import APIRouter, HTTPException, Query, status

from backend.app.schemas.english_speaking import (
    DifficultyTier,
    PromptsListResponse,
    SpeakingEvaluationRequest,
    SpeakingEvaluationResponse,
)
from backend.app.services.english_speaking_service import EnglishSpeakingService

router = APIRouter(prefix="/english-speaking", tags=["English Speaking Engine"])
speaking_service = EnglishSpeakingService()


@router.get(
    "/prompts",
    response_model=PromptsListResponse,
    summary="Fetch daily or lesson English speaking practice sentences",
)
def get_speaking_prompts(
    tier: Optional[DifficultyTier] = Query(
        None, description="Filter prompts by difficulty tier (level_1, level_2, level_3)"
    ),
) -> PromptsListResponse:
    """Fetch practice prompts for English small-sentence speaking exercises."""
    prompts = speaking_service.get_prompts(tier=tier)
    return PromptsListResponse(
        tier=tier,
        prompts=prompts,
        total_count=len(prompts),
    )


@router.post(
    "/evaluate",
    response_model=SpeakingEvaluationResponse,
    status_code=status.HTTP_200_OK,
    summary="Evaluate student English speaking attempt and provide gentle feedback",
)
def evaluate_speaking_attempt(
    request: SpeakingEvaluationRequest,
) -> SpeakingEvaluationResponse:
    """Submit spoken transcript and receive accuracy scores and encouraging feedback."""
    if not request.spoken_transcript.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Spoken transcript cannot be empty.",
        )

    try:
        response = speaking_service.evaluate_speaking_attempt(request)
        return response
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error evaluating speaking attempt: {str(e)}",
        )
