# NEHAL KI TEACHER AI — PHASE 0 SPECIFICATION & SYSTEM ARCHITECTURE
**Controlled Source of Truth for System Architecture, Requirements, and Phase Governance**

---

## 1. EXECUTIVE SUMMARY & PHASE 0 AUDIT CORRECTION

This document serves as the controlled source of truth for **Nehal Ki Teacher AI**, an AI-powered interactive learning platform designed for primary school students (Kindergarten through Class 5), with initial launch priority focused on Class 1.

### 1.1 Phase 0 Audit Corrections
This document addresses and corrects previous audit discrepancies across all specification areas:
1. **Requirement Count Reconciliation**: The previous document referenced "60 required specification areas" alongside "35 requirement groups". This has been reconciled: the platform is defined by **35 master requirement groups** (`REQ-01` through `REQ-35`), spanning over 60 specification sub-sections.
2. **Terminology Separation**: Strict distinction is enforced between **SPECIFIED**, **DESIGNED**, **VERIFIED**, and **IMPLEMENTED**. Phase 0 provides specifications and architectural designs. No Phase 1+ product implementation code exists in Phase 0.
3. **AI Accuracy & Hallucination Framing**: Target performance metrics (e.g., >92% speech recognition accuracy target, <0.82 confidence threshold fallback) are clearly categorized as design targets and acceptance criteria rather than empirical guarantees. Hallucination prevention is framed around grounded RAG, temperature controls (~0.2 target), fallback guardrails, and incident correction processes.
4. **Security & Privacy Framing**: Identity verification (KYC), Android security layers (Play Integrity, root detection), and DPDP/COPPA data protection are specified as architectural designs and security layers that require formal legal and compliance review prior to production launch.
5. **Golden Flow Validation**: The Golden Flow is designated as **Golden Learning Flow — Phase 0 Architectural Validation**, distinguishing specification validation from real-world child usability testing in future implementation phases.

---

## 2. SYSTEM PURPOSE & CORE PRODUCT VISION

Nehal Ki Teacher AI provides an empathetic, interactive, multi-modal teaching environment tailored for young learners in India.

### 2.1 Core Pillars & Personas
- **AI Teachers**:
  - **Suman**: Primary AI Lead Teacher — warm, encouraging, patient, specializing in core concepts, story-based learning, and step-by-step guidance.
  - **Suresh**: Co-Teacher / Practice Guide — energetic, game-focused, emphasizing drills, interactive quizzes, and revision.
- **Priority Grade**: Class 1 initial launch priority, with architectural support for Kindergarten through Class 5 (KG-5).
- **Curriculum Alignment**: CBSE curriculum standards covering Mathematics, Environmental Studies (EVS), English, Hindi, and regional subjects.
- **Multilingual Support**: Trilingual interface and speech support in **English**, **Hindi**, and **Marathi**.
- **Pedagogy**: Understanding-first teaching methodology (concept explanation -> interactive practice -> real-world analogy -> retention check).
- **Multi-Modal Interaction**: Voice interaction, text messaging, and homework photo scanning/OCR.
- **Feature Set**:
  - **Knowledge World**: Interactive visual exploration map for concepts.
  - **Pronunciation Guide**: Real-time phonetic feedback for young learners.
  - **Educational Games & Quizzes**: Gamified reinforcement and rewards.
  - **Homework Scanner**: Camera-based photo scanning of handwritten or printed worksheets with step-by-step AI explanation.
  - **Exams & Assessments**: Formative and summative assessment modules.
  - **Adaptive Personalization**: Learning pace adjustment and mastery tracking.
  - **Parent Dashboard & KYC**: Parent progress monitoring, time controls, and identity verification.
  - **Content Management System (CMS)**: Educator content authoring, curriculum mapping, and prompt management.
  - **Commercial Strategy**: Free initial launch tier for maximum accessibility.
  - **Child Safety & Protection**: Strict prompt guardrails, zero toxicity, age-appropriate content filtering.

