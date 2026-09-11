# Phase 7 — Exams / Analytics Engine / Parent Portal Architecture

## Overview
Phase 7 establishes the diagnostic assessment engine, student learning trajectory analytics, learning gap detection algorithms, parent portal dashboard schemas/endpoints, and privacy-compliant DPDP Act (India) and COPPA parental consent control boundaries for **Nehal Ki Teacher AI**.

## Diagnostic Exam Engine
- **Grade & Subject Targeting**: Dynamically generates age-appropriate diagnostic and formative quiz papers tailored for primary school students (Classes 1–5 across Math, Hindi, English, and EVS).
- **Question Types**: Supports Multiple Choice (MCQ), Fill-in-the-Blank, and Short-Answer item formats with associated point values and explanations.
- **Evaluation Logic**: Auto-evaluates student response payloads, calculates percentage mastery scores, and provides encouraging bilingual feedback.

## Learning Analytics & Gap Detection
- **Subject Mastery**: Categorizes performance across subject domains into mastery tiers (`Novice`, `Developing`, `Proficient`, `Master`).
- **Strength & Weakness Identification**: Automatically groups correct/incorrect responses by topic area (e.g. Addition, Pattern Recognition, Phonology) to highlight specific strengths and active learning gaps.
- **Actionable Parent Recommendations**: Translates diagnosed learning gaps into actionable, child-friendly practice recommendations (e.g., practice skip-counting in Math Jungle).

## Parent Portal Architecture & DPDP/COPPA Privacy Controls
- **Aggregated Summary Dashboard**: Offers parents high-level insights into child learning time, overall mastery percentage, subject breakdowns, and learning gaps without exposing sensitive raw child audio recordings or direct personal identifiers.
- **Parental Consent Framework**: Implements DPDP Act (India) and COPPA compliance flags including:
  - Ephemeral voice processing consent toggles
  - Analytics data aggregation controls
  - Data retention configuration (30–365 days)
  - Full consent granting and revocation status management

## API Endpoints (`/api/v1/analytics/`)
- `POST /api/v1/analytics/generate-exam` & `GET /api/v1/analytics/generate-exam`: Generate diagnostic/formative exam papers.
- `POST /api/v1/analytics/submit-exam`: Evaluate student test responses and return instant scores and topic mastery feedback.
- `GET /api/v1/analytics/parent-dashboard`: Retrieve privacy-compliant child progress, gap indicators, and consent settings.
- `POST /api/v1/analytics/parent-consent`: Update parental privacy consent preferences.

## Mobile Client Architecture
- Dart DTOs in `mobile/lib/models/analytics.dart` mapping `ExamPaper`, `ExamSubmissionResponse`, `ParentDashboardResponse`, and `DPDPParentConsent`.
- Service layer in `mobile/lib/services/analytics_service.dart` handling backend API integration for local practice mode and parent portal visualization.
