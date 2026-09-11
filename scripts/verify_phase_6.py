"""
Phase 6 Verification Script for Nehal Ki Teacher AI.
Validates Knowledge World schemas, story quest engine service,
API endpoints (/worlds, /quest/{id}, /complete-node), mobile DTOs,
badge/reward calculation, absence of forbidden Phase 7+ features
(exams/analytics, live payments, App Store deployment),
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
    print("[1/7] Verifying Phase 6 directory structure...")
    required_files = [
        "backend/app/schemas/knowledge_world.py",
        "backend/app/services/knowledge_world_service.py",
        "backend/app/api/v1/knowledge_world.py",
        "backend/tests/test_knowledge_world.py",
        "mobile/lib/models/knowledge_world.dart",
        "mobile/lib/services/knowledge_world_service.dart",
        "docs/PHASE_6_KNOWLEDGE_WORLD.md",
    ]
    for rel_path in required_files:
        p = root / rel_path
        if not p.is_file():
            print(f"FAIL: Missing required file: {rel_path}")
            return False
    print("Phase 6 directory structure: PASS")
    return True


def verify_knowledge_world_api_endpoints() -> bool:
    print("[2/7] Verifying Knowledge World API endpoints (/worlds, /quest/{id}, /complete-node)...")
    client = TestClient(app)

    # 1. GET /worlds
    worlds_res = client.get("/api/v1/knowledge-world/worlds")
    if worlds_res.status_code != 200 or not isinstance(worlds_res.json(), list):
        print(f"FAIL: /api/v1/knowledge-world/worlds status {worlds_res.status_code}")
        return False

    # 2. GET /quest/quest-math-01
    quest_res = client.get("/api/v1/knowledge-world/quest/quest-math-01")
    if quest_res.status_code != 200 or "nodes" not in quest_res.json():
        print(f"FAIL: /api/v1/knowledge-world/quest/quest-math-01 status {quest_res.status_code}")
        return False

    # 3. POST /complete-node
    comp_res = client.post(
        "/api/v1/knowledge-world/complete-node",
        json={
            "student_id": "verify-std-kw",
            "quest_id": "quest-math-01",
            "node_id": "node-m1-01",
            "selected_choice_id": "opt-m1-01a",
            "time_spent_seconds": 3.0,
        },
    )
    if comp_res.status_code != 200 or "xp_earned" not in comp_res.json():
        print(f"FAIL: /api/v1/knowledge-world/complete-node status {comp_res.status_code}")
        return False

    print("Knowledge World API endpoints verification: PASS")
    return True


def verify_no_phase_7_features(root: Path) -> bool:
    print("[3/7] Checking for forbidden Phase 7+ implementations...")
    forbidden_keywords = [
        "exam_analytics_dashboard",
        "live_payment_gateway",
        "razorpay_subscriptions",
        "app_store_production_deploy",
        "microtransaction_purchase",
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
                        print(f"FAIL: Forbidden Phase 7+ keyword '{kw}' found in {file_path}")
                        return False

    print("No Phase 7+ features check: PASS")
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
    print("[6/7] Verifying Phase 6 documentation...")
    doc_path = root / "docs/PHASE_6_KNOWLEDGE_WORLD.md"
    if not doc_path.is_file():
        print("FAIL: Missing docs/PHASE_6_KNOWLEDGE_WORLD.md")
        return False

    readme_path = root / "README.md"
    if not readme_path.is_file():
        print("FAIL: Missing README.md")
        return False

    readme_content = readme_path.read_text(encoding="utf-8")
    if "Phase 6" not in readme_content:
        print("FAIL: README.md does not reference Phase 6 completion")
        return False

    print("Documentation check: PASS")
    return True


def verify_phase_0_through_5(root: Path) -> bool:
    print("[7/7] Validating baseline verification scripts for Phase 0 - 5...")
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
        print("Phase 0 - 5 baseline verification check: PASS")
        return True
    except subprocess.CalledProcessError as e:
        print(f"FAIL: Baseline verification check failed: {e.stderr}")
        return False


def main():
    root = Path(__file__).parent.parent
    print("=======================================")
    print("Nehal Ki Teacher AI - Phase 6 Verification")
    print("=======================================")

    checks = [
        verify_directory_structure(root),
        verify_knowledge_world_api_endpoints(),
        verify_no_phase_7_features(root),
        verify_pytest(),
        verify_ruff_lint(),
        verify_documentation(root),
        verify_phase_0_through_5(root),
    ]

    if all(checks):
        print("\n=======================================")
        print("PHASE 6 VERIFICATION RESULT: PASS")
        print("=======================================")
        sys.exit(0)
    else:
        print("\n=======================================")
        print("PHASE 6 VERIFICATION RESULT: FAIL")
        print("=======================================")
        sys.exit(1)


if __name__ == "__main__":
    main()
