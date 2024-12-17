// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      id: json['_id'] as String?,
      date: DateTime.parse(json['date'] as String),
      homeTeam: Team.fromJson(json['homeTeam'] as Map<String, dynamic>),
      awayTeam: Team.fromJson(json['awayTeam'] as Map<String, dynamic>),
      homeScore: (json['homeScore'] as num).toInt(),
      awayScore: (json['awayScore'] as num).toInt(),
      playerStats: (json['playerStats'] as List<dynamic>?)
          ?.map((e) => PlayerStats.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      '_id': instance.id,
      'date': instance.date.toIso8601String(),
      'homeTeam': instance.homeTeam.toJson(),
      'awayTeam': instance.awayTeam.toJson(),
      'homeScore': instance.homeScore,
      'awayScore': instance.awayScore,
      'playerStats': instance.playerStats?.map((e) => e.toJson()).toList(),
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
