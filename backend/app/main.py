from fastapi import FastAPI, status
from pydantic import BaseModel

app = FastAPI(
    title="Nehal Ki Teacher AI - Backend API",
    description="Backend service foundation for Nehal Ki Teacher AI platform",
    version="0.1.0",
)


class HealthResponse(BaseModel):
    status: str
    version: str
    environment: str


@app.get("/health", status_code=status.HTTP_200_OK, response_model=HealthResponse)
def health_check() -> HealthResponse:
    """Basic health check endpoint."""
    return HealthResponse(
        status="healthy",
        version="0.1.0",
        environment="development",
    )


@app.get("/")
def root():
    """Root endpoint returning basic system information."""
    return {
        "name": "Nehal Ki Teacher AI API",
        "status": "running",
        "phase": "Phase 1 - Foundation",
    }
