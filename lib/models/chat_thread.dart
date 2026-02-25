enum ConversationType {
  personalDM,
  groupChat,
  support,
  bookingDM,
}

enum ParticipantRole {
  member,
  admin,
  owner,
}

enum ThreadStatus {
  active,
  closed,
  archived,
}

enum ChatMessageType {
  text,
  image,
  file,
  video,
  voice,
  system,
}

class ChatThread {
  final String id;
  final String salonId;
  final ConversationType type;
  final String? appointmentId;
  final String? title;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ThreadStatus status;
  final List<ChatParticipant> participants;
  final ChatMessage? lastMessage;
  final int unreadCount;

  ChatThread({
    required this.id,
    required this.salonId,
    required this.type,
    this.appointmentId,
    this.title,
    required this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
    this.status = ThreadStatus.active,
    List<ChatParticipant>? participants,
    this.lastMessage,
    this.unreadCount = 0,
  }) : participants = participants ?? [];

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    return ChatThread(
      id: json['id']?.toString() ?? '',
      salonId: json['salon_id']?.toString() ?? '',
      type: _parseConversationType(json['type']?.toString()),
      appointmentId: json['appointment_id']?.toString(),
      title: json['title']?.toString(),
      lastMessageAt: _parseDate(json['last_message_at']) ?? DateTime.now(),
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updated_at']) ?? DateTime.now(),
      status: _parseThreadStatus(json['status']?.toString()),
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }

  ChatThread copyWith({
    String? id,
    String? salonId,
    ConversationType? type,
    String? appointmentId,
    String? title,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    ThreadStatus? status,
    List<ChatParticipant>? participants,
    ChatMessage? lastMessage,
    int? unreadCount,
  }) {
    return ChatThread(
      id: id ?? this.id,
      salonId: salonId ?? this.salonId,
      type: type ?? this.type,
      appointmentId: appointmentId ?? this.appointmentId,
      title: title ?? this.title,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class ChatParticipant {
  final String id;
  final String conversationId;
  final String userId;
  final ParticipantRole role;
  final bool isActive;
  final String? lastReadMessageId;
  final DateTime? archivedAt;
  final bool isMuted;
  final bool isBlocked;
  final bool canWrite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userName;

  ChatParticipant({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.role,
    this.isActive = true,
    this.lastReadMessageId,
    this.archivedAt,
    this.isMuted = false,
    this.isBlocked = false,
    this.canWrite = true,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      role: _parseParticipantRole(json['role']?.toString()),
      isActive: json['is_active'] as bool? ?? true,
      lastReadMessageId: json['last_read_message_id']?.toString(),
      archivedAt: _parseDate(json['archived_at']),
      isMuted: json['is_muted'] as bool? ?? false,
      isBlocked: json['is_blocked'] as bool? ?? false,
      canWrite: json['can_write'] as bool? ?? true,
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updated_at']) ?? DateTime.now(),
      userName: json['user_name']?.toString(),
    );
  }
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String? content;
  final ChatMessageType messageType;
  final String? mediaId;
  final String? replyToMessageId;
  final DateTime? editedAt;
  final DateTime? deletedAt;
  final List<String> deletedForUserIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> readByUserIds;
  final String? senderName;
  final String? senderAvatarUrl;
  final ChatMessage? replyToMessage;
  final String? mediaUrl;
  final String? mediaType;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content,
    this.messageType = ChatMessageType.text,
    this.mediaId,
    this.replyToMessageId,
    this.editedAt,
    this.deletedAt,
    List<String>? deletedForUserIds,
    required this.createdAt,
    required this.updatedAt,
    List<String>? readByUserIds,
    this.senderName,
    this.senderAvatarUrl,
    this.replyToMessage,
    this.mediaUrl,
    this.mediaType,
  })  : deletedForUserIds = deletedForUserIds ?? [],
        readByUserIds = readByUserIds ?? [];

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      content: json['content']?.toString(),
      messageType: _parseMessageType(json['message_type']?.toString()),
      mediaId: json['media_id']?.toString(),
      replyToMessageId: json['reply_to_message_id']?.toString(),
      editedAt: _parseDate(json['edited_at']),
      deletedAt: _parseDate(json['deleted_at']),
      deletedForUserIds: _parseStringList(json['deleted_for_user_ids']),
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updated_at']) ?? DateTime.now(),
      readByUserIds: _parseStringList(json['read_by_user_ids']),
      senderName: json['sender_name']?.toString(),
      senderAvatarUrl: json['sender_avatar_url']?.toString(),
      mediaUrl: json['media_url']?.toString(),
      mediaType: json['media_type']?.toString(),
    );
  }
}

class MessageRead {
  final String id;
  final String messageId;
  final String userId;
  final DateTime readAt;

  MessageRead({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.readAt,
  });

  factory MessageRead.fromJson(Map<String, dynamic> json) {
    return MessageRead(
      id: json['id']?.toString() ?? '',
      messageId: json['message_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      readAt: _parseDate(json['read_at']) ?? DateTime.now(),
    );
  }
}

class TypingIndicator {
  final String conversationId;
  final String userId;
  final String userName;
  final DateTime startedAt;

  TypingIndicator({
    required this.conversationId,
    required this.userId,
    required this.userName,
    required this.startedAt,
  });

  factory TypingIndicator.fromJson(Map<String, dynamic> json) {
    return TypingIndicator(
      conversationId: json['conversation_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      startedAt: _parseDate(json['started_at']) ?? DateTime.now(),
    );
  }
}

ConversationType _parseConversationType(String? value) {
  switch (value) {
    case 'group_chat':
    case 'groupChat':
      return ConversationType.groupChat;
    case 'support':
      return ConversationType.support;
    case 'booking_dm':
    case 'bookingDM':
      return ConversationType.bookingDM;
    case 'personal_dm':
    case 'personalDM':
    default:
      return ConversationType.personalDM;
  }
}

ParticipantRole _parseParticipantRole(String? value) {
  switch (value) {
    case 'admin':
      return ParticipantRole.admin;
    case 'owner':
      return ParticipantRole.owner;
    case 'member':
    default:
      return ParticipantRole.member;
  }
}

ThreadStatus _parseThreadStatus(String? value) {
  switch (value) {
    case 'closed':
      return ThreadStatus.closed;
    case 'archived':
      return ThreadStatus.archived;
    case 'active':
    default:
      return ThreadStatus.active;
  }
}

ChatMessageType _parseMessageType(String? value) {
  switch (value) {
    case 'image':
      return ChatMessageType.image;
    case 'file':
      return ChatMessageType.file;
    case 'video':
      return ChatMessageType.video;
    case 'voice':
      return ChatMessageType.voice;
    case 'system':
      return ChatMessageType.system;
    case 'text':
    default:
      return ChatMessageType.text;
  }
}

DateTime? _parseDate(dynamic value) {
  if (value is DateTime) {
    return value;
  }
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}

List<String> _parseStringList(dynamic value) {
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }
  return [];
}
