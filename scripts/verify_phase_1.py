"""
Phase 1 Verification Script for Nehal Ki Teacher AI.
Verifies directory layout, configuration templates, absence of secrets/Phase 2+ features,
and backend unit test passes.
"""

import subprocess
import sys
from pathlib import Path


def verify_directory_layout(root: Path):
    print("[1/5] Verifying directory structure...")
    required_dirs = [
        "backend",
        "backend/app",
        "backend/tests",
        "mobile",
        "mobile/lib",
        "docs",
        "scripts",
        ".github/workflows",
    ]
    for d in required_dirs:
        p = root / d
        if not p.is_dir():
            print(f"FAIL: Directory '{d}' is missing.")
            return False

    required_files = [
        "backend/requirements.txt",
        "backend/app/main.py",
        "mobile/pubspec.yaml",
        "mobile/lib/main.dart",
        ".env.example",
        "backend/.env.example",
        ".gitignore",
        "pyproject.toml",
        ".github/workflows/phase_1_ci.yml",
        "README.md",
        "docs/PHASE_1_FOUNDATION.md",
    ]
    for f in required_files:
        p = root / f
        if not p.is_file():
            print(f"FAIL: File '{f}' is missing.")
            return False

    print("Directory structure verification: PASS")
    return True


def verify_config_and_secrets(root: Path):
    print("[2/5] Verifying configuration templates and checking for hardcoded secrets...")
    env_files = [root / ".env.example", root / "backend/.env.example"]
    secret_keywords = ["sk-proj", "AKIA", "ghp_", "bearer ", "BEGIN PRIVATE KEY"]

    for env_file in env_files:
        content = env_file.read_text(encoding="utf-8")
        for kw in secret_keywords:
            if kw in content:
                print(f"FAIL: Secret keyword '{kw}' found in {env_file.name}")
                return False

    print("Configuration and secret check: PASS")
    return True


def verify_unit_tests():
    print("[3/5] Running pytest unit tests...")
    try:
        result = subprocess.run(
            [sys.executable, "-m", "pytest"],
            capture_output=True,
            text=True,
            check=True,
        )
        print(result.stdout)
        print("Unit tests: PASS")
        return True
    except subprocess.CalledProcessError as e:
        print(f"FAIL: pytest failed with error:\n{e.stderr}\n{e.stdout}")
        return False


def verify_no_phase_2_features(root: Path):
    print("[4/5] Checking for forbidden Phase 2+ implementations...")
    forbidden_terms = [
        "suman_ai",
        "voice_engine",
        "kyc_integration",
        "ocr_service",
        "fake_llm",
    ]

    scan_dirs = [root / "backend", root / "mobile"]
    for d in scan_dirs:
        for file_path in d.rglob("*"):
            if file_path.is_file():
                # Skip __pycache__ or build artifacts
                if "__pycache__" in file_path.parts:
                    continue
                content = file_path.read_text(encoding="utf-8", errors="ignore")
                for term in forbidden_terms:
                    if term in content.lower():
                        print(f"FAIL: Forbidden Phase 2+ keyword '{term}' found in {file_path}")
                        return False

    print("Phase 2+ check: PASS")
    return True


def verify_ci_config(root: Path):
    print("[5/5] Verifying CI configuration...")
    ci_file = root / ".github" / "workflows" / "phase_1_ci.yml"
    if not ci_file.is_file():
        print("FAIL: CI workflow file is missing.")
        return False
    print("CI configuration check: PASS")
    return True


def main():
    root = Path(__file__).parent.parent
    print("=======================================")
    print("Nehal Ki Teacher AI - Phase 1 Verification")
    print("=======================================")

    checks = [
        verify_directory_layout(root),
        verify_config_and_secrets(root),
        verify_unit_tests(),
        verify_no_phase_2_features(root),
        verify_ci_config(root),
    ]

    if all(checks):
        print("\n=======================================")
        print("PHASE 1 VERIFICATION RESULT: PASS")
        print("=======================================")
        sys.exit(0)
    else:
        print("\n=======================================")
        print("PHASE 1 VERIFICATION RESULT: FAIL")
        print("=======================================")
        sys.exit(1)


if __name__ == "__main__":
    main()
