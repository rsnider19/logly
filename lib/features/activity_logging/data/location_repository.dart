import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_logging/domain/location.dart';
import 'package:logly/features/activity_logging/domain/location_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'location_repository.g.dart';

/// Repository for managing location data via Supabase.
///
/// Locations are globally shared across all users, using Google's place_id
/// as the unique identifier for deduplication.
class LocationRepository {
  LocationRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches a location by its ID (Google place_id).
  ///
  /// Returns null if the location doesn't exist.
  Future<Location?> getById(String locationId) async {
    try {
      final response = await _supabase
          .from('location')
          .select()
          .eq('location_id', locationId)
          .maybeSingle();

      if (response == null) return null;
      return Location.fromJson(response);
    } catch (e, st) {
      _logger.e('Failed to fetch location $locationId', e, st);
      throw SaveLocationException(e.toString());
    }
  }

  /// Upserts a location (inserts if not exists, returns existing if it does).
  ///
  /// This ensures locations are deduplicated by Google place_id globally.
  Future<Location> upsert(Location location) async {
    try {
      // Use ON CONFLICT DO NOTHING pattern - if exists, just select it
      await _supabase.from('location').upsert(
        {
          'location_id': location.locationId,
          'lng_lat': 'POINT(${location.lng} ${location.lat})',
          'name': location.name,
          'address': location.address,
        },
        onConflict: 'location_id',
        ignoreDuplicates: true,
      );

      // Return the location (either newly created or existing)
      final response = await _supabase
          .from('location')
          .select()
          .eq('location_id', location.locationId)
          .single();

      return Location.fromJson(response);
    } catch (e, st) {
      _logger.e('Failed to upsert location ${location.locationId}', e, st);
      throw SaveLocationException(e.toString());
    }
  }
}

@Riverpod(keepAlive: true)
LocationRepository locationRepository(Ref ref) {
  return LocationRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
