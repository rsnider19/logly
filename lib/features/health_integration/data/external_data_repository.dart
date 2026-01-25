import 'package:health/health.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/health_integration/domain/health_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'external_data_repository.g.dart';

/// Repository for managing external data in Supabase.
class ExternalDataRepository {
  ExternalDataRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches the last health sync date from the user's profile.
  /// Returns null if the user has never synced.
  Future<DateTime?> getLastSyncDate() async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>('my_profile');

      final lastSyncString = response['last_health_sync_date'] as String?;
      if (lastSyncString == null) {
        return null;
      }

      return DateTime.parse(lastSyncString);
    } catch (e, st) {
      _logger.e('Failed to fetch last sync date', e, st);
      throw UpdateLastSyncException(e.toString());
    }
  }

  /// Updates the last health sync date in the user's profile.
  Future<void> updateLastSyncDate(DateTime date) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const UpdateLastSyncException('User not authenticated');
      }

      await _supabase.from('profile').update({
        'last_health_sync_date': date.toUtc().toIso8601String(),
      }).eq('user_id', userId);

      _logger.i('Updated last health sync date to $date');
    } catch (e, st) {
      _logger.e('Failed to update last sync date', e, st);
      throw UpdateLastSyncException(e.toString());
    }
  }

  /// Upserts raw health data into the external_data table.
  /// The database trigger will automatically create user_activity entries.
  /// Uses upsert to handle duplicates gracefully.
  Future<int> upsertHealthData(List<HealthDataPoint> data) async {
    if (data.isEmpty) {
      return 0;
    }

    try {
      await _supabase.from('external_data').upsert(
        [
          for (final d in data)
            {
              'external_data_id': d.uuid.toLowerCase(),
              'external_data_source': 'apple_google',
              'data': d.toJson(),
            },
        ],
        onConflict: 'external_data_id,user_id',
      );

      _logger.i('Upserted ${data.length} health records');
      return data.length;
    } catch (e, st) {
      _logger.e('Failed to upsert health data', e, st);
      throw StoreExternalDataException(e.toString());
    }
  }
}

/// Provides the external data repository instance.
@Riverpod(keepAlive: true)
ExternalDataRepository externalDataRepository(Ref ref) {
  return ExternalDataRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
