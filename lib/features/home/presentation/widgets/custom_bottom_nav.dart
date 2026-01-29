import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/gen/assets.gen.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Profile button (left)
              _NavButton(
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage: user?.userMetadata?['avatar_url'] != null
                      ? NetworkImage(user!.userMetadata!['avatar_url'] as String)
                      : null,
                  child: user?.userMetadata?['avatar_url'] == null
                      ? Icon(
                          LucideIcons.user,
                          size: 20,
                          color: theme.colorScheme.onPrimaryContainer,
                        )
                      : null,
                ),
              ),

              // Home button (center)
              _NavButton(
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
                child: SvgPicture.asset(
                  Assets.logoLight,
                  height: 28,
                ),
              ),

              // Log activity button (right)
              _NavButton(
                isSelected: false,
                onTap: () => context.push('/activities/search'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.plus,
                    size: 24,
                    color: theme.colorScheme.onPrimary,
                  ),
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}
