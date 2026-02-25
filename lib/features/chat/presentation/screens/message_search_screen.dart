import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/providers/chat_providers.dart';
import '../../domain/models/chat_thread.dart';
import '../widgets/advanced_message_search.dart';

class MessageSearchScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const MessageSearchScreen({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<MessageSearchScreen> createState() => _MessageSearchScreenState();
}

class _MessageSearchScreenState extends ConsumerState<MessageSearchScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  late MessageSearchParams _searchParams;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchParams = MessageSearchParams();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(
      messageSearchProvider((widget.conversationId, _searchQuery)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Messages'),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Advanced Search Filter
          AdvancedMessageSearch(
            conversationId: widget.conversationId,
            onSearch: (params) {
              setState(() {
                _searchParams = params;
                _searchQuery = params.query ?? '';
                _searchController.text = _searchQuery;
              });
            },
          ),

          // Search Results
          Expanded(
            child: _searchQuery.isEmpty && !_searchParams.hasActiveFilters
                ? _buildEmptyState()
                : searchResults.when(
                    data: (messages) {
                      if (messages.isEmpty) {
                        return _buildNoResultsState();
                      }
                      return _buildResultsList(messages);
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, st) => Center(
                      child: Text('Error: $error'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.search,
            size: 48,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Type to search messages',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.searchX,
            size: 48,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No messages found',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(List<ChatMessage> messages) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _SearchResultTile(message: message, searchQuery: _searchQuery);
      },
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final ChatMessage message;
  final String searchQuery;

  const _SearchResultTile({
    required this.message,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: CircleAvatar(
          backgroundImage: message.senderAvatarUrl != null
              ? NetworkImage(message.senderAvatarUrl!)
              : null,
          child: message.senderAvatarUrl == null
              ? Text(message.senderName?.characters.first.toUpperCase() ?? '?')
              : null,
        ),
        title: Text(message.senderName ?? 'Unknown'),
        subtitle: _buildHighlightedContent(context),
        trailing: Text(
          DateFormat('HH:mm').format(message.createdAt),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }

  Widget _buildHighlightedContent(BuildContext context) {
    final content = message.content ?? '';
    final lowerContent = content.toLowerCase();
    final lowerQuery = searchQuery.toLowerCase();

    if (!lowerContent.contains(lowerQuery)) {
      return Text(
        content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    final startIndex = lowerContent.indexOf(lowerQuery);
    final endIndex = startIndex + searchQuery.length;

    final before = content.substring(0, startIndex);
    final highlighted = content.substring(startIndex, endIndex);
    final after = content.substring(endIndex);

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall,
        children: [
          TextSpan(text: before),
          TextSpan(
            text: highlighted,
            style: const TextStyle(
              backgroundColor: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}
