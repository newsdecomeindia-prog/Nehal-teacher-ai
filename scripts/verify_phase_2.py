"""
Phase 2 Verification Script for Nehal Ki Teacher AI.
Validates Class 1 curriculum endpoints, schema validity, representation of all 5 subjects
(English, Hindi, Marathi, Mathematics, EVS/GK), and runs pytest unit tests.
"""

import subprocess
import sys
from pathlib import Path

from fastapi.testclient import TestClient

root_dir = Path(__file__).parent.parent
sys.path.insert(0, str(root_dir))

from backend.app.main import app  # noqa: E402


def verify_directory_structure(root: Path) -> bool:
    print("[1/5] Verifying Phase 2 directory structure...")
    required_files = [
        "backend/app/schemas/curriculum.py",
        "backend/app/services/curriculum_service.py",
        "backend/app/api/v1/curriculum.py",
        "backend/tests/test_curriculum.py",
        "mobile/lib/models/curriculum.dart",
        "mobile/lib/services/curriculum_service.dart",
    ]
    for rel_path in required_files:
        p = root / rel_path
        if not p.is_file():
            print(f"FAIL: Missing required file: {rel_path}")
            return False
    print("Phase 2 directory structure: PASS")
    return True


def verify_endpoints_and_subjects() -> bool:
    print("[2/5] Verifying API endpoints and subject representations...")
    client = TestClient(app)

    # 1. Version endpoint
    v_res = client.get("/api/v1/curriculum/class-1/version")
    if v_res.status_code != 200:
        print(f"FAIL: Version endpoint returned status {v_res.status_code}")
        return False
    v_data = v_res.json()
    if not v_data.get("cbse_compliant"):
        print("FAIL: Curriculum is not flagged as CBSE compliant")
        return False

    # 2. Subjects endpoint
    s_res = client.get("/api/v1/curriculum/class-1/subjects")
    if s_res.status_code != 200:
        print(f"FAIL: Subjects endpoint returned status {s_res.status_code}")
        return False
    subjects = s_res.json()
    subject_codes = {s["code"] for s in subjects}
    expected_subjects = {"english", "hindi", "marathi", "mathematics", "evs_gk"}

    if not expected_subjects.issubset(subject_codes):
        print(f"FAIL: Missing subjects. Found {subject_codes}, expected {expected_subjects}")
        return False

    # 3. Check individual subject details & lesson blueprints
    for code in expected_subjects:
        res = client.get(f"/api/v1/curriculum/class-1/subjects/{code}")
        if res.status_code != 200:
            print(f"FAIL: Could not fetch subject details for {code}")
            return False

    blueprint_res = client.get("/api/v1/curriculum/class-1/lessons/les-eng-01")
    if blueprint_res.status_code != 200:
        print("FAIL: Could not fetch lesson blueprint 'les-eng-01'")
        return False

    print("API endpoints & 5 subjects verification: PASS")
    return True


def verify_no_phase_3_features(root: Path) -> bool:
    print("[3/5] Checking for Phase 2 curriculum module isolation...")
    curriculum_files = [
        root / "backend/app/api/v1/curriculum.py",
        root / "backend/app/services/curriculum_service.py",
        root / "backend/app/schemas/curriculum.py",
    ]
    forbidden_keywords = [
        "kyc_integration",
        "unencrypted_pii_local_store",
    ]

    for file_path in curriculum_files:
        if file_path.is_file():
            content = file_path.read_text(encoding="utf-8", errors="ignore")
            for kw in forbidden_keywords:
                if kw in content.lower():
                    print(f"FAIL: Forbidden keyword '{kw}' found in {file_path}")
                    return False

    print("Curriculum module isolation check: PASS")
    return True


def verify_pytest() -> bool:
    print("[4/5] Running pytest unit test suite...")
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
    print("[5/5] Running ruff lint check...")
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
    print("Nehal Ki Teacher AI - Phase 2 Verification")
    print("=======================================")

    checks = [
        verify_directory_structure(root),
        verify_endpoints_and_subjects(),
        verify_no_phase_3_features(root),
        verify_pytest(),
        verify_ruff_lint(),
    ]

    if all(checks):
        print("\n=======================================")
        print("PHASE 2 VERIFICATION RESULT: PASS")
        print("=======================================")
        sys.exit(0)
    else:
        print("\n=======================================")
        print("PHASE 2 VERIFICATION RESULT: FAIL")
        print("=======================================")
        sys.exit(1)


if __name__ == "__main__":
    main()
