import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';
import 'package:logly/core/providers/growthbook_provider.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_flag_service.g.dart';

/// Service for evaluating feature flags via GrowthBook.
///
/// Wraps the GrowthBook SDK to provide typed access to feature flags
/// and manages user attribute updates.
class FeatureFlagService {
  FeatureFlagService(this._sdk, this._logger);

  final GrowthBookSDK _sdk;
  final LoggerService _logger;

  /// Checks whether a feature flag is enabled (on/off).
  bool isOn(String featureKey) {
    final result = _sdk.feature(featureKey);
    _logger.d('Feature flag "$featureKey": on=${result.on}');
    return result.on ?? false;
  }

  /// Gets the value of a feature flag.
  ///
  /// Returns [defaultValue] if the flag is not found or has no value.
  T getValue<T>(String featureKey, T defaultValue) {
    final result = _sdk.feature(featureKey);
    final value = result.value;
    if (value is T) {
      return value;
    }
    return defaultValue;
  }

  /// Gets the raw [GBFeatureResult] for a feature flag.
  GBFeatureResult evalFeature(String featureKey) {
    return _sdk.feature(featureKey);
  }

  /// Returns all currently loaded features.
  ///
  /// Useful for the developer debug screen.
  dynamic getAllFeatures() {
    return _sdk.features;
  }

  /// Updates user targeting attributes on the GrowthBook SDK.
  ///
  /// Called when auth state changes (sign-in adds user attributes,
  /// sign-out removes them).
  Future<void> updateAttributes(Map<String, dynamic> attributes) async {
    _logger.i('FeatureFlagService: Updating attributes: ${attributes.keys.toList()}');
    _sdk.setAttributes(attributes);
    await _sdk.refresh();
    _logger.i('FeatureFlagService: Attributes updated and cache refreshed');
  }

  /// Builds the base (anonymous) attribute map.
  ///
  /// These attributes are available before the user signs in.
  static Map<String, dynamic> buildAnonymousAttributes({
    required String appVersion,
    required String buildNumber,
    required String environment,
  }) {
    return {
      'platform': Platform.isIOS ? 'ios' : 'android',
      'appVersion': appVersion,
      'buildNumber': buildNumber,
      'environment': environment,
      'isDebug': kDebugMode,
    };
  }

  /// Builds the authenticated attribute map.
  ///
  /// Merges anonymous attributes with user-specific targeting data.
  static Map<String, dynamic> buildAuthenticatedAttributes({
    required String userId,
    required String? email,
    required String appVersion,
    required String buildNumber,
    required String environment,
    bool isPro = false,
  }) {
    return {
      ...buildAnonymousAttributes(
        appVersion: appVersion,
        buildNumber: buildNumber,
        environment: environment,
      ),
      'id': userId,
      if (email != null) 'email': email,
      'subscriptionPlan': isPro ? 'pro' : 'free',
    };
  }
}

/// Provides the feature flag service instance.
@Riverpod(keepAlive: true)
FeatureFlagService featureFlagService(Ref ref) {
  return FeatureFlagService(
    ref.watch(growthBookProvider),
    ref.watch(loggerProvider),
  );
}