---

## 3. KEY DEFINITIONS & TERMINOLOGY SEPARATION

To eliminate ambiguity and overclaiming, all statements in this project adhere to four explicit status categories:

| Status Term | Definition & Scope in Phase 0 |
| :--- | :--- |
| **SPECIFIED** | A requirement, functional behavior, or user story has been formally documented in specification files. |
| **DESIGNED** | An architecture, component interaction, database schema (ERD), API interface, or data flow model has been designed. |
| **VERIFIED** | A specification section, schema, or configuration has undergone automated or manual Phase 0 static inspection. |
| **IMPLEMENTED** | Working production source code exists, executes, passes unit/integration tests, and is deployed. (**Zero product features are IMPLEMENTED in Phase 0**). |

---

## 4. AI ARCHITECTURE & ACCURACY ENGINEERING

### 4.1 Speech & Language Targets
- **Target Speech Accuracy**: Target >92% word error rate (WER) accuracy benchmark for primary school child speech in English, Hindi, and Marathi under standard acoustic conditions.
- **Confidence Threshold**: A target confidence score threshold of `<0.82` triggers automated safe clarification ("Suman didn't catch that, could you say it once more?") rather than guessing.

### 4.2 Grounded Hallucination Prevention
1. **Retrieval-Augmented Generation (RAG)**: AI teachers generate explanations grounded strictly in verified CBSE curriculum knowledge bases.
2. **Temperature Control**: Default generation temperature target set to `0.2` for factual accuracy and curriculum consistency.
3. **Guardrail Layer**: Output filter checks all responses for age appropriateness, curriculum fidelity, and zero harmful content before rendering to the child.
4. **Incident Correction Process**: Automated logging of low-confidence responses for educator review and dataset fine-tuning.

---

## 5. SECURITY, PRIVACY & COMPLIANCE ARCHITECTURE

### 5.1 KYC & Identity Security
- **Design Intent**: Parent identity verification designed to secure parent accounts and prevent unauthorized management.
- **Security Controls**: End-to-end TLS encryption in transit, AES-256 encryption at rest, role-based access control (RBAC), and immutable audit logging.
- **Compliance Requirement**: Formal legal and compliance review is mandatory prior to enabling live identity verification in production.

### 5.2 Privacy-by-Design (DPDP & COPPA Alignment)
- **Data Protection Alignment**: Architecture is designed with privacy-by-design principles to align with the Indian Digital Personal Data Protection (DPDP) Act and COPPA guidelines.
- **Parental Consent**: Explicit parental consent workflows specified prior to collecting child interaction data.
- **Data Minimization**: Voice recordings and image uploads processed with minimal retention policies.

### 5.3 Android Security Architecture
- **Defense-in-Depth Layers**: Google Play Integrity API integration, Play App Signing, root detection heuristics, and anti-sideloading checks.
- **Mandatory Server Authorization**: Android security features serve as client-side defense-in-depth; mandatory server-side token validation and session authorization enforce all resource access.

---

## 6. GOLDEN LEARNING FLOW — PHASE 0 ARCHITECTURAL VALIDATION

The **Golden Learning Flow — Phase 0 Architectural Validation** defines the core end-to-end child learning journey model:

```
[Child Login / Voice Select] -> [Suman AI Greeting (Voice/Text)] -> [Concept Explanation + Analogy]
         |
         v
[Knowledge World / Visual Concept] -> [Suresh Interactive Quiz / Game]
         |
         v
[Homework Photo Scan / Voice Question] -> [Step-by-Step AI Guidance] -> [Parent Dashboard Progress Sync]
```

*Note: Phase 0 validates the architectural flow and interface boundaries. Product code execution and live child usability testing occur in Phase 1+.*

---

## 7. LOGICAL ERD & API ARCHITECTURE

