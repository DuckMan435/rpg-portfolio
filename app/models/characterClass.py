from typing import List
from pydantic import BaseModel
from datetime import datetime

class CharacterClassStat(BaseModel):
    stat_name: str
    value: int

class CharacterClass(BaseModel):
    class_id: int
    class_name: str
    stats: List[CharacterClassStat] = []