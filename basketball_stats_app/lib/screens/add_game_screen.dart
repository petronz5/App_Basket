// lib/screens/add_game_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/game.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/player_stats.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'game_detail_screen.dart'; // Importa la schermata dei dettagli della partita

class AddGameScreen extends StatefulWidget {
  @override
  _AddGameScreenState createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  Team? _homeTeam;
  Team? _awayTeam;
  int _homeScore = 0;
  int _awayScore = 0;
  List<Player> _players = [];
  List<PlayerStats> _playerStats = [];
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    try {
      final teams = await _apiService.getTeams();
      setState(() {
        _teams = teams;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore nel caricamento delle squadre')),
      );
    }
  }

  List<Team> _teams = [];

  Future<void> _loadPlayersForTeam(String teamId) async {
    try {
      final players = await _apiService.getPlayersByTeam(teamId);
      setState(() {
        _players = players;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore nel caricamento dei giocatori')),
      );
    }
  }

  void _addPlayerStat(Player player) {
    showDialog(
      context: context,
      builder: (context) {
        final _statFormKey = GlobalKey<FormState>();
        int minutesPlayed = 0;
        int pointsMade = 0;
        int shotsAttempted = 0;
        int shotsMade = 0;
        int turnovers = 0;
        int steals = 0;
        int defensiveRebounds = 0;
        int offensiveRebounds = 0;
        int foulsCommitted = 0;
        int foulsReceived = 0;
        int assists = 0;

        return AlertDialog(
          title: Text('Statistiche per ${player.name}'),
          content: SingleChildScrollView(
            child: Form(
              key: _statFormKey,
              child: Column(
                children: [
                  _buildNumberField(
                    label: 'Minuti Giocati',
                    initialValue: minutesPlayed,
                    onSaved: (value) => minutesPlayed = value,
                  ),
                  _buildNumberField(
                    label: 'Punti Realizzati',
                    initialValue: pointsMade,
                    onSaved: (value) => pointsMade = value,
                  ),
                  _buildNumberField(
                    label: 'Tiri Tentati',
                    initialValue: shotsAttempted,
                    onSaved: (value) => shotsAttempted = value,
                  ),
                  _buildNumberField(
                    label: 'Tiri Realizzati',
                    initialValue: shotsMade,
                    onSaved: (value) => shotsMade = value,
                  ),
                  _buildNumberField(
                    label: 'Turnover',
                    initialValue: turnovers,
                    onSaved: (value) => turnovers = value,
                  ),
                  _buildNumberField(
                    label: 'Steals',
                    initialValue: steals,
                    onSaved: (value) => steals = value,
                  ),
                  _buildNumberField(
                    label: 'Rimbalzi Difensivi',
                    initialValue: defensiveRebounds,
                    onSaved: (value) => defensiveRebounds = value,
                  ),
                  _buildNumberField(
                    label: 'Rimbalzi Offensivi',
                    initialValue: offensiveRebounds,
                    onSaved: (value) => offensiveRebounds = value,
                  ),
                  _buildNumberField(
                    label: 'Falli Committi',
                    initialValue: foulsCommitted,
                    onSaved: (value) => foulsCommitted = value,
                  ),
                  _buildNumberField(
                    label: 'Falli Ricevuti',
                    initialValue: foulsReceived,
                    onSaved: (value) => foulsReceived = value,
                  ),
                  _buildNumberField(
                    label: 'Assist',
                    initialValue: assists,
                    onSaved: (value) => assists = value,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Annulla'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Aggiungi'),
              onPressed: () {
                if (_statFormKey.currentState!.validate()) {
                  _statFormKey.currentState!.save();
                  setState(() {
                    _playerStats.add(PlayerStats(
                      player: player,
                      minutesPlayed: minutesPlayed,
                      pointsMade: pointsMade,
                      shotsAttempted: shotsAttempted,
                      shotsMade: shotsMade,
                      turnovers: turnovers,
                      steals: steals,
                      defensiveRebounds: defensiveRebounds,
                      offensiveRebounds: offensiveRebounds,
                      foulsCommitted: foulsCommitted,
                      foulsReceived: foulsReceived,
                      assists: assists,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNumberField({
    required String label,
    required int initialValue,
    required Function(int) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        initialValue: initialValue.toString(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Inserisci un valore';
          if (int.tryParse(value) == null) return 'Inserisci un numero valido';
          return null;
        },
        onSaved: (value) {
          onSaved(int.parse(value!));
        },
      ),
    );
  }

  Future<void> _submitGame() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_homeTeam == null || _awayTeam == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Seleziona entrambe le squadre')),
        );
        return;
      }
      if (_homeTeam!.id == _awayTeam!.id) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Le squadre devono essere diverse')),
        );
        return;
      }
      if (_playerStats.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aggiungi almeno una statistica per un giocatore')),
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        final newGame = await _apiService.createGameWithStats(
          date: _date,
          homeTeamId: _homeTeam!.id!,
          awayTeamId: _awayTeam!.id!,
          homeScore: _homeScore,
          awayScore: _awayScore,
          playerStats: _playerStats,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => GameDetailScreen(game: newGame)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nella creazione della partita')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crea Partita'),
      ),
      body: _teams.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Selezione della data
                      ListTile(
                        title: Text('Data: ${_date.toLocal()}'.split(' ')[0]),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null && picked != _date)
                            setState(() {
                              _date = picked;
                            });
                        },
                      ),
                      SizedBox(height: 10),
                      // Selezione delle squadre
                      DropdownButtonFormField<Team>(
                        decoration: InputDecoration(labelText: 'Squadra in Casa'),
                        items: _teams.map((team) {
                          return DropdownMenuItem<Team>(
                            value: team,
                            child: Text(team.name),
                          );
                        }).toList(),
                        onChanged: (team) {
                          setState(() {
                            _homeTeam = team;
                            _loadPlayersForTeam(team!.id!);
                          });
                        },
                        validator: (value) => value == null ? 'Seleziona una squadra' : null,
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<Team>(
                        decoration: InputDecoration(labelText: 'Squadra Ospite'),
                        items: _teams.map((team) {
                          return DropdownMenuItem<Team>(
                            value: team,
                            child: Text(team.name),
                          );
                        }).toList(),
                        onChanged: (team) {
                          setState(() {
                            _awayTeam = team;
                            _loadPlayersForTeam(team!.id!);
                          });
                        },
                        validator: (value) => value == null ? 'Seleziona una squadra' : null,
                      ),
                      SizedBox(height: 20),
                      // Inserimento del punteggio
                      CustomTextField(
                        label: 'Punteggio Squadra in Casa',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Inserisci il punteggio';
                          if (int.tryParse(value) == null) return 'Inserisci un numero valido';
                          return null;
                        },
                        onSaved: (value) {
                          _homeScore = int.parse(value!);
                        },
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        label: 'Punteggio Squadra Ospite',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Inserisci il punteggio';
                          if (int.tryParse(value) == null) return 'Inserisci un numero valido';
                          return null;
                        },
                        onSaved: (value) {
                          _awayScore = int.parse(value!);
                        },
                      ),
                      SizedBox(height: 20),
                      // Lista delle statistiche dei giocatori
                      Text(
                        'Statistiche dei Giocatori',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      _playerStats.isEmpty
                          ? Text('Nessuna statistica aggiunta.')
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _playerStats.length,
                              itemBuilder: (context, index) {
                                final stat = _playerStats[index];
                                return ListTile(
                                  title: Text(stat.player.name),
                                  subtitle: Text(
                                      'Punti: ${stat.pointsMade}, Assist: ${stat.assists}, Rimbalzi: ${stat.defensiveRebounds + stat.offensiveRebounds}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _playerStats.removeAt(index);
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: Icon(Icons.add),
                        label: Text('Aggiungi Statistiche'),
                        onPressed: () {
                          if (_homeTeam != null && _awayTeam != null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                // Selezione della squadra per cui aggiungere statistiche
                                Team? selectedTeam;
                                return AlertDialog(
                                  title: Text('Seleziona Squadra'),
                                  content: DropdownButtonFormField<Team>(
                                    decoration: InputDecoration(labelText: 'Squadra'),
                                    items: [_homeTeam!, _awayTeam!].map((team) {
                                      return DropdownMenuItem<Team>(
                                        value: team,
                                        child: Text(team.name),
                                      );
                                    }).toList(),
                                    onChanged: (team) {
                                      setState(() {
                                        selectedTeam = team;
                                      });
                                    },
                                    validator: (value) => value == null ? 'Seleziona una squadra' : null,
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Annulla'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    ElevatedButton(
                                      child: Text('Continua'),
                                      onPressed: () {
                                        if (selectedTeam == null) return;
                                        Navigator.pop(context);
                                        // Filtra i giocatori della squadra selezionata
                                        List<Player> teamPlayers = _players
                                            .where((p) => p.team.id == selectedTeam!.id)
                                            .toList();
                                        if (teamPlayers.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Nessun giocatore nella squadra selezionata')),
                                          );
                                          return;
                                        }
                                        // Seleziona un giocatore per aggiungere le statistiche
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Player? selectedPlayer;
                                            return AlertDialog(
                                              title: Text('Seleziona Giocatore'),
                                              content: DropdownButtonFormField<Player>(
                                                decoration: InputDecoration(labelText: 'Giocatore'),
                                                items: teamPlayers.map((player) {
                                                  return DropdownMenuItem<Player>(
                                                    value: player,
                                                    child: Text(player.name),
                                                  );
                                                }).toList(),
                                                onChanged: (player) {
                                                  setState(() {
                                                    selectedPlayer = player;
                                                  });
                                                },
                                                validator: (value) => value == null ? 'Seleziona un giocatore' : null,
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text('Annulla'),
                                                  onPressed: () => Navigator.pop(context),
                                                ),
                                                ElevatedButton(
                                                  child: Text('Aggiungi'),
                                                  onPressed: () {
                                                    if (selectedPlayer == null) return;
                                                    Navigator.pop(context);
                                                    _addPlayerStat(selectedPlayer!);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Seleziona entrambe le squadre prima di aggiungere statistiche')),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator()
                          : CustomButton(
                              text: 'Crea Partita',
                              onPressed: _submitGame,
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
