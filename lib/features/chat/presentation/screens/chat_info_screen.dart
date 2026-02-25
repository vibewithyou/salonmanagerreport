import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/providers/chat_providers.dart';
import '../../domain/models/chat_thread.dart';

class ChatInfoScreen extends ConsumerWidget {
  final String conversationId;

  const ChatInfoScreen({
    super.key,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(conversationProvider(conversationId)).when(
      data: (thread) => thread == null
          ? Scaffold(
              appBar: AppBar(title: const Text('Chat Info')),
              body: const Center(child: Text('Conversation not found')),
            )
          : _buildContent(context, ref, thread),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Chat Info')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, st) => Scaffold(
        appBar: AppBar(title: const Text('Chat Info')),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ChatThread thread) {
    final isMuted = thread.participants
        .any((p) => p.isMuted == true); // TODO: Check for current user

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Info'),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Header  
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Icon(
                    thread.type == ConversationType.groupChat
                        ? LucideIcons.users
                        : LucideIcons.messageCircle,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                if (thread.type == ConversationType.groupChat)
                  Text(
                    thread.title ?? 'Group Chat',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  )
                else
                  Text(
                    thread.participants.isNotEmpty
                        ? thread.participants.first.userName ?? 'Chat'
                        : 'Chat',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                if (thread.type == ConversationType.groupChat)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${thread.participants.length} members',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),
          // Notifications Settings
          ListTile(
            leading: const Icon(
              LucideIcons.volumeX,
              size: 20,
            ),
            title: const Text('Mute Notifications'),
            trailing: Switch(
              value: isMuted,
              onChanged: (value) {
                if (value) {
                  ref
                      .read(conversationNotifierProvider.notifier)
                      .muteConversation(thread.id);
                } else {
                  ref
                      .read(conversationNotifierProvider.notifier)
                      .unmuteConversation(thread.id);
                }
              },
            ),
          ),
          const Divider(),
          // Participants Section
          if (thread.type == ConversationType.groupChat)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Members',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...thread.participants.map((participant) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primary.withOpacity(0.2),
                              child: Text(
                                (participant.userName ?? 'U')[0].toUpperCase(),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    participant.userName ?? 'Unknown',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                  Text(
                                    _roleToString(participant.role),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (participant.isBlocked == true)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Blocked',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          const Divider(),
          // Archive Option
          ListTile(
            leading: const Icon(LucideIcons.archive, size: 20),
            title: const Text('Archive Chat'),
            onTap: () {
              ref
                  .read(conversationNotifierProvider.notifier)
                  .archiveConversation(thread.id);
              Navigator.pop(context);
            },
          ),
          // Delete Option
          ListTile(
            leading: const Icon(LucideIcons.trash2, color: Colors.red, size: 20),
            title: const Text(
              'Delete Chat',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              _showDeleteConfirmation(context, ref);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat?'),
        content: const Text(
          'Are you sure you want to delete this conversation? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // TODO: Delete conversation
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _roleToString(ParticipantRole role) {
    switch (role) {
      case ParticipantRole.owner:
        return 'Owner';
      case ParticipantRole.admin:
        return 'Admin';
      case ParticipantRole.member:
        return 'Member';
    }
  }
}
