from typing import Optional

from fastapi import APIRouter, HTTPException, Query, status

from backend.app.schemas.analytics import (
    DPDPParentConsent,
    ExamGenerateRequest,
    ExamPaper,
    ExamSubmissionRequest,
    ExamSubmissionResponse,
    ExamType,
    ParentDashboardResponse,
    SubjectCategory,
)
from backend.app.services.analytics_service import analytics_service

router = APIRouter(prefix="/analytics", tags=["Exams & Parent Analytics"])


@router.post(
    "/generate-exam",
    response_model=ExamPaper,
    status_code=status.HTTP_200_OK,
    summary="Generate diagnostic or formative exam paper",
)
def generate_exam(req: ExamGenerateRequest) -> ExamPaper:
    """Generates an age-appropriate exam paper for Classes 1-5."""
    try:
        return analytics_service.generate_exam_paper(req)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to generate exam paper: {str(e)}",
        )


@router.get(
    "/generate-exam",
    response_model=ExamPaper,
    status_code=status.HTTP_200_OK,
    summary="Fetch diagnostic or formative exam paper via query parameters",
)
def generate_exam_query(
    student_id: str = Query("std-101", description="Unique student ID"),
    grade_level: int = Query(1, ge=1, le=5, description="Grade level"),
    subject: SubjectCategory = Query(SubjectCategory.MATH, description="Subject category"),
    exam_type: ExamType = Query(ExamType.DIAGNOSTIC, description="Exam type"),
    num_questions: int = Query(5, ge=1, le=20, description="Question count"),
) -> ExamPaper:
    """GET endpoint to fetch an exam paper using query parameters."""
    req = ExamGenerateRequest(
        student_id=student_id,
        grade_level=grade_level,
        subject=subject,
        exam_type=exam_type,
        num_questions=num_questions,
    )
    return analytics_service.generate_exam_paper(req)


@router.post(
    "/submit-exam",
    response_model=ExamSubmissionResponse,
    status_code=status.HTTP_200_OK,
    summary="Submit student exam answers for instant diagnostic evaluation",
)
def submit_exam(req: ExamSubmissionRequest) -> ExamSubmissionResponse:
    """Evaluates student exam submission and identifies strength/gap topics."""
    try:
        return analytics_service.submit_exam_paper(req)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to submit exam paper: {str(e)}",
        )


@router.get(
    "/parent-dashboard",
    response_model=ParentDashboardResponse,
    status_code=status.HTTP_200_OK,
    summary="Fetch parent dashboard analytics and mastery report",
)
def get_parent_dashboard(
    student_id: str = Query("std-101", description="Child student ID"),
    parent_id: Optional[str] = Query("parent-01", description="Parent ID"),
) -> ParentDashboardResponse:
    """Fetches privacy-compliant aggregated child learning analytics and gap indicators."""
    try:
        return analytics_service.get_parent_dashboard(student_id=student_id, parent_id=parent_id)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch parent dashboard: {str(e)}",
        )


@router.post(
    "/parent-consent",
    response_model=DPDPParentConsent,
    status_code=status.HTTP_200_OK,
    summary="Update DPDP/COPPA parental consent preferences",
)
def update_parent_consent(consent: DPDPParentConsent) -> DPDPParentConsent:
    """Updates DPDP/COPPA compliance settings for child data privacy."""
    try:
        return analytics_service.update_parent_consent(consent)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to update parent consent: {str(e)}",
        )
