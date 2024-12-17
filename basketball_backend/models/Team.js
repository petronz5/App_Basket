// models/Team.js
const mongoose = require('mongoose');

const TeamSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true,
  },
  city: {
    type: String,
    required: true,
  },
  createdBy: { // Aggiunto
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  // Aggiungi altri campi se necessario
}, { timestamps: true });

const Team = mongoose.model('Team', TeamSchema);

module.exports = Team;
