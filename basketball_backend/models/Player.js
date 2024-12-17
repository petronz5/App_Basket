// models/Player.js
const mongoose = require('mongoose');

const playerSchema = mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Inserisci il nome del giocatore'],
  },
  position: {
    type: String,
    required: [true, 'Inserisci la posizione del giocatore'],
  },
  number: { type: Number, required: false }, // numero di maglia
  nationality: { type: String, required: false }, // nazionalità
  height: { type: Number, required: false }, // altezza in cm
  weight: { type: Number, required: false }, // peso in kg
  team: { type: mongoose.Schema.Types.ObjectId, ref: 'Team', required: true },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

const Player = mongoose.model('Player', playerSchema); // Corretto: usa playerSchema

module.exports = Player;
