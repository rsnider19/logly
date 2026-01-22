import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_category.freezed.dart';
part 'activity_category.g.dart';

/// Represents a category of activities (e.g., Fitness, Sports, Wellness).
@freezed
abstract class ActivityCategory with _$ActivityCategory {
  const factory ActivityCategory({
    required String activityCategoryId,
    required String name,
    required String activityCategoryCode,
    String? description,
    required String hexColor,
    required String icon,
    required int sortOrder,
  }) = _ActivityCategory;

  factory ActivityCategory.fromJson(Map<String, dynamic> json) => _$ActivityCategoryFromJson(json);
}
