const API_BASE_URL = process.env.REACT_APP_API_BASE_URL;

export function getClasses() {
  return fetch(`${API_BASE_URL}/classes`)
    .then((response) => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    });
}

export function getClass(class_name) {
  return fetch(`${API_BASE_URL}/classes/${class_name}`)
    .then((response) => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    });
}

export function getCharacters() {
  return fetch(`${API_BASE_URL}/characters`)
    .then((response) => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    });
}

export function createCharacter(name, classId) {
  return fetch(`${API_BASE_URL}/characters`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify({ character_name: name, class_id: classId }),
  }).then((response) => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
  });
}

export function gainExperience(characterId, expAmount) {
  return fetch(`${API_BASE_URL}/characters/${characterId}/gain-xp`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify({ xp: expAmount }),
  }).then((response) => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
  });
}
