# Phase 0 Specification: Nehal Ki Teacher AI Technical & Architectural Blueprint

## Executive Overview
Nehal Ki Teacher AI is an AI-powered primary education platform tailored for foundational learning in India (KG to Class 5, with Class 1 priority). The platform features Suman AI Teacher and Suresh AI Teacher delivering multi-lingual interactive lessons grounded in standard NCERT / State Board curriculum frameworks.

> **Note on Verification & Metrics**: All performance metrics (e.g. speech accuracy, zero hallucination targets) listed herein represent **Design Targets / Future Acceptance Criteria**. Phase 0 validation represents **Architectural Design Validation** (evaluating structural blueprint completeness and design integrity rather than executing live runtime code). Legal compliance (DPDP/COPPA) and Play Integrity represent architectural design layers that require ongoing runtime verification.

---

## 35 Master Requirement Groups (REQ-01 to REQ-35)

### REQ-01: Multi-Lingual Persona Configuration (Hindi, Marathi, English)
- Support for Suman AI Teacher persona across Hindi, Marathi, and English with warm, patient, and age-appropriate tone.
- *Design Targets / Future Acceptance Criteria*: Smooth language switching mid-conversation without loss of session context.

### REQ-02: Class 1 Foundational Curriculum Grounding (NCERT / State Board)
- Rigorous RAG grounding mapping to Class 1 Literacy, Numeracy, and EVS learning outcomes.

### REQ-03: RAG Context Retrieval & Fallback Explanation Engine
- Deterministic fallback visual explanations ("3 apples on a table") whenever child clicks "I don't understand".

### REQ-04: Child Safety & Content Filtering Engine
- Input/output safety filters blocking non-educational or harmful queries for primary age children.

### REQ-05: Multi-Modal Rich Visual Cards Payload Rendering
- Support for structured visual cards containing HD image, 3-language titles (EN, HI, MR), audio pronunciation trigger, age-appropriate text explanation, and interactive checking question.

### REQ-06: Voice Speech-to-Text (STT) Engine Abstraction
- STT abstraction supporting Hindi, Marathi, and Indian English accents tuned for primary age child voices.

### REQ-07: Voice Text-to-Speech (TTS) Engine Abstraction
- Suman AI warm teacher voice synthesis with calibrated pitch/speed rate for primary school comprehension.

### REQ-08: Homework Photo OCR & Worksheet Scanning
- Vision model abstraction for scanning handwritten and printed primary school homework worksheets.

### REQ-09: Educational Photo Validation & Child Privacy Filter
- Automated detection of educational vs non-educational images and EXIF/PII stripping before processing.

### REQ-10: English Small-Sentence Speaking Tier 1 (Greetings & Basics)
- Gentle child-friendly pronunciation practice for basic greetings ("Good Morning Teacher").

### REQ-11: English Small-Sentence Speaking Tier 2 (Daily Sentences)
- Soft scoring evaluation for simple classroom/daily sentences ("I want water", "May I come in").

### REQ-12: English Small-Sentence Speaking Tier 3 (Short Dialogues)
- Interactive multi-turn English speaking exercises with instant encouraging audio feedback.

### REQ-13: Soft Evaluation & Child Encouragement Scoring
- Non-punitive scoring system prioritizing stars and encouraging messages over strict numeric grades.

### REQ-14: Phonetic Guide & Audio Demonstration Engine
- Hindi/Marathi transliterated phonetic guides for English words to aid non-native primary learners.

### REQ-15: Knowledge World Gamified Story Quests
- Themed story quests (Math Jungle, Word World, Science Safari) engaging Class 1 learners.

### REQ-16: Non-Monetary XP & Badge Rewards Engine
- Gamified learning motivation using stars, XP points, and unlocked achievement badges.

### REQ-17: 2D/3D Grid Cards & Category Visual Explorer
- Kid-friendly grid cards for "Cute Animals", "Fruits", "Vehicles", and "Famous People".

### REQ-18: Learning Progression Roadmap & Quest Path
- Visual roadmap showing completed lessons with ⭐ Stars and unlocked next steps.

### REQ-19: Multi-lingual Picture Dictionary & Word Bank Engine
- 3-language vocabulary cards (English, Hindi, Marathi) with interactive sentence builders.

### REQ-20: Diagnostic Assessment Paper Generation (Classes 1-5)
- Automated generation of age-appropriate quiz papers and diagnostic practice questions.

### REQ-21: Learning Gap Detection & Severity Profiling
- Real-time tracking of student conceptual misunderstandings (e.g. number line subtraction).

### REQ-22: Parent Portal Summary Dashboard
- Parent dashboard showing overall mastery percentage, identified learning gaps, and actionable recommendations.

### REQ-23: DPDP & COPPA Parental Consent Control
- Verifiable parental consent toggles and data minimization privacy enforcement.

### REQ-24: Production Security Hardening & Response Headers
- Security headers (HSTS, CSP, X-Content-Type-Options) and strict CORS configurations on backend APIs.

### REQ-25: Rate Limiting & Denial-of-Service Protection
- Per-IP rate limiting middleware protecting AI LLM and TTS endpoints against abuse.

### REQ-26: Environment Variable & Startup Configuration Validation
- Strict validation of environment keys (API keys, database URLs) upon FastAPI server startup.

### REQ-27: PII Sanitization & Audit Logging
- Logging pipeline ensuring no sensitive child voice/photo data or personally identifiable information is stored in plain text logs.

### REQ-28: Multi-Stage Docker Containerization
- Production Dockerfile with multi-stage build minimizing attack surface and image size.

### REQ-29: Flutter Mobile Error Boundaries & Exception Trapping
- Global Flutter error boundary wrapping the mobile app to catch widget failures gracefully without crashing.

### REQ-30: Offline Continuity & Local State Caching
- Support for offline fallback audio, cached story quests, and secure storage persistence.

### REQ-31: Android Release Build & CI/CD Pipeline
- Automated GitHub Actions workflow (`.github/workflows/build_apk.yml`) for building release APKs.

### REQ-32: Play Integrity Architectural Layer
- Architectural design layer for Google Play Integrity API verification on mobile client requests.

### REQ-33: Suman 3D Animated Avatar Banner Header Widget
- Interactive header banner in Flutter mobile client showing Suman AI Teacher animated avatar.

### REQ-34: Comic Speech Bubble UI Design
- Visual chat interface featuring soft blue student speech bubbles and bright purple/orange Suman AI bubbles.

### REQ-35: End-to-End Master Verification Suite
- Comprehensive automated verification scripts (`scripts/verify_phase_0.py` through `scripts/verify_phase_9.py`).

---

## Golden Flow Architectural Validation
The Golden Flow demonstrates end-to-end integration across Suman AI Chat, Voice/OCR services, Knowledge World, and Parent Portal. In Phase 0, this serves as an **Architectural Design Validation** ensuring all model contracts and API endpoints align before live deployment.
