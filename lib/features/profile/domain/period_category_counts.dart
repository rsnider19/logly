import 'package:freezed_annotation/freezed_annotation.dart';

part 'period_category_counts.freezed.dart';
part 'period_category_counts.g.dart';

/// Activity counts per category for each time period.
/// Maps to the `period_category_counts` database view.
@freezed
abstract class PeriodCategoryCounts with _$PeriodCategoryCounts {
  const factory PeriodCategoryCounts({
    @JsonKey(name: 'activity_category_id') required String activityCategoryId,
    @JsonKey(name: 'past_week') required int pastWeek,
    @JsonKey(name: 'past_month') required int pastMonth,
    @JsonKey(name: 'past_year') required int pastYear,
    @JsonKey(name: 'all_time') required int allTime,
  }) = _PeriodCategoryCounts;

  factory PeriodCategoryCounts.fromJson(Map<String, dynamic> json) => _$PeriodCategoryCountsFromJson(json);
}
