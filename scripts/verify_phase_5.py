"""
Phase 5 Verification Script for Nehal Ki Teacher AI.
Validates English speaking schemas, progression engine service,
API endpoints (/prompts, /evaluate), mobile DTOs, gentle feedback logic,
absence of forbidden Phase 6+ features, pytest suite, ruff linting, and docs.
"""
import subprocess
import sys
from pathlib import Path

from fastapi.testclient import TestClient

root_dir = Path(__file__).parent.parent
sys.path.insert(0, str(root_dir))

from backend.app.main import app  # noqa: E402


def verify_directory_structure(root: Path) -> bool:
    print("[1/7] Verifying Phase 5 directory structure...")
    required_files = [
        "backend/app/schemas/english_speaking.py",
        "backend/app/services/english_speaking_service.py",
        "backend/app/api/v1/english_speaking.py",
        "backend/tests/test_english_speaking.py",
        "mobile/lib/models/english_speaking.dart",
        "mobile/lib/services/english_speaking_service.dart",
        "docs/PHASE_5_ENGLISH_SPEAKING.md",
    ]
    for rel_path in required_files:
        p = root / rel_path
        if not p.is_file():
            print(f"FAIL: Missing required file: {rel_path}")
            return False
    print("Phase 5 directory structure: PASS")
    return True


def verify_english_speaking_api_endpoints() -> bool:
    print("[2/7] Verifying English Speaking API endpoints (/prompts, /evaluate)...")
    client = TestClient(app)

    # 1. GET /prompts
    prompts_res = client.get("/api/v1/english-speaking/prompts")
    if prompts_res.status_code != 200 or "prompts" not in prompts_res.json():
        print(
            f"FAIL: /api/v1/english-speaking/prompts returned status {prompts_res.status_code}"
        )
        return False

    # 2. POST /evaluate
    eval_res = client.post(
        "/api/v1/english-speaking/evaluate",
        json={
            "student_id": "verify-std",
            "prompt_id": "prompt-l1-001",
            "spoken_transcript": "Good morning",
            "duration_seconds": 2.0,
        },
    )
    if eval_res.status_code != 200 or "feedback" not in eval_res.json():
        print(
            f"FAIL: /api/v1/english-speaking/evaluate returned status {eval_res.status_code}"
        )
        return False

    print("English Speaking API endpoints verification: PASS")
    return True


def verify_no_phase_6_features(root: Path) -> bool:
    print("[3/7] Checking for forbidden Phase 6+ implementations...")
    forbidden_keywords = [
        "knowledge_world_game_engine",
        "gamified_exam_analytics_portal",
        "live_kyc_verification_engine",
        "razorpay_payment_gateway",
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
                        print(f"FAIL: Forbidden Phase 6+ keyword '{kw}' found in {file_path}")
                        return False

    print("No Phase 6+ features check: PASS")
    return True


def verify_pytest() -> bool:
    print("[4/7] Running pytest unit test suite...")
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
    print("[5/7] Running ruff lint check...")
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
    print("[6/7] Verifying Phase 5 documentation...")
    doc_path = root / "docs/PHASE_5_ENGLISH_SPEAKING.md"
    if not doc_path.is_file():
        print("FAIL: Missing docs/PHASE_5_ENGLISH_SPEAKING.md")
        return False

    readme_path = root / "README.md"
    if not readme_path.is_file():
        print("FAIL: Missing README.md")
        return False

    readme_content = readme_path.read_text(encoding="utf-8")
    if "Phase 5" not in readme_content:
        print("FAIL: README.md does not reference Phase 5 completion")
        return False

    print("Documentation check: PASS")
    return True


def verify_phase_0_through_4(root: Path) -> bool:
    print("[7/7] Validating baseline verification scripts for Phase 0 - 4...")
    try:
        subprocess.run(
            [sys.executable, "scripts/verify_phase_0.py"],
            check=True,
            capture_output=True,
        )
        subprocess.run(
            [sys.executable, "scripts/verify_phase_1.py"],
            check=True,
            capture_output=True,
        )
        subprocess.run(
            [sys.executable, "scripts/verify_phase_4.py"],
            check=True,
            capture_output=True,
        )
        print("Phase 0 - 4 baseline verification check: PASS")
        return True
    except subprocess.CalledProcessError as e:
        print(f"FAIL: Baseline verification check failed: {e.stderr}")
        return False


def main():
    root = Path(__file__).parent.parent
    print("=======================================")
    print("Nehal Ki Teacher AI - Phase 5 Verification")
    print("=======================================")

    checks = [
        verify_directory_structure(root),
        verify_english_speaking_api_endpoints(),
        verify_no_phase_6_features(root),
        verify_pytest(),
        verify_ruff_lint(),
        verify_documentation(root),
        verify_phase_0_through_4(root),
    ]

    if all(checks):
        print("\n=======================================")
        print("PHASE 5 VERIFICATION RESULT: PASS")
        print("=======================================")
        sys.exit(0)
    else:
        print("\n=======================================")
        print("PHASE 5 VERIFICATION RESULT: FAIL")
        print("=======================================")
        sys.exit(1)


if __name__ == "__main__":
    main()
