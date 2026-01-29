import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/home/presentation/widgets/trending_bottom_sheet.dart';

/// Custom app bar with route title and action icons.
///
/// Left: Route title (dynamic based on current route)
/// Right: Globe icon (trending) + Settings gear
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    this.showTrendingButton = true,
    this.showSettingsButton = true,
    super.key,
  });

  final String title;
  final bool showTrendingButton;
  final bool showSettingsButton;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        if (showTrendingButton)
          IconButton(
            icon: const Icon(LucideIcons.globe),
            tooltip: 'Trending Activities',
            onPressed: () => _showTrendingSheet(context),
          ),
        if (showSettingsButton)
          IconButton(
            icon: const Icon(LucideIcons.settings),
            tooltip: 'Settings',
            onPressed: () => context.go('/settings'),
          ),
      ],
    );
  }

  void _showTrendingSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => const TrendingBottomSheet(),
      ),
    );
  }
}
