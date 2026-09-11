# Nehal Ki Teacher AI

AI-powered learning platform for primary students featuring Suman AI Teacher.

## Status: Phase 3 Completed — Suman AI Teacher Integration

### Overview
Nehal Ki Teacher AI has completed Phase 3, establishing the core **Suman AI Teacher** system prompt architecture, RAG grounding constraints, multi-lingual pedagogical persona (Hindi, Marathi, English), child safety guardrails, "I don't understand" safe fallback explanation engine, and backend/mobile API contracts.

### Key Components Established in Phase 3
- **Persona & Prompt Architecture (`backend/app/core/suman_persona.py` & `prompts.py`)**: Warm, supportive primary teacher persona definitions, multi-lingual system instruction routing (HI, MR, EN), and RAG grounding templates.
- **AI Prompt Engine & Schemas (`backend/app/schemas/teacher.py` & `backend/app/services/ai_teacher_service.py`)**: Request/Response DTOs, RAG curriculum context binding, child safety content filtering, and "I don't understand" fallback explanation engine emitting visual cue triggers.
- **Backend API Contracts (`backend/app/api/v1/teacher.py`)**: Endpoints for `/api/v1/teacher/persona` and `/api/v1/teacher/chat`.
- **Mobile DTOs & Service (`mobile/lib/models/teacher.dart` & `mobile/lib/services/teacher_service.dart`)**: Dart models and client service layer for interactive chat and offline fallback execution.
- **Tests & Verification (`backend/tests/test_ai_teacher.py` & `scripts/verify_phase_3.py`)**: Pytest unit test suite and automated Phase 3 verifier checking endpoints, safety filters, multi-lingual personas, and absence of Phase 4+ features.
- **Documentation (`docs/PHASE_3_SUMAN_AI_TEACHER.md`)**: Full architectural specification of prompt design, persona constraints, RAG grounding rules, and fallback mechanisms.

### Verification & Testing
To run all verification scripts:
```bash
python scripts/verify_phase_0.py
python scripts/verify_phase_1.py
python scripts/verify_phase_2.py
python scripts/verify_phase_3.py
pytest
ruff check .
```
