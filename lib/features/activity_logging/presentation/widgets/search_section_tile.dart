import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_logging/presentation/providers/search_section_expansion_provider.dart';

/// A reusable expandable section tile for the activity search screen.
///
/// Integrates with [SearchSectionExpansionStateNotifier] for persistent
/// expand/collapse state. All sections default to expanded.
class SearchSectionTile extends ConsumerWidget {
  const SearchSectionTile({
    required this.sectionId,
    required this.title,
    required this.leading,
    required this.children,
    super.key,
  });

  /// Unique identifier for this section (used for state persistence).
  final String sectionId;

  /// The title text displayed in the section header.
  final String title;

  /// The widget displayed before the title (typically an icon).
  final Widget leading;

  /// The content to display when expanded.
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final expansionState = ref.watch(searchSectionExpansionStateProvider);
    final isExpanded = expansionState[sectionId] ?? true;

    return Theme(
      data: theme.copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        key: PageStorageKey<String>(sectionId),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          // Only toggle if the state actually changed
          final currentExpanded = expansionState[sectionId] ?? true;
          if (expanded != currentExpanded) {
            ref.read(searchSectionExpansionStateProvider.notifier).toggle(sectionId);
          }
        },
        leading: leading,
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: children,
      ),
    );
  }
}
