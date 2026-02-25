import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReactionPickerWidget extends ConsumerWidget {
  final String messageId;
  final Function(String emoji) onEmojiSelected;

  const ReactionPickerWidget({
    super.key,
    required this.messageId,
    required this.onEmojiSelected,
  });

  static const List<String> commonEmojis = ['👍', '❤️', '😂', '😮', '😢', '🔥'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: commonEmojis
          .map((emoji) => GestureDetector(
                onTap: () {
                  onEmojiSelected(emoji);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
              ))
          .toList(),
    );
  }
}

class ReactionDisplay extends StatelessWidget {
  final String messageId;
  final Map<String, int>? reactions;
  final Function(String emoji) onReactionTap;

  const ReactionDisplay({
    super.key,
    required this.messageId,
    required this.reactions,
    required this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (reactions == null || reactions!.isEmpty) {
      return const SizedBox();
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: reactions!.entries
          .map((entry) => GestureDetector(
                onTap: () => onReactionTap(entry.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entry.key, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        entry.value.toString(),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
