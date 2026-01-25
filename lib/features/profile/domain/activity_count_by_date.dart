import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_count_by_date.freezed.dart';
part 'activity_count_by_date.g.dart';

/// Raw activity count data by date and category.
/// Used as the single source of truth for derived chart providers.
@freezed
abstract class ActivityCountByDate with _$ActivityCountByDate {
  const factory ActivityCountByDate({
    @JsonKey(name: 'activity_date') required DateTime activityDate,
    @JsonKey(name: 'activity_category_id') required String activityCategoryId,
    required int count,
  }) = _ActivityCountByDate;

  factory ActivityCountByDate.fromJson(Map<String, dynamic> json) => _$ActivityCountByDateFromJson(json);
}
