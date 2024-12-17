// lib/screens/guide_screen.dart
import 'package:flutter/material.dart';

class GuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guida all\'Utilizzo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Benvenuto nella Basketball Stats App!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Ecco una guida rapida su come utilizzare l\'applicazione:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildStep(
                step: 1,
                title: 'Registrazione/Login',
                description:
                    'Inizia registrandoti con un nuovo account o effettuando il login se hai già un account.',
              ),
              _buildStep(
                step: 2,
                title: 'Creazione di una Squadra',
                description:
                    'Vai alla sezione "Le Mie Squadre" e clicca sul pulsante "+" per creare una nuova squadra. Inserisci il nome e la città della squadra.',
              ),
              _buildStep(
                step: 3,
                title: 'Aggiunta di Giocatori',
                description:
                    'Seleziona una squadra per visualizzarne i dettagli. Clicca sul pulsante "+" per aggiungere nuovi giocatori alla squadra inserendo il nome e la posizione.',
              ),
              _buildStep(
                step: 4,
                title: 'Creazione di una Partita',
                description:
                    'Vai alla sezione "Partite" e clicca sul pulsante "+" per creare una nuova partita. Seleziona le squadre coinvolte, inserisci la data e i punteggi.',
              ),
              _buildStep(
                step: 5,
                title: 'Registrazione delle Statistiche',
                description:
                    'Durante la creazione di una partita, puoi aggiungere le statistiche dettagliate per ogni giocatore, come punti realizzati, assist, rimbalzi, ecc.',
              ),
              _buildStep(
                step: 6,
                title: 'Visualizzazione delle Statistiche',
                description:
                    'Una volta creata una partita, puoi visualizzare tutte le statistiche dei giocatori direttamente nella sezione delle partite.',
              ),
              SizedBox(height: 20),
              Text(
                'Buon divertimento e buona analisi delle tue partite di basket!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({required int step, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$step. ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(description, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
