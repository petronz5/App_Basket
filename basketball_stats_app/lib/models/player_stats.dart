// lib/models/player_stats.dart
import 'package:json_annotation/json_annotation.dart';
import 'player.dart';

part 'player_stats.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerStats {
  final Player player;
  final int minutesPlayed;
  final int pointsMade;
  final int shotsAttempted;
  final int shotsMade;
  final int turnovers;
  final int steals;
  final int defensiveRebounds;
  final int offensiveRebounds;
  final int foulsCommitted;
  final int foulsReceived;
  final int assists;

  PlayerStats({
    required this.player,
    this.minutesPlayed = 0,
    this.pointsMade = 0,
    this.shotsAttempted = 0,
    this.shotsMade = 0,
    this.turnovers = 0,
    this.steals = 0,
    this.defensiveRebounds = 0,
    this.offensiveRebounds = 0,
    this.foulsCommitted = 0,
    this.foulsReceived = 0,
    this.assists = 0,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) => _$PlayerStatsFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerStatsToJson(this);
}
