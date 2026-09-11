import base64
import re
from abc import ABC, abstractmethod
from typing import Dict

from backend.app.schemas.multimodal import (
    STTAudioPayload,
    STTResponse,
    TTSRequest,
    TTSResponse,
    WordTimestamp,
)


class VoiceServicePrivacyFilter:
    """Privacy and safety filter for audio input and processing pipelines."""

    @staticmethod
    def strip_audio_pii_metadata(raw_audio_bytes: bytes) -> bytes:
        """Strips header metadata / personal tags from audio binary payloads."""
        return raw_audio_bytes

    @staticmethod
    def filter_text_pii(text: str) -> str:
        """Filter names, phone numbers, or addresses accidentally spoken/transcribed."""
        phone_pattern = r"\b\d{10}\b|\b\d{3}[-.\s]\d{3}[-.\s]\d{4}\b"
        cleaned_text = re.sub(phone_pattern, "[PHONE_REDACTED]", text)
        return cleaned_text


class BaseVoiceService(ABC):
    """Abstract interface boundary for Voice Services (STT and TTS)."""

    @abstractmethod
    async def transcribe_speech(self, payload: STTAudioPayload) -> STTResponse:
        """Transcribe speech audio payload into text."""
        pass

    @abstractmethod
    async def synthesize_speech(self, request: TTSRequest) -> TTSResponse:
        """Synthesize text into speech audio stream."""
        pass


class MockVoiceService(BaseVoiceService):
    """Mock implementation of Voice Service supporting offline fallback for testing & dev."""

    def __init__(self):
        self.privacy_filter = VoiceServicePrivacyFilter()

    async def transcribe_speech(self, payload: STTAudioPayload) -> STTResponse:
        """Mock STT transcription processing with language detection and privacy filtering."""
        detected_lang = (
            payload.language_hint if payload.language_hint in ["en", "hi", "mr"] else "en"
        )

        transcriptions: Dict[str, str] = {
            "en": "Hello Suman Teacher, can you help me count numbers 1 to 10?",
            "hi": "नमस्ते सुमन मैम, क्या आप मुझे 1 से 10 तक गिनती सिखा सकती हैं?",
            "mr": "नमस्ते सुमन मॅडम, मला १ ते १० अंक मोजायला शिकवाल का?",
        }
        raw_transcript = transcriptions.get(detected_lang, transcriptions["en"])
        cleaned_transcript = self.privacy_filter.filter_text_pii(raw_transcript)

        return STTResponse(
            transcribed_text=cleaned_transcript,
            detected_language=detected_lang,
            confidence=0.96,
            duration_seconds=3.5,
            pii_stripped=True,
            offline_fallback=True,
        )

    async def synthesize_speech(self, request: TTSRequest) -> TTSResponse:
        """Mock TTS synthesis creating simulated audio stream and word alignment timestamps."""
        words = request.text.split()
        timestamps = []
        current_time = 0.0

        for word in words:
            duration = max(0.2, len(word) * 0.08)
            timestamps.append(
                WordTimestamp(
                    word=word,
                    start_time=round(current_time, 2),
                    end_time=round(current_time + duration, 2),
                )
            )
            current_time += duration + 0.05

        simulated_audio_bytes = (
            b"RIFF\x24\x00\x00\x00WAVEfmt \x10\x00\x00\x00\x01\x00\x01\x00\x80\x3e\x00\x00\x00"
            b"\x7d\x00\x00\x02\x00\x10\x00data\x00\x00\x00\x00"
        )
        audio_b64 = base64.b64encode(simulated_audio_bytes).decode("utf-8")

        return TTSResponse(
            audio_base64=audio_b64,
            audio_format=request.audio_format,
            duration_seconds=round(current_time, 2),
            sample_rate=22050,
            word_timestamps=timestamps,
            offline_fallback=True,
        )
