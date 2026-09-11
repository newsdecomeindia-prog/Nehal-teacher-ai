#!/usr/bin/env python3
import os
import re
import sys
import json

def check_phase_0():
    errors = []
    warnings = []

    doc_path = "docs/PHASE_0_SPECIFICATION.md"
    readme_path = "README.md"

    # 1. File Existence
    if not os.path.exists(doc_path):
        errors.append(f"Missing specification file: {doc_path}")
        return errors, warnings
    if not os.path.exists(readme_path):
        errors.append(f"Missing README file: {readme_path}")

    with open(doc_path, "r", encoding="utf-8") as f:
        doc_text = f.read()

    # 2. Check Requirement IDs REQ-01 to REQ-35
    for i in range(1, 36):
        req_id = f"REQ-{i:02d}"
        if req_id not in doc_text:
            errors.append(f"Missing requirement ID: {req_id}")

    # 3. Check specific required sections / terminology
    required_phrases = [
        "Golden Learning Flow — Phase 0 Architectural Validation",
        "ASSUMPTIONS VS DECISIONS VS TARGETS",
        "Phase 0 Evidence Rule",
        "Phase Gate Rule",
        "No False Completion Rule",
        "PHASE 0 STATUS: PASS",
        "SPECIFIED",
        "DESIGNED",
        "VERIFIED",
        "IMPLEMENTED",
        "35 requirement groups",
        "18 Service Modules",
        "41 Logical ERD Entities"
    ]

    for phrase in required_phrases:
        if phrase.lower() not in doc_text.lower():
            errors.append(f"Missing required phrase/section in {doc_path}: '{phrase}'")

    # 4. JSON Syntax Check in Markdown blocks
    json_blocks = re.findall(r"```json\s*(.*?)\s*```", doc_text, re.DOTALL)
    for idx, block in enumerate(json_blocks):
        try:
            json.loads(block)
        except json.JSONDecodeError as e:
            errors.append(f"Invalid JSON in markdown block #{idx + 1}: {e}")

    # 5. Check Greenfield status (no Phase 1+ product code directories)
    forbidden_dirs = ["src", "app", "backend", "android", "mobile", "server", "services"]
    for root, dirs, files in os.walk("."):
        if ".git" in root:
            continue
        for d in dirs:
            if d.lower() in forbidden_dirs:
                errors.append(f"Found non-greenfield product directory: {os.path.join(root, d)}")

    # 6. Secret scanning check
    secret_patterns = [
        (r"(?i)api[_-]?key\s*[:=]\s*['\"](?!YOUR_)[A-Za-z0-9_\-]{20,}['\"]", "Possible API Key"),
        (r"sk-[A-Za-z0-9]{32,}", "Possible OpenAI / Stripe Secret Key"),
        (r"-----BEGIN\s+PRIVATE\s+KEY-----", "Private Key header")
    ]

    for root, dirs, files in os.walk("."):
        if ".git" in root or root.startswith("./scripts") or root.startswith("/home/jules/self_created_tools"):
            continue
        for file in files:
            filepath = os.path.join(root, file)
            try:
                with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                    content = f.read()
                    for pattern, desc in secret_patterns:
                        if re.search(pattern, content):
                            errors.append(f"Secret detected ({desc}) in file: {filepath}")
            except Exception as e:
                pass

    return errors, warnings

def main():
    print("=== Running Phase 0 Verification Checks ===")
    errors, warnings = check_phase_0()

    if warnings:
        print("\n[WARNINGS]")
        for w in warnings:
            print(f" - {w}")

    if errors:
        print("\n[ERRORS FOUND]")
        for e in errors:
            print(f" - {e}")
        print("\nPhase 0 Verification: FAILED")
        sys.exit(1)
    else:
        print("\nAll Phase 0 Verification Checks PASSED successfully!")
        sys.exit(0)

if __name__ == "__main__":
    main()
