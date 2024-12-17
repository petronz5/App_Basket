// lib/models/player.dart
import 'package:json_annotation/json_annotation.dart';
import 'team.dart';

part 'player.g.dart';

@JsonSerializable()
class Player {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String position;
  final int? number;
  final String? nationality;
  final int? height;
  final int? weight;
  final Team team; // Team object
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Player({
    this.id,
    required this.name,
    required this.position,
    this.number,
    this.nationality,
    this.height,
    this.weight,
    required this.team,
    this.createdAt,
    this.updatedAt,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    print('Player.fromJson called with: $json'); // Log per debug
    return _$PlayerFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
