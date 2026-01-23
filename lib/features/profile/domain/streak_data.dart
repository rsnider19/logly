import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak_data.freezed.dart';
part 'streak_data.g.dart';

/// User activity streak information.
@freezed
abstract class StreakData with _$StreakData {
  const factory StreakData({
    @JsonKey(name: 'current_streak') required int currentStreak,
    @JsonKey(name: 'longest_streak') required int longestStreak,
    @JsonKey(name: 'workout_days_this_week') required int workoutDaysThisWeek,
  }) = _StreakData;

  factory StreakData.fromJson(Map<String, dynamic> json) => _$StreakDataFromJson(json);
}
