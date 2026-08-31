/* CharacterWizard.jsx 
  A component for creating a new character in the game.
*/

import { useState } from 'react';
import { createCharacter } from '../../services/api';
import StepClassSelect  from './StepClassSelect';
import StepNameSelect  from './StepNameSelect';
import StepReview  from './StepReview';

export default function CharacterWizard({onCharacterCreated, setMode}) {
  const [currentStep, setCurrentStep] = useState(1);
  const [selectedClass, setSelectedClass] = useState(null);
  const [characterName, setCharacterName] = useState('');
  const [stepValid, setStepValid] = useState(false);
  
  const handleSubmit = async () => {
    try {
      const newCharacter = await createCharacter(characterName, selectedClass.class_id);
      console.log('Character created:', newCharacter);
      onCharacterCreated(newCharacter.data);
      setMode('sheet');
    } catch (error) {
      console.error('Error creating character:', error);
    }
  };

  function renderStep() {
    switch (currentStep) {
      case 1:
        return <StepClassSelect currentStep={currentStep} setCurrentStep={setCurrentStep} 
                                selectedClass={selectedClass} setSelectedClass={setSelectedClass} 
                                stepValid={stepValid} setStepValid={setStepValid} />;
      case 2:
        return <StepNameSelect currentStep={currentStep} setCurrentStep={setCurrentStep} 
                                selectedClass={selectedClass} setSelectedClass={setSelectedClass} 
                                stepValid={stepValid} setStepValid={setStepValid}  
                                characterName={characterName}
                                setCharacterName={setCharacterName} />;
      case 3:
        return <StepReview currentStep={currentStep} setCurrentStep={setCurrentStep} 
                                selectedClass={selectedClass} setSelectedClass={setSelectedClass} 
                                stepValid={stepValid} setStepValid={setStepValid}  
                                characterName={characterName}
                                setCharacterName={setCharacterName} />;
      default:
        return null;
    }
  }

    return (
    <div className="flex flex-col items-center justify-center" style={{ minHeight: 'calc(100vh - 64px)' }}>
      {renderStep()}
      <div className="flex gap-4 mt-4">
        {currentStep > 1 && (
          <button 
            className="btn-primary btn-disabled"
            onClick={() => { setStepValid(false); setCurrentStep(s => s - 1); }}>
            Back
          </button>
        )}
        {currentStep < 3 && (
          <button 
            className="btn-primary btn-disabled"
            disabled={!stepValid}
            onClick={() => { setStepValid(false); setCurrentStep(s => s + 1); }}>
            Next
          </button>
        )}
        {currentStep === 3 && (
          <button 
            className="btn-primary btn-disabled"
            onClick={handleSubmit}>
            Submit
          </button>
        )}
      </div>
    </div>
    );
}