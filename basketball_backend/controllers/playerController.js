// controllers/playerController.js
const Player = require('../models/Player');
const Team = require('../models/Team'); 

// Ottieni tutti i giocatori
exports.getAllPlayers = async (req, res) => {
  try {
    const { team } = req.query;
    let query = {};

    if (team) {
      query.team = team;
    }

    const players = await Player.find(query).populate('team', 'name city createdBy');

    // Se c'è un parametro team, controlla la proprietà createdBy del team
    if (team && players.length > 0) {
      const onePlayer = players[0]; 
      const teamOwner = onePlayer.team.createdBy.toString();
      if (teamOwner !== req.user.id) {
        return res.status(403).json({ message: 'Accesso negato. Non possiedi questa squadra.' });
      }
    }

    res.json(players);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Ottieni un singolo giocatore
exports.getPlayerById = async (req, res) => {
  try {
    const player = await Player.findById(req.params.id).populate('team', 'name city');
    if (!player) return res.status(404).json({ message: 'Giocatore non trovato' });
    res.json(player);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }


};

// Funzione per creare un nuovo giocatore
exports.createPlayer = async (req, res) => {
  const { name, position, team, number, nationality, height, weight } = req.body;

  // Debug: Stampa i dati ricevuti
  console.log('Dati ricevuti per la creazione del giocatore:', req.body);

  try {
    // Verifica che la squadra appartenga all'utente
    const teamObj = await Team.findById(team);
    if (!teamObj) {
      return res.status(404).json({ message: 'Squadra non trovata' });
    }
    if (teamObj.createdBy.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Accesso negato. Non possiedi questa squadra.' });
    }

    const newPlayer = new Player({
      name,
      position,
      team,
      number,
      nationality,
      height,
      weight,
    });

    await newPlayer.save();

    // Popola il campo 'team' con i dettagli della squadra
    await newPlayer.populate('team', 'name city'); // Rimosso .execPopulate()

    // Debug: Stampa il giocatore creato
    console.log('Giocatore creato:', newPlayer);

    res.status(201).json(newPlayer);
  } catch (error) {
    console.error('Errore nella creazione del giocatore:', error);
    res.status(500).json({ message: 'Errore nella creazione del giocatore' });
  }
};

// Aggiorna un giocatore
exports.updatePlayer = async (req, res) => {
  try {
    const updatedPlayer = await Player.findByIdAndUpdate(req.params.id, req.body, { new: true }).populate('team', 'name city');
    if (!updatedPlayer) return res.status(404).json({ message: 'Giocatore non trovato' });
    res.json(updatedPlayer);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Elimina un giocatore
exports.deletePlayer = async (req, res) => {
  try {
    const deletedPlayer = await Player.findByIdAndDelete(req.params.id);
    if (!deletedPlayer) return res.status(404).json({ message: 'Giocatore non trovato' });
    res.json({ message: 'Giocatore eliminato' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
