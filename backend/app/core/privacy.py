import re
from typing import Any, Dict, List


def sanitize_pii(data: str) -> str:
    """
    Sanitizes personally identifiable information (PII) such as email addresses,
    phone numbers, and Aadhar/national ID patterns from text strings to comply with DPDP and COPPA.
    """
    if not isinstance(data, str):
        return data

    # Redact Emails
    email_pattern = r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+"
    sanitized = re.sub(email_pattern, "[REDACTED_EMAIL]", data)

    # Redact Indian Phone Numbers (10 digits, optional +91 prefix)
    phone_pattern = r"(\+91[\-\s]?)?[6-9]\d{9}"
    sanitized = re.sub(phone_pattern, "[REDACTED_PHONE]", sanitized)

    # Redact Aadhar / 12-digit ID numbers
    aadhar_pattern = r"\b\d{4}[\s\-]?\d{4}[\s\-]?\d{4}\b"
    sanitized = re.sub(aadhar_pattern, "[REDACTED_ID]", sanitized)

    return sanitized


def sanitize_dict_pii(
    payload: Dict[str, Any], sensitive_keys: List[str] = None
) -> Dict[str, Any]:
    """
    Recursively scans and sanitizes sensitive fields in a dictionary or payload.
    """
    if sensitive_keys is None:
        sensitive_keys = [
            "phone",
            "email",
            "parent_email",
            "parent_phone",
            "aadhar",
            "address",
        ]

    cleaned = {}
    for key, value in payload.items():
        if key.lower() in sensitive_keys and isinstance(value, str):
            cleaned[key] = "[REDACTED_PII]"
        elif isinstance(value, dict):
            cleaned[key] = sanitize_dict_pii(value, sensitive_keys)
        elif isinstance(value, str):
            cleaned[key] = sanitize_pii(value)
        else:
            cleaned[key] = value
    return cleaned


def verify_dpdp_coppa_compliance(
    parent_consent_given: bool, child_age: int
) -> Dict[str, Any]:
    """
    Verifies compliance with DPDP and COPPA.
    Child data processing under 18 (DPDP) or under 13 (COPPA) requires parent consent.
    """
    requires_consent = child_age < 18
    is_compliant = parent_consent_given if requires_consent else True

    return {
        "requires_parental_consent": requires_consent,
        "consent_verified": parent_consent_given,
        "is_compliant": is_compliant,
        "status": "APPROVED" if is_compliant else "REJECTED_CONSENT_REQUIRED",
    }
