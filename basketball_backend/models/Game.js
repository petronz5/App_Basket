// models/Game.js
const mongoose = require('mongoose');

const PlayerStatsSchema = new mongoose.Schema({
  player: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Player',
    required: true,
  },
  minutesPlayed: { type: Number, default: 0 },
  pointsMade: { type: Number, default: 0 },
  shotsAttempted: { type: Number, default: 0 },
  shotsMade: { type: Number, default: 0 },
  turnovers: { type: Number, default: 0 },
  steals: { type: Number, default: 0 },
  defensiveRebounds: { type: Number, default: 0 },
  offensiveRebounds: { type: Number, default: 0 },
  foulsCommitted: { type: Number, default: 0 },
  foulsReceived: { type: Number, default: 0 },
  assists: { type: Number, default: 0 },
}, { _id: false });

const GameSchema = new mongoose.Schema({
  date: {
    type: Date,
    required: true,
  },
  homeTeam: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Team',
    required: true,
  },
  awayTeam: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Team',
    required: true,
  },
  homeScore: {
    type: Number,
    required: true,
  },
  awayScore: {
    type: Number,
    required: true,
  },
  playerStats: [PlayerStatsSchema], // Nuovo campo
  createdBy: { // Nuovo campo
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
}, { timestamps: true });

const Game = mongoose.model('Game', GameSchema);

module.exports = Game;
