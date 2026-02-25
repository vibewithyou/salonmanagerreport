import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/models/chat_thread.dart';

class PinnedMessageBanner extends ConsumerWidget {
  final ChatMessage? pinnedMessage;
  final VoidCallback? onDismiss;

  const PinnedMessageBanner({
    super.key,
    required this.pinnedMessage,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pinnedMessage == null) return const SizedBox();

    return Container(
      color: Colors.amber.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(
            LucideIcons.pin,
            size: 16,
            color: Colors.amber.shade900,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pinned message',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.amber.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  pinnedMessage!.content ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade900,
                      ),
                ),
              ],
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(
                LucideIcons.x,
                size: 16,
                color: Colors.amber.shade900,
              ),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

class PinnedMessagesPanel extends ConsumerWidget {
  final String conversationId;
  final List<ChatMessage> pinnedMessages;

  const PinnedMessagesPanel({
    super.key,
    required this.conversationId,
    required this.pinnedMessages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pinnedMessages.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        border: Border(
          bottom: BorderSide(
            color: Colors.amber.shade300,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.pin,
                size: 16,
                color: Colors.amber.shade900,
              ),
              const SizedBox(width: 8),
              Text(
                'Pinned Messages (${pinnedMessages.length})',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: pinnedMessages.length,
              itemBuilder: (context, index) {
                final message = pinnedMessages[index];
                return _PinnedMessageCard(message: message);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PinnedMessageCard extends StatelessWidget {
  final ChatMessage message;

  const _PinnedMessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 8),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.senderName ?? 'Unknown',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                message.content ?? '',
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
