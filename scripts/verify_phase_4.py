"""
Phase 4 Verification Script for Nehal Ki Teacher AI.
Validates multi-modal schemas, voice and image service abstractions,
API endpoints (/stt, /tts, /image-scan), mobile DTOs, privacy/safety filters,
absence of forbidden Phase 5+ features, pytest suite, and ruff linting.
"""

import subprocess
import sys
from pathlib import Path

from fastapi.testclient import TestClient

root_dir = Path(__file__).parent.parent
sys.path.insert(0, str(root_dir))

from backend.app.main import app  # noqa: E402


def verify_directory_structure(root: Path) -> bool:
    print("[1/6] Verifying Phase 4 directory structure...")
    required_files = [
        "backend/app/schemas/multimodal.py",
        "backend/app/services/voice_service.py",
        "backend/app/services/image_service.py",
        "backend/app/api/v1/multimodal.py",
        "backend/tests/test_multimodal.py",
        "mobile/lib/models/multimodal.dart",
        "mobile/lib/services/multimodal_service.dart",
    ]
    for rel_path in required_files:
        p = root / rel_path
        if not p.is_file():
            print(f"FAIL: Missing required file: {rel_path}")
            return False
    print("Phase 4 directory structure: PASS")
    return True


def verify_multimodal_api_endpoints() -> bool:
    print("[2/6] Verifying Multi-Modal API endpoints (/stt, /tts, /image-scan)...")
    client = TestClient(app)

    # 1. STT verification
    stt_res = client.post(
        "/api/v1/multimodal/stt",
        json={"student_id": "verify-std", "language_hint": "en"},
    )
    if stt_res.status_code != 200 or "transcribed_text" not in stt_res.json():
        print(f"FAIL: /api/v1/multimodal/stt returned status {stt_res.status_code}")
        return False

    # 2. TTS verification
    tts_res = client.post(
        "/api/v1/multimodal/tts",
        json={"student_id": "verify-std", "text": "Hello Suman Teacher"},
    )
    if tts_res.status_code != 200 or "audio_base64" not in tts_res.json():
        print(f"FAIL: /api/v1/multimodal/tts returned status {tts_res.status_code}")
        return False

    # 3. Image scan verification
    img_res = client.post(
        "/api/v1/multimodal/image-scan",
        json={"student_id": "verify-std", "subject_hint": "math"},
    )
    if img_res.status_code != 200 or "detected_text" not in img_res.json():
        print(f"FAIL: /api/v1/multimodal/image-scan returned status {img_res.status_code}")
        return False

    print("Multi-Modal API endpoints verification: PASS")
    return True


def verify_no_phase_5_features(root: Path) -> bool:
    print("[3/6] Checking for forbidden Phase 5+ implementations...")
    forbidden_keywords = [
        "full_english_speaking_engine",
        "interactive_phonics_assessment_game",
        "knowledge_world_game_engine",
        "kyc_document_uploader",
        "razorpay_payment_sdk",
        "stripe_billing_integration",
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
                        print(f"FAIL: Forbidden Phase 5+ keyword '{kw}' found in {file_path}")
                        return False

    print("No Phase 5+ features check: PASS")
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


def verify_documentation(root: Path) -> bool:
    print("[6/6] Verifying Phase 4 documentation...")
    doc_path = root / "docs/PHASE_4_MULTIMODAL_ENGINE.md"
    if not doc_path.is_file():
        print("FAIL: Missing docs/PHASE_4_MULTIMODAL_ENGINE.md")
        return False
    print("Documentation check: PASS")
    return True


def main():
    root = Path(__file__).parent.parent
    print("=======================================")
    print("Nehal Ki Teacher AI - Phase 4 Verification")
    print("=======================================")

    checks = [
        verify_directory_structure(root),
        verify_multimodal_api_endpoints(),
        verify_no_phase_5_features(root),
        verify_pytest(),
        verify_ruff_lint(),
        verify_documentation(root),
    ]

    if all(checks):
        print("\n=======================================")
        print("PHASE 4 VERIFICATION RESULT: PASS")
        print("=======================================")
        sys.exit(0)
    else:
        print("\n=======================================")
        print("PHASE 4 VERIFICATION RESULT: FAIL")
        print("=======================================")
        sys.exit(1)


if __name__ == "__main__":
    main()
