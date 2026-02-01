import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_catalog/domain/pace_type.dart';
import 'package:uuid/uuid.dart';

part 'activity_detail_config.freezed.dart';
part 'activity_detail_config.g.dart';

/// Configuration for an activity detail being created.
///
/// This sealed class represents the different types of details that can be
/// added to a custom activity, with type-specific configuration options.
@Freezed(unionKey: 'detailType')
sealed class ActivityDetailConfig with _$ActivityDetailConfig {
  const ActivityDetailConfig._();

  /// Number detail (integer or decimal).
  @FreezedUnionValue('number')
  const factory ActivityDetailConfig.number({
    required String id,
    @Default('') String label,
    @Default(true) bool isInteger,
    @Default(100.0) double maxValue,
  }) = NumberDetailConfig;

  /// Duration detail (hours, minutes, seconds).
  @FreezedUnionValue('duration')
  const factory ActivityDetailConfig.duration({
    required String id,
    @Default('') String label,
    @Default(7200) int maxSeconds,
    @Default(false) bool useForPace,
  }) = DurationDetailConfig;

  /// Distance detail (short: m/yd or long: km/mi).
  @FreezedUnionValue('distance')
  const factory ActivityDetailConfig.distance({
    required String id,
    @Default('') String label,
    @Default(false) bool isShort,
    @Default(50.0) double maxValue,
    @Default(false) bool useForPace,
  }) = DistanceDetailConfig;

  /// Environment detail (indoor/outdoor).
  @FreezedUnionValue('environment')
  const factory ActivityDetailConfig.environment({
    required String id,
    @Default('Environment') String label,
  }) = EnvironmentDetailConfig;

  /// Pace detail (requires duration and distance marked for pace).
  @FreezedUnionValue('pace')
  const factory ActivityDetailConfig.pace({
    required String id,
    @Default(PaceType.minutesPerUom) PaceType paceType,
  }) = PaceDetailConfig;

  factory ActivityDetailConfig.fromJson(Map<String, dynamic> json) => _$ActivityDetailConfigFromJson(json);

  /// Creates a new Number detail with a unique ID.
  static NumberDetailConfig createNumber() => NumberDetailConfig(id: const Uuid().v4());

  /// Creates a new Duration detail with a unique ID.
  static DurationDetailConfig createDuration() => DurationDetailConfig(id: const Uuid().v4());

  /// Creates a new Distance detail with a unique ID.
  static DistanceDetailConfig createDistance() => DistanceDetailConfig(id: const Uuid().v4());

  /// Creates a new Environment detail with a unique ID.
  static EnvironmentDetailConfig createEnvironment() => EnvironmentDetailConfig(id: const Uuid().v4());

  /// Creates a new Pace detail with a unique ID.
  static PaceDetailConfig createPace() => PaceDetailConfig(id: const Uuid().v4());

  /// Returns the display name for this detail type.
  String get typeName => switch (this) {
    NumberDetailConfig() => 'Number',
    DurationDetailConfig() => 'Duration',
    DistanceDetailConfig() => 'Distance',
    EnvironmentDetailConfig() => 'Environment',
    PaceDetailConfig() => 'Pace',
  };

  /// Returns the placeholder hint for the label field.
  String get labelPlaceholder => switch (this) {
    NumberDetailConfig() => 'e.g. Reps, Sets',
    DurationDetailConfig() => 'e.g. Workout Time',
    DistanceDetailConfig() => 'e.g. Running Distance',
    EnvironmentDetailConfig() => 'e.g. Setting',
    PaceDetailConfig() => '',
  };

  /// Returns true if this detail type requires a label.
  bool get requiresLabel => switch (this) {
    PaceDetailConfig() => false,
    _ => true,
  };

  /// Returns true if this detail type is limited to a single instance.
  bool get isSingleInstance => switch (this) {
    EnvironmentDetailConfig() => true,
    PaceDetailConfig() => true,
    _ => false,
  };
}
