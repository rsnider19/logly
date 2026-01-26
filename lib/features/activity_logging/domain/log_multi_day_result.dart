import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';

part 'log_multi_day_result.freezed.dart';
part 'log_multi_day_result.g.dart';

/// Result of logging an activity across multiple days.
///
/// Supports partial success - some days may succeed while others fail.
/// The client can use this to show which days were logged and which failed.
@freezed
abstract class LogMultiDayResult with _$LogMultiDayResult {
  const factory LogMultiDayResult({
    /// Successfully created user activities.
    required List<UserActivity> successes,

    /// Days that failed to log with their error messages.
    required List<FailedDay> failures,
  }) = _LogMultiDayResult;

  const LogMultiDayResult._();

  factory LogMultiDayResult.fromJson(Map<String, dynamic> json) => _$LogMultiDayResultFromJson(json);

  /// Whether all days were logged successfully.
  bool get isFullSuccess => failures.isEmpty;

  /// Whether all days failed.
  bool get isFullFailure => successes.isEmpty;

  /// Whether some days succeeded and some failed.
  bool get isPartialSuccess => successes.isNotEmpty && failures.isNotEmpty;

  /// Total number of days attempted.
  int get totalDays => successes.length + failures.length;

  /// Number of successful days.
  int get successCount => successes.length;

  /// Number of failed days.
  int get failureCount => failures.length;
}

/// Represents a day that failed to log.
@freezed
abstract class FailedDay with _$FailedDay {
  const factory FailedDay({
    /// The date that failed to log.
    required DateTime date,

    /// The error message describing why it failed.
    required String errorMessage,
  }) = _FailedDay;

  factory FailedDay.fromJson(Map<String, dynamic> json) => _$FailedDayFromJson(json);
}
