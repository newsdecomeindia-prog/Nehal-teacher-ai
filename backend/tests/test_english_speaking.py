from fastapi.testclient import TestClient

from backend.app.main import app
from backend.app.schemas.english_speaking import (
    ChildFeedbackTag,
    DifficultyTier,
)
from backend.app.services.english_speaking_service import EnglishSpeakingService

client = TestClient(app)


def test_get_prompts_endpoint():
    """Test fetching speaking practice prompts without tier filter."""
    response = client.get("/api/v1/english-speaking/prompts")
    assert response.status_code == 200
    data = response.json()
    assert "prompts" in data
    assert data["total_count"] >= 6
    assert data["tier"] is None


def test_get_prompts_filtered_by_tier():
    """Test fetching prompts filtered by difficulty level_1."""
    response = client.get("/api/v1/english-speaking/prompts?tier=level_1")
    assert response.status_code == 200
    data = response.json()
    assert data["tier"] == "level_1"
    for prompt in data["prompts"]:
        assert prompt["tier"] == "level_1"


def test_evaluate_speaking_perfect_attempt():
    """Test evaluation for a perfect speaking attempt."""
    payload = {
        "student_id": "test-student-101",
        "prompt_id": "prompt-l1-001",
        "spoken_transcript": "Good morning",
        "duration_seconds": 2.0,
    }
    response = client.post("/api/v1/english-speaking/evaluate", json=payload)
    assert response.status_code == 200
    data = response.json()

    assert data["target_sentence"] == "Good morning"
    assert data["spoken_transcript"] == "Good morning"
    assert data["accuracy"]["overall_accuracy"] >= 90.0
    assert data["feedback"]["stars_earned"] == 3
    assert data["feedback"]["feedback_tag"] == ChildFeedbackTag.STAR_PERFORMER


def test_evaluate_speaking_partial_attempt():
    """Test gentle feedback for partial/mispronounced spoken attempt."""
    payload = {
        "student_id": "test-student-102",
        "prompt_id": "prompt-l2-001",
        "spoken_transcript": "This is cat",  # missing 'a'
        "duration_seconds": 2.5,
    }
    response = client.post("/api/v1/english-speaking/evaluate", json=payload)
    assert response.status_code == 200
    data = response.json()

    assert data["accuracy"]["overall_accuracy"] < 100.0
    assert data["feedback"]["stars_earned"] in [1, 2, 3]
    assert len(data["word_details"]) > 0


def test_evaluate_speaking_empty_transcript_validation():
    """Test validation error for empty transcript."""
    payload = {
        "student_id": "test-student-103",
        "prompt_id": "prompt-l1-001",
        "spoken_transcript": "   ",
        "duration_seconds": 1.0,
    }
    response = client.post("/api/v1/english-speaking/evaluate", json=payload)
    assert response.status_code == 400


def test_english_speaking_service_unit():
    """Unit tests for EnglishSpeakingService logic directly."""
    service = EnglishSpeakingService()

    prompts_l2 = service.get_prompts(tier=DifficultyTier.LEVEL_2)
    assert len(prompts_l2) >= 2
    for p in prompts_l2:
        assert p.tier == DifficultyTier.LEVEL_2

    prompt = service.get_prompt_by_id("prompt-l1-001")
    assert prompt is not None
    assert prompt.target_sentence == "Good morning"
