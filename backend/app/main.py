import time
from collections import defaultdict

from fastapi import FastAPI, Request, Response, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from starlette.middleware.base import BaseHTTPMiddleware

from backend.app.api.v1.analytics import router as analytics_router
from backend.app.api.v1.curriculum import router as curriculum_router
from backend.app.api.v1.english_speaking import router as english_speaking_router
from backend.app.api.v1.knowledge_world import router as knowledge_world_router
from backend.app.api.v1.multimodal import router as multimodal_router
from backend.app.api.v1.teacher import router as teacher_router
from backend.app.core.config import settings

app = FastAPI(
    title="Nehal Ki Teacher AI - Backend API",
    description=(
        "Production-grade Backend service powering Class 1-5 curriculum, Suman AI Teacher, "
        "Multi-Modal Engine, English Speaking Engine, Knowledge World Gamified Story Engine, "
        "Diagnostic Exam & Parent Analytics Engine with strict security hardening."
    ),
    version="1.0.0",
)

# 1. CORS Middleware Constraints
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)


# 2. Security Headers Middleware
class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        response: Response = await call_next(request)
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["X-Frame-Options"] = "DENY"
        response.headers["X-XSS-Protection"] = "1; mode=block"
        response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
        response.headers["Content-Security-Policy"] = "default-src 'self'"
        response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
        return response


app.add_middleware(SecurityHeadersMiddleware)


# 3. Rate Limiting Middleware
class RateLimitingMiddleware(BaseHTTPMiddleware):
    def __init__(self, app, requests_per_minute: int = 60):
        super().__init__(app)
        self.requests_per_minute = requests_per_minute
        self.request_counts = defaultdict(list)

    async def dispatch(self, request: Request, call_next):
        client_ip = request.client.host if request.client else "127.0.0.1"
        now = time.time()

        # Clean timestamps older than 60 seconds
        timestamps = [t for t in self.request_counts[client_ip] if now - t < 60]
        self.request_counts[client_ip] = timestamps

        if len(timestamps) >= self.requests_per_minute:
            return JSONResponse(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                content={"detail": "Too many requests. Rate limit exceeded."},
            )

        self.request_counts[client_ip].append(now)
        return await call_next(request)


app.add_middleware(RateLimitingMiddleware, requests_per_minute=settings.RATE_LIMIT_PER_MINUTE)


# Include API Routers
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
    security_hardening: str


@app.get("/health", status_code=status.HTTP_200_OK, response_model=HealthResponse)
def health_check() -> HealthResponse:
    """Production health check endpoint."""
    return HealthResponse(
        status="healthy",
        version="1.0.0",
        environment=settings.ENVIRONMENT,
        security_hardening="enabled",
    )


@app.get("/")
def root():
    """Root endpoint returning system information."""
    return {
        "name": "Nehal Ki Teacher AI API",
        "status": "running",
        "phase": "Phase 8 - Production Readiness & Security Hardening",
        "version": "1.0.0",
    }
