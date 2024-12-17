// controllers/teamController.js
const Team = require('../models/Team');

// Ottieni tutte le squadre dell'utente loggato
exports.getAllTeams = async (req, res) => {
  try {
    const teams = await Team.find({ createdBy: req.user.id }); // Filtra per utente
    res.json(teams);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Ottieni una singola squadra se appartiene all'utente
exports.getTeamById = async (req, res) => {
  try {
    const team = await Team.findById(req.params.id);
    if (!team) return res.status(404).json({ message: 'Squadra non trovata' });
    
    // Verifica se la squadra appartiene all'utente
    if (team.createdBy.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Accesso negato' });
    }
    
    res.json(team);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Crea una nuova squadra associata all'utente
exports.createTeam = async (req, res) => {
  const { name, city } = req.body;

  const team = new Team({
    name,
    city,
    createdBy: req.user.id, // Associa l'utente
  });

  try {
    const newTeam = await team.save();
    res.status(201).json(newTeam);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Aggiorna una squadra se appartiene all'utente
exports.updateTeam = async (req, res) => {
  try {
    const team = await Team.findById(req.params.id);
    if (!team) return res.status(404).json({ message: 'Squadra non trovata' });

    // Verifica se la squadra appartiene all'utente
    if (team.createdBy.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Accesso negato' });
    }

    const { name, city } = req.body;

    if (name) team.name = name;
    if (city) team.city = city;

    const updatedTeam = await team.save();
    res.json(updatedTeam);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Elimina una squadra se appartiene all'utente
exports.deleteTeam = async (req, res) => {
  try {
    const team = await Team.findById(req.params.id);
    if (!team) return res.status(404).json({ message: 'Squadra non trovata' });

    // Verifica se la squadra appartiene all'utente
    if (team.createdBy.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Accesso negato' });
    }

    await team.remove();
    res.json({ message: 'Squadra eliminata' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
