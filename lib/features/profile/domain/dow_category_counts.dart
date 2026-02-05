import 'package:freezed_annotation/freezed_annotation.dart';

part 'dow_category_counts.freezed.dart';
part 'dow_category_counts.g.dart';

/// Activity counts per day-of-week and category.
/// Maps to the `dow_category_counts` database view.
/// [dayOfWeek] uses Postgres date_part('dow') convention: 0=Sunday, 1=Monday, ..., 6=Saturday.
@freezed
abstract class DowCategoryCounts with _$DowCategoryCounts {
  const factory DowCategoryCounts({
    @JsonKey(name: 'day_of_week') required int dayOfWeek,
    @JsonKey(name: 'activity_category_id') required String activityCategoryId,
    @JsonKey(name: 'past_week') required int pastWeek,
    @JsonKey(name: 'past_month') required int pastMonth,
    @JsonKey(name: 'past_year') required int pastYear,
    @JsonKey(name: 'all_time') required int allTime,
  }) = _DowCategoryCounts;

  factory DowCategoryCounts.fromJson(Map<String, dynamic> json) => _$DowCategoryCountsFromJson(json);
}
