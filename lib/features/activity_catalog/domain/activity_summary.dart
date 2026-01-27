import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/core/services/env_service.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/domain/activity_date_type.dart';

part 'activity_summary.freezed.dart';
part 'activity_summary.g.dart';

/// A lightweight activity model for display in chips, lists, and search results.
///
/// Excludes detail configurations, subactivities, and pace type
/// which are only needed on the log/edit screens.
@freezed
abstract class ActivitySummary with _$ActivitySummary {
  const ActivitySummary._();

  const factory ActivitySummary({
    required String activityId,
    required String activityCategoryId,
    required String name,
    required String activityCode,
    String? description,
    required ActivityDateType activityDateType,
    @Default(false) bool isSuggestedFavorite,

    /// The category this activity belongs to (populated via join).
    ActivityCategory? activityCategory,
  }) = _ActivitySummary;

  factory ActivitySummary.fromJson(Map<String, dynamic> json) => _$ActivitySummaryFromJson(json);

  Color getColor(BuildContext context) => activityCategory?.color ?? Theme.of(context).colorScheme.onSurface;

  /// The Supabase storage URL for this activity's icon.
  String get icon => '${EnvService.supabaseUrl}/storage/v1/object/public/activity_icons/$activityId.png';
}
