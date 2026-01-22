import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';

part 'daily_activity_summary.freezed.dart';
part 'daily_activity_summary.g.dart';

/// A summary of activities logged for a specific day.
@freezed
abstract class DailyActivitySummary with _$DailyActivitySummary {
  const factory DailyActivitySummary({
    required DateTime activityDate,
    required int activityCount,
    @Default([]) List<UserActivity> userActivities,
  }) = _DailyActivitySummary;

  factory DailyActivitySummary.fromJson(Map<String, dynamic> json) => _$DailyActivitySummaryFromJson(json);
}
