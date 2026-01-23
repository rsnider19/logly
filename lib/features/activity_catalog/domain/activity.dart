import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/core/services/env_service.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/domain/activity_date_type.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/pace_type.dart';
import 'package:logly/features/activity_catalog/domain/sub_activity.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// An activity that can be logged (e.g., Running, Yoga, Swimming).
@freezed
abstract class Activity with _$Activity {
  const Activity._();

  const factory Activity({
    required String activityId,
    required String activityCategoryId,
    required String name,
    required String activityCode,
    String? description,
    required ActivityDateType activityDateType,
    PaceType? paceType,
    @Default(false) bool isSuggestedFavorite,

    /// The category this activity belongs to (populated via join).
    ActivityCategory? activityCategory,

    /// Detail configurations for this activity (populated via join).
    @Default([]) List<ActivityDetail> activityDetail,

    /// Subactivities for this activity (populated via join).
    @Default([]) List<SubActivity> subActivity,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

  Color getColor(BuildContext context) => activityCategory?.color ?? Theme.of(context).colorScheme.onSurface;

  /// The Supabase storage URL for this activity's icon.
  String get icon => '${EnvService.supabaseUrl}/storage/v1/object/public/activity_icons/$activityId.png';
}
