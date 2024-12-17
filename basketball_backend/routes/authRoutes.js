// routes/authRoutes.js
const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/authMiddleware');
const authController = require('../controllers/authController');
const { check, validationResult } = require('express-validator');

// Rotta di registrazione con validazione
router.post(
  '/register',
  [
    check('username', 'Username è richiesto').not().isEmpty(),
    check('email', 'Inserisci un email valida').isEmail(),
    check('password', 'La password deve essere di almeno 6 caratteri').isLength({ min: 6 }),
  ],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
  authController.registerUser
);

// Rotta di login con validazione
router.post(
  '/login',
  [
    check('email', 'Inserisci un email valida').isEmail(),
    check('password', 'La password è richiesta').exists(),
  ],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
  authController.loginUser
);

router.put('/updateProfile', protect, authController.updateProfileUser);

module.exports = router;
