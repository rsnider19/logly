import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/env_service.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

/// Service for tracking analytics events via Mixpanel.
///
/// Provides typed methods for each event in the taxonomy.
/// Gracefully no-ops when Mixpanel token is not configured.
class AnalyticsService {
  AnalyticsService(this._logger);

  final LoggerService _logger;
  Mixpanel? _mixpanel;
  bool _initialized = false;

  /// Whether the service has been initialized.
  bool get isInitialized => _initialized;

  // ==================== Initialization ====================

  /// Initializes Mixpanel with the token from environment.
  ///
  /// Must be called during bootstrap before GrowthBook setup
  /// so the experiment tracking callback can reference this service.
  Future<void> initialize() async {
    if (_initialized) return;

    final token = EnvService.mixpanelToken;
    if (token == null || token.isEmpty) {
      _logger.w('AnalyticsService: No MIXPANEL_TOKEN found, analytics disabled');
      return;
    }

    _mixpanel = await Mixpanel.init(
      token,
      trackAutomaticEvents: false,
    );

    // Set super properties (attached to every event)
    final packageInfo = await PackageInfo.fromPlatform();
    _mixpanel!.registerSuperProperties({
      'platform': Platform.operatingSystem,
      'app_version': packageInfo.version,
      'build_number': packageInfo.buildNumber,
      'environment': EnvService.environment.name,
    });

    _initialized = true;
    _logger.i('AnalyticsService: Initialized');
  }

  // ==================== Identity ====================

  /// Identifies the user after sign-in.
  void identify(String userId) {
    _mixpanel?.identify(userId);
    _logger.d('AnalyticsService: Identified user $userId');
  }

  /// Resets Mixpanel identity on sign-out.
  void reset() {
    _mixpanel?.reset();
    _logger.d('AnalyticsService: Reset identity');
  }

  /// Sets user profile properties (People profile).
  void setUserProperties(Map<String, dynamic> properties) {
    final people = _mixpanel?.getPeople();
    if (people != null) {
      for (final entry in properties.entries) {
        people.set(entry.key, entry.value);
      }
    }
  }

  /// Updates a super property (attached to all future events).
  void setSuperProperty(String key, dynamic value) {
    _mixpanel?.registerSuperProperties({key: value});
  }

  // ==================== Generic track (internal) ====================

  void _track(String eventName, [Map<String, dynamic>? properties]) {
    if (!_initialized) return;
    _mixpanel?.track(eventName, properties: properties);
    if (kDebugMode) {
      _logger.d('Analytics: $eventName ${properties ?? ''}');
    }
  }

  // ==================== Lifecycle Events ====================

  void trackAppOpened({required String source}) {
    _track('App Opened', {'source': source});
  }

  void trackSignUpCompleted({required String authProvider}) {
    _track('Sign Up Completed', {'auth_provider': authProvider});
  }

  void trackSignInCompleted({required String authProvider}) {
    _track('Sign In Completed', {'auth_provider': authProvider});
  }

  void trackSignOutCompleted() {
    _track('Sign Out Completed');
  }

  // ==================== Onboarding Events ====================

  void trackOnboardingStepCompleted({
    required String stepName,
    required int stepNumber,
    required bool skipped,
  }) {
    _track('Onboarding Step Completed', {
      'step_name': stepName,
      'step_number': stepNumber,
      'skipped': skipped,
    });
  }

  void trackOnboardingCompleted({
    required int favoritesCount,
    required bool healthPermissionGranted,
  }) {
    _track('Onboarding Completed', {
      'favorites_count': favoritesCount,
      'health_permission_granted': healthPermissionGranted,
    });
  }

  // ==================== Core Engagement Events ====================

  void trackActivityLogged({
    required String category,
    required String activityName,
    required bool isCustom,
    required bool isHealthSync,
    required bool hasNotes,
    required List<String> detailTypes,
    required String entryPoint,
  }) {
    _track('Activity Logged', {
      'category': category,
      'activity_name': activityName,
      'is_custom': isCustom,
      'is_health_sync': isHealthSync,
      'has_notes': hasNotes,
      'detail_types': detailTypes,
      'entry_point': entryPoint,
    });
  }

