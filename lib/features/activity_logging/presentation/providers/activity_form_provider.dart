import 'package:flutter/foundation.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_logging/application/activity_logging_service.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity_detail.dart';
import 'package:logly/features/activity_logging/domain/environment_type.dart';
import 'package:logly/features/activity_logging/domain/update_user_activity.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_form_provider.g.dart';

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

  /// Whether this is editing an existing activity.
  bool get isEditing => existingUserActivity != null;

  /// Whether multi-day logging is enabled.
  bool get isMultiDay => endDate != null && !_isSameDay(activityDate, endDate!);

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
    bool clearError = false,
    bool clearEndDate = false,
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
  final String? latLng;

  /// Returns true if this detail has a value set.
  bool get hasValue =>
      textValue != null ||
      environmentValue != null ||
      numericValue != null ||
      durationInSec != null ||
      distanceInMeters != null ||
      liquidVolumeInLiters != null ||
      weightInKilograms != null ||
      latLng != null;

  /// Converts to CreateUserActivityDetail for submission.
  CreateUserActivityDetail toCreateDetail() {
    return CreateUserActivityDetail(
      activityDetailId: activityDetailId,
      textValue: textValue,
      environmentValue: environmentValue,
      numericValue: numericValue,
      durationInSec: durationInSec,
      distanceInMeters: distanceInMeters,
      liquidVolumeInLiters: liquidVolumeInLiters,
      weightInKilograms: weightInKilograms,
      latLng: latLng,
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
    bool clearText = false,
    bool clearEnvironment = false,
    bool clearNumeric = false,
    bool clearDuration = false,
    bool clearDistance = false,
    bool clearLiquidVolume = false,
    bool clearWeight = false,
    bool clearLatLng = false,
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
  void initForCreate(Activity activity, {DateTime? initialDate}) {
    state = ActivityFormState(
      activity: activity,
      activityDate: initialDate ?? DateTime.now(),
      detailValues: _initDetailValues(activity.activityDetail),
    );
  }

  /// Initializes the form for editing an existing activity log.
  void initForEdit(UserActivity userActivity) {
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
    );
  }

  /// Resets the form to initial state.
  void reset() {
    state = ActivityFormState(activityDate: DateTime.now());
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

  /// Submits the form.
  Future<bool> submit() async {
    if (state.activity == null) {
      state = state.copyWith(errorMessage: 'Activity must be selected');
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final service = ref.read(activityLoggingServiceProvider);
      final details = state.detailValues.values.where((d) => d.hasValue).map((d) => d.toCreateDetail()).toList();

      if (state.isEditing) {
        // Update existing activity
        await service.updateActivity(
          UpdateUserActivity(
            userActivityId: state.existingUserActivity!.userActivityId,
            activityTimestamp: state.activityDate,
            comments: state.comments,
            activityNameOverride: state.activityNameOverride,
            subActivityIds: state.selectedSubActivityIds.toList(),
            details: details,
          ),
        );
      } else {
        // Create new activity
        await service.logActivity(
          CreateUserActivity(
            activityId: state.activity!.activityId,
            activityStartDate: state.activityDate,
            activityEndDate: state.endDate ?? state.activityDate,
            comments: state.comments,
            activityNameOverride: state.activityNameOverride,
            subActivityIds: state.selectedSubActivityIds.toList(),
            details: details,
          ),
        );
      }

      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
      return false;
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
