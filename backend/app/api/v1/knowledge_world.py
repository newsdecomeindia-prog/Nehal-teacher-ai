from typing import List

from fastapi import APIRouter, HTTPException, status

from backend.app.schemas.knowledge_world import (
    NodeCompletionRequest,
    NodeCompletionResponse,
    QuestNode,
    StoryQuest,
    StudentProgress,
    WorldTheme,
)
from backend.app.services.knowledge_world_service import knowledge_world_service

router = APIRouter(prefix="/knowledge-world", tags=["Knowledge World"])


@router.get("/worlds", response_model=List[WorldTheme])
def get_knowledge_worlds() -> List[WorldTheme]:
    """Fetch available learning worlds and progress trees."""
    return knowledge_world_service.get_all_worlds()


@router.get("/quest/{quest_id}", response_model=StoryQuest)
def get_quest_details(quest_id: str) -> StoryQuest:
    """Fetch story quest details and nodes for a specific quest ID."""
    quest = knowledge_world_service.get_quest_by_id(quest_id)
    if not quest:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Quest with ID '{quest_id}' not found",
        )
    return quest


@router.get("/quest/{quest_id}/node/{node_id}", response_model=QuestNode)
def get_quest_node(quest_id: str, node_id: str) -> QuestNode:
    """Fetch story quest node and interactive challenge."""
    node = knowledge_world_service.get_node_by_id(quest_id, node_id)
    if not node:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Node '{node_id}' not found in quest '{quest_id}'",
        )
    return node


@router.post("/complete-node", response_model=NodeCompletionResponse)
def complete_quest_node(request: NodeCompletionRequest) -> NodeCompletionResponse:
    """Submit quest attempt, calculate non-monetary XP, unlock badges."""
    result = knowledge_world_service.complete_quest_node(request)
    if not result.success:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=result.feedback_message,
        )
    return result


@router.get("/progress/{student_id}", response_model=StudentProgress)
def get_student_progress(student_id: str) -> StudentProgress:
    """Fetch gamified progress profile for student."""
    return knowledge_world_service.get_or_create_student_progress(student_id)
