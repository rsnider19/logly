import 'package:json_annotation/json_annotation.dart';

/// How pace should be calculated for an activity.
@JsonEnum(fieldRename: FieldRename.none)
enum PaceType {
  /// Minutes per unit of measure (e.g., min/mile, min/km).
  @JsonValue('minutesPerUom')
  minutesPerUom,

  /// Minutes per 100 units (e.g., min/100m for swimming).
  @JsonValue('minutesPer100Uom')
  minutesPer100Uom,

  /// Minutes per 500m (rowing standard).
  @JsonValue('minutesPer500m')
  minutesPer500m,

  /// Floors per minute (stair climbing).
  @JsonValue('floorsPerMinute')
  floorsPerMinute,
}
