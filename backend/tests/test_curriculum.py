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


def test_get_subject_details():
    response = client.get("/api/v1/curriculum/class-1/subjects/hindi")
    assert response.status_code == 200
    data = response.json()
    assert data["code"] == "hindi"
    assert data["title_native"] == "हिंदी शिक्षण"
    assert len(data["topics"]) > 0


def test_get_subject_details_not_found():
    response = client.get("/api/v1/curriculum/class-1/subjects/invalid_subject")
    assert response.status_code == 422  # Unprocessable Entity due to SubjectCode enum validation


def test_get_topic_details():
    response = client.get("/api/v1/curriculum/class-1/topics/top-eng-01")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == "top-eng-01"
    assert data["title"] == "Alphabet & Phonics"
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
    assert len(data["concepts"]) > 0
    assert len(data["assessment_items"]) > 0


def test_get_lesson_blueprint_not_found():
    response = client.get("/api/v1/curriculum/class-1/lessons/non_existent_lesson")
    assert response.status_code == 404
