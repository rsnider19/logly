import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_activity_count.freezed.dart';
part 'day_activity_count.g.dart';

/// Activity count for a specific day (used in contribution graph).
@freezed
abstract class DayActivityCount with _$DayActivityCount {
  const factory DayActivityCount({
    @JsonKey(name: 'activity_day') required DateTime date,
    @JsonKey(name: 'activity_count') required int count,
  }) = _DayActivityCount;

  factory DayActivityCount.fromJson(Map<String, dynamic> json) => _$DayActivityCountFromJson(json);
}
