import 'package:flutter/foundation.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/pace_type.dart';
import 'package:logly/features/custom_activity/application/custom_activity_service.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_custom_activity_form_provider.g.dart';

/// State for the create custom activity form.
@immutable
class CreateCustomActivityFormState {
  const CreateCustomActivityFormState({
    this.categoryId,
    this.name = '',
    this.details = const [],
    this.isSaving = false,
    this.error,
    this.createdActivity,
  });

  /// Selected category ID.
  final String? categoryId;

  /// Activity name.
  final String name;

  /// List of detail configurations.
  final List<ActivityDetailConfig> details;

  /// Whether the form is currently saving.
  final bool isSaving;

  /// Error message if save failed.
  final String? error;

  /// The created activity after successful save.
  final Activity? createdActivity;

  /// Whether the form has been modified from its initial state.
  bool get isDirty => categoryId != null || name.isNotEmpty || details.isNotEmpty;

  /// Whether an Environment detail already exists.
  bool get hasEnvironment => details.any((d) => d is EnvironmentDetailConfig);

  /// Whether a Pace detail already exists.
  bool get hasPace => details.any((d) => d is PaceDetailConfig);

  /// Whether the detail limit (10) has been reached.
  bool get isAtDetailLimit => details.length >= 10;

  /// Whether a Duration detail is marked for pace calculation.
  bool get hasDurationForPace => details.any((d) => d is DurationDetailConfig && d.useForPace);

  /// Whether a Distance detail is marked for pace calculation.
  bool get hasDistanceForPace => details.any((d) => d is DistanceDetailConfig && d.useForPace);

  /// Whether pace dependencies are met.
  bool get arePaceDependenciesMet => hasDurationForPace && hasDistanceForPace;

  CreateCustomActivityFormState copyWith({
    String? categoryId,
    String? name,
    List<ActivityDetailConfig>? details,
    bool? isSaving,
    String? error,
    Activity? createdActivity,
    bool clearError = false,
    bool clearCategory = false,
    bool clearCreatedActivity = false,
  }) {
    return CreateCustomActivityFormState(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      name: name ?? this.name,
      details: details ?? this.details,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
      createdActivity: clearCreatedActivity ? null : (createdActivity ?? this.createdActivity),
    );
  }
}

/// State notifier for managing the create custom activity form.
@riverpod
class CreateCustomActivityFormStateNotifier extends _$CreateCustomActivityFormStateNotifier {
  @override
  CreateCustomActivityFormState build() {
    return const CreateCustomActivityFormState();
  }

  /// Initializes the form with an optional pre-populated name.
  void init({String? initialName}) {
    state = CreateCustomActivityFormState(name: initialName ?? '');
  }

  /// Sets the selected category ID.
  void setCategory(String? categoryId) {
    state = state.copyWith(categoryId: categoryId, clearError: true);
  }

  /// Sets the activity name.
  void setName(String name) {
    state = state.copyWith(name: name, clearError: true);
  }

  /// Adds a new detail of the specified type.
  void addDetail(ActivityDetailConfig detail) {
    if (state.isAtDetailLimit) return;

    // Don't allow duplicate single-instance types
    if (detail is EnvironmentDetailConfig && state.hasEnvironment) return;
    if (detail is PaceDetailConfig && state.hasPace) return;

    state = state.copyWith(
      details: [...state.details, detail],
      clearError: true,
    );
  }

  /// Removes a detail by its ID.
  void removeDetail(String detailId) {
    state = state.copyWith(
      details: state.details.where((d) => d.id != detailId).toList(),
      clearError: true,
    );
  }

  /// Reorders details by moving the item at [oldIndex] to [newIndex].
  void reorderDetails(int oldIndex, int newIndex) {
    final details = List<ActivityDetailConfig>.from(state.details);
    var adjustedNewIndex = newIndex;
    if (oldIndex < adjustedNewIndex) {
      adjustedNewIndex -= 1;
    }
    final item = details.removeAt(oldIndex);
    details.insert(adjustedNewIndex, item);
    state = state.copyWith(details: details, clearError: true);
  }

  /// Updates a detail by its ID.
  void updateDetail(String detailId, ActivityDetailConfig Function(ActivityDetailConfig) updater) {
    state = state.copyWith(
      details: state.details.map((d) => d.id == detailId ? updater(d) : d).toList(),
      clearError: true,
    );
  }

  /// Updates a Number detail's label.
  void updateNumberLabel(String detailId, String label) {
    updateDetail(detailId, (d) {
      if (d is NumberDetailConfig) {
        return d.copyWith(label: label);
      }
      return d;
    });
  }

  /// Updates a Number detail's isInteger flag.
  void updateNumberIsInteger(String detailId, {required bool isInteger}) {
    updateDetail(detailId, (d) {
      if (d is NumberDetailConfig) {
        return d.copyWith(isInteger: isInteger);
      }
      return d;
    });
  }

  /// Updates a Number detail's max value.
  void updateNumberMaxValue(String detailId, double maxValue) {
    updateDetail(detailId, (d) {
      if (d is NumberDetailConfig) {
        return d.copyWith(maxValue: maxValue);
      }
      return d;
    });
  }

  /// Updates a Duration detail's label.
  void updateDurationLabel(String detailId, String label) {
    updateDetail(detailId, (d) {
      if (d is DurationDetailConfig) {
        return d.copyWith(label: label);
      }
      return d;
    });
  }

