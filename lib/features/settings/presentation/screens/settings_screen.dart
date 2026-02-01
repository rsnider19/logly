import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:logly/features/health_integration/presentation/providers/health_sync_provider.dart';
import 'package:logly/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_status_provider.dart';
import 'package:logly/features/settings/application/settings_service.dart';
import 'package:logly/features/settings/domain/user_preferences.dart';
import 'package:logly/features/settings/presentation/providers/notification_preferences_provider.dart';
import 'package:logly/features/settings/presentation/providers/preferences_provider.dart';
import 'package:logly/features/settings/presentation/widgets/health_sync_bottom_sheet.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Widget _buildLeadingIcon(IconData icon, ThemeData theme, {Color? iconColor}) {
  return CircleAvatar(
    backgroundColor: theme.colorScheme.surfaceContainerHighest,
    child: Icon(icon, color: iconColor ?? theme.colorScheme.primary),
  );
}

/// Settings screen with app preferences and account options.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isSigningOut = false;
  bool _isDeleting = false;
  bool _isTogglingNotifications = false;

  Future<void> _signOut() async {
    final confirmed = await _showConfirmDialog(
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmText: 'Sign Out',
    );

    if (!confirmed) return;

    setState(() => _isSigningOut = true);
    try {
      await ref.read(authServiceProvider).signOut();
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await _showConfirmDialog(
      title: 'Delete Account',
      message:
          'Are you sure you want to delete your account? '
          'You will have 30 days to recover your account before it is permanently deleted.',
      confirmText: 'Delete Account',
      isDestructive: true,
    );

    if (!confirmed) return;

    setState(() => _isDeleting = true);
    try {
      await ref.read(authServiceProvider).requestAccountDeletion();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  Future<void> _rateApp() async {
    try {
      final inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        // Show informative message when review dialog unavailable
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('In-app rating not available'),
              action: SnackBarAction(
                label: 'Open App Store',
                onPressed: () async {
                  final uri = Platform.isIOS
                      ? Uri.parse('https://apps.apple.com/app/id1465198031?action=write-review')
                      : Uri.parse('https://play.google.com/store/apps/details?id=com.logly');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open rating dialog'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _shareApp() async {
    try {
      await ref.read(settingsServiceProvider).shareApp();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _sendFeedback() async {
    try {
      await ref.read(settingsServiceProvider).sendFeedback();
    } catch (e) {
      if (mounted) {
        await launchUrlString(
          'https://www.mylogly.app/feedback',
          mode: LaunchMode.inAppWebView,
        );
      }
    }
  }

  Future<void> _openPrivacyPolicy() async {
    await _openUrl('https://www.mylogly.app/privacy-policy', 'Privacy Policy');
  }

  Future<void> _openEula() async {
    await _openUrl(
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula',
      'EULA',
    );
  }

  Future<void> _openOurVision() async {
    await _openUrl('https://www.mylogly.app', 'Our Vision');
  }

  Future<void> _openUrl(String url, String displayName) async {
    try {
      final uri = Uri.parse(url);

      if (!await canLaunchUrl(uri)) {
        throw Exception('Cannot launch URL');
      }

      // Try in-app web view first
      try {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } catch (e) {
        // Fallback to external browser
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $displayName'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _enableNotifications() async {
    if (_isTogglingNotifications) return;

    setState(() => _isTogglingNotifications = true);
    try {
      final result = await ref.read(notificationPreferencesStateProvider.notifier).enableNotifications();

      if (!mounted) return;

      switch (result) {
        case EnableNotificationsSuccess():
          // Success - UI will update automatically
          break;

        case EnableNotificationsDenied():
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification permission denied'),
              behavior: SnackBarBehavior.floating,
            ),
          );

        case EnableNotificationsPermanentlyDenied():
          await _showOpenSettingsDialog();

        case EnableNotificationsError(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to enable notifications: $message'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
    } finally {
      if (mounted) {
        setState(() => _isTogglingNotifications = false);
      }
    }
  }

  Future<void> _disableNotifications() async {
    if (_isTogglingNotifications) return;

    setState(() => _isTogglingNotifications = true);
    try {
      await ref.read(notificationPreferencesStateProvider.notifier).disableNotifications();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to disable notifications: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTogglingNotifications = false);
      }
    }
  }

  Future<void> _showTimePicker() async {
    final notificationPrefs = ref.read(notificationPreferencesStateProvider);
    final currentTime = notificationPrefs.reminderTime;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (pickedTime != null && mounted) {
      try {
        await ref.read(notificationPreferencesStateProvider.notifier).setReminderTime(pickedTime);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update reminder time: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _showOpenSettingsDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications Disabled'),
        content: const Text(
          'Notification permission is disabled. '
          'Please enable it in your device settings to receive reminders.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    if (result == true) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmText,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDestructive
                ? TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  String _unitSystemLabel(UnitSystem system) {
    return switch (system) {
      UnitSystem.imperial => 'Imperial (lbs, mi)',
      UnitSystem.metric => 'Metric (kg, km)',
    };
  }

  void _showUnitSystemSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      builder: (context) => const _UnitSystemBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preferencesAsync = ref.watch(preferencesStateProvider);

    final healthSyncEnabled = switch (preferencesAsync) {
      AsyncData(:final value) => value.healthSyncEnabled,
      _ => false,
    };

    final unitSystem = switch (preferencesAsync) {
      AsyncData(:final value) => value.unitSystem,
      _ => UnitSystem.metric,
    };

    final hapticFeedbackEnabled = switch (preferencesAsync) {
      AsyncData(:final value) => value.hapticFeedbackEnabled,
      _ => true,
    };

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        showTrendingButton: false,
        showSettingsButton: false,
      ),
      body: ListView(
        children: [
          // Profile completion banner
          const _ProfileCompletionBanner(),

          // Customization Section
          const _SectionHeader(title: 'Customization'),
          ListTile(
            leading: _buildLeadingIcon(LucideIcons.ruler, theme),
            title: const Text('Units'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _unitSystemLabel(unitSystem),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(LucideIcons.chevronRight),
              ],
            ),
            onTap: () => _showUnitSystemSheet(context, ref),
          ),
          ListTile(
            leading: _buildLeadingIcon(LucideIcons.heart, theme),
            title: const Text('Select favorites'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () => const SettingsFavoritesRoute().push<void>(context),
          ),
          _HealthSyncListTile(),
          SwitchListTile(
            secondary: _buildLeadingIcon(LucideIcons.vibrate, theme),
            title: const Text('Home screen vibration'),
            value: hapticFeedbackEnabled,
            onChanged: (value) {
              ref.read(preferencesStateProvider.notifier).setHapticFeedbackEnabled(value);
            },
          ),
          _NotificationsSection(
            isToggling: _isTogglingNotifications,
            onEnable: _enableNotifications,
            onDisable: _disableNotifications,
            onTimeTap: _showTimePicker,
            formatTime: _formatTime,
          ),

          // About us Section
          const _SectionHeader(title: 'About us'),
          ListTile(
            leading: _buildLeadingIcon(LucideIcons.lightbulb, theme),
            title: const Text('Our vision'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: _openOurVision,
          ),
          ListTile(
            leading: _buildLeadingIcon(LucideIcons.shieldCheck, theme),
            title: const Text('Privacy Policy'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: _openPrivacyPolicy,
          ),
          ListTile(
            leading: _buildLeadingIcon(LucideIcons.fileText, theme),
            title: const Text('EULA'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: _openEula,
          ),

          // Feedback Section
          const _SectionHeader(title: 'Feedback'),
          ListTile(
            leading: _buildLeadingIcon(LucideIcons.star, theme),
            title: const Text('Rate us on the App Store'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: _rateApp,
          ),
          ListTile(
            leading: _buildLeadingIcon(LucideIcons.share2, theme),
            title: const Text('Share Logly'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: _shareApp,
          ),
          ListTile(
            leading: _buildLeadingIcon(LucideIcons.messageSquare, theme),
            title: const Text('Send us feedback'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: _sendFeedback,
          ),

          // Account Management Section
          const _SectionHeader(title: 'Account Management'),
          ListTile(
            leading: _buildLeadingIcon(LucideIcons.logOut, theme),
            title: const Text('Sign Out'),
            trailing: _isSigningOut
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.chevronRight),
            onTap: _isSigningOut ? null : _signOut,
          ),
          ListTile(
            leading: _buildLeadingIcon(LucideIcons.trash2, theme, iconColor: Colors.red),
            title: Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
            trailing: _isDeleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.chevronRight),
            onTap: _isDeleting ? null : _deleteAccount,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _NotificationsSection extends ConsumerWidget {
  const _NotificationsSection({
    required this.isToggling,
    required this.onEnable,
    required this.onDisable,
    required this.onTimeTap,
    required this.formatTime,
  });

  final bool isToggling;
  final VoidCallback onEnable;
  final VoidCallback onDisable;
  final VoidCallback onTimeTap;
  final String Function(TimeOfDay) formatTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationPrefs = ref.watch(notificationPreferencesStateProvider);
    final enabled = notificationPrefs.enabled;
    final reminderTime = notificationPrefs.reminderTime;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile(
          secondary: _buildLeadingIcon(LucideIcons.bell, theme),
          title: const Text('Notifications'),
          value: enabled,
          onChanged: isToggling
              ? null
              : (value) {
                  if (value) {
                    onEnable();
                  } else {
                    onDisable();
                  }
                },
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          curve: Curves.easeInOut,
          child: enabled
              ? ListTile(
                  leading: _buildLeadingIcon(LucideIcons.clock, theme),
                  title: const Text('Daily reminder'),
                  trailing: TextButton(
                    onPressed: onTimeTap,
                    child: Text(formatTime(reminderTime)),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// List tile for health sync with smart behavior based on sync state.
class _HealthSyncListTile extends ConsumerWidget {
  Future<void> _handleTap(BuildContext context, WidgetRef ref, {required bool healthSyncEnabled}) async {
    // If health sync is not enabled, show the setup bottom sheet
    if (!healthSyncEnabled) {
      showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        showDragHandle: true,
        builder: (context) => const HealthSyncBottomSheet(),
      );
      return;
    }

    // Otherwise, trigger sync directly
    final syncState = ref.read(healthSyncStateProvider);

    // If this is the first sync (no last sync date), show the date selection dialog
    if (syncState.lastSyncDate == null) {
      final selectedDate = await _showFirstSyncDialog(context);
      if (selectedDate != null) {
        ref.read(healthSyncStateProvider.notifier).sync(fromDate: selectedDate);
      }
    } else {
      ref.read(healthSyncStateProvider.notifier).sync();
    }
  }

  /// Minimum date for syncing (January 1, 2015).
  static final DateTime _minimumSyncDate = DateTime(2015);

  Future<DateTime?> _showFirstSyncDialog(BuildContext context) async {
    final theme = Theme.of(context);

    return showDialog<DateTime>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('First Time Sync'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How far back would you like to sync your workout history?',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Note: Syncing a large history may take longer.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 30)),
                firstDate: _minimumSyncDate,
                lastDate: DateTime.now(),
                helpText: 'Sync workouts from this date',
              );
              if (pickedDate != null && context.mounted) {
                Navigator.of(context).pop(pickedDate);
              }
            },
            child: const Text('Pick a Date'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_minimumSyncDate),
            child: const Text('Sync All History'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(healthSyncStateProvider);
    final preferencesAsync = ref.watch(preferencesStateProvider);

    final isSyncing = syncState.isSyncing;
    final lastSyncDate = syncState.lastSyncDate;

    final healthSyncEnabled = switch (preferencesAsync) {
      AsyncData(:final value) => value.healthSyncEnabled,
      _ => false,
    };

    // Listen for sync completion to show appropriate feedback
    ref.listen(healthSyncStateProvider, (previous, next) {
      if (previous?.isSyncing == true && !next.isSyncing) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (next.lastSyncResult != null) {
          // If no activities were synced and this was a sync attempt, show the no activities sheet
          if (next.lastSyncResult!.total == 0) {
            showModalBottomSheet<void>(
              context: context,
              useRootNavigator: true,
              showDragHandle: true,
              clipBehavior: Clip.antiAlias,
              builder: (context) => const _NoActivitiesFoundBottomSheet(),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(next.lastSyncResult!.summary),
                backgroundColor: Theme.of(context).colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    });

    // Build subtitle based on state
    Widget? subtitle;
    if (isSyncing && syncState.showProgress) {
      // Show progress bar when syncing multiple months
      subtitle = Padding(
        padding: const EdgeInsets.only(top: 8),
        child: LinearProgressIndicator(value: syncState.progress),
      );
    } else if (lastSyncDate != null) {
      subtitle = Text('Last synced ${timeago.format(lastSyncDate)}');
    }

    final theme = Theme.of(context);

    return ListTile(
      leading: _buildLeadingIcon(LucideIcons.heartPulse, theme),
      title: const Text('Sync health data'),
      subtitle: subtitle,
      trailing: const Icon(LucideIcons.chevronRight),
      onTap: isSyncing ? null : () => _handleTap(context, ref, healthSyncEnabled: healthSyncEnabled),
    );
  }
}

/// Banner prompting users to complete their profile questions.
class _ProfileCompletionBanner extends ConsumerWidget {
  const _ProfileCompletionBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAnsweredAsync = ref.watch(hasAnsweredProfileQuestionsProvider);

    final hasAnswered = switch (hasAnsweredAsync) {
      AsyncData(:final value) => value,
      _ => true, // Hide banner while loading or on error
    };

    if (hasAnswered) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        child: ListTile(
          leading: Icon(LucideIcons.userRound, color: theme.colorScheme.primary),
          title: const Text('Complete your profile'),
          subtitle: const Text('Answer a few questions to personalize your experience.'),
          trailing: const Icon(LucideIcons.chevronRight),
          onTap: () => const OnboardingQuestionsRoute(source: 'settings').go(context),
        ),
      ),
    );
  }
}

/// Bottom sheet for selecting the unit system.
class _UnitSystemBottomSheet extends ConsumerWidget {
  const _UnitSystemBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesAsync = ref.watch(preferencesStateProvider);
    final unitSystem = switch (preferencesAsync) {
      AsyncData(:final value) => value.unitSystem,
      _ => UnitSystem.metric,
    };

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<UnitSystem>(
            title: const Text('Imperial'),
            subtitle: const Text('miles, pounds, feet'),
            value: UnitSystem.imperial,
            groupValue: unitSystem,
            onChanged: (value) {
              if (value != null) {
                ref.read(preferencesStateProvider.notifier).setUnitSystem(value);
                Navigator.of(context).pop();
              }
            },
          ),
          RadioListTile<UnitSystem>(
            title: const Text('Metric'),
            subtitle: const Text('kilometers, kilograms, meters'),
            value: UnitSystem.metric,
            groupValue: unitSystem,
            onChanged: (value) {
              if (value != null) {
                ref.read(preferencesStateProvider.notifier).setUnitSystem(value);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet shown when sync completes with no activities found.
class _NoActivitiesFoundBottomSheet extends StatelessWidget {
  const _NoActivitiesFoundBottomSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.searchX,
              size: 40,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            'No Workouts Found',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            "We couldn't find any workouts to sync from your health app. "
            'If you were expecting some, you may need to grant Logly access to your health data in Settings.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Action buttons
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
        ],
      ),
    );
  }
}
