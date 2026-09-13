"""
Phase 8 Final Production Readiness & Verification Script for Nehal Ki Teacher AI.
Executes master verification across all phases (Phase 0 through 7), validates Phase 8
security readiness tests, Docker configurations, Mobile hardening modules, and
final documentation.
"""

import subprocess
import sys
from pathlib import Path

from fastapi.testclient import TestClient

root_dir = Path(__file__).parent.parent
sys.path.insert(0, str(root_dir))

from backend.app.main import app  # noqa: E402


def verify_directory_structure(root: Path) -> bool:
    print("[1/6] Verifying Phase 8 directory structure & production artifacts...")
    required_files = [
        "backend/app/core/config.py",
        "backend/app/core/privacy.py",
        "backend/tests/test_production_readiness.py",
        "backend/Dockerfile",
        "docker-compose.yml",
        "mobile/lib/services/secure_storage_service.dart",
        "mobile/lib/services/network_service.dart",
        "mobile/lib/widgets/error_boundary.dart",
        "scripts/verify_all_phases.py",
        "docs/PHASE_8_PRODUCTION_READINESS.md",
    ]
    for rel_path in required_files:
        p = root / rel_path
        if not p.is_file():
            print(f"FAIL: Missing required file: {rel_path}")
            return False
    print("Phase 8 directory structure & artifacts: PASS")
    return True


def verify_security_and_health_endpoints() -> bool:
    print("[2/6] Verifying Security Hardening & System Health Endpoints...")
    client = TestClient(app)

    # 1. Health check
    res = client.get("/health")
    if res.status_code != 200 or res.json().get("status") != "healthy":
        print(f"FAIL: Health endpoint returned status {res.status_code}")
        return False

    # 2. Security response headers
    headers = res.headers
    required_headers = [
        "X-Content-Type-Options",
        "X-Frame-Options",
        "X-XSS-Protection",
        "Strict-Transport-Security",
        "Content-Security-Policy",
    ]
    for h in required_headers:
        if h not in headers:
            print(f"FAIL: Missing security header {h}")
            return False

    print("Security & Health endpoints check: PASS")
    return True


def verify_production_pytest() -> bool:
    print("[3/6] Running production readiness pytest suite...")
    try:
        result = subprocess.run(
            [sys.executable, "-m", "pytest", "backend/tests/test_production_readiness.py"],
            capture_output=True,
            text=True,
            check=True,
        )
        print(result.stdout)
        print("Production readiness pytest suite: PASS")
        return True
    except subprocess.CalledProcessError as e:
        print(f"FAIL: production readiness pytest suite failed:\n{e.stderr}\n{e.stdout}")
        return False


def verify_all_phases_master_script() -> bool:
    print("[4/6] Running master verification across all phases (verify_all_phases.py)...")
    try:
        result = subprocess.run(
            [sys.executable, "scripts/verify_all_phases.py"],
            capture_output=True,
            text=True,
            check=True,
        )
        print(result.stdout)
        print("Master verification across all phases: PASS")
        return True
    except subprocess.CalledProcessError as e:
        print(f"FAIL: verify_all_phases.py failed:\n{e.stderr}\n{e.stdout}")
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
    print("[6/6] Verifying Phase 8 documentation & release notes...")
    doc_path = root / "docs/PHASE_8_PRODUCTION_READINESS.md"
    if not doc_path.is_file():
        print("FAIL: Missing docs/PHASE_8_PRODUCTION_READINESS.md")
        return False

    readme_path = root / "README.md"
    if not readme_path.is_file():
        print("FAIL: Missing README.md")
        return False

    readme_content = readme_path.read_text(encoding="utf-8")
    if "Phase 8" not in readme_content:
        print("FAIL: README.md does not reference Phase 8 completion")
        return False

    print("Documentation check: PASS")
    return True


def main():
    root = Path(__file__).parent.parent
    print("=======================================")
    print("Nehal Ki Teacher AI - Phase 8 Verification")
    print("=======================================")

    checks = [
        verify_directory_structure(root),
        verify_security_and_health_endpoints(),
        verify_production_pytest(),
        verify_ruff_lint(),
        verify_documentation(root),
        verify_all_phases_master_script(),
    ]

    if all(checks):
        print("\n=======================================")
        print("PHASE 8 VERIFICATION RESULT: PASS")
        print("=======================================")
        sys.exit(0)
    else:
        print("\n=======================================")
        print("PHASE 8 VERIFICATION RESULT: FAIL")
        print("=======================================")
        sys.exit(1)


if __name__ == "__main__":
    main()
