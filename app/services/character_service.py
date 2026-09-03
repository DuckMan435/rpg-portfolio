from sqlalchemy import text
from app.models.character import CharacterResponse, CharacterClassStat, XPGain

class CharacterService:
    def gain_xp(self, id: int, xp: XPGain, db):
        # Logic to gain XP for a specific character
        character_data = db.execute(text("""
                                            SELECT c.*, cl.class_name 
                                            FROM public.characters c
                                            JOIN public.classes cl ON c.class_id = cl.class_id
                                            WHERE c.character_id = :id
                                         """), {"id": id}).first()
        if not character_data:
            return {"message": f"Character with ID {id} not found", "data": None}

        # Add the gained XP to the character's current XP
        new_xp = character_data.current_xp + xp.xp
        
        # Pull xp_multiplier from the database
        xp_multiplier = int(db.execute(text("SELECT setting_value FROM public.settings where setting_name = 'xp_multiplier' LIMIT 1")).scalar())

        # Check if the new XP total crosses a level threshold — this is where the cubic formula lives
        new_level = self.calculate_level(new_xp, xp_multiplier)

        # Update the character in the DB with new current_xp and level
        db.execute(text("UPDATE public.characters SET current_xp = :new_xp, level = :new_level WHERE character_id = :id"),
                   {"new_xp": new_xp, "new_level": new_level, "id": id})
        db.commit()

        calculated_stats = self.calculate_stats(character_data.class_id, character_data.level, db)
        next_level_xp = self.calculate_xp_to_next_level(new_level, new_xp, xp_multiplier)

        character = CharacterResponse(
                character_id=character_data.character_id,
                character_name=character_data.character_name,
                level=new_level,
                current_xp=new_xp,
                next_level_xp=next_level_xp,
                class_id=character_data.class_id,
                class_name=character_data.class_name,
                created_at=character_data.created_at,
                stats=calculated_stats
            )
        return {"message": f"Details of character {character_data.character_name}", "data": character}

        # # Return a result object with XP gained, new total, new level, and XP to next level
        # return {
        #     "message": f"Character {character_data.character_name} gained {xp.xp} XP",
        #     "data": {
        #         "character_id": character_data.character_id,
        #         "new_xp": new_xp,
        #         "new_level": new_level,
        #         "xp_to_next_level": self.calculate_xp_to_next_level(new_level, new_xp, xp_multiplier)
        #     }
        # }

    def calculate_level(self, current_xp: int, xp_multiplier: float) -> int:
        # Implement the cubic formula to calculate level based on current XP based off Final Fantasy's leveling system
        level = 1
        while True:
            xp_for_next_level = int((level ** 3) * xp_multiplier)
            if current_xp < xp_for_next_level:
                break
            level += 1
        
        return level

    def calculate_xp_to_next_level(self, current_level: int, current_xp: int,  xp_multiplier: float) -> int:
        # Calculate the XP required for the next level based on the cubic formula
        next_level_xp = int(((current_level + 1) ** 3) * xp_multiplier)
        return max(0, next_level_xp - current_xp)

    def calculate_stats(self, class_id: int, level: int, db):
        # Logic to calculate stats based on class and level
        class_stats = db.execute(text("""
                                      select * from classes c
                                      join class_basestats cb on c.class_id = cb.class_id
                                      join stat_types st on cb.stat_id = st.stat_id
                                      join class_level_gains clg on c.class_id = clg.class_id and cb.stat_id = clg.stat_id
                                      where c.class_id = :class_id
                                      """), {"class_id": class_id}).fetchall()
        
        calculated_stats = []
        for stat in class_stats:
            # Assuming stat_value is the base value and we scale it by level
            scaled_value = stat.value + (level - 1) * stat.gain_value  # Example scaling formula
            calculated_stats.append({
                "stat_name": stat.stat_type,
                "value": scaled_value
            })
        
        return calculated_stats