import 'package:json_annotation/json_annotation.dart';

/// Whether an activity is logged for a single date or a date range.
@JsonEnum()
enum ActivityDateType {
  /// Activity is logged for a single date/time.
  @JsonValue('single')
  single,

  /// Activity spans a date range (start and end).
  @JsonValue('range')
  range,
}
