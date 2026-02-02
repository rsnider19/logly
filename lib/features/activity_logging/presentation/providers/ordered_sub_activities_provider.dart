import 'package:logly/features/activity_catalog/domain/sub_activity.dart';
import 'package:logly/features/activity_logging/application/activity_logging_service.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ordered_sub_activities_provider.g.dart';

/// Provides sub-activities ordered by usage frequency for the current activity.
///
/// Returns the frequency-ordered list from [ActivityLoggingService], or the
/// original order while loading / if no activity is selected.
@riverpod
Future<List<SubActivity>> orderedSubActivities(Ref ref) async {
  final formState = ref.watch(activityFormStateProvider);
  final activity = formState.activity;

  if (activity == null || activity.subActivity.isEmpty) {
    return const [];
  }

  final service = ref.watch(activityLoggingServiceProvider);
  return service.getSubActivitiesOrderedByFrequency(
    activity.activityId,
    activity.subActivity,
  );
}
