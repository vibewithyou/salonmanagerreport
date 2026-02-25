// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatThreadDtoImpl _$$ChatThreadDtoImplFromJson(Map<String, dynamic> json) =>
    _$ChatThreadDtoImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      type: json['type'] as String,
      appointmentId: json['appointmentId'] as String?,
      title: json['title'] as String?,
      lastMessageAt: json['lastMessageAt'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$ChatThreadDtoImplToJson(_$ChatThreadDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'type': instance.type,
      'appointmentId': instance.appointmentId,
      'title': instance.title,
      'lastMessageAt': instance.lastMessageAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'status': instance.status,
    };

_$ChatParticipantDtoImpl _$$ChatParticipantDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ChatParticipantDtoImpl(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  userId: json['userId'] as String,
  role: json['role'] as String,
  isActive: json['isActive'] as bool,
  lastReadMessageId: json['lastReadMessageId'] as String?,
  archivedAt: json['archivedAt'] as String?,
  isMuted: json['isMuted'] as bool?,
  isBlocked: json['isBlocked'] as bool?,
  canWrite: json['canWrite'] as bool?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$$ChatParticipantDtoImplToJson(
  _$ChatParticipantDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'userId': instance.userId,
  'role': instance.role,
  'isActive': instance.isActive,
  'lastReadMessageId': instance.lastReadMessageId,
  'archivedAt': instance.archivedAt,
  'isMuted': instance.isMuted,
  'isBlocked': instance.isBlocked,
  'canWrite': instance.canWrite,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

_$ChatMessageDtoImpl _$$ChatMessageDtoImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageDtoImpl(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String?,
      messageType: json['messageType'] as String?,
      mediaId: json['mediaId'] as String?,
      replyToMessageId: json['replyToMessageId'] as String?,
      editedAt: json['editedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      deletedForUserIds: (json['deletedForUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$ChatMessageDtoImplToJson(
  _$ChatMessageDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'senderId': instance.senderId,
  'content': instance.content,
  'messageType': instance.messageType,
  'mediaId': instance.mediaId,
  'replyToMessageId': instance.replyToMessageId,
  'editedAt': instance.editedAt,
  'deletedAt': instance.deletedAt,
  'deletedForUserIds': instance.deletedForUserIds,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

_$MessageReadDtoImpl _$$MessageReadDtoImplFromJson(Map<String, dynamic> json) =>
    _$MessageReadDtoImpl(
      id: json['id'] as String,
      messageId: json['messageId'] as String,
      userId: json['userId'] as String,
      readAt: json['readAt'] as String,
    );

Map<String, dynamic> _$$MessageReadDtoImplToJson(
  _$MessageReadDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'messageId': instance.messageId,
  'userId': instance.userId,
  'readAt': instance.readAt,
};
