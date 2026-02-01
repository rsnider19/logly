import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/sub_activity.dart';

part 'activity_month_statistics.freezed.dart';
part 'activity_month_statistics.g.dart';

/// Statistics for an activity within a specific month.
@freezed
abstract class ActivityMonthStatistics with _$ActivityMonthStatistics {
  const factory ActivityMonthStatistics({
    /// Map of date (year/month/day only) to log count for that day.
    required Map<DateTime, int> dailyActivityCounts,

    /// Subactivity counts sorted by count descending.
    required List<SubActivityCount> subActivityCounts,

    /// Total number of logs in this month.
    required int totalCount,

    /// The parent activity, used for icon fallback.
    Activity? activity,
  }) = _ActivityMonthStatistics;

  factory ActivityMonthStatistics.fromJson(Map<String, dynamic> json) => _$ActivityMonthStatisticsFromJson(json);
}

/// A count of how many times a specific subactivity was logged.
@freezed
abstract class SubActivityCount with _$SubActivityCount {
  const factory SubActivityCount({
    required SubActivity subActivity,
    required int count,
  }) = _SubActivityCount;

  factory SubActivityCount.fromJson(Map<String, dynamic> json) => _$SubActivityCountFromJson(json);
}
