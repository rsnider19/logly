// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_month_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityMonthStatistics _$ActivityMonthStatisticsFromJson(
  Map<String, dynamic> json,
) => _ActivityMonthStatistics(
  dailyActivityCounts: (json['daily_activity_counts'] as Map<String, dynamic>)
      .map((k, e) => MapEntry(DateTime.parse(k), (e as num).toInt())),
  subActivityCounts: (json['sub_activity_counts'] as List<dynamic>)
      .map((e) => SubActivityCount.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['total_count'] as num).toInt(),
);

Map<String, dynamic> _$ActivityMonthStatisticsToJson(
  _ActivityMonthStatistics instance,
) => <String, dynamic>{
  'daily_activity_counts': instance.dailyActivityCounts.map(
    (k, e) => MapEntry(k.toIso8601String(), e),
  ),
  'sub_activity_counts': instance.subActivityCounts
      .map((e) => e.toJson())
      .toList(),
  'total_count': instance.totalCount,
};

_SubActivityCount _$SubActivityCountFromJson(Map<String, dynamic> json) =>
    _SubActivityCount(
      subActivity: SubActivity.fromJson(
        json['sub_activity'] as Map<String, dynamic>,
      ),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$SubActivityCountToJson(_SubActivityCount instance) =>
    <String, dynamic>{
      'sub_activity': instance.subActivity.toJson(),
      'count': instance.count,
    };
