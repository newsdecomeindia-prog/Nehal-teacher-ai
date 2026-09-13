from typing import List

from fastapi import APIRouter, HTTPException, status

from backend.app.schemas.curriculum import (
    CurriculumVersion,
    LessonBlueprint,
    ProgressUpdateRequest,
    Subject,
    SubjectCode,
    SureshStudyGuideSummary,
    Topic,
)
from backend.app.services.curriculum_service import CurriculumService

router = APIRouter(prefix="/curriculum/class-1", tags=["Class 1 Curriculum"])


@router.get("/version", response_model=CurriculumVersion)
def get_curriculum_version() -> CurriculumVersion:
    """Get Class 1 curriculum schema version and metadata."""
    return CurriculumService.get_version()


@router.get("/subjects", response_model=List[Subject])
def list_class_1_subjects() -> List[Subject]:
    """Retrieve all CBSE Class 1 subjects (English, Hindi, Marathi, Math, EVS/GK)."""
    return CurriculumService.get_all_subjects()


@router.get("/subjects/{subject_code}", response_model=Subject)
def get_subject_details(subject_code: SubjectCode) -> Subject:
    """Retrieve detailed topic structure for a given Class 1 subject."""
    subject = CurriculumService.get_subject_by_code(subject_code)
    if not subject:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Subject with code '{subject_code}' not found.",
        )
    return subject


@router.get("/topics/{topic_id}", response_model=Topic)
def get_topic_details(topic_id: str) -> Topic:
    """Retrieve details, subtopics, and concepts for a given topic ID."""
    topic = CurriculumService.get_topic_by_id(topic_id)
    if not topic:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Topic with ID '{topic_id}' not found.",
        )
    return topic


@router.get("/lessons/{lesson_id}", response_model=LessonBlueprint)
def get_lesson_blueprint(lesson_id: str) -> LessonBlueprint:
    """Retrieve structured lesson blueprint including concepts and assessment items."""
    blueprint = CurriculumService.get_lesson_blueprint(lesson_id)
    if not blueprint:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Lesson blueprint with ID '{lesson_id}' not found.",
        )
    return blueprint


@router.get("/study-guide/{student_id}", response_model=SureshStudyGuideSummary)
def get_suresh_study_guide(student_id: str) -> SureshStudyGuideSummary:
    """Get Suresh AI Study Guide summary with progress, practice reminders, and prompts."""
    return CurriculumService.get_suresh_study_guide(student_id)


@router.post("/study-guide/progress", response_model=SureshStudyGuideSummary)
def update_study_progress(req: ProgressUpdateRequest) -> SureshStudyGuideSummary:
    """Submit progress update for completed concept or practice module."""
    return CurriculumService.update_study_progress(req)