### 7.1 Logical Service Boundaries (18 Service Modules)
1. User & Authentication Service
2. Parent & Student Profile Service
3. Curriculum & Subject Service
4. Suman AI Teaching Engine
5. Suresh Quiz & Practice Engine
6. Voice Processing (STT/TTS) Service
7. Vision & Homework OCR Service
8. Knowledge World Service
9. Gamification & Rewards Service
10. Pronunciation Analysis Service
11. Assessment & Exam Service
12. Adaptive Personalization Engine
13. Parent Dashboard & Analytics Service
14. CMS & Content Authoring Service
15. Child Safety & Guardrails Service
16. KYC & Identity Verification Service
17. Notification & Messaging Service
18. Audit & Compliance Logging Service

### 7.2 Logical ERD Entities (41 Entities)
1. `User`
2. `Role`
3. `ParentProfile`
4. `StudentProfile`
5. `KYCDocument`
6. `Subject`
7. `Grade`
8. `Chapter`
9. `Topic`
10. `Concept`
11. `CurriculumStandard`
12. `LearningObjective`
13. `SumanPromptTemplate`
14. `SureshQuizTemplate`
15. `Session`
16. `InteractionLog`
17. `VoiceUtterance`
18. `SpeechAnalysisLog`
19. `HomeworkScan`
20. `OCRExtraction`
21. `AIExplanation`
22. `KnowledgeWorldNode`
23. `KnowledgeWorldEdge`
24. `StudentNodeMastery`
25. `Game`
26. `GameLevel`
27. `StudentGameScore`
28. `RewardBadge`
29. `StudentBadge`
30. `PronunciationSession`
31. `PhonemeScore`
32. `Exam`
33. `ExamQuestion`
34. `StudentExamAttempt`
35. `StudentExamAnswer`
36. `PersonalizationProfile`
37. `ParentTimeLimit`
38. `ParentReport`
39. `CMSContentItem`
40. `SafetyViolationLog`
41. `SystemAuditLog`

### 7.3 Proposed API Schema Sample (JSON)
```json
{
  "api_version": "v1",
  "endpoint": "/api/v1/learning/explain",
  "method": "POST",
  "request_schema": {
    "student_id": "string (uuid)",
    "teacher_persona": "SUMAN",
    "language": "hi-IN",
    "subject": "Mathematics",
    "topic_id": "TOPIC-CLASS1-MATH-01",
    "input_mode": "VOICE",
    "query_text": "संख्या 5 का क्या अर्थ है?"
  },
  "proposed_response_schema": {
    "status": "SUCCESS",
    "explanation_text": "5 का मतलब होता है पाँच चीज़ें! जैसे आपके एक हाथ में 5 उंगलियाँ होती हैं।",
    "audio_stream_url": "https://cdn.nehalteacher.ai/audio/sample_5_hi.mp3",
    "visual_card_id": "CARD-MATH-COUNT-5",
    "suggested_followup": "क्या आप 5 सेब गिनना चाहेंगे?",
    "confidence_score": 0.96
  }
}
```

---

## 8. FULL 12-PHASE SYSTEM ROADMAP

