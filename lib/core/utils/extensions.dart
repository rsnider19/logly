import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/core/utils/date_utils.dart' as app_date_utils;

/// String extensions for common operations.
extension StringExtensions on String {
  /// Returns true if the string is null or empty.
  bool get isNullOrEmpty => isEmpty;

  /// Returns true if the string is not null and not empty.
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Capitalizes the first letter of the string.
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Converts the string to title case.
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Truncates the string to the specified length with an ellipsis.
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
}

/// DateTime extensions for common operations.
extension DateTimeExtensions on DateTime {
  /// Returns the start of the day (midnight).
  DateTime get startOfDay => app_date_utils.DateUtils.startOfDay(this);

  /// Returns the end of the day (23:59:59.999).
  DateTime get endOfDay => app_date_utils.DateUtils.endOfDay(this);

  /// Returns the start of the week (Monday).
  DateTime get startOfWeek => app_date_utils.DateUtils.startOfWeek(this);

  /// Returns the end of the week (Sunday).
  DateTime get endOfWeek => app_date_utils.DateUtils.endOfWeek(this);

  /// Returns the start of the month.
  DateTime get startOfMonth => app_date_utils.DateUtils.startOfMonth(this);

  /// Returns the end of the month.
  DateTime get endOfMonth => app_date_utils.DateUtils.endOfMonth(this);

  /// Formats the date for display (e.g., "Jan 15, 2024").
  String get displayFormat => app_date_utils.DateUtils.formatDisplay(this);

  /// Formats the date for short display (e.g., "Jan 15").
  String get shortFormat => app_date_utils.DateUtils.formatShort(this);

  /// Formats the time for display (e.g., "3:30 PM").
  String get timeFormat => app_date_utils.DateUtils.formatTime(this);

  /// Formats the date and time for display.
  String get dateTimeFormat => app_date_utils.DateUtils.formatDateTime(this);

  /// Returns true if this date is the same day as another date.
  bool isSameDayAs(DateTime other) => app_date_utils.DateUtils.isSameDay(this, other);

  /// Returns true if this date is today.
  bool get isToday => app_date_utils.DateUtils.isToday(this);

  /// Returns true if this date is yesterday.
  bool get isYesterday => app_date_utils.DateUtils.isYesterday(this);
}

/// Nullable extensions for common null-safe operations.
extension NullableExtensions<T> on T? {
  /// Returns the value if not null, otherwise returns the result of orElse.
  T orElse(T Function() orElse) => this ?? orElse();

  /// Maps the value if not null, otherwise returns null.
  R? mapOrNull<R>(R Function(T value) mapper) {
    final value = this;
    return value != null ? mapper(value) : null;
  }
}

/// Riverpod AsyncValue extensions for common operations.
extension AsyncValueExtensions<T> on AsyncValue<T> {
  /// Returns true if this is the first load (loading without any existing data).
  ///
  /// Useful for showing shimmer/skeleton loading states only on initial load,
  /// not during pull-to-refresh when previous data should remain visible.
  bool get isFirstLoad => isLoading && !hasValue;
}
