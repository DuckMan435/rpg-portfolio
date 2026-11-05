from typing import Generic, TypeVar

from pydantic import BaseModel

T = TypeVar("T")

class Envelope(BaseModel, Generic[T]):
    # Standard {"message", "data"} response wrapper, typed so it shows up in /openapi.json
    message: str
    data: T

class ErrorDetail(BaseModel):
    # Shape of HTTPException bodies. FastAPI's own request-validation 422s use a list instead.
    detail: str