  /// Updates a Duration detail's max seconds.
  void updateDurationMaxSeconds(String detailId, int maxSeconds) {
    updateDetail(detailId, (d) {
      if (d is DurationDetailConfig) {
        return d.copyWith(maxSeconds: maxSeconds);
      }
      return d;
    });
  }

  /// Updates a Duration detail's useForPace flag.
  void updateDurationUseForPace(String detailId, {required bool useForPace}) {
    // If enabling, disable all other durations
    if (useForPace) {
      state = state.copyWith(
        details: state.details.map((d) {
          if (d is DurationDetailConfig) {
            return d.copyWith(useForPace: d.id == detailId);
          }
          return d;
        }).toList(),
        clearError: true,
      );
    } else {
      updateDetail(detailId, (d) {
        if (d is DurationDetailConfig) {
          return d.copyWith(useForPace: false);
        }
        return d;
      });
    }
  }

  /// Updates a Distance detail's label.
  void updateDistanceLabel(String detailId, String label) {
    updateDetail(detailId, (d) {
      if (d is DistanceDetailConfig) {
        return d.copyWith(label: label);
      }
      return d;
    });
  }

  /// Updates a Distance detail's isShort flag.
  void updateDistanceIsShort(String detailId, {required bool isShort}) {
    updateDetail(detailId, (d) {
      if (d is DistanceDetailConfig) {
        // Update max value to default for the new type
        final newMax = isShort ? 1000.0 : 50.0;
        return d.copyWith(isShort: isShort, maxValue: newMax);
      }
      return d;
    });
  }

  /// Updates a Distance detail's max value.
  void updateDistanceMaxValue(String detailId, double maxValue) {
    updateDetail(detailId, (d) {
      if (d is DistanceDetailConfig) {
        return d.copyWith(maxValue: maxValue);
      }
      return d;
    });
  }

  /// Updates a Distance detail's useForPace flag.
  void updateDistanceUseForPace(String detailId, {required bool useForPace}) {
    // If enabling, disable all other distances
    if (useForPace) {
      state = state.copyWith(
        details: state.details.map((d) {
          if (d is DistanceDetailConfig) {
            return d.copyWith(useForPace: d.id == detailId);
          }
          return d;
        }).toList(),
        clearError: true,
      );
    } else {
      updateDetail(detailId, (d) {
        if (d is DistanceDetailConfig) {
          return d.copyWith(useForPace: false);
        }
        return d;
      });
    }
  }

  /// Updates an Environment detail's label.
  void updateEnvironmentLabel(String detailId, String label) {
    updateDetail(detailId, (d) {
      if (d is EnvironmentDetailConfig) {
        return d.copyWith(label: label);
      }
      return d;
    });
  }

  /// Updates a Pace detail's pace type.
  void updatePaceType(String detailId, PaceType paceType) {
    updateDetail(detailId, (d) {
      if (d is PaceDetailConfig) {
        return d.copyWith(paceType: paceType);
      }
      return d;
    });
  }

  /// Resets the form to initial state.
  void reset() {
    state = const CreateCustomActivityFormState();
  }

  /// Saves the custom activity.
  ///
  /// Returns true if save was successful.
  Future<bool> save() async {
    if (state.isSaving) return false;

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final service = ref.read(customActivityServiceProvider);
      final activity = await service.createCustomActivity(
        categoryId: state.categoryId ?? '',
        name: state.name,
        details: state.details,
      );

      state = state.copyWith(
        isSaving: false,
        createdActivity: activity,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }
}

/// Provider for form validation state.
@riverpod
CreateCustomActivityValidation createCustomActivityValidation(Ref ref) {
  final formState = ref.watch(createCustomActivityFormStateProvider);
  return CreateCustomActivityValidation(formState);
}

/// Validation state for the create custom activity form.
@immutable
class CreateCustomActivityValidation {
  const CreateCustomActivityValidation(this._state);

  final CreateCustomActivityFormState _state;

  /// Whether a category is selected.
  bool get hasCategorySelected => _state.categoryId != null;

  /// Whether the name is valid (2-50 characters).
  bool get isNameValid {
    final trimmed = _state.name.trim();
    return trimmed.length >= 2 && trimmed.length <= 50;
  }

  /// Whether all details have valid labels.
  bool get areDetailsValid {
    for (final detail in _state.details) {
      if (detail.requiresLabel) {
        final label = switch (detail) {
          NumberDetailConfig(:final label) => label,
          DurationDetailConfig(:final label) => label,
          DistanceDetailConfig(:final label) => label,
          EnvironmentDetailConfig(:final label) => label,
          PaceDetailConfig() => '',
        };

        if (label.trim().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  /// Whether pace dependencies are met (if pace is added).
  bool get arePaceDependenciesMet {
    if (!_state.hasPace) return true;
    return _state.arePaceDependenciesMet;
  }

  /// Whether the form can be submitted.
  bool get canSubmit =>
      hasCategorySelected && isNameValid && areDetailsValid && arePaceDependenciesMet && !_state.isSaving;

  /// Error message for pace dependencies, if not met.
  String? get paceDependencyError {
    if (!_state.hasPace) return null;
    if (_state.arePaceDependenciesMet) return null;

    final missing = <String>[];
    if (!_state.hasDurationForPace) missing.add('Duration');
    if (!_state.hasDistanceForPace) missing.add('Distance');

    return 'Pace requires ${missing.join(' and ')} marked for pace calculation';
  }
}
