import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/env_service.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/subscriptions/domain/feature_code.dart';
import 'package:logly/features/subscriptions/domain/subscription_exception.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_repository.g.dart';

/// Repository for RevenueCat SDK interactions.
///
/// Handles direct SDK operations - no business logic, just data access.
class SubscriptionRepository {
  SubscriptionRepository(this._logger);

  final LoggerService _logger;

  /// Configures the RevenueCat SDK with the API key.
  ///
  /// Should be called once during app bootstrap.
  Future<void> configure() async {
    try {
      await Purchases.configure(PurchasesConfiguration(EnvService.revenueCatApiKey));

      _logger.i('RevenueCat configured');
    } catch (e, st) {
      _logger.e('Failed to configure RevenueCat', e, st);
      throw SubscriptionConfigurationException(e.toString());
    }
  }

  /// Logs in a user to RevenueCat after Supabase authentication.
  ///
  /// This associates the RevenueCat customer with the Supabase user ID.
  Future<void> loginUser(String userId, String? email) async {
    try {
      await Purchases.logIn(userId);

      // Set email attribute for customer support
      if (email != null && email.isNotEmpty) {
        await Purchases.setEmail(email);
      }

      _logger.i('RevenueCat user logged in: $userId');
    } catch (e, st) {
      _logger.e('Failed to log in to RevenueCat', e, st);
      throw SubscriptionLoginException(e.toString());
    }
  }

  /// Logs out the current user from RevenueCat.
  ///
  /// This resets the customer to an anonymous user.
  Future<void> logoutUser() async {
    try {
      final isAnonymous = await Purchases.isAnonymous;
      if (!isAnonymous) {
        await Purchases.logOut();
        _logger.i('RevenueCat user logged out');
      }
    } catch (e, st) {
      _logger.e('Failed to log out from RevenueCat', e, st);
      // Don't throw on logout failure - not critical
    }
  }

  /// Checks if the current user has access to a specific feature.
  ///
  /// Returns true if the user has either:
  /// - The specific feature entitlement, OR
  /// - The `logly-pro` entitlement (which grants all features)
  Future<bool> hasFeature(FeatureCode feature) async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final activeEntitlements = customerInfo.entitlements.active;

      _logger.d('Checking feature: ${feature.value}');
      _logger.d('Active entitlements: ${activeEntitlements.keys.toList()}');

      // Check for specific feature OR the pro entitlement (grants all)
      final hasAccess = activeEntitlements.containsKey(feature.value) ||
          activeEntitlements.containsKey(FeatureCode.pro.value);
      _logger.d('Has access to ${feature.value}: $hasAccess');

      return hasAccess;
    } catch (e, st) {
      _logger.e('Failed to check entitlement for ${feature.value}', e, st);
      throw SubscriptionEntitlementException(e.toString());
    }
  }

  /// Gets the current customer info from RevenueCat.
  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e, st) {
      _logger.e('Failed to get customer info', e, st);
      throw SubscriptionEntitlementException(e.toString());
    }
  }

  /// Displays the RevenueCat paywall UI.
  ///
  /// Returns true if a purchase was made, false otherwise.
  Future<bool> showPaywall() async {
    try {
      final result = await RevenueCatUI.presentPaywall();
      _logger.d('Paywall result: $result');
      return result == PaywallResult.purchased || result == PaywallResult.restored;
    } catch (e, st) {
      _logger.e('Failed to display paywall', e, st);
      throw SubscriptionPaywallException(e.toString());
    }
  }

  /// Restores previous purchases.
  Future<CustomerInfo> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      _logger.i('Purchases restored');
      return customerInfo;
    } catch (e, st) {
      _logger.e('Failed to restore purchases', e, st);
      throw SubscriptionRestoreException(e.toString());
    }
  }
}

/// Provides the subscription repository instance.
@Riverpod(keepAlive: true)
SubscriptionRepository subscriptionRepository(Ref ref) {
  return SubscriptionRepository(ref.watch(loggerProvider));
}
