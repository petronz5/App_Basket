// lib/screens/game_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/player_stats.dart';
import '../models/team.dart';

class GameDetailScreen extends StatelessWidget {
  final Game game;

  GameDetailScreen({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettagli Partita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Data: ${game.date.toLocal()}'.split(' ')[0],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTeamColumn(game.homeTeam, game.homeScore),
                _buildTeamColumn(game.awayTeam, game.awayScore),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Statistiche dei Giocatori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: game.playerStats == null || game.playerStats!.isEmpty
                  ? Center(child: Text('Nessuna statistica disponibile.'))
                  : ListView.builder(
                      itemCount: game.playerStats!.length,
                      itemBuilder: (context, index) {
                        final stat = game.playerStats![index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(stat.player.name),
                            subtitle: Text('Posizione: ${stat.player.position}'),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Punti: ${stat.pointsMade}'),
                                Text('Assist: ${stat.assists}'),
                                Text('Rimbalzi: ${stat.defensiveRebounds + stat.offensiveRebounds}'),
                                // Aggiungi altre statistiche come necessario
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamColumn(Team team, int score) {
    return Column(
      children: [
        Text(
          team.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'Punteggio: $score',
          style: TextStyle(fontSize: 16, color: Colors.green),
        ),
      ],
    );
  }
}
