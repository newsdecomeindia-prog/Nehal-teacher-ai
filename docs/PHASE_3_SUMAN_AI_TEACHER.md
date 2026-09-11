# Phase 3 — Suman AI Teacher Integration Specification

## Overview
Phase 3 establishes the core **Suman AI Teacher** system architecture, system prompt formatting, RAG curriculum grounding constraints, multi-lingual pedagogical persona (Hindi, Marathi, English), child safety guardrails, and "I don't understand" safe fallback explanation engine for **Nehal Ki Teacher AI**.

## Persona Architecture (`backend/app/core/suman_persona.py`)
- **Persona Name**: Suman AI ("Suman Teacher" / "सुमन दीदी" / "सुमन बाई").
- **Target Audience**: Primary school children (Class 1-5, Class 1 primary target).
- **Core Principles**:
  - Warm, encouraging, patient, and child-safe tone.
  - Understanding-first pedagogy prioritizing conceptual clarity over memorization.
  - Short, engaging sentences appropriate for 5-10 year old learners.

## Multi-lingual Routing (`backend/app/core/prompts.py`)
Supported languages:
1. **English (`en`)**: Warm primary school teacher persona.
2. **Hindi (`hi`)**: "सुमन दीदी/टीचर" warm tone with Hindi curriculum terms.
3. **Marathi (`mr`)**: "सुमन बाई" respectful regional primary teacher persona.

## "I Don't Understand" Fallback Engine
When a student expresses confusion or presses the "I don't understand" button:
1. The engine bypasses standard definitions.
2. Formulates a 2-sentence concrete real-world analogy (e.g. sharing fruits or counting toys).
3. Emits an explicit visual breakdown trigger in square brackets: `[Visual Cue: Description of visual aid]`.

## RAG Curriculum Grounding & Safety Filters (`backend/app/services/ai_teacher_service.py`)
- **Strict Grounding**: Prompt context dynamically binds subject domain, active concept, and CBSE learning outcomes from Phase 2 curriculum schemas.
- **Child Safety Filtering**: Inspects student queries for inappropriate keywords (`violence`, `weapon`, etc.) and gently redirects student back to school topics.

## Backend REST API Endpoints (`/api/v1/teacher/...`)
- `GET /api/v1/teacher/persona`: Returns Suman AI Teacher metadata and localized settings.
- `POST /api/v1/teacher/chat`: Accepts `TeacherChatRequest` and returns `TeacherChatResponse` with response text, interaction mode, fallback flags, and visual cue triggers.

## Mobile Client DTOs & Service Layer (`mobile/lib/`)
- `mobile/lib/models/teacher.dart`: Models for `TeacherChatMessage`, `TeacherChatRequest`, `TeacherChatResponse`, and `TeacherPersonaConfig`.
- `mobile/lib/services/teacher_service.dart`: Client service layer to interact with backend chat endpoints with offline fallback support.

## Verification & Testing
Execute Phase 3 verification via:
```bash
python scripts/verify_phase_3.py
```
This script validates:
1. Directory structure completeness.
2. Multi-lingual API responses and fallback explanation triggers.
3. Absence of Phase 4+ forbidden components (No speech synthesis/recording, no photo OCR scanning, no payment/KYC).
4. Pytest test suite execution.
5. Ruff linting and formatting compliance.
