// lib/models/game.dart
import 'package:json_annotation/json_annotation.dart';
import 'team.dart';
import 'player_stats.dart'; // Nuovo modello

part 'game.g.dart';

@JsonSerializable(explicitToJson: true)
class Game {
  @JsonKey(name: '_id')
  final String? id;
  final DateTime date;
  final Team homeTeam;
  final Team awayTeam;
  final int homeScore;
  final int awayScore;
  final List<PlayerStats>? playerStats; // Nuovo campo
  final String? createdBy; // Nuovo campo
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Game({
    this.id,
    required this.date,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    this.playerStats,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);
}
