import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/subscriptions/domain/feature_code.dart';

part 'entitlement_state.freezed.dart';
part 'entitlement_state.g.dart';

/// Represents the current state of user entitlements.
@freezed
abstract class EntitlementState with _$EntitlementState {
  const factory EntitlementState({
    @Default(true) bool isLoading,
    @Default({}) Set<String> activeEntitlements,
    String? error,
  }) = _EntitlementState;
  const EntitlementState._();

  factory EntitlementState.fromJson(Map<String, dynamic> json) => _$EntitlementStateFromJson(json);

  /// Whether the user has the pro subscription.
  bool get isPro => activeEntitlements.contains(FeatureCode.pro.value);

  /// Checks if the user has access to a specific feature.
  ///
  /// Returns true if the user has either:
  /// - The specific feature entitlement, OR
  /// - The `logly-pro` entitlement (which grants all features)
  bool hasFeature(FeatureCode feature) =>
      activeEntitlements.contains(feature.value) || activeEntitlements.contains(FeatureCode.pro.value);
}
