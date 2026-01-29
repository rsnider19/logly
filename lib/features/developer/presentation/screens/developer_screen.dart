import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_catalog/domain/imperial_uom.dart';
import 'package:logly/features/activity_catalog/domain/metric_uom.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/distance_input.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/duration_input.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/environment_selector.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/liquid_volume_input.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/numeric_input.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/weight_input.dart';

/// Developer screen for testing activity detail inputs.
///
/// Only accessible when [kDebugMode] is true.
class DeveloperScreen extends ConsumerStatefulWidget {
  const DeveloperScreen({super.key});

  @override
  ConsumerState<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends ConsumerState<DeveloperScreen> {
  static const _mockDetails = <ActivityDetail>[
    ActivityDetail(
      activityDetailId: 'duration',
      activityId: 'test',
      label: 'Duration',
      activityDetailType: ActivityDetailType.duration,
      sortOrder: 0,
      minDurationInSec: 0,
      maxDurationInSec: 7200,
    ),
    ActivityDetail(
      activityDetailId: 'distance',
      activityId: 'test',
      label: 'Distance',
      activityDetailType: ActivityDetailType.distance,
      sortOrder: 1,
      minDistanceInMeters: 0,
      maxDistanceInMeters: 50000,
      metricUom: MetricUom.kilometers,
      imperialUom: ImperialUom.miles,
    ),
    ActivityDetail(
      activityDetailId: 'integer',
      activityId: 'test',
      label: 'Integer',
      activityDetailType: ActivityDetailType.integer,
      sortOrder: 2,
      minNumeric: 0,
      maxNumeric: 100,
    ),
    ActivityDetail(
      activityDetailId: 'double',
      activityId: 'test',
      label: 'Double',
      activityDetailType: ActivityDetailType.double_,
      sortOrder: 3,
      minNumeric: 0,
      maxNumeric: 10,
      sliderInterval: 0.1,
    ),
    ActivityDetail(
      activityDetailId: 'environment',
      activityId: 'test',
      label: 'Environment',
      activityDetailType: ActivityDetailType.environment,
      sortOrder: 4,
    ),
    ActivityDetail(
      activityDetailId: 'liquidVolume',
      activityId: 'test',
      label: 'Liquid Volume',
      activityDetailType: ActivityDetailType.liquidVolume,
      sortOrder: 5,
      minLiquidVolumeInLiters: 0,
      maxLiquidVolumeInLiters: 5,
      metricUom: MetricUom.liters,
      imperialUom: ImperialUom.fluidOunces,
    ),
    ActivityDetail(
      activityDetailId: 'weight',
      activityId: 'test',
      label: 'Weight',
      activityDetailType: ActivityDetailType.weight,
      sortOrder: 6,
      minWeightInKilograms: 0,
      maxWeightInKilograms: 200,
      metricUom: MetricUom.kilograms,
      imperialUom: ImperialUom.pounds,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFormState();
    });
  }

  void _initializeFormState() {
    final notifier = ref.read(activityFormStateProvider.notifier);
    // Initialize detail values for each mock detail
    for (final detail in _mockDetails) {
      notifier.setDetailValue(
        detail.activityDetailId,
        DetailValue(
          activityDetailId: detail.activityDetailId,
          type: detail.activityDetailType,
        ),
      );
    }
  }

  void _showResultsDialog() {
    final formState = ref.read(activityFormStateProvider);

    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Form Values'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _mockDetails.map((detail) {
              final value = formState.detailValues[detail.activityDetailId];
              return ListTile(
                title: Text(detail.label),
                subtitle: Text(_formatValue(detail, value)),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    ));
  }

  String _formatValue(ActivityDetail detail, DetailValue? value) {
    if (value == null || !value.hasValue) {
      return 'Not set';
    }

    return switch (detail.activityDetailType) {
      ActivityDetailType.duration => _formatDuration(value.durationInSec),
      ActivityDetailType.distance => '${value.distanceInMeters?.toStringAsFixed(2)} meters',
      ActivityDetailType.integer => value.numericValue?.round().toString() ?? 'Not set',
      ActivityDetailType.double_ => value.numericValue?.toStringAsFixed(2) ?? 'Not set',
      ActivityDetailType.environment => value.environmentValue?.displayName ?? 'Not set',
      ActivityDetailType.liquidVolume => '${value.liquidVolumeInLiters?.toStringAsFixed(2)} liters',
      ActivityDetailType.weight => '${value.weightInKilograms?.toStringAsFixed(2)} kg',
      ActivityDetailType.string => value.textValue ?? 'Not set',
      ActivityDetailType.location => value.latLng ?? 'Not set',
    };
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return 'Not set';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    }
    return '${secs}s';
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const Scaffold(
        body: Center(
          child: Text('Developer screen is only available in debug mode'),
        ),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Detail Inputs',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Test all input types with their labels',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(height: 32),
            ..._mockDetails.map((detail) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildInput(detail),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _showResultsDialog,
            child: const Text('Submit'),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(ActivityDetail detail) {
    return switch (detail.activityDetailType) {
      ActivityDetailType.duration => DurationInput(activityDetail: detail),
      ActivityDetailType.distance => DistanceInput(activityDetail: detail),
      ActivityDetailType.integer || ActivityDetailType.double_ => NumericInput(activityDetail: detail),
      ActivityDetailType.environment => EnvironmentSelector(activityDetail: detail),
      ActivityDetailType.liquidVolume => LiquidVolumeInput(activityDetail: detail),
      ActivityDetailType.weight => WeightInput(activityDetail: detail),
      ActivityDetailType.string => _buildPlaceholder(detail, 'String input'),
      ActivityDetailType.location => _buildPlaceholder(detail, 'Location input'),
    };
  }

  Widget _buildPlaceholder(ActivityDetail detail, String description) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.label,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.info,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
