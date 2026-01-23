import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_summary.freezed.dart';
part 'category_summary.g.dart';

/// Summary of activity count per category.
@freezed
abstract class CategorySummary with _$CategorySummary {
  const factory CategorySummary({
    @JsonKey(name: 'activity_category_id') required String activityCategoryId,
    @JsonKey(name: 'activity_count') required int activityCount,
  }) = _CategorySummary;

  factory CategorySummary.fromJson(Map<String, dynamic> json) => _$CategorySummaryFromJson(json);
}
