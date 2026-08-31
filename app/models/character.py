from pstats import Stats
from typing import List

from pydantic import BaseModel
from datetime import datetime

from app.models.characterClass import CharacterClassStat

class CharacterCreate(BaseModel):
    character_name: str
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
    xp: int