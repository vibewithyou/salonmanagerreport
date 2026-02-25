import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/chat_thread.dart';
import '../dto/chat_thread_dto.dart';

abstract class ChatRepository {
  Future<List<ChatThread>> getConversations(String salonId, String userId);
  Future<ChatThread?> getConversation(String conversationId);
  Future<List<ChatMessage>> getMessages(String conversationId, {int limit = 50, int offset = 0});
  Future<ChatMessage?> getMessage(String messageId);
  Future<ChatMessage> sendMessage(String conversationId, String senderId, {
    required String content,
    ChatMessageType type = ChatMessageType.text,
    String? mediaId,
    String? replyToMessageId,
  });
  Future<void> markMessageAsRead(String messageId, String userId);
  Future<void> editMessage(String messageId, String newContent);
  Future<void> deleteMessageForMe(String messageId, String userId);
  Future<void> deleteMessageForAll(String messageId);
  Future<void> archiveConversation(String conversationId, String userId);
  Future<void> unarchiveConversation(String conversationId, String userId);
  Future<void> muteConversation(String conversationId, String userId);
  Future<void> unmuteConversation(String conversationId, String userId);
  Future<void> blockParticipant(String conversationId, String userToBlockId);
  Future<void> unblockParticipant(String conversationId, String userToUnblockId);
  Future<ChatThread> createPersonalDMThread(String salonId, String initiatorId, String recipientId);
  Future<ChatThread> createGroupChatThread(String salonId, String title, List<String> participantIds);
  Future<void> closeBookingDMThread(String threadId, String salonId);
  
  // Search
  Future<List<ChatMessage>> searchMessages(String conversationId, String query);
  Future<List<ChatThread>> searchConversations(String salonId, String query);
  Future<void> addReaction(String messageId, String emoji);
  Future<void> removeReaction(String messageId, String emoji);
  Future<void> pinMessage(String messageId, String userId);
  Future<void> unpinMessage(String messageId);
  
  // Read Receipts
  Future<List<String>> getMessageReads(String messageId);
  
  Stream<ChatMessage> subscribeToMessages(String conversationId);
  Stream<TypingIndicator> subscribeToTyping(String conversationId);
}

class ChatRepositoryImpl implements ChatRepository {
  final SupabaseClient _supabase;

  ChatRepositoryImpl(this._supabase);

