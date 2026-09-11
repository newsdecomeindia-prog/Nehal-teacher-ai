# Nehal Ki Teacher AI

AI-powered learning platform for primary students featuring Suman AI Teacher.

## Status: Phase 2 Completed — Class 1 Core Learning Architecture

### Overview
Nehal Ki Teacher AI has completed Phase 2, establishing the core learning data structures, curriculum schema, lesson engine models, REST API endpoints, and mobile client DTOs for CBSE Class 1 (supporting English, Hindi, Marathi, Mathematics, and EVS/GK).

### Key Components Established in Phase 2
- **Curriculum Schema (`backend/app/schemas/curriculum.py`)**: Pydantic models for Subject, Topic, Subtopic, Concept, LearningOutcome (Understanding-First Principles), ExerciseItem, AssessmentItem, CurriculumVersion, and LessonBlueprint.
- **Lesson Engine Service (`backend/app/services/curriculum_service.py`)**: Central curriculum data service serving Class 1 subjects and version metadata.
- **Backend API Endpoints (`backend/app/api/v1/curriculum.py`)**: REST endpoints mounted under `/api/v1/curriculum/class-1/...`.
- **Mobile Domain DTOs (`mobile/lib/models/curriculum.dart` & `mobile/lib/services/curriculum_service.dart`)**: Dart data structures and service layer matching backend models.
- **Verification & Tests (`scripts/verify_phase_2.py` & `backend/tests/test_curriculum.py`)**: Comprehensive test suite and automated Phase 2 compliance verifier.
- **Documentation (`docs/PHASE_2_CURRICULUM_ARCHITECTURE.md`)**: Architectural specification of curriculum schemas, version control, and API specs.

### Verification & Testing
To run all tests and verify Phase 2 completion:
```bash
python scripts/verify_phase_2.py
pytest
ruff check .
```
