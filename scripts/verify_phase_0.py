"""
Phase 0 Verification Script for Nehal Ki Teacher AI.
Validates baseline setup and documentation integrity.
"""
import sys
from pathlib import Path


def main():
    root = Path(__file__).parent.parent
    print("=== Running Phase 0 Verification ===")

    # Verify docs and basic repo state
    readme = root / "README.md"
    if not readme.exists():
        print("FAIL: README.md missing")
        sys.exit(1)

    print("Phase 0 verification passed.")
    sys.exit(0)


if __name__ == "__main__":
    main()
