import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for subscription-related errors.
abstract class SubscriptionException extends AppException {
  const SubscriptionException(super.message, [super.technicalDetails]);
}

/// Thrown when RevenueCat SDK configuration fails.
class SubscriptionConfigurationException extends SubscriptionException {
  const SubscriptionConfigurationException([String? technicalDetails])
      : super('Failed to initialize subscription service', technicalDetails);
}

/// Thrown when login to RevenueCat fails.
class SubscriptionLoginException extends SubscriptionException {
  const SubscriptionLoginException([String? technicalDetails])
      : super('Failed to sync subscription status', technicalDetails);
}

/// Thrown when checking entitlements fails.
class SubscriptionEntitlementException extends SubscriptionException {
  const SubscriptionEntitlementException([String? technicalDetails])
      : super('Failed to check subscription status', technicalDetails);
}

/// Thrown when displaying the paywall fails.
class SubscriptionPaywallException extends SubscriptionException {
  const SubscriptionPaywallException([String? technicalDetails])
      : super('Failed to display subscription options', technicalDetails);
}

/// Thrown when restoring purchases fails.
class SubscriptionRestoreException extends SubscriptionException {
  const SubscriptionRestoreException([String? technicalDetails])
      : super('Failed to restore purchases', technicalDetails);
}
