import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/settings/data/settings_repository.dart';
import 'package:logly/features/settings/domain/settings_exception.dart';
import 'package:logly/features/settings/domain/user_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus, XFile;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

part 'settings_service.g.dart';

/// Service for settings business logic.
class SettingsService {
  SettingsService(this._repository, this._supabase, this._logger);

  final SettingsRepository _repository;
  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches the current user's preferences.
  Future<UserPreferences> getPreferences() async {
    return _repository.getPreferences();
  }

  /// Updates the user's theme mode.
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _repository.setThemeMode(themeMode);
  }

  /// Updates the health sync enabled preference.
  Future<void> setHealthSyncEnabled(bool enabled) async {
    await _repository.setHealthSyncEnabled(enabled);
  }

  /// Updates the haptic feedback enabled preference.
  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    await _repository.setHapticFeedbackEnabled(enabled);
  }

  /// Updates the unit system preference.
  Future<void> setUnitSystem(UnitSystem unitSystem) async {
    await _repository.setUnitSystem(unitSystem);
  }

  /// Exports all user data as a JSON file and shares it.
  Future<void> exportData() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const ExportDataException('User not authenticated');
      }

      // Fetch all user activities with details
      final activities = await _supabase
          .from('user_activity')
          .select('''
            *,
            user_activity_detail(*),
            user_activity_sub_activity(*)
          ''')
          .eq('user_id', userId)
          .order('activity_date', ascending: false);

      // Fetch favorites
      final favorites = await _supabase.from('favorite_user_activity').select('activity_id').eq('user_id', userId);

      // Fetch profile
      final profile = await _supabase.rpc<Map<String, dynamic>>('my_profile');

      // Create export data
      final exportData = {
        'exportDate': DateTime.now().toIso8601String(),
        'profile': profile,
        'activities': activities,
        'favorites': favorites,
      };

      // Generate JSON
      final json = const JsonEncoder.withIndent('  ').convert(exportData);

      // Write to file
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/logly_export_$timestamp.json');
      await file.writeAsString(json);

      // Share file
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Logly Data Export',
        ),
      );

      _logger.i('Data exported successfully');
    } catch (e, st) {
      _logger.e('Failed to export data', e, st);
      if (e is ExportDataException) rethrow;
      throw ExportDataException(e.toString());
    }
  }

  /// Opens email client for feedback.
  Future<void> sendFeedback() async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: 'feedback@logly.app',
        queryParameters: {
          'subject': 'Logly Feedback',
        },
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw const SendFeedbackException('Could not open email client');
      }
    } catch (e, st) {
      _logger.e('Failed to send feedback', e, st);
      if (e is SendFeedbackException) rethrow;
      throw SendFeedbackException(e.toString());
    }
  }

  /// Shares the app using the system share sheet.
  Future<void> shareApp() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: [
            'Check out Logly! ',
            if (Platform.isIOS) 'https://apps.apple.com/us/app/id1465198031',
            if (Platform.isAndroid) 'https://play.google.com/store/apps/details?id=com.logly',
          ].join(),
        ),
      );
    } catch (e, st) {
      _logger.e('Failed to share app', e, st);
      rethrow;
    }
  }
}

/// Provides the settings service instance.
@Riverpod(keepAlive: true)
SettingsService settingsService(Ref ref) {
  return SettingsService(
    ref.watch(settingsRepositoryProvider),
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
