# Nehal Ki Teacher AI

An AI-powered primary education platform tailored for foundational learning in India (KG to Class 5, with Class 1 as priority). Features Suman AI Teacher and Suresh AI Teacher delivering multi-lingual interactive lessons grounded in standard NCERT / State Board curriculum frameworks.

## Project Structure
- `backend/`: FastAPI backend service powering curriculum APIs, Suman AI teacher interaction, multi-modal voice/image services, English speaking engine, Knowledge World story engine, Diagnostic Exams & Parent Analytics, and production security hardening middleware.
- `mobile/`: Flutter client application data models, service abstractions, secure storage, offline state handling, and error boundaries.
- `docs/`: Technical specification documents, architecture guides, and production release documentation.
- `scripts/`: Verification scripts for Phase 0 through Phase 8, including the master verification script `scripts/verify_all_phases.py`.

## Completed Phases
- **Phase 0**: Architecture & Technical Requirements Blueprint
- **Phase 1**: Technical Foundation Setup & Core Repository Structure
- **Phase 2**: Class 1 Core Learning Architecture & Curriculum API
- **Phase 3**: Suman AI Teacher Integration
- **Phase 4**: Multi-Modal Engine Architecture Setup (Voice STT/TTS & Homework Photo Scan abstractions with child safety & privacy controls)
- **Phase 5**: English Small-Sentence Speaking Engine Architecture (3 difficulty tiers, gentle child-friendly soft scoring, phonetic guides, and offline fallback)
- **Phase 6**: Knowledge World / Gamified Learning & Story Engine Architecture (Interactive story quests, non-monetary gamification XP/badge rewards, Math Jungle / Word World / Science Safari themes, and offline continuity)
- **Phase 7**: Diagnostic Exams / Analytics Engine / Parent Portal Architecture (Classes 1-5 quiz paper generation, learning gap detection, parent portal summary dashboard, and DPDP/COPPA consent privacy controls)
- **Phase 8**: Production Readiness, Security Hardening & Pre-Release Audit (Security response headers, CORS constraints, rate limiting, startup environment variable validation, PII sanitization, Docker multi-stage build, Flutter error boundaries, and end-to-end verification suite)

## Building Android APK (CI/CD)

An automated GitHub Actions workflow (`.github/workflows/build_apk.yml`) is configured to automatically build a release Android APK whenever code is pushed to `main`, or on-demand via manual trigger (`workflow_dispatch`).

### How to Manually Trigger the APK Build & Download the APK

#### Desktop GitHub UI:
1. Navigate to the repository page on GitHub.
2. Click the **Actions** tab.
3. Select **Build Android APK** from the left sidebar workflow list.
4. Click **Run workflow** dropdown near the top right.
5. Choose the branch (e.g. `main`) and click **Run workflow**.
6. When the job finishes, click on the completed run.
7. Scroll down to the **Artifacts** section at the bottom of the page.
8. Click **Nehal-Teacher-AI-App** to download the zipped `.apk` file.

#### GitHub Mobile UI / App:
1. Open the repository in the GitHub Mobile app or mobile browser.
2. Tap **Actions**.
3. Select **Build Android APK**.
4. Tap **Run workflow** or the options menu to trigger the build manually.
5. Once the run completes, open the workflow run details and scroll down to **Artifacts**.
6. Tap **Nehal-Teacher-AI-App** to download the generated `.apk`.
