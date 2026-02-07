import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/gen/assets.gen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Custom bottom navigation bar with profile, home, and log buttons.
///
/// Left: Profile picture → Profile
/// Center: Logly icon → Home (scroll to top if already on home)
/// Right: Plus icon → Log Activity (full screen modal)
class CustomBottomNav extends ConsumerWidget {
  const CustomBottomNav({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);

    // Compute the same elevation-tinted color the AppBar uses when
    // scrolled-under (surfaceContainerLowest + elevation 3 surface tint).
    final tintedSurface = ElevationOverlay.applySurfaceTint(
      theme.colorScheme.surfaceContainerLowest,
      theme.colorScheme.surfaceTint,
      3,
    );

    return ColoredBox(
      color: tintedSurface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Profile button (left)
              _NavButton(
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
                child: user?.userMetadata?['avatar_url'] != null
                    ? CachedNetworkImage(
                        imageUrl: user!.userMetadata!['avatar_url'] as String,
                      )
                    : Icon(
                        LucideIcons.user,
                        size: 20,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
              ),

              // Home button (center)
              GestureDetector(
                onTap: () => onTap(1),
                child: Transform.translate(
                  offset: Offset(0, 4),
                  child: SvgPicture.asset(
                    Assets.logoLight,
                    height: 28,
                  ),
                ),
              ),

              // Log activity button (right)
              _NavButton(
                isSelected: false,
                onTap: () => const ActivitySearchRoute(entryPoint: 'plus_icon').push<void>(context),
                child: Icon(
                  LucideIcons.plus,
                  size: 24,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: CircleAvatar(
        radius: 16,
        child: ClipOval(
          child: child,
        ),
      ),
    );
  }
}
