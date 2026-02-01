// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pace_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Calculates pace based on duration and distance.
///
/// Parameters:
/// - [durationInSeconds]: Total duration in seconds
/// - [distanceInMeters]: Total distance in meters
/// - [paceType]: The type of pace calculation to perform
/// - [isMetric]: Whether to use metric units (km) or imperial (miles)

@ProviderFor(calculatePace)
final calculatePaceProvider = CalculatePaceFamily._();

/// Calculates pace based on duration and distance.
///
/// Parameters:
/// - [durationInSeconds]: Total duration in seconds
/// - [distanceInMeters]: Total distance in meters
/// - [paceType]: The type of pace calculation to perform
/// - [isMetric]: Whether to use metric units (km) or imperial (miles)

final class CalculatePaceProvider
    extends $FunctionalProvider<PaceResult?, PaceResult?, PaceResult?>
    with $Provider<PaceResult?> {
  /// Calculates pace based on duration and distance.
  ///
  /// Parameters:
  /// - [durationInSeconds]: Total duration in seconds
  /// - [distanceInMeters]: Total distance in meters
  /// - [paceType]: The type of pace calculation to perform
  /// - [isMetric]: Whether to use metric units (km) or imperial (miles)
  CalculatePaceProvider._({
    required CalculatePaceFamily super.from,
    required ({
      int? durationInSeconds,
      double? distanceInMeters,
      PaceType? paceType,
      bool isMetric,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'calculatePaceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$calculatePaceHash();

  @override
  String toString() {
    return r'calculatePaceProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<PaceResult?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaceResult? create(Ref ref) {
    final argument =
        this.argument
            as ({
              int? durationInSeconds,
              double? distanceInMeters,
              PaceType? paceType,
              bool isMetric,
            });
    return calculatePace(
      ref,
      durationInSeconds: argument.durationInSeconds,
      distanceInMeters: argument.distanceInMeters,
      paceType: argument.paceType,
      isMetric: argument.isMetric,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaceResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaceResult?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CalculatePaceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$calculatePaceHash() => r'1c38be9b83ca394bbe62c7f6345959f1be89daa3';

/// Calculates pace based on duration and distance.
///
/// Parameters:
/// - [durationInSeconds]: Total duration in seconds
/// - [distanceInMeters]: Total distance in meters
/// - [paceType]: The type of pace calculation to perform
/// - [isMetric]: Whether to use metric units (km) or imperial (miles)

final class CalculatePaceFamily extends $Family
    with
        $FunctionalFamilyOverride<
          PaceResult?,
          ({
            int? durationInSeconds,
            double? distanceInMeters,
            PaceType? paceType,
            bool isMetric,
          })
        > {
  CalculatePaceFamily._()
    : super(
        retry: null,
        name: r'calculatePaceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Calculates pace based on duration and distance.
  ///
  /// Parameters:
  /// - [durationInSeconds]: Total duration in seconds
  /// - [distanceInMeters]: Total distance in meters
  /// - [paceType]: The type of pace calculation to perform
  /// - [isMetric]: Whether to use metric units (km) or imperial (miles)

  CalculatePaceProvider call({
    required int? durationInSeconds,
    required double? distanceInMeters,
    required PaceType? paceType,
    required bool isMetric,
  }) => CalculatePaceProvider._(
    argument: (
      durationInSeconds: durationInSeconds,
      distanceInMeters: distanceInMeters,
      paceType: paceType,
      isMetric: isMetric,
    ),
    from: this,
  );

  @override
  String toString() => r'calculatePaceProvider';
}

/// Calculates speed based on duration and distance.
///
/// Returns speed in km/h or mph depending on [isMetric].

@ProviderFor(calculateSpeed)
final calculateSpeedProvider = CalculateSpeedFamily._();

/// Calculates speed based on duration and distance.
///
/// Returns speed in km/h or mph depending on [isMetric].

final class CalculateSpeedProvider
    extends $FunctionalProvider<double?, double?, double?>
    with $Provider<double?> {
  /// Calculates speed based on duration and distance.
  ///
  /// Returns speed in km/h or mph depending on [isMetric].
  CalculateSpeedProvider._({
    required CalculateSpeedFamily super.from,
    required ({int? durationInSeconds, double? distanceInMeters, bool isMetric})
    super.argument,
  }) : super(
         retry: null,
         name: r'calculateSpeedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$calculateSpeedHash();

  @override
  String toString() {
    return r'calculateSpeedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<double?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double? create(Ref ref) {
    final argument =
        this.argument
            as ({
              int? durationInSeconds,
              double? distanceInMeters,
              bool isMetric,
            });
    return calculateSpeed(
      ref,
      durationInSeconds: argument.durationInSeconds,
      distanceInMeters: argument.distanceInMeters,
      isMetric: argument.isMetric,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CalculateSpeedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$calculateSpeedHash() => r'7e6ad69bda39585b513159ba39152e15ec7e8e19';

/// Calculates speed based on duration and distance.
///
/// Returns speed in km/h or mph depending on [isMetric].

final class CalculateSpeedFamily extends $Family
    with
        $FunctionalFamilyOverride<
          double?,
          ({int? durationInSeconds, double? distanceInMeters, bool isMetric})
        > {
  CalculateSpeedFamily._()
    : super(
        retry: null,
        name: r'calculateSpeedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Calculates speed based on duration and distance.
  ///
  /// Returns speed in km/h or mph depending on [isMetric].

  CalculateSpeedProvider call({
    required int? durationInSeconds,
    required double? distanceInMeters,
    required bool isMetric,
  }) => CalculateSpeedProvider._(
    argument: (
      durationInSeconds: durationInSeconds,
      distanceInMeters: distanceInMeters,
      isMetric: isMetric,
    ),
    from: this,
  );

  @override
  String toString() => r'calculateSpeedProvider';
}
