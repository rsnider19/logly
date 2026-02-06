import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'growthbook_provider.g.dart';

/// Provides the GrowthBook SDK instance.
///
/// This provider must be overridden in the ProviderScope during app bootstrap
/// with an initialized GrowthBook SDK instance.
@Riverpod(keepAlive: true)
GrowthBookSDK growthBook(Ref ref) {
  throw UnimplementedError(
    'growthBookProvider must be overridden with an initialized GrowthBook SDK instance',
  );
}
