// routes/gameRoutes.js
const express = require('express');
const router = express.Router();
const gameController = require('../controllers/gameController');
const { protect } = require('../middleware/authMiddleware');
const { check, validationResult } = require('express-validator');

/**
 * @swagger
 * tags:
 *   name: Games
 *   description: API per gestire le partite
 */

// Rotta per ottenere tutte le partite
router.get('/', protect, gameController.getAllGames);

// Rotta per ottenere una singola partita
router.get('/:id', protect, gameController.getGameById);

// Rotta per creare una nuova partita con validazione
router.post(
  '/',
  protect,
  [
    check('date', 'La data della partita è richiesta').isISO8601(),
    check('homeTeam', 'L\'ID della squadra di casa è richiesto').isMongoId(),
    check('awayTeam', 'L\'ID della squadra ospite è richiesto').isMongoId(),
    check('homeScore', 'Il punteggio della squadra di casa è richiesto e deve essere un numero').isInt({ min: 0 }),
    check('awayScore', 'Il punteggio della squadra ospite è richiesto e deve essere un numero').isInt({ min: 0 }),
  ],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
  gameController.createGame
);

// Rotta per aggiornare una partita con validazione
router.put(
  '/:id',
  protect,
  [
    check('date', 'La data della partita deve essere in formato ISO8601').optional().isISO8601(),
    check('homeTeam', 'L\'ID della squadra di casa deve essere valido').optional().isMongoId(),
    check('awayTeam', 'L\'ID della squadra ospite deve essere valido').optional().isMongoId(),
    check('homeScore', 'Il punteggio della squadra di casa deve essere un numero').optional().isInt({ min: 0 }),
    check('awayScore', 'Il punteggio della squadra ospite deve essere un numero').optional().isInt({ min: 0 }),
  ],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
  gameController.updateGame
);

// Rotta per eliminare una partita
router.delete('/:id', protect, gameController.deleteGame);

module.exports = router;
