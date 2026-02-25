import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Chat System Main Screen
class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ChatScreen({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatConversation> conversations = [
    ChatConversation(
      id: '1',
      name: 'Emma Davis',
      avatar: '👩‍💼',
      lastMessage: 'Thanks for the booking confirmation!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 2,
    ),
    ChatConversation(
      id: '2',
      name: 'Sarah Johnson',
      avatar: '👱‍♀️',
      lastMessage: 'Can you confirm my appointment?',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      unreadCount: 0,
    ),
    ChatConversation(
      id: '3',
      name: 'Team Chat',
      avatar: '👥',
      lastMessage: 'New schedule is ready!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 5,
    ),
  ];

  ChatConversation? _selectedConversation;
  String _searchQuery = '';

  List<ChatConversation> get filteredConversations {
    return conversations
        .where((conv) => conv.name
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      if (_selectedConversation != null) {
        return _buildChatDetail(_selectedConversation!);
      }
      return _buildConversationList();
    }

    return Row(
      children: [
        // Conversation List
        SizedBox(
          width: 350,
          child: _buildConversationListPanel(),
        ),

        // Chat Detail
        Expanded(
          child: _selectedConversation != null
              ? _buildChatDetail(_selectedConversation!)
              : _buildEmptyState(),
        ),
      ],
    );
  }

  Widget _buildConversationList() {
    return Scaffold(
      appBar: AppBar(
        title: Text('messages'.tr()),
      ),
      body: _buildConversationListPanel(),
    );
  }

  Widget _buildConversationListPanel() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search conversations...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // Conversation List
        Expanded(
          child: ListView.builder(
            itemCount: filteredConversations.length,
            itemBuilder: (context, index) {
              final conv = filteredConversations[index];
              final isSelected = _selectedConversation?.id == conv.id;

              return GestureDetector(
                onTap: () => setState(() => _selectedConversation = conv),
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : (isDark
                            ? AppColors.gray800
                            : AppColors.gray100),
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(
                            color: AppColors.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Text(
                        conv.avatar,
                        style: const TextStyle(fontSize: 32),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  conv.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  _formatTime(conv.timestamp),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.gray600,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.xs),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    conv.lastMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.gray600,
                                        ),
                                  ),
                                ),
                                if (conv.unreadCount > 0)
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: AppSpacing.sm),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      conv.unreadCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatDetail(ChatConversation conversation) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              conversation.avatar,
              style: const TextStyle(fontSize: 32),
            ),
            SizedBox(width: AppSpacing.md),
            Text(conversation.name),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.video_call_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.info_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildChatMessages(conversation),
    );
  }

  Widget _buildChatMessages(ChatConversation conversation) {
    final messages = _getConversationMessages(conversation.id);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: EdgeInsets.all(AppSpacing.lg),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[messages.length - 1 - index];
              return _ChatMessageBubble(
                message: message,
                isCurrentUser: message.senderId == widget.userId,
              );
            },
          ),
        ),
        _buildChatInputArea(conversation),
      ],
    );
  }

  Widget _buildChatInputArea(ChatConversation conversation) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : AppColors.gray50,
        border: Border(
          top: BorderSide(color: AppColors.gray200),
        ),
      ),
      child: Row(
        children: [
          // Attachment Button
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.attach_file, color: AppColors.primary),
            ),
          ),
          SizedBox(width: AppSpacing.md),

          // Input Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray800 : AppColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: inputController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),

          // Send Button
          GestureDetector(
            onTap: () {
              if (inputController.text.isNotEmpty) {
                // Send message
                inputController.clear();
              }
            },
            child: Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.send, color: Colors.white),
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
          Icon(Icons.chat_outlined, size: 64, color: AppColors.gray400),
          SizedBox(height: AppSpacing.lg),
          Text(
            'select_conversation'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.gray600,
                ),
          ),
        ],
      ),
    );
  }

  List<ChatMessage> _getConversationMessages(String conversationId) {
    return [
      ChatMessage(
        id: '1',
        conversationId: conversationId,
        senderId: 'user2',
        senderName: 'Emma Davis',
        content: 'Hi! How are you?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: '2',
        conversationId: conversationId,
        senderId: widget.userId,
        senderName: widget.userName,
        content: 'Hey! I\'m doing great, thanks for asking!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: '3',
        conversationId: conversationId,
        senderId: 'user2',
        senderName: 'Emma Davis',
        content: 'Thanks for the booking confirmation!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        type: MessageType.text,
      ),
    ];
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays > 0) {
      return DateFormat('MMM d').format(time);
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}

/// Chat Message Bubble
class _ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;

  const _ChatMessageBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            Text(
              '👤',
              style: const TextStyle(fontSize: 24),
            ),
          if (!isCurrentUser) SizedBox(width: AppSpacing.md),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? AppColors.primary
                    : AppColors.gray200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isCurrentUser
                          ? Colors.white
                          : AppColors.gray900,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: isCurrentUser
                          ? Colors.white.withOpacity(0.7)
                          : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) SizedBox(width: AppSpacing.md),
          if (isCurrentUser)
            Text(
              '👤',
              style: const TextStyle(fontSize: 24),
            ),
        ],
      ),
    );
  }
}

/// Chat Models
class ChatConversation {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;

  ChatConversation({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
  });
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final MessageType type;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.type,
  });
}

enum MessageType { text, image, file, voice }
