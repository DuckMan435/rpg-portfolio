import { useState, useEffect } from "react";
import { getClasses, getClass } from "../../services/api";

export default function StepClassSelect({
  currentStep,
  setCurrentStep,
  selectedClass,
  setSelectedClass,
  stepValid,
  setStepValid,
}) {
  const [classes, setClasses] = useState([]);

  useEffect(() => {
    const fetchClasses = async () => {
      try {
        const response = await getClasses();
        setClasses(response.data);
      } catch (error) {
        console.error("Error fetching classes:", error);
      }
    };

    fetchClasses();
  }, []);

  function handleClassSelect(cls) {
    setStepValid(true);

    const fetchClass = async () => {
      try {
        const response = await getClass(cls.class_name);
        setSelectedClass(response);
      } catch (error) {
        console.error("Error fetching class:", error);
      }
    };

    fetchClass();
  }

  return (
    <div>
      <div className="panel flex gap-8">
        <div className="flex flex-col gap-2 w-48">
          <span className="text-yellow-400 font-bold text-xl">
            Choose a Class
          </span>
          <p>Select a class for your character.</p>
          {/* Render class selection options here */}
          <ul>
            {classes.map((cls) => (
              <li
                key={cls.class_id}
                className={`px-6 py-3 w-full tracking-widest cursor-pointer
                        ${
                          cls.class_id === selectedClass?.class_id
                            ? "bg-yellow-600 text-black font-bold border border-yellow-400"
                            : "btn-primary "
                        }`}
                onClick={() => handleClassSelect(cls)}
              >
                {cls.class_name}
              </li>
            ))}
          </ul>
        </div>
        <div className="w-96">
          {selectedClass == null && <span>Select a class to view stats</span>}
          {selectedClass?.stats && (
            <span className="text-yellow-400 font-bold tracking-widest">
              {selectedClass.class_name}
            </span>
          )}
          {selectedClass?.stats && (
            <div className="border-t border-yellow-600 pt-4 mt-2">
              <span className="text-yellow-400 font-bold tracking-widest">
                STATS
              </span>
              <div className="grid grid-cols-2 gap-1 mt-2">
                {selectedClass.stats.map((ability, index) => (
                  <span key={index} className="text-yellow-300 text-sm">
                    {ability.stat_name}:{" "}
                    <span className="text-white">{ability.value}</span>
                  </span>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
