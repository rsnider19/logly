// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StreakData _$StreakDataFromJson(Map<String, dynamic> json) => _StreakData(
  currentStreak: (json['current_streak'] as num).toInt(),
  longestStreak: (json['longest_streak'] as num).toInt(),
  workoutDaysThisWeek: (json['workout_days_this_week'] as num).toInt(),
);

Map<String, dynamic> _$StreakDataToJson(_StreakData instance) => <String, dynamic>{
  'current_streak': instance.currentStreak,
  'longest_streak': instance.longestStreak,
  'workout_days_this_week': instance.workoutDaysThisWeek,
};
