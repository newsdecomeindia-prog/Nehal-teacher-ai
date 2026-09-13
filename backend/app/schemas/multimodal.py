from enum import Enum
from typing import List, Optional

from pydantic import BaseModel, Field


class AudioFormat(str, Enum):
    WAV = "wav"
    MP3 = "mp3"
    AAC = "aac"
    OGG = "ogg"
    FLAC = "flac"


class ImageMimeType(str, Enum):
    JPEG = "image/jpeg"
    PNG = "image/png"
    WEBP = "image/webp"


class ChildSafetyScanStatus(str, Enum):
    SAFE = "safe"
    FLAGGED_NON_EDUCATIONAL = "flagged_non_educational"
    FLAGGED_PII_DETECTED = "flagged_pii_detected"
    REJECTED = "rejected"


class TTSVoicePersona(str, Enum):
    SUMAN_WARM = "suman_warm"
    SURESH_PLAYFUL = "suresh_playful"


class ChildVoiceParameters(BaseModel):
    pitch_frequency_hz: Optional[float] = Field(
        default=250.0,
        description="Average fundamental frequency (Hz) typical for child voices (200-350 Hz)",
    )
    speed_rate: float = Field(
        default=0.85,
        description="Speaking rate multiplier adjusted for primary children (0.7 - 1.2)",
    )
    age_group: str = Field(
        default="6-7",
        description="Target age group bracket (e.g. '5-6', '6-7')",
    )


class STTAudioPayload(BaseModel):
    student_id: str = Field(..., description="Unique student/user identifier")
    audio_base64: Optional[str] = Field(None, description="Base64 encoded audio binary data")
    audio_url: Optional[str] = Field(None, description="URL pointing to audio file")
    audio_format: AudioFormat = Field(default=AudioFormat.WAV, description="Audio container format")
    sample_rate: int = Field(default=16000, description="Sampling rate in Hz")
    language_hint: str = Field(default="en", description="Language hint ('en', 'hi', 'mr')")
    child_voice_params: Optional[ChildVoiceParameters] = Field(
        default_factory=ChildVoiceParameters,
        description="Child voice acoustic characteristics",
    )


class STTResponse(BaseModel):
    transcribed_text: str = Field(..., description="Speech-to-Text transcribed output text")
    detected_language: str = Field(..., description="Detected spoken language ('en', 'hi', 'mr')")
    confidence: float = Field(..., ge=0.0, le=1.0, description="Transcription confidence score")
    duration_seconds: float = Field(..., ge=0.0, description="Audio clip duration in seconds")
    pii_stripped: bool = Field(default=True, description="Indicates if PII/metadata was stripped")
    offline_fallback: bool = Field(
        default=False,
        description="True if transcription used local offline model fallback",
    )


class ChildTTSParameters(BaseModel):
    pitch: float = Field(
        default=1.0, description="Pitch modifier (0.8 - 1.2), calibrated for clarity"
    )
    speed: float = Field(
        default=0.85,
        description="Speaking speed (0.7 - 1.0) for primary school comprehension",
    )
    volume: float = Field(default=1.0, ge=0.0, le=1.0, description="Audio volume level")


class TTSRequest(BaseModel):
    student_id: str = Field(..., description="Unique student/user identifier")
    text: str = Field(
        ...,
        min_length=1,
        max_length=2000,
        description="Text string to synthesize into speech",
    )
    language: str = Field(default="en", description="Target language ('en', 'hi', 'mr')")
    voice_persona: TTSVoicePersona = Field(
        default=TTSVoicePersona.SUMAN_WARM, description="Voice persona profile"
    )
    voice_params: ChildTTSParameters = Field(
        default_factory=ChildTTSParameters,
        description="Audio speed/pitch parameters for child audience",
    )
    audio_format: AudioFormat = Field(
        default=AudioFormat.MP3, description="Requested output audio format"
    )


class WordTimestamp(BaseModel):
    word: str = Field(..., description="Individual spoken word")
    start_time: float = Field(..., description="Start offset in seconds")
    end_time: float = Field(..., description="End offset in seconds")


class TTSResponse(BaseModel):
    audio_base64: str = Field(..., description="Base64 encoded audio stream/payload")
    audio_format: AudioFormat = Field(..., description="Audio format of synthesized clip")
    duration_seconds: float = Field(
        ..., ge=0.0, description="Synthesized audio duration in seconds"
    )
    sample_rate: int = Field(default=22050, description="Audio sample rate in Hz")
    word_timestamps: List[WordTimestamp] = Field(
        default_factory=list,
        description="Word level alignment timestamps for synchronized highlighting",
    )
    offline_fallback: bool = Field(
        default=False, description="True if synthesis used local offline TTS engine"
    )


class BoundingBox(BaseModel):
    x_min: float = Field(
        ..., ge=0.0, le=1.0, description="Normalized minimum X coordinate (0.0 to 1.0)"
    )
    y_min: float = Field(
        ..., ge=0.0, le=1.0, description="Normalized minimum Y coordinate (0.0 to 1.0)"
    )
    x_max: float = Field(
        ..., ge=0.0, le=1.0, description="Normalized maximum X coordinate (0.0 to 1.0)"
    )
    y_max: float = Field(
        ..., ge=0.0, le=1.0, description="Normalized maximum Y coordinate (0.0 to 1.0)"
    )


class OCRTextRegion(BaseModel):
    text: str = Field(..., description="Extracted text from image region")
    confidence: float = Field(..., ge=0.0, le=1.0, description="OCR confidence score")
    bounding_box: BoundingBox = Field(..., description="Normalized bounding box coordinates")
    line_number: int = Field(..., ge=1, description="Line sequence number in worksheet")


class ImageResolution(BaseModel):
    width: int = Field(..., ge=1, le=4096, description="Image width in pixels")
    height: int = Field(..., ge=1, le=4096, description="Image height in pixels")


class ImageScanRequest(BaseModel):
    student_id: str = Field(..., description="Unique student/user identifier")
    image_base64: Optional[str] = Field(None, description="Base64 encoded image content")
    image_url: Optional[str] = Field(None, description="URL to worksheet image")
    mime_type: ImageMimeType = Field(default=ImageMimeType.JPEG, description="Image MIME type")
    resolution: Optional[ImageResolution] = Field(None, description="Image resolution dimensions")
    subject_hint: Optional[str] = Field(
        None, description="Optional subject context ('math', 'english', 'hindi', etc.)"
    )


class ImageScanResponse(BaseModel):
    scan_id: str = Field(..., description="Unique identifier for scan transaction")
    is_educational: bool = Field(
        ..., description="True if photo is validated as educational homework/worksheet"
    )
    safety_status: ChildSafetyScanStatus = Field(
        ..., description="Child safety scan assessment result"
    )
    detected_text: str = Field(..., description="Full combined OCR text extracted from worksheet")
    text_regions: List[OCRTextRegion] = Field(
        default_factory=list,
        description="Structured text blocks with bounding box positions",
    )
    homework_type: str = Field(
        default="worksheet",
        description="Identified type ('math_worksheet', 'handwriting_practice', etc.)",
    )
    child_safety_tags: List[str] = Field(
        default_factory=list, description="Safety tags assigned during safety inspection"
    )
    pii_redacted: bool = Field(
        default=True, description="True if EXIF/personal identifying metadata was stripped"
    )
    offline_fallback: bool = Field(
        default=False, description="True if offline mock/local vision model was utilized"
    )
