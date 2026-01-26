// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_multi_day_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LogMultiDayResult _$LogMultiDayResultFromJson(Map<String, dynamic> json) =>
    _LogMultiDayResult(
      successes: (json['successes'] as List<dynamic>)
          .map((e) => UserActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      failures: (json['failures'] as List<dynamic>)
          .map((e) => FailedDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LogMultiDayResultToJson(_LogMultiDayResult instance) =>
    <String, dynamic>{
      'successes': instance.successes.map((e) => e.toJson()).toList(),
      'failures': instance.failures.map((e) => e.toJson()).toList(),
    };

_FailedDay _$FailedDayFromJson(Map<String, dynamic> json) => _FailedDay(
  date: DateTime.parse(json['date'] as String),
  errorMessage: json['error_message'] as String,
);

Map<String, dynamic> _$FailedDayToJson(_FailedDay instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'error_message': instance.errorMessage,
    };
