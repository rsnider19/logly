import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/analytics_service.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/subscriptions/data/subscription_repository.dart';
import 'package:logly/features/subscriptions/domain/feature_code.dart';
import 'package:logly/features/subscriptions/domain/subscription_exception.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_service_provider.g.dart';

/// Service for subscription business logic.
///
/// Coordinates repository calls and provides feature access control.
class SubscriptionService {
  SubscriptionService(this._repository, this._logger, this._analytics);

  final SubscriptionRepository _repository;
  final LoggerService _logger;
  final AnalyticsService _analytics;

  /// Checks if the current user has access to a specific premium feature.
  ///
  /// Returns true if the user has an active entitlement that includes the feature.
  Future<bool> hasFeature(FeatureCode feature) async {
    try {
      return await _repository.hasFeature(feature);
    } on SubscriptionException {
      // On error, deny access for safety
      _logger.w('Entitlement check failed for ${feature.value}, denying access');
      return false;
    }
  }

  /// Gets all active entitlements for the current user.
  Future<Map<String, EntitlementInfo>> getActiveEntitlements() async {
    final customerInfo = await _repository.getCustomerInfo();
    return customerInfo.entitlements.active;
  }

  /// Shows the paywall and returns true if a purchase was made.
  Future<bool> showPaywall({String source = 'unknown'}) async {
    _analytics.trackSubscriptionViewed(source: source);
    return _repository.showPaywall();
  }

  /// Restores previous purchases.
  ///
  /// Returns true if any entitlements are now active.
  Future<bool> restorePurchases() async {
    final customerInfo = await _repository.restorePurchases();
    return customerInfo.entitlements.active.isNotEmpty;
  }
}

/// Provides the subscription service instance.
@Riverpod(keepAlive: true)
SubscriptionService subscriptionService(Ref ref) {
  return SubscriptionService(
    ref.watch(subscriptionRepositoryProvider),
    ref.watch(loggerProvider),
    ref.watch(analyticsServiceProvider),
  );
}
