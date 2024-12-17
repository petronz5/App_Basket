// lib/screens/home_screen.dart
import 'package:basketball_stats_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../services/auth_provider.dart';
import '../services/api_service.dart';
import '../models/team.dart';
import 'add_team_screen.dart';
import 'team_detail_screen.dart';
import 'add_game_screen.dart';
import 'guide_screen.dart';
import 'game_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Team> _teams = [];
  bool _isLoading = true;
  List<Game> _games = [];
  bool _isLoadingGames = true;

  @override
  void initState() {
    super.initState();
    _loadTeams();
    _loadGames();
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadGames() async {
    try {
      final games = await _apiService.getGames();
      setState(() {
        _games = games;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore nel caricamento delle partite')),
      );
    } finally {
      setState(() {
        _isLoadingGames = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Basketball Stats'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ... codice esistente del Drawer
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Basketball Stats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.sports_basketball),
              title: Text('Partite'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => _buildGamesList()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profilo'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Guida'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/guide');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            // ... codice esistente del Drawer
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _teams.isEmpty
              ? Center(child: Text('Nessuna squadra trovata. Aggiungi una squadra!'))
              : ListView.builder(
                  itemCount: _teams.length,
                  itemBuilder: (context, index) {
                    final team = _teams[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Icon(Icons.group, color: Theme.of(context).primaryColor),
                        title: Text(team.name, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(team.city),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TeamDetailScreen(team: team)),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newTeam = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTeamScreen()),
          );
          if (newTeam != null) {
            setState(() {
              _teams.add(newTeam);
            });
          }
        },
      ),
    );
  }

  Widget _buildGamesList() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partite'),
      ),
      body: _isLoadingGames
          ? Center(child: CircularProgressIndicator())
          : _games.isEmpty
              ? Center(child: Text('Nessuna partita trovata. Aggiungi una partita!'))
              : ListView.builder(
                  itemCount: _games.length,
                  itemBuilder: (context, index) {
                    final game = _games[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Icon(Icons.sports_basketball, color: Theme.of(context).primaryColor),
                        title: Text('${game.homeTeam.name} vs ${game.awayTeam.name}'),
                        subtitle: Text('Data: ${game.date.toLocal()}'.split(' ')[0]),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => GameDetailScreen(game: game)),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newGame = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddGameScreen()),
          );
          if (newGame != null) {
            setState(() {
              _games.add(newGame);
            });
          }
        },
      ),
    );
  }
}
