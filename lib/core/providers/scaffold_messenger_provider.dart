import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scaffold_messenger_provider.g.dart';

/// Global key for the ScaffoldMessenger so background providers can show
/// snackbars even after the originating screen has been popped.
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Provides the [ScaffoldMessengerState] for showing snackbars from anywhere.
@Riverpod(keepAlive: true)
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKeyProvider(Ref ref) {
  return scaffoldMessengerKey;
}