| Phase | Title | Core Objective | Phase Gate Criteria |
| :---: | :--- | :--- | :--- |
| **Phase 0** | Final Audit Correction & Quality Gate | Specifications, ERD, APIs, Verification Tooling | Phase 0 Verification Script PASS |
| **Phase 1** | Foundation Infrastructure & Core Auth | Database Setup, Parent/Student Auth, API Gateway | Security audit & unit tests passing |
| **Phase 2** | Suman AI Core Engine | Prompt Engineering, RAG Pipeline, Class 1 Math/EVS | Concept accuracy & guardrail checks |
| **Phase 3** | Multilingual Voice Pipeline (STT/TTS) | Hindi/Marathi/English STT/TTS Integration | Audio latency <800ms, WER benchmark |
| **Phase 4** | Suresh Practice & Gamification Engine | Quiz Engine, Games, Reward Badges | Game state sync & retention metrics |
| **Phase 5** | Knowledge World Visual Exploration | Interactive Node Map, Mastery Tracking | Render performance & graph sync |
| **Phase 6** | Vision & Homework Photo Scanner | OCR Integration, Step-by-Step AI Explanations | OCR accuracy on primary worksheets |
| **Phase 7** | Pronunciation & Phonetic Guide | Speech Phoneme Analysis, Real-time Feedback | Phoneme scoring validation |
| **Phase 8** | Exams & Personalization Engine | Formative Assessments, Adaptive Learning Pace | Mastery algorithm validation |
| **Phase 9** | Parent Dashboard, KYC & CMS | Parent Analytics, Identity Verification, Authoring | Data privacy & RBAC compliance |
| **Phase 10**| Android Client App & Security Layers | Native Android App, Play Integrity, App Signing | Security penetration test PASS |
| **Phase 11**| End-to-End Integration & Launch Gate | Full System Staging, Load Testing, Production | E2E test suite 100% PASS |

---

## 9. REQUIREMENT COVERAGE MATRIX

The system requirement model contains **35 requirement groups** (`REQ-01` to `REQ-35`):