  @override
  Future<List<ChatThread>> getConversations(String salonId, String userId) async {
    try {
      // Hole Conversations mit Participant Info
      final response = await _supabase
          .from('conversations')
          .select('''
            id,
            salon_id,
            type,
            appointment_id,
            title,
            last_message_at,
            created_at,
            updated_at,
            status
          ''')
          .eq('salon_id', salonId)
          .order('last_message_at', ascending: false);

      if (response.isEmpty) return [];

      // Filter: Nur Conversations wo User ein Participant ist
      final List<ChatThread> threads = [];
      for (final data in response as List) {
        final threadId = data['id'] as String;
        
        // Check if user is participant
        final participantResponse = await _supabase
            .from('conversation_participants')
            .select('id')
            .eq('conversation_id', threadId)
            .eq('user_id', userId)
          .maybeSingle();
        
        if (participantResponse != null) {
          final thread = ChatThreadDto.fromJson(data).toDomain();
          threads.add(thread);
        }
      }

      return threads;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatThread?> getConversation(String conversationId) async {
    try {
      final response = await _supabase
          .from('conversations')
          .select()
          .eq('id', conversationId)
          .single();

      final thread = ChatThreadDto.fromJson(response).toDomain();
      
      // Load participants
      final participantsResponse = await _supabase
          .from('conversation_participants')
          .select()
          .eq('conversation_id', conversationId);

      final participants = (participantsResponse as List)
          .map((p) => ChatParticipantDto.fromJson(p).toDomain())
          .toList();

      return thread.copyWith(participants: participants);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ChatMessage>> getMessages(
    String conversationId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .isFilter('deleted_at', null) // Nur nicht gelöschte
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((m) => ChatMessageDto.fromJson(m).toDomain())
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ChatMessage?> getMessage(String messageId) async {
    try {
      final response = await _supabase
          .from('messages')
          .select()
          .eq('id', messageId)
          .single();

      return ChatMessageDto.fromJson(response).toDomain();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ChatMessage> sendMessage(
    String conversationId,
    String senderId, {
    required String content,
    ChatMessageType type = ChatMessageType.text,
    String? mediaId,
    String? replyToMessageId,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      final response = await _supabase.from('messages').insert([
        {
          'conversation_id': conversationId,
          'sender_id': senderId,
          'content': content,
          'message_type': messageTypeToString(type),
          'media_id': mediaId,
          'reply_to_message_id': replyToMessageId,
          'created_at': now,
          'updated_at': now,
        }
      ]).select().single();

      // Update conversation last_message_at
      await _supabase
          .from('conversations')
          .update({'last_message_at': now})
          .eq('id', conversationId);

      return ChatMessageDto.fromJson(response).toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markMessageAsRead(String messageId, String userId) async {
    try {
      final existingRead = await _supabase
          .from('message_reads')
          .select('id')
          .eq('message_id', messageId)
          .eq('user_id', userId);

      if ((existingRead as List).isNotEmpty) return;

      await _supabase.from('message_reads').insert({
        'message_id': messageId,
        'user_id': userId,
        'read_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editMessage(String messageId, String newContent) async {
    try {
      await _supabase
          .from('messages')
          .update({
            'content': newContent,
            'edited_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', messageId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteMessageForMe(String messageId, String userId) async {
    try {
      // Soft-Delete für diesen User
      final message = await getMessage(messageId);
      if (message == null) throw Exception('Message not found');

      final deletedForUserIds = [...message.deletedForUserIds, userId];

      await _supabase
          .from('messages')
          .update({
            'deleted_for_user_ids': deletedForUserIds,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', messageId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteMessageForAll(String messageId) async {
    try {
      await _supabase
          .from('messages')
          .update({
            'deleted_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', messageId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> archiveConversation(String conversationId, String userId) async {
    try {
      final now = DateTime.now().toIso8601String();
      await _supabase
          .from('conversation_participants')
          .update({'archived_at': now, 'updated_at': now})
          .eq('conversation_id', conversationId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unarchiveConversation(String conversationId, String userId) async {
    try {
      final now = DateTime.now().toIso8601String();
      await _supabase
          .from('conversation_participants')
          .update({'archived_at': null, 'updated_at': now})
          .eq('conversation_id', conversationId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> muteConversation(String conversationId, String userId) async {
    try {
      final now = DateTime.now().toIso8601String();
      await _supabase
          .from('conversation_participants')
          .update({'is_muted': true, 'updated_at': now})
          .eq('conversation_id', conversationId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unmuteConversation(String conversationId, String userId) async {
    try {
      final now = DateTime.now().toIso8601String();
      await _supabase
          .from('conversation_participants')
          .update({'is_muted': false, 'updated_at': now})
          .eq('conversation_id', conversationId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> blockParticipant(String conversationId, String userToBlockId) async {
    try {
      final now = DateTime.now().toIso8601String();
      await _supabase
          .from('conversation_participants')
          .update({'is_blocked': true, 'updated_at': now})
          .eq('conversation_id', conversationId)
          .eq('user_id', userToBlockId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unblockParticipant(String conversationId, String userToUnblockId) async {
    try {
      final now = DateTime.now().toIso8601String();
      await _supabase
          .from('conversation_participants')
          .update({'is_blocked': false, 'updated_at': now})
          .eq('conversation_id', conversationId)
          .eq('user_id', userToUnblockId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatThread> createPersonalDMThread(
    String salonId,
    String initiatorId,
    String recipientId,
  ) async {
    try {
      final now = DateTime.now().toIso8601String();
      final threadResponse = await _supabase
          .from('conversations')
          .insert({
            'salon_id': salonId,
            'type': 'personal_dm',
            'last_message_at': now,
            'created_at': now,
            'updated_at': now,
            'status': 'active',
          })
          .select()
          .single();

      final threadId = threadResponse['id'];

      // Add participants
      await _supabase.from('conversation_participants').insert([
        {
          'conversation_id': threadId,
          'user_id': initiatorId,
          'role': 'member',
          'created_at': now,
          'updated_at': now,
        },
        {
          'conversation_id': threadId,
          'user_id': recipientId,
          'role': 'member',
          'created_at': now,
          'updated_at': now,
        },
      ]);

      return ChatThreadDto.fromJson(threadResponse).toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatThread> createGroupChatThread(
    String salonId,
    String title,
    List<String> participantIds,
  ) async {
    try {
      final now = DateTime.now().toIso8601String();
      final threadResponse = await _supabase
          .from('conversations')
          .insert({
            'salon_id': salonId,
            'type': 'group_chat',
            'title': title,
            'last_message_at': now,
            'created_at': now,
            'updated_at': now,
            'status': 'active',
          })
          .select()
          .single();

      final threadId = threadResponse['id'];

      // Add participants
      final participantInserts = participantIds.map((userId) => ({
        'conversation_id': threadId,
        'user_id': userId,
        'role': 'member',
        'created_at': now,
        'updated_at': now,
      })).toList();

      await _supabase.from('conversation_participants').insert(participantInserts);

      return ChatThreadDto.fromJson(threadResponse).toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> closeBookingDMThread(String threadId, String salonId) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      // Mark thread as closed
      await _supabase
          .from('conversations')
          .update({
            'status': 'closed',
            'updated_at': now,
          })
          .eq('id', threadId)
          .eq('salon_id', salonId);

      // Disable write for all participants
      await _supabase
          .from('conversation_participants')
          .update({
            'can_write': false,
            'updated_at': now,
          })
          .eq('conversation_id', threadId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatMessage>> searchMessages(String conversationId, String query) async {
    try {
      final response = await _supabase
          .from('messages')
          .select('''
            id,
            conversation_id,
            sender_id,
            content,
            message_type,
            reply_to_message_id,
            edited_at,
            deleted_for_user_ids,
            reactions,
            pinned_by,
            pinned_at,
            created_at
          ''')
          .eq('conversation_id', conversationId)
          .ilike('content', '%$query%')  // Case-insensitive search
          .order('created_at', ascending: false)
          .limit(100);

      return (response as List)
          .map((json) => ChatMessageDto.fromJson(json).toDomain())
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatThread>> searchConversations(String salonId, String query) async {
    try {
      final response = await _supabase
          .from('conversations')
          .select('''
            id,
            salon_id,
            type,
            status,
            title,
            last_message_at,
            created_at,
            archived_at,
            conversation_participants(
              id,
              user_id,
              role,
              joined_at,
              last_seen_at
            )
          ''')
          .eq('salon_id', salonId)
          .or('title.ilike.%$query%,conversation_participants->>user_id.ilike.%$query%')
          .order('last_message_at', ascending: false);

      return (response as List)
          .map((json) => ChatThreadDto.fromJson(json).toDomain())
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addReaction(String messageId, String emoji) async {
    try {
      // Hole aktuelle reactions
      final response = await _supabase
          .from('messages')
          .select('reactions')
          .eq('id', messageId)
          .single();

      final reactions = Map<String, int>.from(response['reactions'] ?? {});
      reactions[emoji] = (reactions[emoji] ?? 0) + 1;

      // Update reactions
      await _supabase
          .from('messages')
          .update({'reactions': reactions})
          .eq('id', messageId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeReaction(String messageId, String emoji) async {
    try {
      final response = await _supabase
          .from('messages')
          .select('reactions')
          .eq('id', messageId)
          .single();

      final reactions = Map<String, int>.from(response['reactions'] ?? {});
      if (reactions.containsKey(emoji)) {
        reactions[emoji] = reactions[emoji]! - 1;
        if (reactions[emoji]! <= 0) {
          reactions.remove(emoji);
        }

        await _supabase
            .from('messages')
            .update({'reactions': reactions})
            .eq('id', messageId);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> pinMessage(String messageId, String userId) async {
    try {
      final now = DateTime.now();
      await _supabase
          .from('messages')
          .update({
            'pinned_by': userId,
            'pinned_at': now.toIso8601String(),
          })
          .eq('id', messageId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unpinMessage(String messageId) async {
    try {
      await _supabase
          .from('messages')
          .update({
            'pinned_by': null,
            'pinned_at': null,
          })
          .eq('id', messageId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getMessageReads(String messageId) async {
    try {
      final response = await _supabase
          .from('message_reads')
          .select('reader_id')
          .eq('message_id', messageId);

      return (response as List).map((json) => json['reader_id'] as String).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Stream<ChatMessage> subscribeToMessages(String conversationId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .expand(
          (rows) => rows
              .map((row) => ChatMessageDto.fromJson(row).toDomain())
              .toList(),
        );
  }

  @override
  Stream<TypingIndicator> subscribeToTyping(String conversationId) {
    return _supabase
        .from('typing_indicators')
        .stream(primaryKey: ['conversation_id', 'user_id'])
        .eq('conversation_id', conversationId)
        .expand(
          (rows) => rows
              .map((row) => TypingIndicator.fromJson(row))
              .toList(),
        );
  }
}
