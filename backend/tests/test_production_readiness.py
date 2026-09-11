import pytest
from fastapi.testclient import TestClient

from backend.app.core.config import Settings
from backend.app.core.privacy import (
    sanitize_dict_pii,
    sanitize_pii,
    verify_dpdp_coppa_compliance,
)
from backend.app.main import app

client = TestClient(app)


def test_production_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["version"] == "1.0.0"
    assert data["security_hardening"] == "enabled"


def test_security_response_headers():
    response = client.get("/health")
    headers = response.headers
    assert headers.get("X-Content-Type-Options") == "nosniff"
    assert headers.get("X-Frame-Options") == "DENY"
    assert headers.get("X-XSS-Protection") == "1; mode=block"
    assert "max-age=31536000" in headers.get("Strict-Transport-Security", "")
    assert headers.get("Content-Security-Policy") == "default-src 'self'"


def test_cors_headers():
    response = client.options(
        "/health",
        headers={
            "Origin": "http://localhost:3000",
            "Access-Control-Request-Method": "GET",
        },
    )
    assert response.status_code in [200, 204]
    assert response.headers.get("access-control-allow-origin") == "http://localhost:3000"


def test_pii_sanitization():
    raw_text = (
        "Contact student parent at test@example.com or phone +91 9876543210 "
        "with Aadhar 1234 5678 9012"
    )
    sanitized = sanitize_pii(raw_text)
    assert "test@example.com" not in sanitized
    assert "[REDACTED_EMAIL]" in sanitized
    assert "9876543210" not in sanitized
    assert "[REDACTED_PHONE]" in sanitized
    assert "1234 5678 9012" not in sanitized
    assert "[REDACTED_ID]" in sanitized

    payload = {
        "student_id": "std_101",
        "parent_email": "parent@domain.org",
        "parent_phone": "+91 9876543210",
        "nested": {"notes": "Send copy to admin@school.edu"},
    }
    sanitized_dict = sanitize_dict_pii(payload)
    assert sanitized_dict["parent_email"] == "[REDACTED_PII]"
    assert sanitized_dict["parent_phone"] == "[REDACTED_PII]"
    assert "[REDACTED_EMAIL]" in sanitized_dict["nested"]["notes"]


def test_dpdp_coppa_compliance_verification():
    res_underage = verify_dpdp_coppa_compliance(parent_consent_given=False, child_age=7)
    assert res_underage["is_compliant"] is False
    assert res_underage["status"] == "REJECTED_CONSENT_REQUIRED"

    res_with_consent = verify_dpdp_coppa_compliance(parent_consent_given=True, child_age=7)
    assert res_with_consent["is_compliant"] is True
    assert res_with_consent["status"] == "APPROVED"


def test_env_production_secret_key_validation(monkeypatch):
    monkeypatch.setenv("ENVIRONMENT", "production")
    with pytest.raises(ValueError, match="Insecure SECRET_KEY used in production environment"):
        Settings(
            ENVIRONMENT="production",
            SECRET_KEY="dev_secret_key_change_me",
        )
