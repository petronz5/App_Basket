// controllers/authController.js
const User = require('../models/User');
const jwt = require('jsonwebtoken');

// Genera il token JWT
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: '30d',
  });
};

// Registrazione utente
exports.registerUser = async (req, res) => {
  const { username, email, password } = req.body;

  try {
    const userExists = await User.findOne({ email });

    if (userExists) {
      return res.status(400).json({ message: 'Utente già registrato' });
    }

    const user = await User.create({
      username,
      email,
      password,
    });

    res.status(201).json({
      _id: user._id,
      username: user.username,
      email: user.email,
      token: generateToken(user._id),
    });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Login utente
exports.loginUser = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });

    if (user && (await user.matchPassword(password))) {
      res.json({
        _id: user._id,
        username: user.username,
        email: user.email,
        token: generateToken(user._id),
      });
    } else {
      res.status(401).json({ message: 'Credenziali non valide' });
    }
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.updateProfileUser = async (req, res) => {
  const { username, email, password } = req.body;
  try {
    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ message: 'Utente non trovato' });
    }

    if (username) user.username = username;
    if (email) user.email = email;
    if (password) {
      const bcrypt = require('bcryptjs');
      const salt = await bcrypt.genSalt(10);
      user.password = await bcrypt.hash(password, salt);
    }

    await user.save();
    const token = generateToken(user._id);

    res.json({
      _id: user._id,
      username: user.username,
      email: user.email,
      role: user.role,
      token,
    });
  } catch (error) {
    res.status(500).json({ message: 'Errore nell\'aggiornamento del profilo' });
  }
};
