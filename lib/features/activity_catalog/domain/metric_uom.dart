import 'package:json_annotation/json_annotation.dart';

/// Metric units of measurement.
@JsonEnum()
enum MetricUom {
  @JsonValue('meters')
  meters,
  @JsonValue('kilometers')
  kilometers,
  @JsonValue('milliliters')
  milliliters,
  @JsonValue('liters')
  liters,
  @JsonValue('grams')
  grams,
  @JsonValue('kilograms')
  kilograms,
}
