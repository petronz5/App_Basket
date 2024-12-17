// controllers/gameController.js
const Game = require('../models/Game');

// Ottieni tutte le partite
exports.getAllGames = async (req, res) => {
  try {
    const games = await Game.find()
      .populate('homeTeam', 'name city')
      .populate('awayTeam', 'name city');
    res.json(games);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Ottieni una singola partita
exports.getGameById = async (req, res) => {
  try {
    const game = await Game.findById(req.params.id)
      .populate('homeTeam', 'name city')
      .populate('awayTeam', 'name city');
    if (!game) return res.status(404).json({ message: 'Partita non trovata' });
    res.json(game);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Crea una nuova partita
exports.createGame = async (req, res) => {
  const { date, homeTeam, awayTeam, homeScore, awayScore } = req.body;

  const game = new Game({
    date,
    homeTeam,
    awayTeam,
    homeScore,
    awayScore,
  });

  try {
    const newGame = await game.save();
    res.status(201).json(newGame);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Aggiorna una partita
exports.updateGame = async (req, res) => {
  try {
    const updatedGame = await Game.findByIdAndUpdate(req.params.id, req.body, { new: true })
      .populate('homeTeam', 'name city')
      .populate('awayTeam', 'name city');
    if (!updatedGame) return res.status(404).json({ message: 'Partita non trovata' });
    res.json(updatedGame);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Elimina una partita
exports.deleteGame = async (req, res) => {
  try {
    const deletedGame = await Game.findByIdAndDelete(req.params.id);
    if (!deletedGame) return res.status(404).json({ message: 'Partita non trovata' });
    res.json({ message: 'Partita eliminata' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
