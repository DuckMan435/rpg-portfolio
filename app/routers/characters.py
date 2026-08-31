from fastapi import APIRouter, Depends
from app.database import get_db
from app.services.character_service import CharacterService
from app.models.character import CharacterCreate, CharacterResponse, XPGain
from sqlalchemy import text

router = APIRouter()
character_service = CharacterService()

@router.get("/")
def get_characters(db=Depends(get_db)):
    # Logic to retrieve a specific character from the database
    character_data = db.execute(text("""
                                        SELECT c.*, cl.class_name 
                                        FROM public.characters c
                                        JOIN public.classes cl ON c.class_id = cl.class_id
                                    """)).all()
    if character_data:
        
        # Pull xp_multiplier from the database
        xp_multiplier = int(db.execute(text("SELECT setting_value FROM public.settings where setting_name = 'xp_multiplier' LIMIT 1")).scalar())

        list_of_characters = []
        for character in character_data:
            calculated_stats = character_service.calculate_stats(character.class_id, character.level, db)

            list_of_characters.append(CharacterResponse(
                character_id=character.character_id,
                character_name=character.character_name,
                level=character.level,
                current_xp=character.current_xp,
                next_level_xp=character_service.calculate_xp_to_next_level(character.level, character.current_xp, xp_multiplier),
                class_id=character.class_id,
                class_name=character.class_name,
                created_at=character.created_at,
                stats=calculated_stats
            ))
        return {"message": f"All characters retrieved", "data": list_of_characters}
    else:
        return {"message": f"No characters found", "data": None}

@router.get("/{id}")
def get_character(id: int, db=Depends(get_db)):
    # Logic to retrieve a specific character from the database
    character_data = db.execute(text("""
                                        SELECT c.*, cl.class_name 
                                        FROM public.characters c
                                        JOIN public.classes cl ON c.class_id = cl.class_id
                                        WHERE c.character_id = :id
                                    """), {"id": id}).first()
    if character_data:

        calculated_stats = character_service.calculate_stats(character_data.class_id, character_data.level, db)
        
        # Pull xp_multiplier from the database
        xp_multiplier = int(db.execute(text("SELECT setting_value FROM public.settings where setting_name = 'xp_multiplier' LIMIT 1")).scalar())

        character = CharacterResponse(
                character_id=character_data.character_id,
                character_name=character_data.character_name,
                level=character_data.level,
                current_xp=character_data.current_xp,
                next_level_xp=character_service.calculate_xp_to_next_level(character_data.level, character_data.current_xp, xp_multiplier),
                class_id=character_data.class_id,
                class_name=character_data.class_name,
                created_at=character_data.created_at,
                stats=calculated_stats
            )
        return {"message": f"Details of character {character_data.character_name}", "data": character}
    else:
        return {"message": f"Character with ID {id} not found", "data": None}

@router.post("/")
def create_character(character: CharacterCreate, db=Depends(get_db)):
    # Logic to create a new character in the database
    db.execute(text("INSERT INTO public.characters (character_name, class_id) VALUES (:name, :class_id)"),
               {"name": character.character_name, "class_id": character.class_id})
    db.commit()

    # Retrieve the newly created character to return in the response
    character_data = db.execute(text("""
                                        SELECT c.*, cl.class_name 
                                        FROM public.characters c
                                        JOIN public.classes cl ON c.class_id = cl.class_id
                                        WHERE c.character_name = :name AND c.class_id = :class_id 
                                        ORDER BY c.created_at DESC 
                                        LIMIT 1
                                     """),
                                {"name": character.character_name, "class_id": character.class_id}).first()

        
    # Pull xp_multiplier from the database
    xp_multiplier = int(db.execute(text("SELECT setting_value FROM public.settings where setting_name = 'xp_multiplier' LIMIT 1")).scalar())
    
    calculated_stats = character_service.calculate_stats(character_data.class_id, character_data.level, db)

    character = CharacterResponse(
        character_id=character_data.character_id,
        character_name=character_data.character_name,
        level=character_data.level,
        current_xp=character_data.current_xp,
        next_level_xp=character_service.calculate_xp_to_next_level(character_data.level, character_data.current_xp, xp_multiplier),
        class_id=character_data.class_id,
        class_name=character_data.class_name,
        created_at=character_data.created_at,
        stats=calculated_stats
    )
    
    return {"message": f"Character {character.character_name} created successfully", "data": character}

@router.post("/{id}/gain-xp")
def gain_xp(id: int, xp: XPGain, db=Depends(get_db)):
    # Logic to gain XP for a specific character
    result = character_service.gain_xp(id, xp, db)
    return result