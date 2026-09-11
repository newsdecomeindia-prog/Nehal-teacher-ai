# Phase 2 — Class 1 Core Learning Architecture Specification

## Overview
Phase 2 establishes the CBSE Class 1 core learning data structures, curriculum schema, lesson engine models, API endpoints, and mobile DTOs for **Nehal Ki Teacher AI**.

## Supported Subjects
The Class 1 curriculum covers all 5 primary subject domains as specified by CBSE:
1. **English (`english`)**: Alphabet recognition, CVC words, short vowels, sight words.
2. **Hindi (`hindi`)**: Swar (स्वर), Vyanjan (व्यंजन), and basic word association.
3. **Marathi (`marathi`)**: Primary Swar (स्वर), Mulakshare, and regional vocabulary.
4. **Mathematics (`mathematics`)**: Counting objects (1 to 20), zero concept, shapes, and spatial awareness.
5. **EVS / GK (`evs_gk`)**: Self-awareness, sense organs, family, animals, and safety rules.

## Core Schema & Data Structures (`backend/app/schemas/curriculum.py`)
- **Subject**: Includes `id`, `code` (`SubjectCode`), `title_en`, `title_native`, `description`, `language`, `grade_level` (1), and list of `Topic`s.
- **Topic**: Grouping of learning modules containing `subtopics`.
- **Subtopic**: Sequential lesson unit containing `concepts` and `exercises`.
- **Concept**: Kid-friendly explanation with `visual_cues` and associated `LearningOutcome`s.
- **LearningOutcome**: Aligned with Bloom's Taxonomy (`blooms_level`) and core `understanding_first_principle`.
- **ExerciseItem**: Interactive practice item (`MULTIPLE_CHOICE`, `VISUAL_MATCH`, `FILL_IN_BLANK`, `TRUE_FALSE`).
- **AssessmentItem**: Assessment wrapper around `ExerciseItem` with weightage parameters.
- **CurriculumVersion**: Semantic versioning (`1.0.0`), `release_date`, `cbse_compliant` flag, and list of `supported_subjects`.
- **LessonBlueprint**: Structured lesson plan containing topic ID, subtopic ID, concepts, assessment items, and curriculum version metadata.

## Backend REST API Endpoints (`/api/v1/curriculum/class-1/...`)
- `GET /api/v1/curriculum/class-1/version`: Returns current curriculum version and CBSE compliance status.
- `GET /api/v1/curriculum/class-1/subjects`: Lists all 5 Class 1 subjects.
- `GET /api/v1/curriculum/class-1/subjects/{subject_code}`: Returns detailed topic hierarchy for the specified subject code.
- `GET /api/v1/curriculum/class-1/topics/{topic_id}`: Returns subtopics and concepts for a given topic ID.
- `GET /api/v1/curriculum/class-1/lessons/{lesson_id}`: Returns structured lesson blueprint for client-side lesson execution.

## Mobile Client Domain Architecture (`mobile/lib/`)
- `mobile/lib/models/curriculum.dart`: Dart model classes (`Subject`, `Topic`, `Subtopic`, `Concept`, `LearningOutcome`, `ExerciseItem`, `AssessmentItem`, `LessonBlueprint`) with `fromJson` and `toJson` serialization.
- `mobile/lib/services/curriculum_service.dart`: Client-side service layer for querying curriculum structures from backend or local mock fallbacks.

## Verification & Testing
To execute Phase 2 verification:
```bash
python scripts/verify_phase_2.py
```
This script performs:
1. Directory structure validation.
2. Endpoint response & 5 subjects coverage verification.
3. Strict check against forbidden Phase 3+ components (No Suman AI persona, no voice engine, no OCR, no KYC, no LLM calls).
4. Full pytest unit test suite run.
5. Code style and formatting check via Ruff.