  void trackActivityEdited({
    required String category,
    required String activityName,
  }) {
    _track('Activity Edited', {
      'category': category,
      'activity_name': activityName,
    });
  }

  void trackActivityDeleted({
    required String category,
    required String activityName,
  }) {
    _track('Activity Deleted', {
      'category': category,
      'activity_name': activityName,
    });
  }

  void trackCustomActivityCreated({
    required String category,
    required int detailCount,
  }) {
    _track('Custom Activity Created', {
      'category': category,
      'detail_count': detailCount,
    });
  }

  void trackFavoriteToggled({
    required String activityName,
    required String category,
    required bool isFavorited,
  }) {
    _track('Favorite Toggled', {
      'activity_name': activityName,
      'category': category,
      'is_favorited': isFavorited,
    });
  }

  void trackActivitySearchPerformed({
    required String query,
    required int resultCount,
  }) {
    _track('Activity Search Performed', {
      'query': query,
      'result_count': resultCount,
    });
  }

  // ==================== Discovery Events ====================

  void trackTrendingSheetOpened() {
    _track('Trending Sheet Opened');
  }

  void trackCategoryBrowsed({required String categoryName}) {
    _track('Category Browsed', {'category_name': categoryName});
  }

  void trackStreakCardTapped({required String cardType}) {
    _track('Streak Card Tapped', {'card_type': cardType});
  }

  // ==================== Health Integration Events ====================

  void trackHealthSyncStarted({required String platform}) {
    _track('Health Sync Started', {'platform': platform});
  }

  void trackHealthSyncCompleted({
    required String platform,
    required int activitiesSyncedCount,
    required int durationSeconds,
  }) {
    _track('Health Sync Completed', {
      'platform': platform,
      'activities_synced_count': activitiesSyncedCount,
      'duration_seconds': durationSeconds,
    });
  }

  void trackHealthSyncFailed({
    required String platform,
    required String errorType,
  }) {
    _track('Health Sync Failed', {
      'platform': platform,
      'error_type': errorType,
    });
  }

  void trackHealthPermissionRequested({required String platform}) {
    _track('Health Permission Requested', {'platform': platform});
  }

  void trackHealthPermissionGranted({required String platform}) {
    _track('Health Permission Granted', {'platform': platform});
  }

  void trackHealthPermissionDenied({required String platform}) {
    _track('Health Permission Denied', {'platform': platform});
  }

  // ==================== AI Chat Events ====================

  void trackChatMessageSent({
    required bool isNewConversation,
    required int conversationMessageCount,
  }) {
    _track('Chat Message Sent', {
      'is_new_conversation': isNewConversation,
      'conversation_message_count': conversationMessageCount,
    });
  }

  void trackChatResponseReceived({
    required bool hasSuggestions,
    required int responseDurationSeconds,
  }) {
    _track('Chat Response Received', {
      'has_suggestions': hasSuggestions,
      'response_duration_seconds': responseDurationSeconds,
    });
  }

  // ==================== Monetization Events ====================

  void trackSubscriptionViewed({required String source}) {
    _track('Subscription Viewed', {'source': source});
  }

  // ==================== Navigation & Feature Usage Events ====================

  void trackScreenViewed({required String screenName}) {
    _track('Screen Viewed', {'screen_name': screenName});
  }

  void trackProfileFilterChanged({
    required String filterType,
    required String value,
  }) {
    _track('Profile Filter Changed', {
      'filter_type': filterType,
      'value': value,
    });
  }

  void trackProfileStatsViewed({required String timeRange}) {
    _track('Profile Stats Viewed', {'time_range': timeRange});
  }

  void trackActivityStatsViewed({
    required String activityName,
    required String category,
  }) {
    _track('Activity Stats Viewed', {
      'activity_name': activityName,
      'category': category,
    });
  }

  // ==================== Experimentation Events ====================

  void trackExperimentViewed({
    required String experimentKey,
    required int variationId,
    required String variationKey,
  }) {
    _track('Experiment Viewed', {
      'experiment_key': experimentKey,
      'variation_id': variationId,
      'variation_key': variationKey,
    });
  }
}

/// Provides the analytics service singleton.
@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService(ref.watch(loggerProvider));
}
