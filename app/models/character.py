from typing import List

from pydantic import BaseModel, Field
from datetime import datetime

from app.models.characterClass import CharacterClassStat

class CharacterCreate(BaseModel):
    # Mirrors the characters_name_format CHECK and varchar(30) in the DB
    character_name: str = Field(min_length=1, max_length=30, pattern=r"^[a-zA-Z0-9 ]+$")
    class_id: int

class CharacterResponse(BaseModel):
    character_id: int
    character_name: str
    level: int
    current_xp: int 
    next_level_xp: int 
    class_id: int 
    class_name: str
    created_at: datetime
    stats: List[CharacterClassStat] = []

class XPGain(BaseModel):
    xp: int = Field(gt=0)