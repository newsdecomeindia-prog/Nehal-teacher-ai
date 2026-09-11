from fastapi import FastAPI, status
from pydantic import BaseModel

from backend.app.api.v1.curriculum import router as curriculum_router

app = FastAPI(
    title="Nehal Ki Teacher AI - Backend API",
    description="Backend service and Class 1 curriculum architecture",
    version="0.2.0",
)

app.include_router(curriculum_router, prefix="/api/v1")


class HealthResponse(BaseModel):
    status: str
    version: str
    environment: str


@app.get("/health", status_code=status.HTTP_200_OK, response_model=HealthResponse)
def health_check() -> HealthResponse:
    """Basic health check endpoint."""
    return HealthResponse(
        status="healthy",
        version="0.2.0",
        environment="development",
    )


@app.get("/")
def root():
    """Root endpoint returning basic system information."""
    return {
        "name": "Nehal Ki Teacher AI API",
        "status": "running",
        "phase": "Phase 2 - Class 1 Core Learning Architecture",
    }
