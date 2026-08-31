

export default function NavBar({ setMode, setCharacter }) {

  return (
    <nav className="flex items-center justify-between p-4 border-b border-yellow-600 bg-gray-950">
      <span className="text-yellow-400 font-bold text-xl">RPG</span>
      <button 
        onClick={() => { setMode("landing"); setCharacter(null); }}
        className="text-yellow-400 border border-yellow-600 px-4 py-2 hover:bg-yellow-600 hover:text-black"
      >
        Main Menu
      </button>
  </nav>
  );
}
