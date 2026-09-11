# Nehal Ki Teacher AI

AI-powered learning platform for primary students featuring Suman AI Teacher.

## Phase 1 — Technical & Repository Foundation

This repository provides a clean, monorepo-style engineering foundation for the Nehal Ki Teacher AI platform.

### Repository Architecture

- `backend/` — FastAPI Python backend application foundation, dependencies, and unit tests.
- `mobile/` — Flutter mobile application client configuration and foundational layout.
- `docs/` — Technical architecture and Phase 1 documentation (`docs/PHASE_1_FOUNDATION.md`).
- `scripts/` — Automated repository verification scripts (`scripts/verify_phase_0.py`, `scripts/verify_phase_1.py`).
- `.github/workflows/` — Automated CI workflow (`.github/workflows/phase_1_ci.yml`).

### Getting Started

#### Backend
```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
uvicorn backend.app.main:app --reload
```

#### Verification & Quality Checks
To verify Phase 1 foundation status and run test suites:
```bash
python scripts/verify_phase_0.py
python scripts/verify_phase_1.py
pytest
ruff check .
```

### Verification Status
- **Phase 1 Verification**: PASS
- **CI Workflow**: Enabled in `.github/workflows/phase_1_ci.yml`
