export default function StepReview({
  currentStep,
  setCurrentStep,
  selectedClass,
  setSelectedClass,
  stepValid,
  setStepValid,
  characterName,
}) {
  return (
      <div className="panel flex gap-8">
      <div className="flex flex-col gap-2 w-96">
      <span className="text-yellow-400 font-bold text-xl">Step 3: Review and Confirm</span>
       <span className="text-yellow-400 text-l">Review your character details before confirming.</span>
      <span className="text-yellow-400 text-l">Character Name: {characterName}</span>
      <div className="w-96">
          {selectedClass == null && <span>Select a class to view stats</span>}
          {selectedClass?.stats && <span className="text-yellow-400 font-bold tracking-widest">{selectedClass.class_name}</span>}
          {selectedClass?.stats && (
            <div className="border-t border-yellow-600 pt-4 mt-2">
              <span className="text-yellow-400 font-bold tracking-widest">STATS</span>
              <div className="grid grid-cols-2 gap-1 mt-2">
                {selectedClass.stats.map((ability, index) => (
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
  );
}