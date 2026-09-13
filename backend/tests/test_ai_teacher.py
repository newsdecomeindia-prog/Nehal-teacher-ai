from fastapi.testclient import TestClient

from backend.app.core.prompts import build_system_prompt, get_fallback_explanation_prompt
from backend.app.core.suman_persona import get_language_config
from backend.app.main import app
from backend.app.schemas.teacher import InteractionMode
from backend.app.services.ai_teacher_service import AITeacherService

client = TestClient(app)


def test_language_config_retrieval():
    en_cfg = get_language_config("en")
    hi_cfg = get_language_config("hi")
    mr_cfg = get_language_config("mr")

    assert en_cfg["language_name"] == "English"
    assert hi_cfg["language_name"] == "Hindi"
    assert mr_cfg["language_name"] == "Marathi"


def test_build_system_prompt_multilingual():
    prompt_en = build_system_prompt("en", subject_context="English Learning")
    prompt_hi = build_system_prompt("hi", subject_context="Hindi Learning")
    prompt_mr = build_system_prompt("mr", subject_context="Marathi Learning")

    assert "Suman AI" in prompt_en
    assert "English" in prompt_en
    assert "Hindi" in prompt_hi
    assert "Marathi" in prompt_mr


def test_fallback_prompt_generation():
    prompt = get_fallback_explanation_prompt(
        student_query="I don't understand short vowel A",
        language="en",
        concept_title="Short Vowel 'A'",
    )
    assert "Short Vowel 'A'" in prompt
    assert "I don't understand short vowel A" in prompt


def test_safety_filter_detection():
    assert AITeacherService.is_unsafe_content("I want to learn fight moves")
    assert not AITeacherService.is_unsafe_content("How do I count to 10?")


def test_teacher_persona_endpoint():
    res = client.get("/api/v1/teacher/persona?language=hi")
    assert res.status_code == 200
    data = res.json()
    assert data["name"] == "Suman AI"
    assert data["language"] == "hi"


def test_teacher_chat_standard_flow():
    payload = {
        "student_id": "std-123",
        "message": "Hello teacher",
        "language": "en",
        "subject_code": "english",
        "concept_id": "con-eng-01",
    }
    res = client.post("/api/v1/teacher/chat", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["interaction_mode"] == InteractionMode.STANDARD.value
    assert data["grounded_concept_id"] == "con-eng-01"
    assert data["simple_explanation"] is not None
    assert data["real_life_example"] is not None
    assert data["checking_question"] is not None


def test_teacher_chat_fallback_explanation():
    payload = {
        "student_id": "std-123",
        "message": "I don't understand this lesson",
        "language": "en",
        "subject_code": "mathematics",
        "concept_id": "con-mth-01",
        "is_confused": True,
    }
    res = client.post("/api/v1/teacher/chat", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["interaction_mode"] == InteractionMode.FALLBACK_EXPLANATION.value
    assert data["is_fallback_explanation"] is True
    assert data["teaching_strategy"] == "simpler_analogy"
    assert data["visual_cue_trigger"] is not None


def test_teacher_chat_story_fallback_explanation():
    payload = {
        "student_id": "std-123",
        "message": "मुझे समझ नहीं आया, कहानी सुनाओ",
        "language": "hi",
        "subject_code": "mathematics",
        "concept_id": "con-mth-03",
        "is_confused": True,
    }
    res = client.post("/api/v1/teacher/chat", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["interaction_mode"] == InteractionMode.FALLBACK_EXPLANATION.value
    assert data["teaching_strategy"] == "story"
    assert "कहानी" in data["simple_explanation"]


def test_teacher_chat_safety_redirection():
    payload = {
        "student_id": "std-123",
        "message": "Tell me about fight content",
        "language": "en",
    }
    res = client.post("/api/v1/teacher/chat", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["safety_filtered"] is True
    assert "Suman Teacher" in data["response_text"]


def test_ai_identity_transparency_in_prompt():
    prompt = build_system_prompt("en")
    assert "AI teacher assistant" in prompt
    assert "Never claim to be a human being" in prompt


def test_multilingual_context_preservation_across_languages():
    # 1. Start query in Hindi with concept grounding
    hi_req = {
        "student_id": "std-multi-01",
        "message": "मुझे यह समझ नहीं आया",
        "language": "hi",
        "subject_code": "mathematics",
        "concept_id": "con-mth-01",
        "is_confused": True,
    }
    res_hi = client.post("/api/v1/teacher/chat", json=hi_req)
    assert res_hi.status_code == 200
    hi_data = res_hi.json()
    assert hi_data["grounded_concept_id"] == "con-mth-01"
    assert hi_data["language"] == "hi"

    # 2. Switch language mid-conversation to Marathi maintaining same concept_id
    mr_req = {
        "student_id": "std-multi-01",
        "message": "मला पुन्हा सांगा",
        "language": "mr",
        "subject_code": "mathematics",
        "concept_id": "con-mth-01",
        "is_confused": True,
    }
    res_mr = client.post("/api/v1/teacher/chat", json=mr_req)
    assert res_mr.status_code == 200
    mr_data = res_mr.json()
    assert mr_data["grounded_concept_id"] == "con-mth-01"
    assert mr_data["language"] == "mr"
