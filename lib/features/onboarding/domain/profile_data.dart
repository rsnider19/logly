import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_data.freezed.dart';
part 'profile_data.g.dart';

/// User profile data including onboarding status.
@freezed
abstract class ProfileData with _$ProfileData {
  const factory ProfileData({
    required String userId,
    required DateTime createdAt,
    required bool onboardingCompleted,
    DateTime? lastHealthSyncDate,
    String? gender,
    DateTime? dateOfBirth,
    @_JsonbStringListConverter() List<String>? motivations,
    @_JsonbStringListConverter() List<String>? progressPreferences,
    @_JsonbStringListConverter() List<String>? userDescriptors,
  }) = _ProfileData;

  factory ProfileData.fromJson(Map<String, dynamic> json) => _$ProfileDataFromJson(json);
}

/// Converts JSONB arrays (List<dynamic>) to List<String> for Freezed.
class _JsonbStringListConverter implements JsonConverter<List<String>?, dynamic> {
  const _JsonbStringListConverter();

  @override
  List<String>? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is List) return json.cast<String>();
    return null;
  }

  @override
  dynamic toJson(List<String>? object) => object;
}
