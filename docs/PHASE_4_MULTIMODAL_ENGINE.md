# Phase 4 — Voice / Text / Image Engine Architecture Setup

## Executive Summary
Phase 4 establishes the multi-modal API foundation, interfaces, contracts, and privacy filters for Nehal Ki Teacher AI. It introduces Speech-to-Text (STT), Text-to-Speech (TTS), and Image/Homework Photo Scanning capabilities specifically tailored for primary school children (KG to Class 5, Class 1 focus) with offline fallback support.

---

## Architecture Overview

```
                          +-------------------------+
                          |   Mobile Client (Dart)  |
                          |  models/multimodal.dart |
                          |  services/multimodal.dart|
                          +------------+------------+
                                       |
                                       v  HTTP REST API
                          +-------------------------+
                          |   Backend API Router    |
                          |  api/v1/multimodal.py   |
                          +------------+------------+
                                       |
       +-------------------------------+-------------------------------+
       |                               |                               |
       v                               v                               v
+--------------+              +-----------------+             +------------------+
|  STT Service |              |   TTS Service   |             |  Image Service   |
| (transcribe) |              |   (synthesize)  |             |  (homework scan) |
+--------------+              +-----------------+             +------------------+
       |                               |                               |
       +-------------------------------+-------------------------------+
                                       |
                                       v
                          +-------------------------+
                          |  Privacy & Child Safety |
                          |  PII & EXIF Filters     |
                          +-------------------------+
```

---

## 1. Speech-to-Text (STT) Contract & Service
- **Endpoint**: `POST /api/v1/multimodal/stt`
- **Schema**: `STTAudioPayload` -> `STTResponse`
- **Child Acoustics**: Calibrated for fundamental frequencies typical of young children (200 Hz - 350 Hz).
- **Languages**: Multi-lingual support for English (`en`), Hindi (`hi`), and Marathi (`mr`).
- **Privacy Controls**: Automatic stripping of audio metadata and PII redaction (phones, names).

---

## 2. Text-to-Speech (TTS) Contract & Service
- **Endpoint**: `POST /api/v1/multimodal/tts`
- **Schema**: `TTSRequest` -> `TTSResponse`
- **Voice Personas**:
  - `suman_warm`: Warm, supportive, patient primary teacher voice.
  - `suresh_playful`: Encouraging co-teacher voice.
- **Child Pitch & Speed**: Speech speed defaults to 0.85x normal rate for primary comprehension.
- **Word Alignment**: Generates word-level timestamps (`WordTimestamp`) for synchronized UI word highlighting.

---

## 3. Homework Photo Scan (Image Vision) Contract
- **Endpoint**: `POST /api/v1/multimodal/image-scan`
- **Schema**: `ImageScanRequest` -> `ImageScanResponse`
- **Child Safety & Content Inspection**: Filters out non-educational or inappropriate content (`ChildSafetyScanStatus`).
- **OCR Region Bounding Boxes**: Normalized coordinate bounding boxes (`BoundingBox` with `x_min`, `y_min`, `x_max`, `y_max`) for highlighting worksheet questions.
- **EXIF & PII Redaction**: Strips camera EXIF metadata and redacts student personal header details.

---

## 4. Offline Fallback Strategy
All multi-modal service interfaces inherit from abstract base classes (`BaseVoiceService`, `BaseImageService`), backed by `MockVoiceService` and `MockImageService` implementations. In the event of network disruption or local processing, offline fallback responses are flagged via `offline_fallback: true`.

---

## Verification & Compliance
- Full unit test suite in `backend/tests/test_multimodal.py`
- End-to-end Phase 4 validation script in `scripts/verify_phase_4.py`
