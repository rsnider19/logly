import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';

part 'favorite_activity.freezed.dart';
part 'favorite_activity.g.dart';

/// A user's favorite activity.
@freezed
abstract class FavoriteActivity with _$FavoriteActivity {
  const factory FavoriteActivity({
    required String userId,
    required String activityId,
    required DateTime createdAt,

    /// The activity summary (populated via join).
    ActivitySummary? activity,
  }) = _FavoriteActivity;

  factory FavoriteActivity.fromJson(Map<String, dynamic> json) => _$FavoriteActivityFromJson(json);
}
