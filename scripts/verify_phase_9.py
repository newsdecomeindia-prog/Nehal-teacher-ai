"""
Phase 9 Final Backend Integration & Full UI Activation Verification Script.
Validates Flutter mobile UI code integrity, tests live backend contracts across all 4 UI tabs,
executes master verification, and checks Flutter analyze/tests.
"""
import subprocess
import sys
from pathlib import Path

from fastapi.testclient import TestClient

root_dir = Path(__file__).parent.parent
sys.path.insert(0, str(root_dir))

from backend.app.main import app  # noqa: E402


def verify_phase_9_directory_structure(root: Path) -> bool:
    print("[1/4] Verifying Phase 9 mobile & backend integration files...")
    required_files = [
        "mobile/lib/main.dart",
        "mobile/lib/services/teacher_service.dart",
        "mobile/lib/services/knowledge_world_service.dart",
        "mobile/lib/services/english_speaking_service.dart",
        "mobile/lib/services/analytics_service.dart",
        "mobile/pubspec.yaml",
        "mobile/test/widget_test.dart",
    ]
    for rel_path in required_files:
        p = root / rel_path
        if not p.is_file():
            print(f"FAIL: Missing required file: {rel_path}")
            return False
    print("Phase 9 directory structure check: PASS")
    return True


def verify_live_backend_contracts() -> bool:
    print("[2/4] Testing FastAPI backend endpoints for all 4 mobile UI tabs...")
    client = TestClient(app)

    # Tab 1: Suman AI Chat
    chat_payload = {
        "student_id": "student_class1_001",
        "message": "Hello Suman Teacher!",
        "language": "en",
        "is_confused": False,
    }
    chat_res = client.post("/api/v1/teacher/chat", json=chat_payload)
    if chat_res.status_code != 200 or "response_text" not in chat_res.json():
        print(f"FAIL: Teacher chat endpoint status {chat_res.status_code}")
        return False

    # Tab 2: Knowledge World
    kw_res = client.get("/api/v1/knowledge-world/worlds")
    if kw_res.status_code != 200 or not isinstance(kw_res.json(), list):
        print(f"FAIL: Knowledge World endpoint status {kw_res.status_code}")
        return False

    # Tab 3: English Speaking
    prompts_res = client.get("/api/v1/english-speaking/prompts")
    if prompts_res.status_code != 200 or "prompts" not in prompts_res.json():
        print(f"FAIL: English speaking prompts status {prompts_res.status_code}")
        return False

    eval_payload = {
        "student_id": "student_class1_001",
        "prompt_id": "prompt-c1-01",
        "spoken_transcript": "Good Morning Teacher",
        "target_sentence": "Good Morning Teacher!",
        "duration_seconds": 2.5,
    }
    eval_res = client.post("/api/v1/english-speaking/evaluate", json=eval_payload)
    if eval_res.status_code != 200 or "feedback" not in eval_res.json():
        print(f"FAIL: English speaking evaluation status {eval_res.status_code}")
        return False

    # Tab 4: Parent Portal Dashboard & Consent
    dash_url = (
        "/api/v1/analytics/parent-dashboard"
        "?student_id=student_class1_001&parent_id=parent-01"
    )
    dash_res = client.get(dash_url)
    if dash_res.status_code != 200 or "overall_mastery_percentage" not in dash_res.json():
        print(f"FAIL: Parent dashboard status {dash_res.status_code}")
        return False

    consent_payload = {
        "parent_id": "parent-01",
        "child_student_id": "student_class1_001",
        "dpdp_consent_granted": True,
        "coppa_consent_granted": True,
    }
    consent_res = client.post("/api/v1/analytics/parent-consent", json=consent_payload)
    if consent_res.status_code != 200 or "consent_status" not in consent_res.json():
        print(f"FAIL: Parent consent status {consent_res.status_code}")
        return False

    print("FastAPI backend endpoint contracts check: PASS")
    return True


def verify_flutter_code_quality(root: Path) -> bool:
    print("[3/4] Running Flutter analyze & flutter test...")
    mobile_dir = root / "mobile"
    res_analyze = subprocess.run(
        ["flutter", "analyze", "--no-fatal-infos"],
        cwd=mobile_dir,
        capture_output=True,
        text=True,
    )
    print(res_analyze.stdout)
    if res_analyze.returncode != 0:
        print(f"FAIL: Flutter analyze failed:\n{res_analyze.stderr}")
        return False

    res_test = subprocess.run(
        ["flutter", "test"],
        cwd=mobile_dir,
        capture_output=True,
        text=True,
    )
    print(res_test.stdout)
    if res_test.returncode != 0:
        print(f"FAIL: Flutter test failed:\n{res_test.stderr}")
        return False

    print("Flutter analyze & test: PASS")
    return True


def verify_ruff_lint() -> bool:
    print("[4/4] Running ruff lint check...")
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
    print("Nehal Ki Teacher AI - Phase 9 Verification")
    print("=======================================")

    checks = [
        verify_phase_9_directory_structure(root),
        verify_live_backend_contracts(),
        verify_flutter_code_quality(root),
        verify_ruff_lint(),
    ]

    if all(checks):
        print("\n=======================================")
        print("PHASE 9 VERIFICATION RESULT: PASS")
        print("=======================================")
        sys.exit(0)
    else:
        print("\n=======================================")
        print("PHASE 9 VERIFICATION RESULT: FAIL")
        print("=======================================")
        sys.exit(1)


if __name__ == "__main__":
    main()
