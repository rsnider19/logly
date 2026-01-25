/// Enum of premium feature codes that match the database feature table.
enum FeatureCode {
  /// The main pro entitlement that grants all premium features.
  pro('logly-pro'),

  /// Individual feature codes (for future granular entitlements).
  aiInsights('ai-insights'),
  createCustomActivity('create-custom-activity'),
  activityNameOverride('activity-name-override'),
  locationServices('location-services');

  const FeatureCode(this.value);

  /// The database value for this feature code.
  final String value;

  /// Returns the FeatureCode for the given database value, or null if not found.
  static FeatureCode? fromValue(String value) {
    for (final code in FeatureCode.values) {
      if (code.value == value) {
        return code;
      }
    }
    return null;
  }
}
