"""
Master verification script executing all phase verification scripts (Phase 0 through Phase 7)
sequentially, followed by running the entire pytest test suite.
"""
import subprocess
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).parent.parent


def run_command(cmd: list) -> bool:
    print(f"Running: {' '.join(cmd)}")
    try:
        res = subprocess.run(cmd, check=True, capture_output=True, text=True, cwd=ROOT_DIR)
        print(res.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"ERROR executing {' '.join(cmd)}:\n{e.stderr}\n{e.stdout}")
        return False


def main():
    print("==================================================")
    print("Executing All Phase Verifications (Phase 0 - 7)")
    print("==================================================")

    phase_scripts = [
        "scripts/verify_phase_0.py",
        "scripts/verify_phase_1.py",
        "scripts/verify_phase_2.py",
        "scripts/verify_phase_3.py",
        "scripts/verify_phase_4.py",
        "scripts/verify_phase_5.py",
        "scripts/verify_phase_6.py",
        "scripts/verify_phase_7.py",
    ]

    for script in phase_scripts:
        script_path = ROOT_DIR / script
        if script_path.exists():
            print(f"\n--- Verifying {script} ---")
            if not run_command([sys.executable, str(script_path)]):
                print(f"FAIL: {script} failed verification.")
                sys.exit(1)
        else:
            print(f"Skipping non-existent script: {script}")

    print("\n==================================================")
    print("Running Full System Pytest Suite")
    print("==================================================")
    if not run_command([sys.executable, "-m", "pytest", "backend/tests"]):
        print("FAIL: Full pytest suite failed.")
        sys.exit(1)

    print("\n==================================================")
    print("ALL PHASES (0-7) & PYTEST SUITE PASSED SUCCESSFULLY!")
    print("==================================================")


if __name__ == "__main__":
    main()
