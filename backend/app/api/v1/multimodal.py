from fastapi import APIRouter, HTTPException, status

from backend.app.schemas.multimodal import (
    ImageScanRequest,
    ImageScanResponse,
    STTAudioPayload,
    STTResponse,
    TTSRequest,
    TTSResponse,
)
from backend.app.services.image_service import MockImageService
from backend.app.services.voice_service import MockVoiceService

router = APIRouter(prefix="/multimodal", tags=["Multi-Modal Services"])

voice_service = MockVoiceService()
image_service = MockImageService()


@router.post(
    "/stt",
    response_model=STTResponse,
    status_code=status.HTTP_200_OK,
    summary="Speech-to-Text Transcribe API",
)
async def process_speech_to_text(payload: STTAudioPayload) -> STTResponse:
    """Accepts STTAudioPayload containing audio data/metadata and returns transcribed text."""
    try:
        response = await voice_service.transcribe_speech(payload)
        return response
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Speech transcription failed: {str(e)}",
        )


@router.post(
    "/tts",
    response_model=TTSResponse,
    status_code=status.HTTP_200_OK,
    summary="Text-to-Speech Synthesize API",
)
async def process_text_to_speech(request: TTSRequest) -> TTSResponse:
    """Accepts TTSRequest text and child voice parameters, returning base64 audio and timestamps."""
    try:
        response = await voice_service.synthesize_speech(request)
        return response
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Speech synthesis failed: {str(e)}",
        )


@router.post(
    "/image-scan",
    response_model=ImageScanResponse,
    status_code=status.HTTP_200_OK,
    summary="Homework Photo Scan API",
)
async def process_image_scan(request: ImageScanRequest) -> ImageScanResponse:
    """Accepts ImageScanRequest homework photo payload, returning safety assessment and OCR text."""
    try:
        response = await image_service.scan_homework_photo(request)
        return response
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Homework image scan failed: {str(e)}",
        )
