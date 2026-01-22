import 'package:intl/intl.dart';

/// Date utility functions for common date operations.
class DateUtils {
  const DateUtils._();

  /// Returns the start of the day (midnight) for the given date.
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns the end of the day (23:59:59.999) for the given date.
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Returns the start of the week (Monday) for the given date.
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Returns the end of the week (Sunday) for the given date.
  static DateTime endOfWeek(DateTime date) {
    final daysUntilSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysUntilSunday)));
  }

  /// Returns the start of the month for the given date.
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month);
  }

  /// Returns the end of the month for the given date.
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Formats a date as ISO 8601 string for database queries.
  static String toIso8601(DateTime date) {
    return date.toUtc().toIso8601String();
  }

  /// Formats a date for display (e.g., "Jan 15, 2024").
  static String formatDisplay(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// Formats a date for short display (e.g., "Jan 15").
  static String formatShort(DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  /// Formats a time for display (e.g., "3:30 PM").
  static String formatTime(DateTime date) {
    return DateFormat.jm().format(date);
  }

  /// Formats a date and time for display (e.g., "Jan 15, 2024 at 3:30 PM").
  static String formatDateTime(DateTime date) {
    return '${formatDisplay(date)} at ${formatTime(date)}';
  }

  /// Returns true if the two dates are the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Returns true if the date is today.
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Returns true if the date is yesterday.
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }
}
