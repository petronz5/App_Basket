// lib/screens/team_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/team.dart';
import '../services/api_service.dart';
import '../models/player.dart';
import 'add_player_screen.dart';
import 'game_detail_screen.dart'; // Importa la schermata dei dettagli della partita

class TeamDetailScreen extends StatefulWidget {
  final Team team;

  TeamDetailScreen({required this.team});

  @override
  _TeamDetailScreenState createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  final ApiService _apiService = ApiService();
  List<Player> _players = [];
  bool _isLoading = true;
  bool _hasLoaded = false; // Per evitare chiamate multiple

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      _loadPlayers();
      _hasLoaded = true;
    }
  }

  Future<void> _loadPlayers() async {
    if (widget.team.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: squadra senza ID')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      final players = await _apiService.getPlayersByTeam(widget.team.id!);
      setState(() {
        _players = players;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore nel caricamento dei giocatori')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToAddPlayer() async {
    if (widget.team.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: squadra senza ID')),
      );
      return;
    }
    final newPlayer = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddPlayerScreen(teamId: widget.team.id!)),
    );
    if (newPlayer != null) {
      setState(() {
        _players.add(newPlayer);
      });
    }
  }

  void _navigateToPlayerDetail(Player player) {
    // Implementa la navigazione verso la schermata dei dettagli del giocatore
  }

  @override
  Widget build(BuildContext context) {
    // Calcolare le statistiche aggregate
    int totalPoints = 0;
    int totalAssists = 0;
    int totalRebounds = 0;
    int totalSteals = 0;
    int totalTurnovers = 0;

    for (var player in _players) {
      // Supponiamo che ogni giocatore abbia una lista di statistiche
      // Devi recuperare queste statistiche dal backend o dal modello
      // Questo esempio presuppone che ogni giocatore abbia le statistiche aggregate
      // Se non è così, dovrai modificare il modello e il backend
      // Per semplicità, questo esempio utilizza valori fittizi

      // Esempio:
      // totalPoints += player.pointsMade;
      // totalAssists += player.assists;
      // totalRebounds += player.defensiveRebounds + player.offensiveRebounds;
      // totalSteals += player.steals;
      // totalTurnovers += player.turnovers;

      // Se non hai queste proprietà, devi aggiungerle al modello Player
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team.name),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Sezione delle statistiche della squadra
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.orange[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Statistiche della Squadra',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          // Aggiungi le statistiche reali qui
                          // Esempio:
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Punti Totali:'),
                          //     Text('$totalPoints'),
                          //   ],
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Assist Totali:'),
                          //     Text('$totalAssists'),
                          //   ],
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Rimbalzi Totali:'),
                          //     Text('$totalRebounds'),
                          //   ],
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Steals Totali:'),
                          //     Text('$totalSteals'),
                          //   ],
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Turnover Totali:'),
                          //     Text('$totalTurnovers'),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(),
                // Lista dei giocatori
                Expanded(
                  child: _players.isEmpty
                      ? Center(child: Text('Nessun giocatore trovato. Aggiungi un giocatore!'))
                      : ListView.builder(
                          itemCount: _players.length,
                          itemBuilder: (context, index) {
                            final player = _players[index];
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: ListTile(
                                title: Text(player.name),
                                subtitle: Text(player.position),
                                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                onTap: () => _navigateToPlayerDetail(player),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _navigateToAddPlayer,
      ),
    );
  }
}
