from fastapi import FastAPI, status
from pydantic import BaseModel

from backend.app.api.v1.analytics import router as analytics_router
from backend.app.api.v1.curriculum import router as curriculum_router
from backend.app.api.v1.english_speaking import router as english_speaking_router
from backend.app.api.v1.knowledge_world import router as knowledge_world_router
from backend.app.api.v1.multimodal import router as multimodal_router
from backend.app.api.v1.teacher import router as teacher_router

app = FastAPI(
    title="Nehal Ki Teacher AI - Backend API",
    description=(
        "Backend service, Class 1 curriculum, Suman AI Teacher, "
        "Multi-Modal Engine, English Speaking Engine, Knowledge World Gamified Story Engine, "
        "and Diagnostic Exam & Parent Analytics Engine"
    ),
    version="0.7.0",
)

app.include_router(curriculum_router, prefix="/api/v1")
app.include_router(teacher_router, prefix="/api/v1")
app.include_router(multimodal_router, prefix="/api/v1")
app.include_router(english_speaking_router, prefix="/api/v1")
app.include_router(knowledge_world_router, prefix="/api/v1")
app.include_router(analytics_router, prefix="/api/v1")


class HealthResponse(BaseModel):
    status: str
    version: str
    environment: str


@app.get("/health", status_code=status.HTTP_200_OK, response_model=HealthResponse)
def health_check() -> HealthResponse:
    """Basic health check endpoint."""
    return HealthResponse(
        status="healthy",
        version="0.7.0",
        environment="development",
    )


@app.get("/")
def root():
    """Root endpoint returning basic system information."""
    return {
        "name": "Nehal Ki Teacher AI API",
        "status": "running",
        "phase": "Phase 7 - Exams / Analytics Engine / Parent Portal Architecture",
    }
