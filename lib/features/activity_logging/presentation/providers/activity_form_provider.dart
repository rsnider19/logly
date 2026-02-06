import 'package:flutter/foundation.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_logging/application/activity_logging_service.dart';
import 'package:logly/features/activity_logging/application/location_service.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity_detail.dart';
import 'package:logly/features/activity_logging/domain/environment_type.dart';
import 'package:logly/features/activity_logging/domain/log_multi_day_result.dart';
import 'package:logly/features/activity_logging/domain/update_user_activity.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:logly/features/activity_logging/presentation/providers/pending_save_provider.dart';
import 'package:logly/features/home/presentation/providers/daily_activities_provider.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:logly/features/profile/presentation/providers/contribution_provider.dart';
import 'package:logly/features/profile/presentation/providers/monthly_chart_provider.dart';
import 'package:logly/features/profile/presentation/providers/streak_provider.dart';
import 'package:logly/features/profile/presentation/providers/summary_provider.dart';
import 'package:logly/features/profile/presentation/providers/weekly_radar_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_form_provider.g.dart';

/// Result of form submission.
enum SubmitResult {
  /// All activities were logged successfully.
  success,

  /// Some activities were logged, but some failed (multi-day only).
  partialSuccess,

  /// No activities were logged.
  failure,
}

/// Represents the state of the activity logging form.
@immutable
class ActivityFormState {
  const ActivityFormState({
    required this.activityDate,
    this.activity,
    this.existingUserActivity,
    this.endDate,
    this.comments,
    this.activityNameOverride,
    this.selectedSubActivityIds = const {},
    this.detailValues = const {},
    this.isSubmitting = false,
    this.errorMessage,
    this.multiDayResult,
    this.isMetric = true,
  });

  /// The activity being logged.
  final Activity? activity;

  /// If editing, the existing user activity.
  final UserActivity? existingUserActivity;

  /// The date/time for the activity (start date for multi-day).
  final DateTime activityDate;

  /// End date for multi-day logging (null for single day).
  final DateTime? endDate;

  /// Optional comments/notes.
  final String? comments;

  /// Optional custom name override.
  final String? activityNameOverride;

  /// Selected subactivity IDs.
  final Set<String> selectedSubActivityIds;

  /// Detail values keyed by activityDetailId.
  final Map<String, DetailValue> detailValues;

  /// Whether the form is currently submitting.
  final bool isSubmitting;

  /// Error message if submission failed.
  final String? errorMessage;

  /// Result of multi-day logging (for partial success scenarios).
  final LogMultiDayResult? multiDayResult;

  /// Whether the current unit system is metric (true) or imperial (false).
  final bool isMetric;

  /// Whether this is editing an existing activity.
  bool get isEditing => existingUserActivity != null;

  /// Whether multi-day logging is enabled.
  bool get isMultiDay => endDate != null && !_isSameDay(activityDate, endDate!);

  /// Whether the last submission had partial success.
  bool get hasPartialSuccess => multiDayResult?.isPartialSuccess ?? false;

