import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

/// User activity statistics including streaks and consistency.
/// Maps to the `user_stats` database view.
@freezed
abstract class UserStats with _$UserStats {
  const factory UserStats({
    @JsonKey(name: 'current_streak') required int currentStreak,
    @JsonKey(name: 'longest_streak') required int longestStreak,
    @JsonKey(name: 'consistency_pct') required double consistencyPct,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) => _$UserStatsFromJson(json);
}
