// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/game.dart';
import '../models/player_stats.dart'; // Importa PlayerStats

class ApiService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Funzione per registrare un utente
  Future<User?> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.auth}/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      return User.fromJson(data);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to register user');
    }
  }

  // Funzione per effettuare il login
  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.auth}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      return User.fromJson(data);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to login user');
    }
  }

  // Funzione per ottenere tutte le squadre
  Future<List<Team>> getTeams() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse(ApiConfig.teams),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((team) => Team.fromJson(team)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to load teams');
    }
  }

  // Funzione per creare una nuova squadra
  Future<Team> createTeam(String name, String city) async {
    final token = await _storage.read(key: 'token');
    final Map<String, dynamic> body = {
      'name': name,
      'city': city,
    };

    // Log del corpo della richiesta
    print('Sending createTeam request with body: $body');

    final response = await http.post(
      Uri.parse(ApiConfig.teams),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    // Log della risposta
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      return Team.fromJson(jsonDecode(response.body));
    } else {
      final responseBody = jsonDecode(response.body);
      final message = responseBody['message'] ?? 'Failed to create team';
      throw Exception(message);
    }
  }

  // Funzione per ottenere i giocatori di una squadra
  Future<List<Player>> getPlayersByTeam(String teamId) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiConfig.players}?team=$teamId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Log della risposta
    print('getPlayersByTeam response status: ${response.statusCode}');
    print('getPlayersByTeam response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((player) => Player.fromJson(player)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to load players');
    }
  }

  // Funzione per creare un nuovo giocatore con campi aggiuntivi
  Future<Player> createPlayer(
      String name,
      String position,
      String teamId, {
        int? number,
        String? nationality,
        int? height,
        int? weight,
      }) async {
    final token = await _storage.read(key: 'token');
    final body = <String, dynamic>{
      'name': name,
      'position': position,
      'team': teamId,
    };
    if (number != null) body['number'] = number;
    if (nationality != null) body['nationality'] = nationality;
    if (height != null) body['height'] = height;
    if (weight != null) body['weight'] = weight;

    // Log del corpo della richiesta
    print('Sending createPlayer request with body: $body');

    final response = await http.post(
      Uri.parse(ApiConfig.players),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    // Log della risposta
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      return Player.fromJson(jsonDecode(response.body));
    } else {
      final responseBody = jsonDecode(response.body);
      final message = responseBody['message'] ?? 'Failed to create player';
      throw Exception(message);
    }
  }

  Future<List<Player>> searchPlayers(String query) async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiConfig.players}/search?query=$query'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((p) => Player.fromJson(p)).toList();
    } else {
      throw Exception('Errore nella ricerca giocatori');
    }
  }

  // Funzione per ottenere tutte le partite
  Future<List<Game>> getGames() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse(ApiConfig.games),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((game) => Game.fromJson(game)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to load games');
    }
  }

  Future<User?> updateProfile(String? username, String? email, String? password) async {
    final token = await _storage.read(key: 'token');
    final body = {};
    if (username != null) body['username'] = username;
    if (email != null) body['email'] = email;
    if (password != null) body['password'] = password;

    final response = await http.put(
      Uri.parse('${ApiConfig.auth}/updateProfile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      return User.fromJson(data);
    } else {
      throw Exception('Errore nell\'aggiornamento del profilo');
    }
  }


  Future<Game> getGameById(String gameId) async {
  final token = await _storage.read(key: 'token');
  final response = await http.get(
    Uri.parse('${ApiConfig.games}/$gameId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return Game.fromJson(jsonDecode(response.body));
  } else {
    final responseBody = jsonDecode(response.body);
    final message = responseBody['message'] ?? 'Failed to load game';
    throw Exception(message);
  }
}

  // Funzione per creare una nuova partita
  Future<Game> createGame(DateTime date, String homeTeamId, String awayTeamId, int homeScore, int awayScore) async {
    final token = await _storage.read(key: 'token');
    final response = await http.post(
      Uri.parse(ApiConfig.games),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'date': date.toIso8601String(),
        'homeTeam': homeTeamId,
        'awayTeam': awayTeamId,
        'homeScore': homeScore,
        'awayScore': awayScore,
      }),
    );

    if (response.statusCode == 201) {
      return Game.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to create game');
    }
  }

  // Altre funzioni per aggiornare ed eliminare team, players, games seguono lo stesso schema
  // ...
// Funzione per creare una nuova partita con statistiche dei giocatori
  Future<Game> createGameWithStats({
    required DateTime date,
    required String homeTeamId,
    required String awayTeamId,
    required int homeScore,
    required int awayScore,
    required List<PlayerStats> playerStats,
  }) async {
    final token = await _storage.read(key: 'token');
    final response = await http.post(
      Uri.parse(ApiConfig.games),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'date': date.toIso8601String(),
        'homeTeam': homeTeamId,
        'awayTeam': awayTeamId,
        'homeScore': homeScore,
        'awayScore': awayScore,
        'playerStats': playerStats.map((ps) => ps.toJson()).toList(),
      }),
    );

    if (response.statusCode == 201) {
      return Game.fromJson(jsonDecode(response.body));
    } else {
      final responseBody = jsonDecode(response.body);
      final message = responseBody['message'] ?? 'Failed to create game';
      throw Exception(message);
    }
  }



}
