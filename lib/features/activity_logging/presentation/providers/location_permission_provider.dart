import 'package:app_settings/app_settings.dart';
import 'package:logly/features/activity_logging/application/location_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_permission_provider.g.dart';

/// State for location permission management.
class LocationPermissionState {
  const LocationPermissionState({
    required this.status,
    this.hasShownPrimer = false,
  });

  /// The current permission status.
  final LocationPermissionStatus status;

  /// Whether the permission primer has been shown in this session.
  final bool hasShownPrimer;

  /// Whether location permission is granted.
  bool get isGranted => status == LocationPermissionStatus.granted;

  /// Whether the user can be prompted for permission.
  bool get canPrompt =>
      status == LocationPermissionStatus.denied || status == LocationPermissionStatus.serviceDisabled;

  LocationPermissionState copyWith({
    LocationPermissionStatus? status,
    bool? hasShownPrimer,
  }) {
    return LocationPermissionState(
      status: status ?? this.status,
      hasShownPrimer: hasShownPrimer ?? this.hasShownPrimer,
    );
  }
}

/// Provider for managing location permission state.
@riverpod
class LocationPermissionStateNotifier extends _$LocationPermissionStateNotifier {
  @override
  Future<LocationPermissionState> build() async {
    final service = ref.read(locationServiceProvider);
    final status = await service.checkPermission();
    return LocationPermissionState(status: status);
  }

  /// Marks that the primer dialog has been shown.
  ///
  /// This prevents showing the primer multiple times in a session.
  void markPrimerShown() {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(hasShownPrimer: true));
    }
  }

  /// Requests location permission from the user.
  ///
  /// Returns the new permission status after the request.
  Future<LocationPermissionStatus> requestPermission() async {
    final service = ref.read(locationServiceProvider);
    final status = await service.requestPermission();

    state = AsyncData(LocationPermissionState(
      status: status,
      hasShownPrimer: true,
    ));

    return status;
  }

  /// Opens the app settings for the user to manually grant permission.
  ///
  /// Used when permission is permanently denied.
  Future<void> openSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.location);
  }

  /// Refreshes the current permission status.
  ///
  /// Call this when returning from settings or when the app resumes.
  Future<void> refresh() async {
    final service = ref.read(locationServiceProvider);
    final status = await service.checkPermission();

    final current = state.valueOrNull;
    state = AsyncData(LocationPermissionState(
      status: status,
      hasShownPrimer: current?.hasShownPrimer ?? false,
    ));
  }
}
