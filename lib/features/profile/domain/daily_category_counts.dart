import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_category_counts.freezed.dart';
part 'daily_category_counts.g.dart';

/// A single category's count for a day.
@freezed
abstract class CategoryCount with _$CategoryCount {
  const factory CategoryCount({
    @JsonKey(name: 'activity_category_id') required String activityCategoryId,
    required int count,
  }) = _CategoryCount;

  factory CategoryCount.fromJson(Map<String, dynamic> json) => _$CategoryCountFromJson(json);
}

/// Activity counts per category by day.
/// Maps to the `daily_category_counts` database view.
@freezed
abstract class DailyCategoryCounts with _$DailyCategoryCounts {
  const factory DailyCategoryCounts({
    @JsonKey(name: 'activity_date') required DateTime activityDate,
    required List<CategoryCount> categories,
  }) = _DailyCategoryCounts;

  factory DailyCategoryCounts.fromJson(Map<String, dynamic> json) => _$DailyCategoryCountsFromJson(json);
}
