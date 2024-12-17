// middleware/authMiddleware.js
const jwt = require('jsonwebtoken');
const User = require('../models/User');

const protect = async (req, res, next) => {
  let token;

  if (
    req.headers.authorization && 
    req.headers.authorization.startsWith('Bearer')
  ) {
    try {
      // Prendi il token dal header
      token = req.headers.authorization.split(' ')[1];

      // Verifica il token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Prendi l'utente dal token, escludendo la password
      req.user = await User.findById(decoded.id).select('-password');

      next();
    } catch (error) {
      console.error(error);
      res.status(401).json({ message: 'Non autorizzato, token fallito' });
    }
  }

  if (!token) {
    res.status(401).json({ message: 'Non autorizzato, nessun token' });
  }
};

module.exports = { protect };
