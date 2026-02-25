import 'package:flutter/material.dart';
import 'screens/chat_inbox_screen.dart';

/// Dashboard Integration für Chat
/// Diese Screen wird vom Dashboard aufgerufen und zeigt den Chat-Inbox
class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatInboxScreen();
  }
}

