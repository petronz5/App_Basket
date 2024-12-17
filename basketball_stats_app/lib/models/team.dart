// lib/models/team.dart
import 'package:json_annotation/json_annotation.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String city;
  final String? createdBy; // Se necessario
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Team({
    this.id,
    required this.name,
    required this.city,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    print('Team.fromJson called with: $json'); // Log per debug
    return _$TeamFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
