# Phase 5 — English Small-Sentence Speaking Engine Architecture

## Overview
Phase 5 establishes the core architecture, data contracts, soft evaluation logic, and API endpoints for the primary school English Small-Sentence Speaking Engine in **Nehal Ki Teacher AI**.

The engine enables primary students (Class 1) to practice speaking English small sentences with Suman Teacher, receiving gentle, child-friendly feedback without harsh penalty.

---

## Architecture & Components

### 1. English Speaking Schemas (`backend/app/schemas/english_speaking.py`)
- `DifficultyTier`: Progression levels for primary learners.
  - **Level 1**: 2–3 word phrases (e.g. *"Good morning"*, *"Red apple"*).
  - **Level 2**: 4–5 word simple sentences (e.g. *"This is a cat"*, *"I like to play"*).
  - **Level 3**: Interactive conversational responses (e.g. *"My name is Suman teacher"*, *"I live in a big house"*).
- `TargetPhoneticGuide`: Phonetic IPA and child-friendly phonetic breakdown (e.g. *"AP-puhl"*).
- `SpeakingPrompt`: Practice sentence prompt with multilingual contextual translations (Hindi & Marathi).
- `AccuracyScore` & `FluencyMetrics`: Word accuracy percentage, phonetic match score, WPM (words per minute), and hesitation pause count.
- `ChildFeedbackTag`: Gentle performance badges (`star_performer`, `great_effort`, `keep_trying`, `super_clear`, `try_again_gently`).
- `GentleFeedback`: Child-centric feedback carrying stars awarded (1–3 stars), encouraging praise points, and soft tips.

### 2. Speaking Evaluation Service (`backend/app/services/english_speaking_service.py`)
- Soft comparison engine matching student spoken transcript against target expected sentence.
- Soft Error Classifier:
  - **Pronunciation**: Soft hint when word is close or mispronounced.
  - **Missing Word**: Gentle reminder for skipped words.
  - **Extra Word**: Reassurance to keep sentences simple.
- Offline-first mock/stub evaluation fallback mechanism ensuring zero dependency on paid third-party external evaluation APIs.

### 3. API Endpoints (`backend/app/api/v1/english_speaking.py`)
Registered in main FastAPI router:
- **`GET /api/v1/english-speaking/prompts`**: Retrieve daily speaking prompts filtered by difficulty tier (`level_1`, `level_2`, `level_3`).
- **`POST /api/v1/english-speaking/evaluate`**: Submit student spoken transcript attempt and return detailed evaluation breakdown and gentle feedback.

### 4. Mobile Layer Integration (`mobile/lib/`)
- **`mobile/lib/models/english_speaking.dart`**: Dart models mirror backend schemas (`SpeakingPrompt`, `TargetPhoneticGuide`, `AccuracyScore`, `GentleFeedback`, etc.).
- **`mobile/lib/services/english_speaking_service.dart`**: Flutter HTTP service communicating with the backend API.

---

## Child-Friendly Gentle Feedback Rules
1. **Never use negative or punitive phrasing**: Messages use encouraging words like *"Shabash!"*, *"Bahut Achha Try!"*, *"Super Star!"*.
2. **Star Badging System**:
   - **3 Stars (90–100%) — Star Performer**: *"Aadhabhut! You spoke the sentence wonderfully! 🌟"*
   - **2 Stars (70–89%) — Great Effort**: *"Shabash! You are speaking English so nicely! ⭐"*
   - **1 Star (<70%) — Keep Trying**: *"Bahut Achha Try! Keep practicing with Suman teacher! 💪"*
3. **Constructive Soft Guidance**: Maximum 3 concise improvement tips per response to avoid overwhelming young learners.

---

## Offline & Mock Evaluation Strategy
In accordance with system constraints, the engine does NOT bind third-party paid speech evaluation SaaS keys. An internal mock/stub adapter calculates transcript edit similarity and phonetics locally, ensuring fast execution during development and offline resilience.
