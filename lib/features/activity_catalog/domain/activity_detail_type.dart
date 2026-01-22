import 'package:json_annotation/json_annotation.dart';

/// Types of activity details that can be logged.
@JsonEnum(fieldRename: FieldRename.none)
enum ActivityDetailType {
  @JsonValue('string')
  string,
  @JsonValue('integer')
  integer,
  @JsonValue('double')
  double_,
  @JsonValue('duration')
  duration,
  @JsonValue('distance')
  distance,
  @JsonValue('location')
  location,
  @JsonValue('environment')
  environment,
  @JsonValue('liquidVolume')
  liquidVolume,
  @JsonValue('weight')
  weight;

  /// Returns true if this type requires min/max numeric bounds.
  bool get hasNumericBounds => this == integer || this == double_;

  /// Returns true if this type requires duration bounds.
  bool get hasDurationBounds => this == duration;

  /// Returns true if this type requires distance bounds.
  bool get hasDistanceBounds => this == distance;

  /// Returns true if this type requires liquid volume bounds.
  bool get hasLiquidVolumeBounds => this == liquidVolume;

  /// Returns true if this type requires weight bounds.
  bool get hasWeightBounds => this == weight;

  /// Returns true if this type requires unit of measurement selection.
  bool get hasUom => this == distance || this == liquidVolume || this == weight;
}
