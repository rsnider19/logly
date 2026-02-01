import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/core/services/env_service.dart';

part 'activity_category.freezed.dart';
part 'activity_category.g.dart';

/// Represents a category of activities (e.g., Fitness, Sports, Wellness).
@freezed
abstract class ActivityCategory with _$ActivityCategory {
  const factory ActivityCategory({
    required String activityCategoryId,
    required String name,
    required String activityCategoryCode,
    required String hexColor,
    required int sortOrder,
    String? description,
  }) = _ActivityCategory;

  const ActivityCategory._();

  factory ActivityCategory.fromJson(Map<String, dynamic> json) => _$ActivityCategoryFromJson(json);

  /// The Supabase storage URL for this activity category's icon.
  String get icon =>
      '${EnvService.supabaseUrl}/storage/v1/object/public/activity_category_icons/$activityCategoryId.png';

  Color get color => Color(int.parse(hexColor.replaceFirst('#', 'FF'), radix: 16));
}
