import { useState } from 'react';

export default function StepNameSelect({
  selectedClass,
  characterName,
  setCharacterName,
  stepValid,
  setStepValid,
}) {
  const [nameError, setNameError] = useState("");

  function handleSetCharacterName(name) {
    setCharacterName(name);
    let isValid =
      name.trim().length > 0 &&
      name.trim().length <= 30 &&
      RegExp(/^[a-zA-Z0-9 ]+$/).test(name.trim());
    if (!isValid) {
      setNameError(
        "Name must be 1-30 characters, letters, numbers, and spaces only.",
      );
    } else {
      setNameError("");
    }
    setStepValid(isValid);
  }

  function generateRandomName() {
    const adjectives = ["Brave", "Cunning", "Wise", "Fierce", "Noble"];
    const nouns = ["Warrior", "Mage", "Rogue", "Paladin", "Hunter"];

    const randomAdjective =
      adjectives[Math.floor(Math.random() * adjectives.length)];
    const randomNoun = nouns[Math.floor(Math.random() * nouns.length)];

    return `${randomAdjective} ${randomNoun}`;
  }

  return (
    <div>
      <div className="panel flex gap-8 w-96">
        <div className="flex flex-col gap-2 w-96">
          <h2>Selected Class: {selectedClass?.class_name}</h2>
          <span className="text-yellow-400 font-bold text-xl">
            Step 2: Name Your Character
          </span>
          <p>Enter a name for your character.</p>
          <div className="flex flex-col gap-2 w-full">
            <input
              type="button"
              className="text-yellow-400 border border-yellow-600 px-4 py-1 hover:bg-yellow-600 hover:text-black w-full"
              value="Random Name"
              onClick={() => handleSetCharacterName(generateRandomName())}
            />
            <input
              type="text"
              className="bg-gray-800 border border-yellow-600 text-yellow-400 px-4 py-1 w-full focus:outline-none focus:border-yellow-400"
              placeholder="Enter name..."
              value={characterName}
              onChange={(e) => handleSetCharacterName(e.target.value)}
            />
            {nameError && <p className="text-red-500 text-sm mt-1">{nameError}</p>}
          </div>
        </div>
      </div>
    </div>
  );
}
