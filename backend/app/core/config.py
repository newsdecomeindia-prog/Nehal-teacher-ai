import os
from typing import List, Union

from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    ENVIRONMENT: str = Field(
        default="development",
        description="App environment: development, staging, production",
    )
    SECRET_KEY: str = Field(
        default="dev_secret_key_change_in_production_123456789",
        description="App secret key",
    )
    ALLOWED_HOSTS: List[str] = Field(default_factory=lambda: ["*"])
    CORS_ORIGINS: List[str] = Field(
        default_factory=lambda: [
            "http://localhost",
            "http://localhost:3000",
            "http://localhost:8080",
        ]
    )
    RATE_LIMIT_PER_MINUTE: int = Field(default=60, description="Rate limit requests per minute")
    DPDP_COPPA_STRICT_MODE: bool = Field(
        default=True, description="Enforce strict child data privacy laws"
    )
    DEBUG: bool = Field(default=False)

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    @field_validator("SECRET_KEY")
    @classmethod
    def validate_secret_key(cls, v: str, info) -> str:
        env = os.getenv("ENVIRONMENT", "development").lower()
        if env == "production":
            if "dev" in v.lower() or "change" in v.lower() or len(v) < 16:
                raise ValueError("Insecure SECRET_KEY used in production environment.")
        return v

    @field_validator("CORS_ORIGINS", mode="before")
    @classmethod
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> List[str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, list):
            return v
        return ["http://localhost", "http://localhost:3000"]


settings = Settings()
