import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/providers/chat_providers.dart';
import '../../domain/models/chat_thread.dart';
import 'chat_detail_screen.dart';

class ChatInboxScreen extends ConsumerStatefulWidget {
  final String? conversationType;

  const ChatInboxScreen({
    super.key,
    this.conversationType,
  });

  @override
  ConsumerState<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends ConsumerState<ChatInboxScreen> {
  final _searchController = TextEditingController();
  bool _showArchived = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversationsAsync = _showArchived
        ? ref.watch(archivedConversationsProvider)
        : ref.watch(activeConversationsProvider);
    
    final searchQuery = _searchController.text.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(
              _showArchived ? LucideIcons.archive : LucideIcons.inbox,
              color: _showArchived
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            tooltip: _showArchived ? 'Show Active' : 'Show Archived',
            onPressed: () => setState(() => _showArchived = !_showArchived),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(LucideIcons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
          // Conversations List
          Expanded(
            child: conversationsAsync.when(
              data: (conversations) {
                final filtered = conversations
                    .where((c) =>
                        (c.title?.toLowerCase().contains(searchQuery) ?? false) ||
                        (c.id.toLowerCase().contains(searchQuery)) ||
                        c.participants.any((p) =>
                            (p.userName?.toLowerCase().contains(searchQuery) ?? false)))
                    .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.messageCircle,
                          size: 64,
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showArchived ? 'No archived conversations' : 'No messages yet',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final thread = filtered[index];
                    return _ConversationTile(
                      thread: thread,
                      onTap: () => _openConversation(context, thread),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.alertCircle,
                      size: 64,
                      color: Colors.red.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text('Error loading conversations: $error'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewChatDialog(context),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  void _openConversation(BuildContext context, ChatThread thread) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(conversationId: thread.id),
      ),
    );
  }

  void _showNewChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Chat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.user),
              title: const Text('Personal Message'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(LucideIcons.users),
              title: const Text('Group Chat'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(LucideIcons.helpCircle),
              title: const Text('Support'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTile extends ConsumerWidget {
  final ChatThread thread;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.thread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = _getDisplayName();
    final displayType = _getDisplayType();
    final unreadCount = thread.unreadCount;

    return Container(
      color: unreadCount > 0
          ? Theme.of(context).primaryColor.withOpacity(0.05)
          : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildAvatar(),
        title: Row(
          children: [
            Expanded(
              child: Text(
                displayName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: unreadCount > 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              thread.lastMessage?.content ?? 'No messages',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  displayType,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(thread.lastMessageAt),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(LucideIcons.volumeX, size: 18),
                  SizedBox(width: 8),
                  Text('Mute'),
                ],
              ),
              onTap: () {
                ref.read(conversationNotifierProvider.notifier)
                    .muteConversation(thread.id);
              },
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                    thread.status == ThreadStatus.archived
                        ? LucideIcons.inbox
                        : LucideIcons.archive,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(thread.status == ThreadStatus.archived
                      ? 'Unarchive'
                      : 'Archive'),
                ],
              ),
              onTap: () {
                if (thread.status == ThreadStatus.archived) {
                  ref.read(conversationNotifierProvider.notifier)
                      .unarchiveConversation(thread.id);
                } else {
                  ref.read(conversationNotifierProvider.notifier)
                      .archiveConversation(thread.id);
                }
              },
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(LucideIcons.trash2, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
              onTap: () {
                // TODO: Implement delete
              },
            ),
          ],
          child: const Icon(LucideIcons.moreVertical),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAvatar() {
    if (thread.type == ConversationType.groupChat) {
      return CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Icon(
          LucideIcons.users,
          color: AppColors.primary,
        ),
      );
    }

    final firstParticipant =
        thread.participants.isNotEmpty ? thread.participants.first : null;
    final initials = (firstParticipant?.userName ?? 'U')
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .join()
        .toUpperCase()
        .substring(0, 1);

    return CircleAvatar(
      backgroundColor: AppColors.primary.withOpacity(0.2),
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getDisplayName() {
    switch (thread.type) {
      case ConversationType.groupChat:
        return thread.title ?? 'Group Chat';
      case ConversationType.support:
        return 'Support Team';
      case ConversationType.bookingDM:
        return 'Appointment';
      case ConversationType.personalDM:
        return thread.participants
            .where((p) => p.userId != 'CURRENT_USER_ID') // TODO: Get actual user
            .firstOrNull
            ?.userName ??
            'Unknown';
    }
  }

  String _getDisplayType() {
    switch (thread.type) {
      case ConversationType.groupChat:
        return 'Group (${thread.participants.length})';
      case ConversationType.support:
        return 'Support';
      case ConversationType.bookingDM:
        return 'Appointment';
      case ConversationType.personalDM:
        return 'Direct';
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final threadDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (threadDate == today) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (threadDate == yesterday) {
      return 'Yesterday';
    } else if (threadDate.year == today.year) {
      return DateFormat('MMM d').format(dateTime);
    } else {
      return DateFormat('MMM d, y').format(dateTime);
    }
  }
}
