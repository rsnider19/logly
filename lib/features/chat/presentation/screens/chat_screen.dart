import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Placeholder chat screen for LoglyAI.
///
/// This is a temporary scaffold that Plan 02 will replace with
/// the full flutter_chat_ui Chat widget and custom builders.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoglyAI'),
      ),
      body: const Center(
        child: Text('Chat screen placeholder'),
      ),
    );
  }
}
