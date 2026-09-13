"""
Phase 0 Verification Script for Nehal Ki Teacher AI.
Validates baseline setup, 35 master requirements, and design validation labels.
"""

import sys
from pathlib import Path


def main():
    root = Path(__file__).parent.parent
    print("=== Running Phase 0 Verification ===")

    readme = root / "README.md"
    phase_0_spec = root / "docs" / "PHASE_0_SPECIFICATION.md"

    if not readme.exists():
        print("FAIL: README.md missing")
        sys.exit(1)

    if not phase_0_spec.exists():
        print("FAIL: docs/PHASE_0_SPECIFICATION.md missing")
        sys.exit(1)

    spec_content = phase_0_spec.read_text()

    # Check for Design Targets / Future Acceptance Criteria framing
    if "Design Targets / Future Acceptance Criteria" not in spec_content:
        print(
            "FAIL: PHASE_0_SPECIFICATION.md must explicitly designate metrics as "
            "Design Targets / Future Acceptance Criteria"
        )
        sys.exit(1)

    # Check for Architectural Design Validation label
    if "Architectural Design Validation" not in spec_content:
        print(
            "FAIL: PHASE_0_SPECIFICATION.md must label Phase 0 validation as "
            "Architectural Design Validation"
        )
        sys.exit(1)

    # Check for 35 requirement groups coverage
    for req_num in range(1, 36):
        req_str = f"REQ-{req_num:02d}"
        if req_str not in spec_content:
            print(f"FAIL: {req_str} missing from docs/PHASE_0_SPECIFICATION.md")
            sys.exit(1)

    print("Phase 0 verification passed. PHASE 0 STATUS: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()