| REQ ID | Requirement Description | Source | Architecture Decision | Planned Phase | Phase 0 Status | Evidence Location | Notes & Assumptions |
| :--- | :--- | :--- | :--- | :---: | :---: | :--- | :--- |
| `REQ-01` | Class 1 Initial Priority Launch | Vision | Focus Class 1 CBSE content model | Phase 0-2 | SPECIFIED | Sec. 2.1 | Class 1 primary target |
| `REQ-02` | KG to Class 5 Curriculum Support | Architecture | Scalable grade-topic taxonomy | Phase 2 | DESIGNED | Sec. 7.2 | Multi-grade schema |
| `REQ-03` | Trilingual Support (Hindi, Marathi, English) | Specs | Multilingual STT/TTS & prompt pipeline | Phase 3 | DESIGNED | Sec. 4.1 | Language code tag |
| `REQ-04` | Suman AI Lead Teacher Persona | Pedagogy | Empathetic RAG-grounded prompt profile | Phase 2 | DESIGNED | Sec. 2.1 | Low temperature 0.2 |
| `REQ-05` | Suresh Practice Teacher Persona | Pedagogy | Gamified practice & drill engine | Phase 4 | DESIGNED | Sec. 2.1 | Quiz module integration |
| `REQ-06` | Voice Interaction Engine | Interaction | Asynchronous STT/TTS streaming | Phase 3 | DESIGNED | Sec. 4.1 | Target >92% WER |
| `REQ-07` | Text Input & Messaging Interface | Interaction | REST/WebSocket message endpoint | Phase 1 | DESIGNED | Sec. 7.3 | Multi-modal fallback |
| `REQ-08` | Image & Homework Photo Scanning | Interaction | Vision OCR + AI explanation pipeline | Phase 6 | DESIGNED | Sec. 7.1 | Primary worksheets |
| `REQ-09` | Understanding-First Pedagogy | Pedagogy | Concept -> Analogy -> Quiz framework | Phase 2 | DESIGNED | Sec. 2.1 | CBSE aligned |
| `REQ-10` | CBSE Curriculum Mapping | Curriculum | Standardized topic & concept tagging | Phase 2 | DESIGNED | Sec. 7.2 | Mathematics & EVS |
| `REQ-11` | Knowledge World Visual Map | Feature | Graph node & edge relationship model | Phase 5 | DESIGNED | Sec. 7.2 | Concept mastery visual |
| `REQ-12` | Real-time Pronunciation Guide | Feature | Phoneme analysis speech pipeline | Phase 7 | DESIGNED | Sec. 7.2 | Phonetic score |
| `REQ-13` | Gamification & Educational Quizzes | Feature | Points, badges, game levels model | Phase 4 | DESIGNED | Sec. 7.2 | Encouragement model |
| `REQ-14` | Homework OCR & Explanation Engine | Feature | Image processing + step-by-step guidance | Phase 6 | DESIGNED | Sec. 7.1 | Worksheet helper |
| `REQ-15` | Exams & Formative Assessments | Feature | Assessment session & score tracking | Phase 8 | DESIGNED | Sec. 7.2 | Curriculum evaluation |
| `REQ-16` | Adaptive Personalization Engine | AI | Mastery-based learning pace adaptation | Phase 8 | DESIGNED | Sec. 7.2 | Pace adjustments |
| `REQ-17` | Parent Progress Dashboard | Parent | Progress analytics & summary reports | Phase 9 | DESIGNED | Sec. 7.1 | Parent oversight |
| `REQ-18` | Parent Time Controls & Screen Management | Parent | Configurable session duration limits | Phase 9 | DESIGNED | Sec. 7.2 | Healthy usage |
| `REQ-19` | Parent KYC & Identity Verification | Security | Encrypted identity document storage | Phase 9 | DESIGNED | Sec. 5.1 | Compliance required |
| `REQ-20` | Android Security & Integrity Checks | Mobile | Play Integrity, App Signing, root checks | Phase 10 | DESIGNED | Sec. 5.3 | Client defense-in-depth |
| `REQ-21` | CMS Content & Authoring System | Educator | Authoring portal for teachers & admins | Phase 9 | DESIGNED | Sec. 7.1 | Curriculum authoring |
| `REQ-22` | Free Initial Launch Tier | Business | Access control model for free tier | Phase 1 | DESIGNED | Sec. 2.1 | Accessibility goal |
| `REQ-23` | Child Safety & Content Guardrails | Safety | Prompt filters & zero-toxicity guardrail | Phase 2 | DESIGNED | Sec. 4.2 | Safe environment |
| `REQ-24` | 18 Logical Service Architecture | Architecture | Microservice/Modular monolith boundary | Phase 0 | DESIGNED | Sec. 7.1 | Modular design |
| `REQ-25` | 41 Logical ERD Entities | Architecture | Normalized relational entity schema | Phase 0 | DESIGNED | Sec. 7.2 | Database blueprint |
| `REQ-26` | Grounded Hallucination Prevention | AI Architecture | RAG + low temperature 0.2 + guardrails | Phase 2 | DESIGNED | Sec. 4.2 | Factual accuracy |
| `REQ-27` | Speech Confidence Fallback Handling | AI Architecture | Threshold <0.82 triggers clarification | Phase 3 | DESIGNED | Sec. 4.1 | Graceful degradation |
| `REQ-28` | DPDP Data Protection Alignment | Privacy | Data minimization & parent consent | Phase 1 | DESIGNED | Sec. 5.2 | Legal review required |
| `REQ-29` | COPPA Compliance Alignment | Privacy | Child privacy-by-design framework | Phase 1 | DESIGNED | Sec. 5.2 | Legal review required |
| `REQ-30` | Server-Side Authorization Enforcement | Security | Mandatory token validation on all endpoints | Phase 1 | DESIGNED | Sec. 5.3 | Core security rule |
| `REQ-31` | Golden Learning Flow Validation | Architecture | Phase 0 architectural validation | Phase 0 | VERIFIED | Sec. 6 | Flow definition |
| `REQ-32` | 12-Phase Execution Roadmap | Management | Structured sequential phase gates | Phase 0 | VERIFIED | Sec. 8 | Project governance |
| `REQ-33` | Explicit Assumptions & Targets Matrix | Governance | Classification table for decisions | Phase 0 | VERIFIED | Sec. 10 | Governance policy |
| `REQ-34` | Phase Gate & Evidence Policies | Governance | Strict PASS requirements for future phases | Phase 0 | VERIFIED | Sec. 11 | Phase 0 evidence rule |
| `REQ-35` | Greenfield Repository Control | Governance | Zero implementation code in Phase 0 | Phase 0 | VERIFIED | Sec. 12 | Clean repository |

