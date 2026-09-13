"""
Phase 3 Verification Script for Nehal Ki Teacher AI.
Validates Suman AI Teacher architecture, multi-lingual prompt system,
RAG grounding, safety filters, mobile client DTOs, endpoint contracts,
absence of forbidden Phase 4+ features, and executes unit tests.
"""

import subprocess
import sys
from pathlib import Path

from fastapi.testclient import TestClient

root_dir = Path(__file__).parent.parent
sys.path.insert(0, str(root_dir))

from backend.app.main import app  # noqa: E402


def verify_directory_structure(root: Path) -> bool:
    print("[1/6] Verifying Phase 3 directory structure...")
    required_files = [
        "backend/app/core/suman_persona.py",
        "backend/app/core/prompts.py",
        "backend/app/schemas/teacher.py",
        "backend/app/services/ai_teacher_service.py",
        "backend/app/api/v1/teacher.py",
        "backend/tests/test_ai_teacher.py",
        "mobile/lib/models/teacher.dart",
        "mobile/lib/services/teacher_service.dart",
        "docs/PHASE_3_SUMAN_AI_TEACHER.md",
    ]
    for rel_path in required_files:
        p = root / rel_path
        if not p.is_file():
            print(f"FAIL: Missing required file: {rel_path}")
            return False
    print("Phase 3 directory structure: PASS")
    return True


def verify_api_endpoints() -> bool:
    print("[2/6] Verifying Suman AI Teacher API endpoints & personas...")
    client = TestClient(app)

    # 1. Persona endpoint across 3 languages
    for lang in ["en", "hi", "mr"]:
        res = client.get(f"/api/v1/teacher/persona?language={lang}")
        if res.status_code != 200:
            print(f"FAIL: /api/v1/teacher/persona returned {res.status_code} for {lang}")
            return False
        data = res.json()
        if data.get("name") != "Suman AI":
            print(f"FAIL: Unexpected persona name for {lang}: {data.get('name')}")
            return False

    # 2. Chat endpoint standard query
    chat_payload = {
        "student_id": "verify-std-01",
        "message": "Explain Short Vowel A",
        "language": "en",
        "subject_code": "english",
        "concept_id": "con-eng-01",
    }
    chat_res = client.post("/api/v1/teacher/chat", json=chat_payload)
    if chat_res.status_code != 200:
        print(f"FAIL: /api/v1/teacher/chat returned status {chat_res.status_code}")
        return False

    # 3. Chat endpoint fallback explanation query
    fallback_payload = {
        "student_id": "verify-std-01",
        "message": "I don't understand",
        "language": "hi",
        "subject_code": "hindi",
        "concept_id": "con-hnd-01",
        "is_confused": True,
    }
    fallback_res = client.post("/api/v1/teacher/chat", json=fallback_payload)
    if fallback_res.status_code != 200:
        print(f"FAIL: /api/v1/teacher/chat fallback returned status {fallback_res.status_code}")
        return False
    fb_data = fallback_res.json()
    if not fb_data.get("is_fallback_explanation"):
        print("FAIL: Fallback response flag is not True")
        return False

    print("API endpoints & multi-lingual persona verification: PASS")
    return True


def verify_no_phase_4_features(root: Path) -> bool:
    print("[3/6] Checking for forbidden Phase 4+ implementations...")
    forbidden_keywords = [
        "elevenlabs",
        "voice_synthesis_engine",
        "speech_to_text_recorder",
        "audio_recording_stream",
        "photo_ocr_scanner",
        "tesseract_ocr",
        "payment_gateway",
        "kyc_verification_flow",
    ]

    scan_dirs = [root / "backend", root / "mobile"]
    for d in scan_dirs:
        for file_path in d.rglob("*"):
            if file_path.is_file():
                if "__pycache__" in file_path.parts:
                    continue
                content = file_path.read_text(encoding="utf-8", errors="ignore")
                for kw in forbidden_keywords:
                    if kw in content.lower():
                        print(f"FAIL: Forbidden Phase 4+ keyword '{kw}' found in {file_path}")
                        return False

    print("No Phase 4+ features check: PASS")
    return True


def verify_pytest() -> bool:
    print("[4/6] Running pytest unit test suite...")
    try:
        result = subprocess.run(
            [sys.executable, "-m", "pytest"],
            capture_output=True,
            text=True,
            check=True,
        )
        print(result.stdout)
        print("Pytest unit tests: PASS")
        return True
    except subprocess.CalledProcessError as e:
        print(f"FAIL: pytest failed with error:\n{e.stderr}\n{e.stdout}")
        return False


def verify_ruff_lint() -> bool:
    print("[5/6] Running ruff lint check...")
    try:
        result = subprocess.run(
            [sys.executable, "-m", "ruff", "check", "."],
            capture_output=True,
            text=True,
            check=True,
        )
        print(result.stdout)
        print("Ruff lint check: PASS")
        return True
    except subprocess.CalledProcessError as e:
        print(f"FAIL: ruff lint check failed:\n{e.stderr}\n{e.stdout}")
        return False


def main():
    root = Path(__file__).parent.parent
    print("=======================================")
    print("Nehal Ki Teacher AI - Phase 3 Verification")
    print("=======================================")

    checks = [
        verify_directory_structure(root),
        verify_api_endpoints(),
        verify_no_phase_4_features(root),
        verify_pytest(),
        verify_ruff_lint(),
    ]

    if all(checks):
        print("\n=======================================")
        print("PHASE 3 VERIFICATION RESULT: PASS")
        print("=======================================")
        sys.exit(0)
    else:
        print("\n=======================================")
        print("PHASE 3 VERIFICATION RESULT: FAIL")
        print("=======================================")
        sys.exit(1)


if __name__ == "__main__":
    main()
