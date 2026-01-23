import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collapsible_sections_provider.g.dart';

/// Section identifiers for collapsible sections.
abstract class ProfileSections {
  static const String streak = 'streak';
  static const String summary = 'summary';
  static const String contribution = 'contribution';
  static const String monthly = 'monthly';
}

/// Notifier for managing collapsible section states.
@riverpod
class CollapsibleSectionsStateNotifier extends _$CollapsibleSectionsStateNotifier {
  @override
  Map<String, bool> build() {
    // All sections start expanded
    return {
      ProfileSections.streak: true,
      ProfileSections.summary: true,
      ProfileSections.contribution: true,
      ProfileSections.monthly: true,
    };
  }

  /// Toggles a section's expanded state.
  void toggle(String sectionId) {
    state = {
      ...state,
      sectionId: !(state[sectionId] ?? true),
    };
  }

  /// Checks if a section is expanded.
  bool isExpanded(String sectionId) => state[sectionId] ?? true;
}
