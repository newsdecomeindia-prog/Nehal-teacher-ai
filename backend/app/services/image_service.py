import uuid
from abc import ABC, abstractmethod
from typing import List, Tuple

from backend.app.schemas.multimodal import (
    BoundingBox,
    ChildSafetyScanStatus,
    ImageScanRequest,
    ImageScanResponse,
    OCRTextRegion,
)


class ImagePrivacyFilter:
    """Privacy and child-safety inspection filter for worksheet/homework photos."""

    NON_EDUCATIONAL_KEYWORDS = [
        "weapon",
        "violence",
        "gambling",
        "explicit",
        "advertisement",
        "social_media",
    ]

    @staticmethod
    def inspect_and_filter_image(
        request: ImageScanRequest,
    ) -> Tuple[bool, ChildSafetyScanStatus, List[str]]:
        """Scans image parameters/hints to ensure image is appropriate and educational."""
        subject_hint = (request.subject_hint or "").lower()
        url = (request.image_url or "").lower()

        for keyword in ImagePrivacyFilter.NON_EDUCATIONAL_KEYWORDS:
            if keyword in subject_hint or keyword in url:
                return (
                    False,
                    ChildSafetyScanStatus.FLAGGED_NON_EDUCATIONAL,
                    ["non_educational_content", f"flagged_keyword_{keyword}"],
                )

        return True, ChildSafetyScanStatus.SAFE, ["educational_homework", "verified_safe"]

    @staticmethod
    def redact_pii_from_ocr(ocr_text: str) -> Tuple[str, bool]:
        """Redacts sensitive PII headers from OCR text."""
        lines = ocr_text.split("\n")
        cleaned_lines = []
        pii_found = False

        pii_keywords = ["student name:", "roll no:", "address:", "phone:"]
        for line in lines:
            line_lower = line.lower()
            if any(kw in line_lower for kw in pii_keywords):
                cleaned_lines.append("[REDACTED_PII_HEADER]")
                pii_found = True
            else:
                cleaned_lines.append(line)

        return "\n".join(cleaned_lines), pii_found


class BaseImageService(ABC):
    """Abstract interface boundary for Image & Vision Processing Service."""

    @abstractmethod
    async def scan_homework_photo(self, request: ImageScanRequest) -> ImageScanResponse:
        """Analyze homework photo, perform OCR, and assess child safety/educational context."""
        pass


class MockImageService(BaseImageService):
    """Mock implementation of Image Service supporting offline fallback and vision response."""

    def __init__(self):
        self.privacy_filter = ImagePrivacyFilter()

    async def scan_homework_photo(self, request: ImageScanRequest) -> ImageScanResponse:
        """Processes homework image scan request with privacy filtering and mock OCR."""
        is_safe, safety_status, safety_tags = self.privacy_filter.inspect_and_filter_image(request)

        if not is_safe:
            return ImageScanResponse(
                scan_id=f"scan-{uuid.uuid4().hex[:8]}",
                is_educational=False,
                safety_status=safety_status,
                detected_text="",
                text_regions=[],
                homework_type="rejected_image",
                child_safety_tags=safety_tags,
                pii_redacted=True,
                offline_fallback=True,
            )

        subject = (request.subject_hint or "math").lower()

        if "math" in subject:
            ocr_raw = (
                "Student Name: Nehal Kumar\n1) 5 + 3 = ?\n2) 10 - 4 = ?\n3) Count the apples: 7"
            )
            homework_type = "math_worksheet"
            regions = [
                OCRTextRegion(
                    text="Student Name: Nehal Kumar",
                    confidence=0.98,
                    bounding_box=BoundingBox(x_min=0.05, y_min=0.05, x_max=0.85, y_max=0.12),
                    line_number=1,
                ),
                OCRTextRegion(
                    text="1) 5 + 3 = ?",
                    confidence=0.99,
                    bounding_box=BoundingBox(x_min=0.1, y_min=0.2, x_max=0.6, y_max=0.3),
                    line_number=2,
                ),
                OCRTextRegion(
                    text="2) 10 - 4 = ?",
                    confidence=0.97,
                    bounding_box=BoundingBox(x_min=0.1, y_min=0.35, x_max=0.6, y_max=0.45),
                    line_number=3,
                ),
            ]
        elif "english" in subject:
            ocr_raw = "Fill in the blanks with vowels:\nC _ T -> ?\nD _ G -> ?"
            homework_type = "english_worksheet"
            regions = [
                OCRTextRegion(
                    text="Fill in the blanks with vowels:",
                    confidence=0.95,
                    bounding_box=BoundingBox(x_min=0.05, y_min=0.05, x_max=0.9, y_max=0.15),
                    line_number=1,
                ),
                OCRTextRegion(
                    text="C _ T -> ?",
                    confidence=0.96,
                    bounding_box=BoundingBox(x_min=0.1, y_min=0.2, x_max=0.7, y_max=0.32),
                    line_number=2,
                ),
            ]
        else:
            ocr_raw = "Worksheet Exercise\nQuestion 1: Draw a circle around the correct number."
            homework_type = "general_worksheet"
            regions = [
                OCRTextRegion(
                    text="Worksheet Exercise",
                    confidence=0.94,
                    bounding_box=BoundingBox(x_min=0.05, y_min=0.05, x_max=0.8, y_max=0.15),
                    line_number=1,
                )
            ]

        cleaned_text, pii_detected = self.privacy_filter.redact_pii_from_ocr(ocr_raw)

        return ImageScanResponse(
            scan_id=f"scan-{uuid.uuid4().hex[:8]}",
            is_educational=True,
            safety_status=ChildSafetyScanStatus.SAFE,
            detected_text=cleaned_text,
            text_regions=regions,
            homework_type=homework_type,
            child_safety_tags=safety_tags,
            pii_redacted=True,
            offline_fallback=True,
        )
