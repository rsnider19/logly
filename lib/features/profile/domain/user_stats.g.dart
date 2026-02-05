// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStats _$UserStatsFromJson(Map<String, dynamic> json) => _UserStats(
  currentStreak: (json['current_streak'] as num).toInt(),
  longestStreak: (json['longest_streak'] as num).toInt(),
  consistencyPct: (json['consistency_pct'] as num).toDouble(),
);

Map<String, dynamic> _$UserStatsToJson(_UserStats instance) =>
    <String, dynamic>{
      'current_streak': instance.currentStreak,
      'longest_streak': instance.longestStreak,
      'consistency_pct': instance.consistencyPct,
    };
