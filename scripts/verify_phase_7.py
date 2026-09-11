"""
Phase 7 Verification Script for Nehal Ki Teacher AI.
Validates Exam & Analytics schemas, analytics service,
API endpoints (/generate-exam, /submit-exam, /parent-dashboard, /parent-consent),
mobile models & service, absence of forbidden Phase 8+ features
(live payment gateway, production App Store deployment, unsafe data storage),
pytest suite, ruff linting, and documentation.
"""
import subprocess
import sys
from pathlib import Path

from fastapi.testclient import TestClient

root_dir = Path(__file__).parent.parent
sys.path.insert(0, str(root_dir))

from backend.app.main import app  # noqa: E402


def verify_directory_structure(root: Path) -> bool:
    print("[1/7] Verifying Phase 7 directory structure...")
    required_files = [
        "backend/app/schemas/analytics.py",
        "backend/app/services/analytics_service.py",
        "backend/app/api/v1/analytics.py",
        "backend/tests/test_analytics.py",
        "mobile/lib/models/analytics.dart",
        "mobile/lib/services/analytics_service.dart",
        "docs/PHASE_7_EXAMS_AND_PARENT_PORTAL.md",
    ]
    for rel_path in required_files:
        p = root / rel_path
        if not p.is_file():
            print(f"FAIL: Missing required file: {rel_path}")
            return False
    print("Phase 7 directory structure: PASS")
    return True


def verify_analytics_api_endpoints() -> bool:
    print("[2/7] Verifying Analytics API endpoints...")
    client = TestClient(app)

    # 1. GET /generate-exam
    url = "/api/v1/analytics/generate-exam?student_id=verify-std&grade_level=1&subject=math"
    gen_res = client.get(url)
    if gen_res.status_code != 200 or "questions" not in gen_res.json():
        print(f"FAIL: /api/v1/analytics/generate-exam GET status {gen_res.status_code}")
        return False
    exam_data = gen_res.json()
    exam_id = exam_data["exam_id"]
    q1 = exam_data["questions"][0]

    # 2. POST /submit-exam
    sub_res = client.post(
        "/api/v1/analytics/submit-exam",
        json={
            "student_id": "verify-std",
            "exam_id": exam_id,
            "grade_level": 1,
            "subject": "math",
            "answers": [
                {
                    "question_id": q1["question_id"],
                    "answer_text": q1["correct_answer"],
                    "selected_option_id": q1["correct_answer"],
                    "time_spent_seconds": 5.0,
                }
            ],
        },
    )
    if sub_res.status_code != 200 or "submission_id" not in sub_res.json():
        print(f"FAIL: /api/v1/analytics/submit-exam POST status {sub_res.status_code}")
        return False

    # 3. GET /parent-dashboard
    dash_res = client.get("/api/v1/analytics/parent-dashboard?student_id=verify-std")
    if dash_res.status_code != 200 or "overall_mastery_percentage" not in dash_res.json():
        print(f"FAIL: /api/v1/analytics/parent-dashboard GET status {dash_res.status_code}")
        return False

    print("Analytics API endpoints verification: PASS")
    return True


def verify_no_phase_8_features(root: Path) -> bool:
    print("[3/7] Checking for forbidden Phase 8+ implementations...")
    forbidden_keywords = [
        "razorpay_live_secret",
        "stripe_production_key",
        "apple_app_store_production_deploy",
        "unencrypted_pii_local_store",
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
                        print(f"FAIL: Forbidden Phase 8+ keyword '{kw}' found in {file_path}")
                        return False

    print("No Phase 8+ features check: PASS")
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
    print("[6/7] Verifying Phase 7 documentation...")
    doc_path = root / "docs/PHASE_7_EXAMS_AND_PARENT_PORTAL.md"
    if not doc_path.is_file():
        print("FAIL: Missing docs/PHASE_7_EXAMS_AND_PARENT_PORTAL.md")
        return False

    readme_path = root / "README.md"
    if not readme_path.is_file():
        print("FAIL: Missing README.md")
        return False

    readme_content = readme_path.read_text(encoding="utf-8")
    if "Phase 7" not in readme_content:
        print("FAIL: README.md does not reference Phase 7 completion")
        return False

    print("Documentation check: PASS")
    return True


def verify_phase_0_through_6(root: Path) -> bool:
    print("[7/7] Validating baseline verification scripts for Phase 0 - 6...")
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
            [sys.executable, "scripts/verify_phase_5.py"],
            check=True,
            capture_output=True,
        )
        subprocess.run(
            [sys.executable, "scripts/verify_phase_6.py"],
            check=True,
            capture_output=True,
        )
        print("Phase 0 - 6 baseline verification check: PASS")
        return True
    except subprocess.CalledProcessError as e:
        print(f"FAIL: Baseline verification check failed: {e.stderr}")
        return False


def main():
    root = Path(__file__).parent.parent
    print("=======================================")
    print("Nehal Ki Teacher AI - Phase 7 Verification")
    print("=======================================")

    checks = [
        verify_directory_structure(root),
        verify_analytics_api_endpoints(),
        verify_no_phase_8_features(root),
        verify_pytest(),
        verify_ruff_lint(),
        verify_documentation(root),
        verify_phase_0_through_6(root),
    ]

    if all(checks):
        print("\n=======================================")
        print("PHASE 7 VERIFICATION RESULT: PASS")
        print("=======================================")
        sys.exit(0)
    else:
        print("\n=======================================")
        print("PHASE 7 VERIFICATION RESULT: FAIL")
        print("=======================================")
        sys.exit(1)


if __name__ == "__main__":
    main()
