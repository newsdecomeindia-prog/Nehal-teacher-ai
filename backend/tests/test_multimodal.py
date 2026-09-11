from fastapi.testclient import TestClient

from backend.app.main import app
from backend.app.schemas.multimodal import ChildSafetyScanStatus

client = TestClient(app)


def test_stt_endpoint_basic():
    """Test STT endpoint with English language hint."""
    payload = {
        "student_id": "test-std-01",
        "audio_base64": "UklGRiQAAABXQVZFZm10IBAAAAABAAEA...",
        "audio_format": "wav",
        "sample_rate": 16000,
        "language_hint": "en",
        "child_voice_params": {
            "pitch_frequency_hz": 260.0,
            "speed_rate": 0.85,
            "age_group": "6-7",
        },
    }
    response = client.post("/api/v1/multimodal/stt", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "transcribed_text" in data
    assert data["detected_language"] == "en"
    assert data["confidence"] > 0.9
    assert data["pii_stripped"] is True
    assert data["offline_fallback"] is True


def test_stt_endpoint_multilingual():
    """Test STT endpoint with Hindi and Marathi language hints."""
    for lang in ["hi", "mr"]:
        payload = {
            "student_id": "test-std-01",
            "audio_format": "wav",
            "language_hint": lang,
        }
        response = client.post("/api/v1/multimodal/stt", json=payload)
        assert response.status_code == 200
        data = response.json()
        assert data["detected_language"] == lang
        assert len(data["transcribed_text"]) > 0


def test_tts_endpoint_basic():
    """Test TTS synthesis endpoint returning audio b64 and word timestamps."""
    payload = {
        "student_id": "test-std-01",
        "text": "Count numbers 1 to 5",
        "language": "en",
        "voice_persona": "suman_warm",
        "voice_params": {
            "pitch": 1.0,
            "speed": 0.85,
            "volume": 1.0,
        },
        "audio_format": "mp3",
    }
    response = client.post("/api/v1/multimodal/tts", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "audio_base64" in data
    assert len(data["audio_base64"]) > 0
    assert data["audio_format"] == "mp3"
    assert len(data["word_timestamps"]) == 5
    assert data["word_timestamps"][0]["word"] == "Count"
    assert data["offline_fallback"] is True


def test_image_scan_educational_math():
    """Test homework photo scanning for educational math worksheet."""
    dummy_b64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="  # noqa: E501
    payload = {
        "student_id": "test-std-01",
        "image_base64": dummy_b64,
        "mime_type": "image/jpeg",
        "subject_hint": "math",
    }
    response = client.post("/api/v1/multimodal/image-scan", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["is_educational"] is True
    assert data["safety_status"] == ChildSafetyScanStatus.SAFE.value
    assert data["homework_type"] == "math_worksheet"
    assert "5 + 3 = 8" in data["detected_text"]
    assert len(data["text_regions"]) > 0
    assert data["pii_redacted"] is True


def test_image_scan_non_educational_flag():
    """Test homework photo scan privacy filter rejecting non-educational content."""
    payload = {
        "student_id": "test-std-01",
        "subject_hint": "advertisement weapon photo",
    }
    response = client.post("/api/v1/multimodal/image-scan", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["is_educational"] is False
    assert data["safety_status"] == ChildSafetyScanStatus.FLAGGED_NON_EDUCATIONAL.value
    assert data["homework_type"] == "rejected_image"
