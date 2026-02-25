import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/providers/chat_providers.dart';
import '../../domain/models/chat_thread.dart';
import '../widgets/read_receipt_widget.dart';
import 'chat_info_screen.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  String? _replyingToMessageId;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversationAsync = ref.watch(conversationProvider(widget.conversationId));
    final messagesAsync = ref.watch(
      messagesProvider((
        widget.conversationId,
        limit: 50,
        offset: 0,
      )),
    );

    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          conversationAsync.maybeWhen(
            data: (thread) {
              if (thread != null && thread.status == ThreadStatus.closed) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.lock, size: 16, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        'Closed',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(LucideIcons.info),
            onPressed: () => _navigateToChatInfo(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
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
                          'No messages yet',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final showDate =
                        index == messages.length - 1 ||
                        !_isSameDay(
                          messages[messages.length - index].createdAt,
                          message.createdAt,
                        );

                    return Column(
                      children: [
                        if (showDate) _buildDateSeparator(message.createdAt),
                        _MessageBubble(
                          message: message,
                          conversationId: widget.conversationId,
                          onReply: () => setState(() =>
                              _replyingToMessageId = message.id),
                          onLongPress: () =>
                              _showMessageActions(context, message),
                        ),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
          // Input Area
          conversationAsync.maybeWhen(
            data: (thread) {
              if (thread == null) {
                return const SizedBox();
              }
              if (thread.status != ThreadStatus.closed) {
                return Column(
                  children: [
                    if (_replyingToMessageId != null) _buildReplyPreview(),
                    _buildMessageInput(),
                  ],
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    'This conversation is closed',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                );
              }
            },
            orElse: () => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return ref.watch(conversationProvider(widget.conversationId)).when(
      data: (thread) {
        if (thread == null) {
          return const Text('Chat');
        }
        String title = '';
        if (thread.type == ConversationType.groupChat) {
          title = thread.title ?? 'Group Chat';
        } else if (thread.type == ConversationType.support) {
          title = 'Support';
        } else {
          title = thread.participants.isNotEmpty
              ? thread.participants.first.userName ?? 'Chat'
              : 'Chat';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            if (thread.type == ConversationType.groupChat)
              Text(
                '${thread.participants.length} members',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
          ],
        );
      },
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (err, st) => Text(err.toString()),
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.textSecondary.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _formatDate(date),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColors.textSecondary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.primary, width: 3),
        ),
        color: AppColors.primary.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Replying to message',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Preview of message here...',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.x, size: 18),
            onPressed: () => setState(() => _replyingToMessageId = null),
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.textSecondary.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () {
              // TODO: Show attachment menu
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(LucideIcons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final userId = ref.read(currentUserIdProvider).value;
    if (userId == null) return;

    ref.read(chatNotifierProvider.notifier).sendMessage(
      widget.conversationId,
      userId,
      content: content,
      replyToMessageId: _replyingToMessageId,
    );

    _messageController.clear();
    setState(() => _replyingToMessageId = null);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _showMessageActions(BuildContext context, ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.reply),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _replyingToMessageId = message.id);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.copyCheck),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Copy to clipboard
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.penTool),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Edit message
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2, color: Colors.red),
              title: const Text('Delete for me', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(chatNotifierProvider.notifier)
                    .deleteMessageForMe(message.id);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash, color: Colors.red),
              title: const Text('Delete for all', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(chatNotifierProvider.notifier)
                    .deleteMessageForAll(message.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChatInfo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatInfoScreen(conversationId: widget.conversationId),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}

class _MessageBubble extends ConsumerWidget {
  final ChatMessage message;
  final String conversationId;
  final VoidCallback onReply;
  final VoidCallback onLongPress;

  const _MessageBubble({
    required this.message,
    required this.conversationId,
    required this.onReply,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider).value;
    final isOwn = message.senderId == currentUserId;
    
    // Check if message was read by any participant
    final messageReads = ref.watch(
      messageReadsProvider(message.id),
    );
    
    final isDelivered = true;
    final isRead = messageReads.maybeWhen(
      data: (reads) => reads.isNotEmpty,
      orElse: () => false,
    );

    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isOwn ? 64 : 16,
          4,
          isOwn ? 16 : 64,
          4,
        ),
        child: Align(
          alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isOwn
                  ? AppColors.primary
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: isOwn
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  message.content ?? '',
                  style: TextStyle(
                    color: isOwn ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(message.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: isOwn
                            ? Colors.white.withOpacity(0.7)
                            : AppColors.textSecondary,
                      ),
                    ),
                    if (isOwn) ...[
                      const SizedBox(width: 4),
                      ReadReceiptIndicator(
                        isSent: true,
                        isDelivered: isDelivered,
                        isRead: isRead,
                        size: 14,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
