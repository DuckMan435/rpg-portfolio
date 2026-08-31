import './App.css';
import { useState, useEffect } from 'react';
import CharacterWizard from './components/wizard/CharacterWizard';
import CharacterSheet from './components/CharacterSheet';
import CharacterSelect from './components/CharacterSelect';
import NavBar from "./components/NavBar";


function App() {
  const [character, setCharacter] = useState(null);
  const [mode, setMode] = useState('landing'); // 'wizard' or 'sheet'

  useEffect(() => {
  if (character !== null) {
    setMode('sheet');
  }
}, [character]);

  return (
    <div className="min-h-screen">
    <NavBar setMode={setMode} setCharacter={setCharacter}></NavBar>
        {mode === 'landing' && (
    <div className="flex flex-col items-center justify-center" style={{ minHeight: 'calc(100vh - 64px)' }}>
      <div className="panel flex flex-col gap-4 w-64">
              <>
                  <button className="text-yellow-400 border border-yellow-600 px-6 py-3 hover:bg-yellow-600 hover:text-black w-full tracking-widest" onClick={() => setMode('wizard')}>Create Character</button>
                  <button className="text-yellow-400 border border-yellow-600 px-6 py-3 hover:bg-yellow-600 hover:text-black w-full tracking-widest" onClick={() => setMode('select')}>Load Character</button>
              </>
            </div>
            </div>
          )}
          {mode === 'wizard' && <CharacterWizard onCharacterCreated={setCharacter} setMode={setMode} />}
          {mode === 'select' && <CharacterSelect onCharacterSelected={setCharacter} setMode={setMode} />}
          {mode === 'sheet' && <CharacterSheet character={character} setCharacter={setCharacter} />}
    </div>
  );
}

export default App;
