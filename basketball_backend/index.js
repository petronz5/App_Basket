// index.js
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const helmet = require('helmet'); // Importa Helmet
const rateLimit = require('express-rate-limit'); // Importa express-rate-limit
const connectDB = require('./config/db');

// Carica le variabili d'ambiente
dotenv.config();

// Inizializza l'app Express
const app = express();

// Middleware di sicurezza
app.use(helmet());

// Configura il rate limiter
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minuti
  max: 100, // Limite di 100 richieste per windowMs
  message: 'Troppo traffico da questo indirizzo, riprova tra 15 minuti',
});

// Applica il rate limiter a tutte le richieste
app.use(limiter);

// Middleware CORS
app.use(cors());

// Middleware per parsare JSON
app.use(express.json());

// Connessione al database
connectDB();

// Rotte di base
app.get('/', (req, res) => {
  res.send('Backend del Basketball Stats App è attivo!');
});

// Importa e usa le rotte
const authRoutes = require('./routes/authRoutes');
const teamRoutes = require('./routes/teamRoutes');
const playerRoutes = require('./routes/playerRoutes');
const gameRoutes = require('./routes/gameRoutes');

app.use('/api/auth', authRoutes);
app.use('/api/teams', teamRoutes);
app.use('/api/players', playerRoutes);
app.use('/api/games', gameRoutes);

// Gestione degli errori
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Qualcosa è andato storto!' });
});

// Avvia il server
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => {
  console.log(`Server in esecuzione su http://localhost:${PORT}`);
});
