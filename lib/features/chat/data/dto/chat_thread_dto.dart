import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/chat_thread.dart';

part 'chat_thread_dto.freezed.dart';
part 'chat_thread_dto.g.dart';

@freezed
class ChatThreadDto with _$ChatThreadDto {
  const factory ChatThreadDto({
    required String id,
    required String salonId,
    required String type,
    String? appointmentId,
    String? title,
    required String lastMessageAt,
    required String createdAt,
    required String updatedAt,
    String? status,
  }) = _ChatThreadDto;

  const ChatThreadDto._();

  factory ChatThreadDto.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadDtoFromJson(json);

  /// Konversion zu Domain Model
  ChatThread toDomain() {
    return ChatThread(
      id: id,
      salonId: salonId,
      type: _stringToType(type),
      appointmentId: appointmentId,
      title: title,
      lastMessageAt: DateTime.parse(lastMessageAt),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      status: _stringToStatus(status ?? 'active'),
    );
  }
}

@freezed
class ChatParticipantDto with _$ChatParticipantDto {
  const factory ChatParticipantDto({
    required String id,
    required String conversationId,
    required String userId,
    required String role,
    required bool isActive,
    String? lastReadMessageId,
    String? archivedAt,
    bool? isMuted,
    bool? isBlocked,
    bool? canWrite,
    required String createdAt,
    required String updatedAt,
  }) = _ChatParticipantDto;

  const ChatParticipantDto._();

  factory ChatParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$ChatParticipantDtoFromJson(json);

  ChatParticipant toDomain() {
    return ChatParticipant(
      id: id,
      conversationId: conversationId,
      userId: userId,
      role: _stringToRole(role),
      isActive: isActive,
      lastReadMessageId: lastReadMessageId,
      archivedAt:
          archivedAt != null ? DateTime.parse(archivedAt!) : null,
      isMuted: isMuted ?? false,
      isBlocked: isBlocked ?? false,
      canWrite: canWrite ?? true,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}

@freezed
class ChatMessageDto with _$ChatMessageDto {
  const factory ChatMessageDto({
    required String id,
    required String conversationId,
    required String senderId,
    String? content,
    String? messageType,
    String? mediaId,
    String? replyToMessageId,
    String? editedAt,
    String? deletedAt,
    List<String>? deletedForUserIds,
    required String createdAt,
    required String updatedAt,
  }) = _ChatMessageDto;

  const ChatMessageDto._();

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);

  ChatMessage toDomain() {
    return ChatMessage(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      messageType: _stringToMessageType(messageType ?? 'text'),
      mediaId: mediaId,
      replyToMessageId: replyToMessageId,
      editedAt: editedAt != null ? DateTime.parse(editedAt!) : null,
      deletedAt: deletedAt != null ? DateTime.parse(deletedAt!) : null,
      deletedForUserIds: deletedForUserIds ?? [],
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}

@freezed
class MessageReadDto with _$MessageReadDto {
  const factory MessageReadDto({
    required String id,
    required String messageId,
    required String userId,
    required String readAt,
  }) = _MessageReadDto;

  const MessageReadDto._();

  factory MessageReadDto.fromJson(Map<String, dynamic> json) =>
      _$MessageReadDtoFromJson(json);

  MessageRead toDomain() {
    return MessageRead(
      id: id,
      messageId: messageId,
      userId: userId,
      readAt: DateTime.parse(readAt),
    );
  }
}

// Conversion Helpers
ConversationType _stringToType(String value) {
  switch (value) {
    case 'personal_dm':
      return ConversationType.personalDM;
    case 'group_chat':
      return ConversationType.groupChat;
    case 'support':
      return ConversationType.support;
    case 'booking_dm':
      return ConversationType.bookingDM;
    default:
      return ConversationType.personalDM;
  }
}

ParticipantRole _stringToRole(String value) {
  switch (value.toLowerCase()) {
    case 'admin':
      return ParticipantRole.admin;
    case 'owner':
      return ParticipantRole.owner;
    default:
      return ParticipantRole.member;
  }
}

ChatMessageType _stringToMessageType(String value) {
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
    default:
      return ChatMessageType.text;
  }
}

ThreadStatus _stringToStatus(String value) {
  switch (value) {
    case 'closed':
      return ThreadStatus.closed;
    case 'archived':
      return ThreadStatus.archived;
    default:
      return ThreadStatus.active;
  }
}

String typeToString(ConversationType type) {
  switch (type) {
    case ConversationType.personalDM:
      return 'personal_dm';
    case ConversationType.groupChat:
      return 'group_chat';
    case ConversationType.support:
      return 'support';
    case ConversationType.bookingDM:
      return 'booking_dm';
  }
}

String roleToString(ParticipantRole role) {
  switch (role) {
    case ParticipantRole.admin:
      return 'admin';
    case ParticipantRole.owner:
      return 'owner';
    case ParticipantRole.member:
      return 'member';
  }
}

String messageTypeToString(ChatMessageType type) {
  switch (type) {
    case ChatMessageType.image:
      return 'image';
    case ChatMessageType.file:
      return 'file';
    case ChatMessageType.video:
      return 'video';
    case ChatMessageType.voice:
      return 'voice';
    case ChatMessageType.system:
      return 'system';
    default:
      return 'text';
  }
}
