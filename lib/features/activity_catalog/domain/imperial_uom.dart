import 'package:json_annotation/json_annotation.dart';

/// Imperial units of measurement.
@JsonEnum(fieldRename: FieldRename.none)
enum ImperialUom {
  @JsonValue('yards')
  yards,
  @JsonValue('miles')
  miles,
  @JsonValue('fluidOunces')
  fluidOunces,
  @JsonValue('gallons')
  gallons,
  @JsonValue('ounces')
  ounces,
  @JsonValue('pounds')
  pounds,
}
