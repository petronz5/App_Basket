// routes/teamRoutes.js
const express = require('express');
const router = express.Router();
const teamController = require('../controllers/teamController');
const { protect } = require('../middleware/authMiddleware');
const { check, validationResult } = require('express-validator');

/**
 * @swagger
 * tags:
 *   name: Teams
 *   description: API per gestire le squadre
 */

// Rotta per ottenere tutte le squadre
router.get('/', protect, teamController.getAllTeams);

// Rotta per ottenere una singola squadra
router.get('/:id', protect, teamController.getTeamById);

// Rotta per creare una nuova squadra con validazione
router.post(
  '/',
  protect,
  [
    check('name', 'Il nome della squadra è richiesto').not().isEmpty(),
    check('city', 'La città è richiesta').not().isEmpty(),
  ],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
  teamController.createTeam
);

// Rotta per aggiornare una squadra con validazione
router.put(
  '/:id',
  protect,
  [
    check('name', 'Il nome della squadra è richiesto').optional().not().isEmpty(),
    check('city', 'La città è richiesta').optional().not().isEmpty(),
  ],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
  teamController.updateTeam
);


router.get('/export', protect, async (req, res) => {
  try {
    const teams = await Team.find();
    let csv = 'ID,Name,City\n';
    teams.forEach(team => {
      csv += `${team._id},${team.name},${team.city}\n`;
    });
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', 'attachment; filename="teams_export.csv"');
    res.send(csv);
  } catch (error) {
    res.status(500).json({ message: 'Errore nell\'esportazione dei dati' });
  }
});


// Rotta per eliminare una squadra
router.delete('/:id', protect, teamController.deleteTeam);

module.exports = router;
