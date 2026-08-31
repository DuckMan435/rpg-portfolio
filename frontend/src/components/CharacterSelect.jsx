import { useState, useEffect } from "react";
import { getCharacters } from "../services/api";

export default function CharacterSelect({ onCharacterSelected, setMode }) {
  const [characters, setCharacters] = useState([]);
  const [selectedCharacter, setSelectedCharacter] = useState(null);
  const [pendingCharacter, setPendingCharacter] = useState(null);

  useEffect(() => {
    const fetchCharacters = async () => {
      try {
        const response = await getCharacters();
        setCharacters(response.data);
      } catch (error) {
        console.error("Error fetching characters:", error);
      }
    };

    fetchCharacters();
  }, []);

  function handleCharacterClick(char) {
    setPendingCharacter(char);
  }

  function handleConfirm() {
    setSelectedCharacter(pendingCharacter);
    onCharacterSelected(pendingCharacter);
    setMode("sheet");
  }

  function handleBack() {
    setPendingCharacter(null);
  }

  return (
    <div className="flex flex-col items-center justify-center" style={{ minHeight: 'calc(100vh - 64px)' }}>
      <div className="panel flex gap-8">
        <div className="flex flex-col col-2 gap-2">
          <span className="text-yellow-400 font-bold text-xl">
            Choose a Character
          </span>
          <p>Select a character to load.</p>
          {/* Render character selection options here */}
          <ul>
            {characters.map((char) => (
              <li
                key={char.character_id}
                onClick={() => handleCharacterClick(char)}
                className={`px-6 py-3 w-full tracking-widest cursor-pointer
                        ${
                          char.character_id === selectedCharacter?.character_id
                            ? "bg-yellow-600 text-black font-bold border border-yellow-400"
                            : "btn-primary "
                        }`}
                style={{
                  fontWeight:
                    char.character_id === selectedCharacter?.character_id
                      ? "bold"
                      : "normal",
                }}
              >
                {char.character_name}
              </li>
            ))}
          </ul>
          {pendingCharacter && (  
            <div className="flex flex-col gap-2 w-48">
              <h2>Play as {pendingCharacter.character_name}?</h2>
              <p>Class: {pendingCharacter.class_name}</p>
              <p>Level: {pendingCharacter.level}</p>
            </div>
          )}
          {pendingCharacter && (  
            <div className="flex flex-col gap-2 w-48">
              <button
                className="text-yellow-400 border border-yellow-600 px-6 py-2 hover:bg-yellow-600 hover:text-black tracking-widest"
                onClick={handleConfirm}
              >
                Confirm
              </button>
              <button
                className="text-yellow-400 border border-yellow-600 px-6 py-2 hover:bg-yellow-600 hover:text-black tracking-widest"
                onClick={handleBack}
              >
                Back
              </button>
        </div>
          )}
        </div>
      </div>
    </div>
  );
}
