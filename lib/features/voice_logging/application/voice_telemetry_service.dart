import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/package_info_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'voice_telemetry_service.g.dart';

/// Service for tracking voice activity telemetry.
///
/// This service updates telemetry records with user actions in a fire-and-forget
/// manner. Telemetry failures never block the UI or throw exceptions.
class VoiceTelemetryService {
  VoiceTelemetryService(this._supabase, this._logger, this._packageInfo);

  final SupabaseClient _supabase;
  final LoggerService _logger;
  final PackageInfo _packageInfo;

  /// Updates a telemetry record with user action.
  ///
  /// This is a fire-and-forget operation that:
  /// - Never throws exceptions
  /// - Never blocks the caller
  /// - Logs errors but does not retry
  ///
  /// Parameters:
  /// - [telemetryId]: UUID of the telemetry record to update
  /// - [userAction]: One of: 'activity_selected', 'dismissed', 'retry'
  /// - [selectedActivityId]: Optional activity ID when userAction is 'activity_selected'
  Future<void> updateUserAction({
    required String telemetryId,
    required String userAction,
    String? selectedActivityId,
  }) async {
    try {
      _logger.d('Updating telemetry $telemetryId with action: $userAction');

      // Capture app context
      final appVersion = _packageInfo.version;
      final platform = _getPlatformName();
      final locale = _getLocaleName();

      // Fire-and-forget update
      unawaited(
        _supabase.from('voice_activity_telemetry').update({
          'user_action': userAction,
          'selected_activity_id': selectedActivityId,
          'user_action_timestamp': DateTime.now().toIso8601String(),
          'app_version': appVersion,
          'platform': platform,
          'locale': locale,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', telemetryId),
      );
    } catch (e, st) {
      // Log error but never throw - telemetry failures should not affect UX
      _logger.e('Failed to update telemetry', e, st);
    }
  }

  /// Gets the platform name for telemetry.
  String _getPlatformName() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// Gets the locale name for telemetry.
  String _getLocaleName() {
    try {
      return Platform.localeName;
    } catch (e) {
      _logger.w('Failed to get locale name', e, StackTrace.current);
      return 'unknown';
    }
  }
}

/// Provides the voice telemetry service instance.
@Riverpod(keepAlive: true)
Future<VoiceTelemetryService> voiceTelemetryService(Ref ref) async {
  final packageInfo = await ref.watch(packageInfoProvider.future);
  return VoiceTelemetryService(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
    packageInfo,
  );
}
