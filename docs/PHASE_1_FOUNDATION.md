# Phase 1 Technical & Repository Foundation

## Overview
This document outlines the architecture, directory layout, configuration guidelines, and local development instructions established in Phase 1 for **Nehal Ki Teacher AI**.

## Directory Layout
```
/
├── .github/workflows/    # CI/CD workflows (phase_1_ci.yml)
├── backend/              # FastAPI Python backend service
│   ├── app/              # Application logic and endpoints
│   ├── tests/            # Pytest unit tests
│   ├── .env.example      # Backend environment variables template
│   └── requirements.txt  # Pinned backend dependencies
├── mobile/               # Flutter / Mobile client application
│   ├── lib/              # Main Dart source files
│   └── pubspec.yaml      # Dependencies & configuration
├── docs/                 # Documentation (PHASE_1_FOUNDATION.md)
├── scripts/              # Verification scripts (verify_phase_0.py, verify_phase_1.py)
├── .env.example          # Root environment configuration template
├── .gitignore            # Git ignore configuration
├── pyproject.toml        # Ruff and Pytest tools configuration
└── README.md             # Main repository documentation
```

## Local Setup & Development Instructions

### Backend Setup
1. Navigate to `backend/`:
   ```bash
   cd backend
   ```
2. Create and activate a virtual environment:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Copy environment configuration:
   ```bash
   cp .env.example .env
   ```
5. Run application locally:
   ```bash
   uvicorn backend.app.main:app --reload
   ```

### Mobile Setup
1. Navigate to `mobile/`:
   ```bash
   cd mobile
   ```
2. Get Flutter packages:
   ```bash
   flutter pub get
   ```

## Verification & Testing

Run all checks locally using:
```bash
python scripts/verify_phase_0.py
python scripts/verify_phase_1.py
pytest
ruff check .
```
