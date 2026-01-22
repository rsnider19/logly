import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';

part 'trending_activity.freezed.dart';
part 'trending_activity.g.dart';

/// An activity with trending rank information.
@freezed
abstract class TrendingActivity with _$TrendingActivity {
  const TrendingActivity._();

  const factory TrendingActivity({
    required String activityId,
    required int currentRank,
    required int previousRank,
    required int rankChange,

    /// The activity definition (populated via join).
    Activity? activity,
  }) = _TrendingActivity;

  factory TrendingActivity.fromJson(Map<String, dynamic> json) => _$TrendingActivityFromJson(json);

  /// Whether the activity moved up in rankings.
  bool get isRankingUp => rankChange > 0;

  /// Whether the activity moved down in rankings.
  bool get isRankingDown => rankChange < 0;

  /// Whether the activity rank stayed the same.
  bool get isRankingSame => rankChange == 0;
}