  /// Creates a copy with updated values.
  ActivityFormState copyWith({
    Activity? activity,
    UserActivity? existingUserActivity,
    DateTime? activityDate,
    DateTime? endDate,
    String? comments,
    String? activityNameOverride,
    Set<String>? selectedSubActivityIds,
    Map<String, DetailValue>? detailValues,
    bool? isSubmitting,
    String? errorMessage,
    LogMultiDayResult? multiDayResult,
    bool? isMetric,
    bool clearError = false,
    bool clearEndDate = false,
    bool clearMultiDayResult = false,
  }) {
    return ActivityFormState(
      activity: activity ?? this.activity,
      existingUserActivity: existingUserActivity ?? this.existingUserActivity,
      activityDate: activityDate ?? this.activityDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      comments: comments ?? this.comments,
      activityNameOverride: activityNameOverride ?? this.activityNameOverride,
      selectedSubActivityIds: selectedSubActivityIds ?? this.selectedSubActivityIds,
      detailValues: detailValues ?? this.detailValues,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      multiDayResult: clearMultiDayResult ? null : (multiDayResult ?? this.multiDayResult),
      isMetric: isMetric ?? this.isMetric,
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Represents a value for an activity detail.
@immutable
class DetailValue {
  const DetailValue({
    required this.activityDetailId,
    required this.type,
    this.textValue,
    this.environmentValue,
    this.numericValue,
    this.durationInSec,
    this.distanceInMeters,
    this.liquidVolumeInLiters,
    this.weightInKilograms,
    this.latLng,
    this.locationId,
  });

  final String activityDetailId;
  final ActivityDetailType type;
  final String? textValue;
  final EnvironmentType? environmentValue;
  final double? numericValue;
  final int? durationInSec;
  final double? distanceInMeters;
  final double? liquidVolumeInLiters;
  final double? weightInKilograms;

  /// @deprecated Use locationId instead.
  final String? latLng;

  /// Google place_id reference to the location table.
  final String? locationId;

  /// Returns true if this detail has a value set.
  bool get hasValue =>
      textValue != null ||
      environmentValue != null ||
      numericValue != null ||
      durationInSec != null ||
      distanceInMeters != null ||
      liquidVolumeInLiters != null ||
      weightInKilograms != null ||
      latLng != null ||
      locationId != null;

  /// Converts to CreateUserActivityDetail for submission.
  CreateUserActivityDetail toCreateDetail() {
    return CreateUserActivityDetail(
      activityDetailId: activityDetailId,
      activityDetailType: type,
      textValue: textValue,
      environmentValue: environmentValue,
      numericValue: numericValue,
      durationInSec: durationInSec,
      distanceInMeters: distanceInMeters,
      liquidVolumeInLiters: liquidVolumeInLiters,
      weightInKilograms: weightInKilograms,
      latLng: latLng,
      locationId: locationId,
    );
  }

  DetailValue copyWith({
    String? textValue,
    EnvironmentType? environmentValue,
    double? numericValue,
    int? durationInSec,
    double? distanceInMeters,
    double? liquidVolumeInLiters,
    double? weightInKilograms,
    String? latLng,
    String? locationId,
    bool clearText = false,
    bool clearEnvironment = false,
    bool clearNumeric = false,
    bool clearDuration = false,
    bool clearDistance = false,
    bool clearLiquidVolume = false,
    bool clearWeight = false,
    bool clearLatLng = false,
    bool clearLocationId = false,
  }) {
    return DetailValue(
      activityDetailId: activityDetailId,
      type: type,
      textValue: clearText ? null : (textValue ?? this.textValue),
      environmentValue: clearEnvironment ? null : (environmentValue ?? this.environmentValue),
      numericValue: clearNumeric ? null : (numericValue ?? this.numericValue),
      durationInSec: clearDuration ? null : (durationInSec ?? this.durationInSec),
      distanceInMeters: clearDistance ? null : (distanceInMeters ?? this.distanceInMeters),
      liquidVolumeInLiters: clearLiquidVolume ? null : (liquidVolumeInLiters ?? this.liquidVolumeInLiters),
      weightInKilograms: clearWeight ? null : (weightInKilograms ?? this.weightInKilograms),
      latLng: clearLatLng ? null : (latLng ?? this.latLng),
      locationId: clearLocationId ? null : (locationId ?? this.locationId),
    );
  }
}

/// State notifier for managing the activity logging form.
@riverpod
class ActivityFormStateNotifier extends _$ActivityFormStateNotifier {
  @override
  ActivityFormState build() {
    return ActivityFormState(activityDate: DateTime.now());
  }

  /// Initializes the form for creating a new activity log.
  void initForCreate(Activity activity, {DateTime? initialDate, bool? isMetric}) {
    state = ActivityFormState(
      activity: activity,
      activityDate: initialDate ?? DateTime.now(),
      detailValues: _initDetailValues(activity.activityDetail),
      isMetric: isMetric ?? true,
    );
  }

  /// Initializes the form for editing an existing activity log.
  void initForEdit(UserActivity userActivity, {bool? isMetric}) {
    final detailValues = <String, DetailValue>{};

    // Populate detail values from existing user activity
    for (final detail in userActivity.userActivityDetail) {
      detailValues[detail.activityDetailId] = DetailValue(
        activityDetailId: detail.activityDetailId,
        type: detail.activityDetailType,
        textValue: detail.textValue,
        environmentValue: detail.environmentValue,
        numericValue: detail.numericValue,
        durationInSec: detail.durationInSec,
        distanceInMeters: detail.distanceInMeters,
        liquidVolumeInLiters: detail.liquidVolumeInLiters,
        weightInKilograms: detail.weightInKilograms,
        latLng: detail.latLng,
        locationId: detail.locationId,
      );
    }

    state = ActivityFormState(
      activity: userActivity.activity,
      existingUserActivity: userActivity,
      activityDate: userActivity.activityTimestamp,
      comments: userActivity.comments,
      activityNameOverride: userActivity.activityNameOverride,
      selectedSubActivityIds: userActivity.subActivity.map((s) => s.subActivityId).toSet(),
      detailValues: detailValues,
      isMetric: isMetric ?? true,
    );
  }

  /// Resets the form to initial state.
  void reset() {
    state = ActivityFormState(activityDate: DateTime.now());
  }

  /// Updates the unit system preference.
  void setIsMetric({required bool isMetric}) {
    state = state.copyWith(isMetric: isMetric);
  }

  /// Updates the activity date.
  void setActivityDate(DateTime date) {
    state = state.copyWith(activityDate: date, clearError: true);
  }

  /// Updates the end date for multi-day logging.
  void setEndDate(DateTime? date) {
    if (date == null) {
      state = state.copyWith(clearEndDate: true, clearError: true);
    } else {
      state = state.copyWith(endDate: date, clearError: true);
    }
  }

  /// Updates the comments.
  void setComments(String? comments) {
    state = state.copyWith(comments: comments, clearError: true);
  }

  /// Updates the activity name override.
  void setActivityNameOverride(String? name) {
    state = state.copyWith(activityNameOverride: name, clearError: true);
  }

  /// Toggles a subactivity selection.
  void toggleSubActivity(String subActivityId) {
    final newSelection = Set<String>.from(state.selectedSubActivityIds);
    if (newSelection.contains(subActivityId)) {
      newSelection.remove(subActivityId);
    } else {
      newSelection.add(subActivityId);
    }
    state = state.copyWith(selectedSubActivityIds: newSelection, clearError: true);
  }

  /// Updates a detail value.
  void setDetailValue(String activityDetailId, DetailValue value) {
    final newValues = Map<String, DetailValue>.from(state.detailValues);
    newValues[activityDetailId] = value;
    state = state.copyWith(detailValues: newValues, clearError: true);
  }

  /// Updates a text detail value.
  void setTextValue(String activityDetailId, String? value) {
    final existing = state.detailValues[activityDetailId];
    if (existing != null) {
      setDetailValue(
        activityDetailId,
        existing.copyWith(textValue: value, clearText: value == null),
      );
    }
  }

  /// Updates an environment detail value.
  void setEnvironmentValue(String activityDetailId, EnvironmentType? value) {
    final existing = state.detailValues[activityDetailId];
    if (existing != null) {
      setDetailValue(
        activityDetailId,
        existing.copyWith(environmentValue: value, clearEnvironment: value == null),
      );
    }
  }

  /// Updates a numeric detail value.
  void setNumericValue(String activityDetailId, double? value) {
    final existing = state.detailValues[activityDetailId];
    if (existing != null) {
      setDetailValue(
        activityDetailId,
        existing.copyWith(numericValue: value, clearNumeric: value == null),
      );
    }
  }

  /// Updates a duration detail value.
  void setDurationValue(String activityDetailId, int? seconds) {
    final existing = state.detailValues[activityDetailId];
    if (existing != null) {
      setDetailValue(
        activityDetailId,
        existing.copyWith(durationInSec: seconds, clearDuration: seconds == null),
      );
    }
  }

  /// Updates a distance detail value.
  void setDistanceValue(String activityDetailId, double? meters) {
    final existing = state.detailValues[activityDetailId];
    if (existing != null) {
      setDetailValue(
        activityDetailId,
        existing.copyWith(distanceInMeters: meters, clearDistance: meters == null),
      );
    }
  }

  /// Updates a liquid volume detail value.
  void setLiquidVolumeValue(String activityDetailId, double? liters) {
    final existing = state.detailValues[activityDetailId];
    if (existing != null) {
      setDetailValue(
        activityDetailId,
        existing.copyWith(liquidVolumeInLiters: liters, clearLiquidVolume: liters == null),
      );
    }
  }

  /// Updates a weight detail value.
  void setWeightValue(String activityDetailId, double? kilograms) {
    final existing = state.detailValues[activityDetailId];
    if (existing != null) {
      setDetailValue(
        activityDetailId,
        existing.copyWith(weightInKilograms: kilograms, clearWeight: kilograms == null),
      );
    }
  }

  /// Updates a location detail value.
  void setLocationValue(String activityDetailId, String? locationId) {
    final existing = state.detailValues[activityDetailId];
    if (existing != null) {
      setDetailValue(
        activityDetailId,
        existing.copyWith(locationId: locationId, clearLocationId: locationId == null),
      );
    }
  }

  /// Refreshes activity-related providers to update home and profile screens.
  Future<void> _refreshActivityProviders() async {
    // Use refresh instead of invalidate to force immediate rebuild
    // This ensures data is loaded even if screens are not mounted

    // First refresh the source providers
    await Future.wait([
      // Home screen
      ref.refresh(dailyActivitiesStateProvider.future),
      // Profile screen - streak card
      ref.refresh(userStatsProvider.future),
      // Profile screen - source for summary
      ref.refresh(periodCategoryCountsProvider.future),
      // Profile screen - source for charts (contribution + monthly)
      ref.refresh(dailyCategoryCountsProvider.future),
      // Profile screen - source for radar chart
      ref.refresh(dowCategoryCountsProvider.future),
    ]);

    // Then refresh the derived providers that widgets watch directly
    // These have keepAlive:true and may not auto-rebuild
    await Future.wait([
      // Summary card watches this
      ref.refresh(categorySummaryProvider.future),
      // Contribution graph watches this
      ref.refresh(contributionDataProvider.future),
      // Weekly radar chart watches normalizedRadarDataProvider
      ref.refresh(normalizedRadarDataProvider.future),
      // Monthly chart watches this
      ref.refresh(filteredMonthlyChartDataProvider.future),
    ]);
  }

  /// Prepares a [PendingSaveRequest] for optimistic saving if applicable.
  ///
  /// Returns `null` if the form is editing, multi-day, or has no activity,
  /// in which case the caller should fall back to the synchronous [submit] flow.
  PendingSaveRequest? prepareOptimisticSave(String userId) {
    if (state.activity == null || state.isEditing || state.isMultiDay) {
      return null;
    }

    final activity = state.activity!;
    final activityDate = DateTime(
      state.activityDate.year,
      state.activityDate.month,
      state.activityDate.day,
    );

    final details = state.detailValues.values.where((d) => d.hasValue).map((d) => d.toCreateDetail()).toList();

    final createUserActivity = CreateUserActivity(
      activityId: activity.activityId,
      activityTimestamp: state.activityDate,
      activityDate: activityDate,
      comments: state.comments,
      activityNameOverride: state.activityNameOverride,
      subActivityIds: state.selectedSubActivityIds.toList(),
      details: details,
    );

    // Resolve selected SubActivity objects from the activity's subactivities
    final selectedSubActivities = activity.subActivity
        .where((s) => state.selectedSubActivityIds.contains(s.subActivityId))
        .toList();

    return PendingSaveRequest(
      activity: activity,
      createUserActivity: createUserActivity,
      userId: userId,
      selectedSubActivities: selectedSubActivities,
    );
  }

  /// Prepares a [PendingUpdateRequest] for optimistic editing if applicable.
  ///
  /// Returns `null` if not editing or has no activity,
  /// in which case the caller should fall back to the synchronous [submit] flow.
  PendingUpdateRequest? prepareOptimisticUpdate() {
    if (!state.isEditing || state.activity == null || state.existingUserActivity == null) {
      return null;
    }

    final activity = state.activity!;
    final existing = state.existingUserActivity!;

    final activityDate = DateTime(
      state.activityDate.year,
      state.activityDate.month,
      state.activityDate.day,
    );

    final details = state.detailValues.values.where((d) => d.hasValue).map((d) => d.toCreateDetail()).toList();

    final updatePayload = UpdateUserActivity(
      userActivityId: existing.userActivityId,
      activityTimestamp: state.activityDate,
      activityDate: activityDate,
      comments: state.comments,
      activityNameOverride: state.activityNameOverride,
      subActivityIds: state.selectedSubActivityIds.toList(),
      details: details,
    );

    // Resolve selected SubActivity objects from the activity's subactivities
    final selectedSubActivities = activity.subActivity
        .where((s) => state.selectedSubActivityIds.contains(s.subActivityId))
        .toList();

    // Build the optimistic entry reflecting edited values
    final optimisticEntry = existing.copyWith(
      activityTimestamp: state.activityDate,
      comments: state.comments,
      activityNameOverride: state.activityNameOverride,
      activity: activity,
      subActivity: selectedSubActivities,
    );

    return PendingUpdateRequest(
      updateUserActivity: updatePayload,
      originalEntry: existing,
      optimisticEntry: optimisticEntry,
    );
  }

  /// Submits the form.
  ///
  /// Returns a [SubmitResult] indicating success, partial success, or failure.
  Future<SubmitResult> submit() async {
    debugPrint('=== FORM PROVIDER: submit() ===');
    debugPrint('activity: ${state.activity?.activityId}');
    debugPrint('activityDate: ${state.activityDate}');
    debugPrint('endDate: ${state.endDate}');
    debugPrint('isEditing: ${state.isEditing}');
    debugPrint('isMultiDay: ${state.isMultiDay}');
    debugPrint('comments: ${state.comments}');
    debugPrint('selectedSubActivityIds: ${state.selectedSubActivityIds}');
    debugPrint('detailValues count: ${state.detailValues.length}');

    if (state.activity == null) {
      debugPrint('ERROR: Activity is null');
      state = state.copyWith(errorMessage: 'Activity must be selected');
      return SubmitResult.failure;
    }

    state = state.copyWith(isSubmitting: true, clearError: true, clearMultiDayResult: true);

    try {
      final service = ref.read(activityLoggingServiceProvider);
      final locationService = ref.read(locationServiceProvider);
      final details = state.detailValues.values.where((d) => d.hasValue).map((d) => d.toCreateDetail()).toList();
      debugPrint('Details with values: ${details.length}');

      // Capture current GPS location silently (for logged_location field)
      final gpsCoords = await locationService.getCurrentLocationIfPermitted();
      debugPrint('GPS coords: ${gpsCoords?.latitude}, ${gpsCoords?.longitude}');

      late SubmitResult result;

      if (state.isEditing) {
        debugPrint('=== UPDATING EXISTING ACTIVITY ===');
        // Update existing activity
        final activityDate = DateTime(
          state.activityDate.year,
          state.activityDate.month,
          state.activityDate.day,
        );

        await service.updateActivity(
          UpdateUserActivity(
            userActivityId: state.existingUserActivity!.userActivityId,
            activityTimestamp: state.activityDate,
            activityDate: activityDate,
            comments: state.comments,
            activityNameOverride: state.activityNameOverride,
            subActivityIds: state.selectedSubActivityIds.toList(),
            details: details,
          ),
        );

        debugPrint('=== UPDATE SUCCESS ===');
        result = SubmitResult.success;
      } else if (state.isMultiDay) {
        debugPrint('=== MULTI-DAY LOGGING ===');
        // Multi-day logging
        final multiDayResult = await service.logMultiDayActivity(
          activityId: state.activity!.activityId,
          startDate: state.activityDate,
          endDate: state.endDate!,
          comments: state.comments,
          activityNameOverride: state.activityNameOverride,
          subActivityIds: state.selectedSubActivityIds.toList(),
          details: details,
          loggedLocationLng: gpsCoords?.longitude,
          loggedLocationLat: gpsCoords?.latitude,
        );

        debugPrint('Multi-day result: ${multiDayResult.successCount} success, ${multiDayResult.failureCount} failures');

        if (multiDayResult.isFullSuccess) {
          state = state.copyWith(isSubmitting: false, multiDayResult: multiDayResult);
          result = SubmitResult.success;
        } else if (multiDayResult.isPartialSuccess) {
          state = state.copyWith(
            isSubmitting: false,
            multiDayResult: multiDayResult,
            errorMessage: '${multiDayResult.failureCount} of ${multiDayResult.totalDays} days failed to log',
          );
          result = SubmitResult.partialSuccess;
        } else {
          state = state.copyWith(
            isSubmitting: false,
            multiDayResult: multiDayResult,
            errorMessage: 'Failed to log activity for all days',
          );
          result = SubmitResult.failure;
        }
      } else {
        debugPrint('=== SINGLE DAY LOGGING ===');
        // Single day logging
        final activityDate = DateTime(
          state.activityDate.year,
          state.activityDate.month,
          state.activityDate.day,
        );

        debugPrint('Calling service.logActivity...');
        debugPrint('activityId: ${state.activity!.activityId}');
        debugPrint('activityTimestamp: ${state.activityDate}');
        debugPrint('activityDate: $activityDate');

        await service.logActivity(
          CreateUserActivity(
            activityId: state.activity!.activityId,
            activityTimestamp: state.activityDate,
            activityDate: activityDate,
            comments: state.comments,
            activityNameOverride: state.activityNameOverride,
            subActivityIds: state.selectedSubActivityIds.toList(),
            details: details,
            loggedLocationLng: gpsCoords?.longitude,
            loggedLocationLat: gpsCoords?.latitude,
          ),
        );

        debugPrint('=== SINGLE DAY SUCCESS ===');
        state = state.copyWith(isSubmitting: false);
        result = SubmitResult.success;
      }

      await _refreshActivityProviders();
      return result;
    } catch (e, st) {
      debugPrint('=== FORM PROVIDER: submit() FAILED ===');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $st');
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
      return SubmitResult.failure;
    }
  }

  /// Gets the detail value for a specific detail ID.
  DetailValue? getDetailValue(String activityDetailId) {
    return state.detailValues[activityDetailId];
  }

  /// Initialize detail values map from activity details.
  Map<String, DetailValue> _initDetailValues(List<ActivityDetail> details) {
    final values = <String, DetailValue>{};
    for (final detail in details) {
      values[detail.activityDetailId] = DetailValue(
        activityDetailId: detail.activityDetailId,
        type: detail.activityDetailType,
      );
    }
    return values;
  }
}
