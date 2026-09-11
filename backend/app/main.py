from fastapi import FastAPI, status
from pydantic import BaseModel

from backend.app.api.v1.curriculum import router as curriculum_router
from backend.app.api.v1.multimodal import router as multimodal_router
from backend.app.api.v1.teacher import router as teacher_router

app = FastAPI(
    title="Nehal Ki Teacher AI - Backend API",
    description="Backend service, Class 1 curriculum, Suman AI Teacher, and Multi-Modal Engine",
    version="0.4.0",
)

app.include_router(curriculum_router, prefix="/api/v1")
app.include_router(teacher_router, prefix="/api/v1")
app.include_router(multimodal_router, prefix="/api/v1")


class HealthResponse(BaseModel):
    status: str
    version: str
    environment: str


@app.get("/health", status_code=status.HTTP_200_OK, response_model=HealthResponse)
def health_check() -> HealthResponse:
    """Basic health check endpoint."""
    return HealthResponse(
        status="healthy",
        version="0.4.0",
        environment="development",
    )


@app.get("/")
def root():
    """Root endpoint returning basic system information."""
    return {
        "name": "Nehal Ki Teacher AI API",
        "status": "running",
        "phase": "Phase 4 - Voice / Text / Image Engine Architecture Setup",
    }
