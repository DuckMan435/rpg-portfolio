import { gainExperience } from '../services/api';

export default function CharacterSheet({ character, setCharacter }) {

  function onGainExperience() {
    const fetchCharacter = async () => {
      try {
        const response = await gainExperience(character.character_id, 100);
        setCharacter(response.data); // update App.js state, triggers re-render
      } catch (error) {
        console.error("Error fetching class:", error);
      }
    };

    fetchCharacter();
  }


  return (
    <div className="flex flex-col items-center justify-center" style={{ minHeight: 'calc(100vh - 64px)' }}>
      <div className="panel flex gap-8">
        <div className="flex flex-col gap-2 w-96">
        <span className="text-yellow-400 font-bold text-xl">{character.character_name}</span>
        <span><b>Class:</b> {character.class_name}</span>
        <span><b>Level:</b> {character.level}</span>
        <span><b>Current EXP:</b> {character.current_xp}</span>
        <span><b>EXP to next level:</b> {character.next_level_xp - character.current_xp}</span>
        <button className="text-yellow-400 border border-yellow-600 px-6 py-1 hover:bg-yellow-600 hover:text-black w-full tracking-widest w-96" onClick={() => onGainExperience()}>Gain EXP</button>
          <div className="w-96">
            {character.stats && (
              <div className="border-t border-yellow-600 pt-4 mt-2">
                <span className="text-yellow-400 font-bold tracking-widest">STATS</span>
                <div className="grid grid-cols-2 gap-1 mt-2">
                  {character.stats.map((ability, index) => (
                    <span key={index} className="text-yellow-300 text-sm">
                      {ability.stat_name}: <span className="text-white">{ability.value}</span>
                    </span>
                  ))}
                </div>
              </div>
            )}
        </div>
          </div>
      </div>
      </div>
  );
}