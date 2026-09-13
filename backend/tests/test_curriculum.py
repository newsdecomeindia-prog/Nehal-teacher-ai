from fastapi.testclient import TestClient

from backend.app.main import app
from backend.app.schemas.curriculum import SubjectCode

client = TestClient(app)


def test_get_curriculum_version():
    response = client.get("/api/v1/curriculum/class-1/version")
    assert response.status_code == 200
    data = response.json()
    assert data["version"] == "1.0.0"
    assert data["grade_level"] == 1
    assert data["cbse_compliant"] is True
    assert data["cbse_academic_year"] == "2026-27"
    assert len(data["supported_subjects"]) == 5


def test_list_class_1_subjects():
    response = client.get("/api/v1/curriculum/class-1/subjects")
    assert response.status_code == 200
    subjects = response.json()
    assert len(subjects) == 5

    subject_codes = {s["code"] for s in subjects}
    expected_codes = {
        SubjectCode.ENGLISH.value,
        SubjectCode.HINDI.value,
        SubjectCode.MARATHI.value,
        SubjectCode.MATHEMATICS.value,
        SubjectCode.EVS_GK.value,
    }
    assert subject_codes == expected_codes


def test_math_curriculum_topics_coverage():
    response = client.get("/api/v1/curriculum/class-1/subjects/mathematics")
    assert response.status_code == 200
    data = response.json()
    topic_titles = [t["title"].lower() for t in data["topics"]]
    assert len(topic_titles) == 6
    assert any("counting" in t for t in topic_titles)
    assert any("addition" in t for t in topic_titles)
    assert any("subtraction" in t for t in topic_titles)
    assert any("shapes" in t for t in topic_titles)
    assert any("pattern" in t for t in topic_titles)
    assert any("spatial" in t for t in topic_titles)


def test_english_curriculum_topics_coverage():
    response = client.get("/api/v1/curriculum/class-1/subjects/english")
    assert response.status_code == 200
    data = response.json()
    topic_titles = [t["title"].lower() for t in data["topics"]]
    assert len(topic_titles) == 4
    assert any("phonics" in t for t in topic_titles)
    assert any("sight words" in t for t in topic_titles)
    assert any("cvc" in t for t in topic_titles)
    assert any("sentence" in t for t in topic_titles)


def test_hindi_curriculum_topics_coverage():
    response = client.get("/api/v1/curriculum/class-1/subjects/hindi")
    assert response.status_code == 200
    data = response.json()
    topic_titles = [t["title"] for t in data["topics"]]
    assert len(topic_titles) == 4
    assert any("वर्णमाला" in t for t in topic_titles)
    assert any("मात्राएँ" in t for t in topic_titles)
    assert any("अमात्रिक" in t for t in topic_titles)
    assert any("वाक्य" in t for t in topic_titles)


def test_get_subject_details():
    response = client.get("/api/v1/curriculum/class-1/subjects/hindi")
    assert response.status_code == 200
    data = response.json()
    assert data["code"] == "hindi"
    assert data["title_native"] == "हिंदी शिक्षण"
    assert data["cbse_academic_year"] == "2026-27"
    assert len(data["topics"]) > 0


def test_get_subject_details_not_found():
    response = client.get("/api/v1/curriculum/class-1/subjects/invalid_subject")
    assert response.status_code == 422


def test_get_topic_details():
    response = client.get("/api/v1/curriculum/class-1/topics/top-eng-01")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == "top-eng-01"
    assert data["title"] == "Alphabet & Phonics"
    assert data["cbse_academic_year"] == "2026-27"
    assert len(data["subtopics"]) > 0


def test_get_topic_details_not_found():
    response = client.get("/api/v1/curriculum/class-1/topics/non_existent_topic")
    assert response.status_code == 404


def test_get_lesson_blueprint():
    response = client.get("/api/v1/curriculum/class-1/lessons/les-mth-01")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == "les-mth-01"
    assert data["subject_code"] == "mathematics"
    assert data["cbse_academic_year"] == "2026-27"
    assert len(data["concepts"]) > 0
    assert len(data["assessment_items"]) > 0


def test_suresh_study_guide_summary():
    response = client.get("/api/v1/curriculum/class-1/study-guide/student_class1_001")
    assert response.status_code == 200
    data = response.json()
    assert data["student_id"] == "student_class1_001"
    assert data["mentor_name"] == "Suresh Teacher"
    assert "progress" in data
    assert len(data["daily_reminders"]) > 0
    assert len(data["revision_prompts"]) > 0


def test_suresh_study_guide_progress_update():
    payload = {
        "student_id": "student_class1_001",
        "concept_id": "con-mth-02",
        "exercise_id": "ex-mth-02",
        "is_correct": True,
    }
    response = client.post("/api/v1/curriculum/class-1/study-guide/progress", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "con-mth-02" in data["progress"]["completed_concept_ids"]
    assert "ex-mth-02" in data["progress"]["completed_exercise_ids"]
