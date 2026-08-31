from fastapi import APIRouter, Depends
from app.database import get_db
from app.services.character_service import CharacterService
from app.models.characterClass import CharacterClass
from sqlalchemy import text


router = APIRouter()
character_service = CharacterService()

@router.get("/")
def get_classes(db=Depends(get_db)):
    # Logic to retrieve classes from the database
    classes = db.execute(text("select * from classes c")).fetchall()
    return {"message": "List of classes", "data": [dict(row._mapping) for row in classes]}

@router.get("/{class_name}")
def get_class(class_name: str, db=Depends(get_db)):
    # Logic to retrieve a specific class from the database
    class_data = db.execute(text("select * from classes c WHERE class_name ILIKE :name"), {"name": class_name}).first()    
    
    calculated_stats = character_service.calculate_stats(class_data.class_id, 1, db)

    if class_data:
        characterClass = CharacterClass(
            class_id= class_data.class_id,
            class_name= class_data.class_name,
            stats= calculated_stats
        )
        return characterClass
    else:
        return {"message": f"Class {class_name} not found", "data": None}