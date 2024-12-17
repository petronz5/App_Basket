// routes/teamRoutes.js
const express = require('express');
const router = express.Router();
const teamController = require('../controllers/teamController');
const { protect } = require('../middleware/authMiddleware');

// Tutte le rotte relative ai team saranno protette dall'autenticazione
router.get('/', protect, teamController.getAllTeams);
router.get('/:id', protect, teamController.getTeamById);
router.post('/', protect, teamController.createTeam);
router.put('/:id', protect, teamController.updateTeam);
router.delete('/:id', protect, teamController.deleteTeam);

module.exports = router;
