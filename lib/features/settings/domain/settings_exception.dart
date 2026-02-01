/// Base exception for settings-related errors.
abstract class SettingsException implements Exception {
  const SettingsException(this.message, [this.technicalDetails]);

  /// User-facing error message.
  final String message;

  /// Technical details for logging.
  final String? technicalDetails;

  @override
  String toString() => 'SettingsException: $message${technicalDetails != null ? ' ($technicalDetails)' : ''}';
}

/// Exception thrown when loading preferences fails.
class LoadPreferencesException extends SettingsException {
  const LoadPreferencesException([String? technicalDetails]) : super('Failed to load preferences', technicalDetails);
}

/// Exception thrown when saving preferences fails.
class SavePreferencesException extends SettingsException {
  const SavePreferencesException([String? technicalDetails]) : super('Failed to save preferences', technicalDetails);
}

/// Exception thrown when exporting data fails.
class ExportDataException extends SettingsException {
  const ExportDataException([String? technicalDetails]) : super('Failed to export data', technicalDetails);
}

/// Exception thrown when sending feedback fails.
class SendFeedbackException extends SettingsException {
  const SendFeedbackException([String? technicalDetails]) : super('Failed to open feedback', technicalDetails);
}
