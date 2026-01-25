import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/features/subscriptions/domain/entitlement_state.dart';
import 'package:logly/features/subscriptions/domain/feature_code.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entitlement_provider.g.dart';

/// Manages entitlement state with reactive updates from RevenueCat.
///
/// Fetches customer info immediately on init and listens for updates.
/// Automatically rebuilds dependent widgets when entitlements change.
@Riverpod(keepAlive: true)
class EntitlementStateNotifier extends _$EntitlementStateNotifier {
  void Function(CustomerInfo)? _listener;

  @override
  EntitlementState build() {
    _fetchInitial();
    _startListening();
    ref.onDispose(_stopListening);
    return const EntitlementState(); // isLoading: true by default
  }

  Future<void> _fetchInitial() async {
    final logger = ref.read(loggerProvider);
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _updateFromCustomerInfo(customerInfo);
      logger.d('Initial entitlements loaded: ${state.activeEntitlements}');
    } catch (e, st) {
      logger.e('Failed to fetch initial customer info', e, st);
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void _startListening() {
    final logger = ref.read(loggerProvider);
    _listener = (customerInfo) {
      logger.d('Customer info update received');
      _updateFromCustomerInfo(customerInfo);
    };
    Purchases.addCustomerInfoUpdateListener(_listener!);
    logger.d('Started listening to customer info updates');
  }

  void _stopListening() {
    if (_listener != null) {
      Purchases.removeCustomerInfoUpdateListener(_listener!);
      _listener = null;
      ref.read(loggerProvider).d('Stopped listening to customer info updates');
    }
  }

  void _updateFromCustomerInfo(CustomerInfo info) {
    state = EntitlementState(
      isLoading: false,
      activeEntitlements: info.entitlements.active.keys.toSet(),
    );
  }

  /// Manually refreshes entitlements from RevenueCat.
  Future<void> refresh() async {
    final logger = ref.read(loggerProvider);
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _updateFromCustomerInfo(customerInfo);
      logger.d('Entitlements refreshed: ${state.activeEntitlements}');
    } catch (e, st) {
      logger.e('Failed to refresh entitlements', e, st);
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Provides whether the user has access to a specific premium feature.
///
/// This is a convenience provider that derives from the entitlement state.
@riverpod
bool hasFeature(Ref ref, FeatureCode feature) {
  final entitlements = ref.watch(entitlementStateProvider);
  return entitlements.hasFeature(feature);
}

/// Provides whether the user has access to AI Insights.
@riverpod
bool hasAiInsights(Ref ref) {
  return ref.watch(hasFeatureProvider(FeatureCode.aiInsights));
}

/// Provides whether the user can create custom activities.
@riverpod
bool hasCreateCustomActivity(Ref ref) {
  return ref.watch(hasFeatureProvider(FeatureCode.createCustomActivity));
}

/// Provides whether the user can override activity names.
@riverpod
bool hasActivityNameOverride(Ref ref) {
  return ref.watch(hasFeatureProvider(FeatureCode.activityNameOverride));
}

/// Provides whether the user has access to location services.
@riverpod
bool hasLocationServices(Ref ref) {
  return ref.watch(hasFeatureProvider(FeatureCode.locationServices));
}