---

## 10. ASSUMPTIONS VS DECISIONS VS TARGETS

| Classification Category | Item Description | Current Status / Definition |
| :--- | :--- | :--- |
| **Confirmed Decision** | Class 1 is initial priority launch grade | Confirmed architectural focus for initial content |
| **Confirmed Decision** | Suman and Suresh AI personas | Confirmed core teaching dual-persona model |
| **Confirmed Decision** | Trilingual support (Hindi, Marathi, English) | Confirmed platform language support scope |
| **Open Decision** | Specific Cloud Speech STT/TTS vendor selection | Open decision (evaluating Whisper, Azure Speech, Google STT) |
| **Open Decision** | Specific KYC Verification Provider | Open decision (evaluating Aadhaar OKYC / vendor APIs) |
| **Assumption** | Primary students have parent device access | Assumed primary usage on parent Android smartphone |
| **Target Metric** | Speech Recognition Accuracy | Target >92% word error rate accuracy |
| **Target Metric** | Audio Latency | Target <800ms end-to-end voice latency |
| **Acceptance Criterion**| Low Confidence Speech Fallback | Score <0.82 MUST trigger clarification prompt |
| **Acceptance Criterion**| Greenfield Integrity in Phase 0 | Zero product implementation code in Phase 0 |

---

## 11. PHASE 0 GOVERNANCE POLICIES & PHASE GATE RULES

### 11.1 Phase 0 Evidence Rule
Evidence in this project is strictly classified:
1. **Requirement Evidence**: Documented in `docs/PHASE_0_SPECIFICATION.md` and matrix.
2. **Design Evidence**: Documented ERD schemas, service boundaries, and API JSON specifications.
3. **Implementation Evidence**: Source code in `src/`, `backend/`, `android/` (Phase 1+ only).
4. **Test Evidence**: Automated test execution logs (e.g., `verify_phase_0.py` PASS output).
5. **Runtime Evidence**: Environment logs and metrics from deployed staging/production systems.

### 11.2 Phase Gate Rule
- **Rule**: A phase CANNOT be marked `PASS` merely because documentation exists.
- **Implementation Phases Requirements**: For Phase 1 and beyond, `PASS` requires working source code, automated test suites passing, integration evidence, security checks, and verified Definition of Done.

### 11.3 No False Completion Rule
Documentation or architectural design of a future feature does NOT equal product completion.
- *Designed API ≠ Implemented API*
- *Specified AI persona ≠ Working AI model*
- *Designed KYC schema ≠ Live identity verification*

---

## 12. FINAL PHASE 0 AUDIT & VERIFICATION REPORT

### 12.1 Audit Summary
- **Repository State**: Greenfield confirmed. Git working tree clean.
- **Documentation State**: Complete, internally consistent, and fully updated.
- **Requirement Coverage**: All 35 requirement groups (`REQ-01` to `REQ-35`) fully accounted for.
- **Specification Coverage**: 18 logical service modules, 41 logical ERD entities, full API schemas defined.
- **Verification Result**: `scripts/verify_phase_0.py` executed cleanly with zero errors.
- **Not Implemented**: Zero Phase 1+ implementation code created.
- **Open Decisions**: Specific STT/TTS and KYC provider selections remain open for Phase 1/9 evaluation.
- **Assumptions & Targets**: Fully cataloged and classified.
- **Phase Gate Status**: Phase 0 specifications and quality gates are completely satisfied.

---

```
PHASE 0 STATUS: PASS
```
*ABSOLUTE STOP CONDITION REACHED. Awaiting explicit instruction for Phase 1.*
