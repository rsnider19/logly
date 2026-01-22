// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrendingActivity _$TrendingActivityFromJson(Map<String, dynamic> json) =>
    _TrendingActivity(
      activityId: json['activity_id'] as String,
      currentRank: (json['current_rank'] as num).toInt(),
      previousRank: (json['previous_rank'] as num).toInt(),
      rankChange: (json['rank_change'] as num).toInt(),
      activity: json['activity'] == null
          ? null
          : Activity.fromJson(json['activity'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrendingActivityToJson(_TrendingActivity instance) =>
    <String, dynamic>{
      'activity_id': instance.activityId,
      'current_rank': instance.currentRank,
      'previous_rank': instance.previousRank,
      'rank_change': instance.rankChange,
      'activity': instance.activity?.toJson(),
    };
