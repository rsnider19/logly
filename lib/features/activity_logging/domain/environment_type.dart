import 'package:json_annotation/json_annotation.dart';

/// Environment type for where an activity was performed.
@JsonEnum()
enum EnvironmentType {
  @JsonValue('indoor')
  indoor,
  @JsonValue('outdoor')
  outdoor;

  /// Returns a human-readable display name.
  String get displayName {
    switch (this) {
      case EnvironmentType.indoor:
        return 'Indoor';
      case EnvironmentType.outdoor:
        return 'Outdoor';
    }
  }
}
