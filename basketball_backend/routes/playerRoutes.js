// routes/playerRoutes.js
const express = require('express');
const router = express.Router();
const playerController = require('../controllers/playerController');
const { protect } = require('../middleware/authMiddleware');
const { check, validationResult } = require('express-validator');

/**
 * @swagger
 * tags:
 *   name: Players
 *   description: API per gestire i giocatori
 */

// Rotta per ottenere tutti i giocatori
router.get('/', protect, playerController.getAllPlayers);

// Rotta per ottenere un singolo giocatore
router.get('/:id', protect, playerController.getPlayerById);

// Rotta per creare un nuovo giocatore con validazione
router.post(
  '/',
  protect,
  [
    check('name', 'Il nome del giocatore è richiesto').not().isEmpty(),
    check('position', 'La posizione è richiesta').not().isEmpty(),
    check('team', 'L\'ID della squadra è richiesto').isMongoId(),
  ],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
  playerController.createPlayer
);

// Rotta per aggiornare un giocatore con validazione
router.put(
  '/:id',
  protect,
  [
    check('name', 'Il nome del giocatore è richiesto').optional().not().isEmpty(),
    check('position', 'La posizione è richiesta').optional().not().isEmpty(),
    check('team', 'L\'ID della squadra è richiesto').optional().isMongoId(),
  ],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
  playerController.updatePlayer
);

router.get('/search', protect, async (req, res) => {
  const { query } = req.query;
  try {
    const players = await Player.find({ name: { $regex: query, $options: 'i' } }).populate('team', 'name city');
    res.json(players);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Rotta per eliminare un giocatore
router.delete('/:id', protect, playerController.deletePlayer);

module.exports = router;
