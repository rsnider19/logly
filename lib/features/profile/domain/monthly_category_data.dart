import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_category_data.freezed.dart';
part 'monthly_category_data.g.dart';

/// Monthly activity data grouped by category (used in stacked bar chart).
@freezed
abstract class MonthlyCategoryData with _$MonthlyCategoryData {
  const factory MonthlyCategoryData({
    @JsonKey(name: 'activity_month') required DateTime activityMonth,
    @JsonKey(name: 'activity_count') required int activityCount,
    @JsonKey(name: 'activity_category_id') String? activityCategoryId,
  }) = _MonthlyCategoryData;

  factory MonthlyCategoryData.fromJson(Map<String, dynamic> json) => _$MonthlyCategoryDataFromJson(json);
}
