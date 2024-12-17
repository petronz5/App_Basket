// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      id: json['_id'] as String?,
      name: json['name'] as String,
      position: json['position'] as String,
      number: (json['number'] as num?)?.toInt(),
      nationality: json['nationality'] as String?,
      height: (json['height'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toInt(),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'number': instance.number,
      'nationality': instance.nationality,
      'height': instance.height,
      'weight': instance.weight,
      'team': instance.team,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
