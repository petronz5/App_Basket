// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) => PlayerStats(
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      minutesPlayed: (json['minutesPlayed'] as num?)?.toInt() ?? 0,
      pointsMade: (json['pointsMade'] as num?)?.toInt() ?? 0,
      shotsAttempted: (json['shotsAttempted'] as num?)?.toInt() ?? 0,
      shotsMade: (json['shotsMade'] as num?)?.toInt() ?? 0,
      turnovers: (json['turnovers'] as num?)?.toInt() ?? 0,
      steals: (json['steals'] as num?)?.toInt() ?? 0,
      defensiveRebounds: (json['defensiveRebounds'] as num?)?.toInt() ?? 0,
      offensiveRebounds: (json['offensiveRebounds'] as num?)?.toInt() ?? 0,
      foulsCommitted: (json['foulsCommitted'] as num?)?.toInt() ?? 0,
      foulsReceived: (json['foulsReceived'] as num?)?.toInt() ?? 0,
      assists: (json['assists'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PlayerStatsToJson(PlayerStats instance) =>
    <String, dynamic>{
      'player': instance.player.toJson(),
      'minutesPlayed': instance.minutesPlayed,
      'pointsMade': instance.pointsMade,
      'shotsAttempted': instance.shotsAttempted,
      'shotsMade': instance.shotsMade,
      'turnovers': instance.turnovers,
      'steals': instance.steals,
      'defensiveRebounds': instance.defensiveRebounds,
      'offensiveRebounds': instance.offensiveRebounds,
      'foulsCommitted': instance.foulsCommitted,
      'foulsReceived': instance.foulsReceived,
      'assists': instance.assists,
    };
