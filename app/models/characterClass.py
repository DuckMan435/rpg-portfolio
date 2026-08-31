from typing import List
from pydantic import BaseModel
from datetime import datetime

class CharacterClass(BaseModel):
    class_id: int
    class_name: str
    stats: List[CharacterClassStat] = []

class CharacterClassStat(BaseModel):
    stat_name: str
    value: int