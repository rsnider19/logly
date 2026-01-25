import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_category_data.freezed.dart';
part 'weekly_category_data.g.dart';

/// Activity data grouped by day of week and category (used in radar chart).
/// dayOfWeek: 1 = Monday, 7 = Sunday (ISO 8601 standard)
@freezed
abstract class WeeklyCategoryData with _$WeeklyCategoryData {
  const factory WeeklyCategoryData({
    required int dayOfWeek,
    required int activityCount,
    String? activityCategoryId,
  }) = _WeeklyCategoryData;

  factory WeeklyCategoryData.fromJson(Map<String, dynamic> json) => _$WeeklyCategoryDataFromJson(json);
}
