import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/health_integration/data/external_data_repository.dart';
import 'package:logly/features/health_integration/data/health_repository.dart';
import 'package:logly/features/health_integration/domain/sync_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_sync_service.g.dart';

/// Service for orchestrating health data synchronization.
class HealthSyncService {
  HealthSyncService(
    this._healthRepository,
    this._externalDataRepository,
    this._logger,
  );

  final HealthRepository _healthRepository;
  final ExternalDataRepository _externalDataRepository;
  final LoggerService _logger;

  /// Minimum date allowed for syncing (January 1, 2015).
  static final DateTime minimumSyncDate = DateTime(2015);

  /// Checks if the health platform permissions have been granted.
  Future<bool> hasPermissions() async {
    return _healthRepository.hasPermissions();
  }

  /// Requests health platform permissions.
  /// Returns true if permissions were granted.
  Future<bool> requestPermissions() async {
    return _healthRepository.requestPermissions();
  }

  /// Gets the last sync date, or null if never synced.
  Future<DateTime?> getLastSyncDate() async {
    return _externalDataRepository.getLastSyncDate();
  }

  /// Generates a list of month ranges between two dates.
  List<(DateTime, DateTime)> _generateMonthRanges(DateTime start, DateTime end) {
    final ranges = <(DateTime, DateTime)>[];
    var current = DateTime(start.year, start.month);

    while (current.isBefore(end)) {
      final monthStart = current.isBefore(start) ? start : current;
      final nextMonth = DateTime(current.year, current.month + 1);
      final monthEnd = nextMonth.isAfter(end) ? end : nextMonth;

      ranges.add((monthStart, monthEnd));
      current = nextMonth;
    }

    return ranges;
  }

  /// Syncs health data from the health platform to Logly.
  ///
  /// The sync process:
  /// 1. Gets last sync date (or uses provided [fromDate] for first sync)
  /// 2. Calculates month ranges to sync
  /// 3. For each month, fetches and upserts raw health data
  /// 4. Reports progress via [onProgress] callback
  /// 5. Updates last_health_sync_date
  ///
  /// [fromDate] is used as the start date for first-time syncs. If not provided
  /// and there's no previous sync date, an error will be thrown.
  ///
  /// [onProgress] is called with (currentMonth, totalMonths) for progress tracking.
  ///
  /// Returns a [SyncResult] with counts.
  Future<SyncResult> syncWorkouts({
    DateTime? fromDate,
    void Function(int currentMonth, int totalMonths)? onProgress,
  }) async {
    _logger.i('Starting health sync...');

    // Get last sync date (stored as UTC in database)
    final lastSyncUtc = await _externalDataRepository.getLastSyncDate();

    // For first sync, require fromDate to be provided
    if (lastSyncUtc == null && fromDate == null) {
      throw ArgumentError('fromDate is required for first-time sync');
    }

    // Convert to local time for health platform queries
    // Health platforms (Apple Health, Health Connect) use local dates
    final startDate = lastSyncUtc?.toLocal() ?? fromDate!;
    final endDate = DateTime.now(); // Already local

    _logger.i('Syncing health data from $startDate to $endDate (local time)');

    // Calculate month ranges
    final monthRanges = _generateMonthRanges(startDate, endDate);
    final totalMonths = monthRanges.length;

    _logger.i('Syncing $totalMonths month(s) of data');

    // Track cumulative results
    var totalCreated = 0;

    // Process each month
    for (var i = 0; i < monthRanges.length; i++) {
      final (monthStart, monthEnd) = monthRanges[i];

      // Report progress
      onProgress?.call(i + 1, totalMonths);

      _logger.i('Syncing month ${i + 1}/$totalMonths: $monthStart to $monthEnd');

      // Fetch raw health data for this month
      final healthData = await _healthRepository.fetchHealthData(
        startDate: monthStart,
        endDate: monthEnd,
      );

      if (healthData.isEmpty) {
        _logger.d('No health data found for this month');
        continue;
      }

      _logger.i('Found ${healthData.length} health records for this month');

      // Upsert raw health data (database trigger handles the rest)
      final count = await _externalDataRepository.upsertHealthData(healthData);
      totalCreated += count;
    }

    // Update last sync date
    await _externalDataRepository.updateLastSyncDate(endDate);

    final result = SyncResult(created: totalCreated);
    _logger.i('Health sync completed: ${result.summary}');

    return result;
  }
}

/// Provides the health sync service instance.
@Riverpod(keepAlive: true)
HealthSyncService healthSyncService(Ref ref) {
  return HealthSyncService(
    ref.watch(healthRepositoryProvider),
    ref.watch(externalDataRepositoryProvider),
    ref.watch(loggerProvider),
  );
}
