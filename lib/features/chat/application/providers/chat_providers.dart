import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repository/chat_repository.dart';
import '../../domain/models/chat_thread.dart';

// Supabase Client Provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Chat Repository Provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return ChatRepositoryImpl(supabase);
});

// Current User ID Provider (from Auth)
final currentUserIdProvider = FutureProvider<String?>((ref) async {
  final supabase = ref.watch(supabaseProvider);
  return supabase.auth.currentUser?.id;
});

// Current Salon ID Provider
final currentSalonIdProvider = FutureProvider<String?>((ref) async {
  final supabase = ref.watch(supabaseProvider);
  final userId = ref.watch(currentUserIdProvider).value;
  
  if (userId == null) return null;
  
  try {
    final response = await supabase
        .from('employees')
        .select('salon_id')
        .eq('user_id', userId)
        .single();
    
    return response['salon_id'] as String?;
  } catch (e) {
    return null;
  }
});

// ============ CONVERSATIONS ============

/// Alle Conversations für aktuellen User
final conversationsProvider = FutureProvider<List<ChatThread>>((ref) async {
  final repository = ref.watch(chatRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider).value;
  final salonId = ref.watch(currentSalonIdProvider).value;

  if (userId == null || salonId == null) return [];

  return repository.getConversations(salonId, userId);
});

/// Einzelne Conversation mit vollständigen Daten
final conversationProvider = FutureProvider.family<ChatThread?, String>((ref, threadId) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getConversation(threadId);
});

// ============ MESSAGES ============

/// Messages in einem Thread (mit Pagination)
final messagesProvider = FutureProvider.family
    .autoDispose<List<ChatMessage>, (String conversationId, {int limit, int offset})>(
  (ref, params) async {
    final repository = ref.watch(chatRepositoryProvider);
    return repository.getMessages(
      params.$1,
      limit: params.limit,
      offset: params.offset,
    );
  },
);

/// Realtime Messages Subscribe
final messagesRealtimeProvider =
    StreamProvider.family.autoDispose<ChatMessage, String>((ref, conversationId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.subscribeToMessages(conversationId);
});

// ============ STATE NOTIFIER (MUTATIONS) ============

/// Chat Controller für SendingMessages, Editing, etc.
class ChatNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRepository _repository;
  final Ref _ref;

  ChatNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> sendMessage(
    String conversationId,
    String senderId, {
    required String content,
    ChatMessageType type = ChatMessageType.text,
    String? mediaId,
    String? replyToMessageId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.sendMessage(
        conversationId,
        senderId,
        content: content,
        type: type,
        mediaId: mediaId,
        replyToMessageId: replyToMessageId,
      );
      state = const AsyncValue.data(null);
      // Refresh messages
      _ref.invalidate(messagesProvider((conversationId, limit: 50, offset: 0)));
      _ref.invalidate(conversationsProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> editMessage(String messageId, String newContent) async {
    try {
      await _repository.editMessage(messageId, newContent);
      _ref.invalidate(messagesProvider);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMessageForMe(String messageId) async {
    try {
      final userId = _ref.read(currentUserIdProvider).value;
      if (userId != null) {
        await _repository.deleteMessageForMe(messageId, userId);
        _ref.invalidate(messagesProvider);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMessageForAll(String messageId) async {
    try {
      await _repository.deleteMessageForAll(messageId);
      _ref.invalidate(messagesProvider);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      final userId = _ref.read(currentUserIdProvider).value;
      if (userId != null) {
        await _repository.markMessageAsRead(messageId, userId);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addReaction(String messageId, String emoji) async {
    try {
      await _repository.addReaction(messageId, emoji);
      _ref.invalidate(messagesProvider);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeReaction(String messageId, String emoji) async {
    try {
      await _repository.removeReaction(messageId, emoji);
      _ref.invalidate(messagesProvider);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> pinMessage(String messageId) async {
    try {
      final userId = _ref.read(currentUserIdProvider).value;
      if (userId != null) {
        await _repository.pinMessage(messageId, userId);
        _ref.invalidate(messagesProvider);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unpinMessage(String messageId) async {
    try {
      await _repository.unpinMessage(messageId);
      _ref.invalidate(messagesProvider);
    } catch (e) {
      rethrow;
    }
  }
}

final chatNotifierProvider = StateNotifierProvider<ChatNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(repository, ref);
});

// ============ CONVERSATION MUTATIONS ============

class ConversationNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRepository _repository;
  final Ref _ref;

  ConversationNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> archiveConversation(String conversationId) async {
    try {
      final userId = _ref.read(currentUserIdProvider).value;
      if (userId != null) {
        await _repository.archiveConversation(conversationId, userId);
        _ref.invalidate(conversationsProvider);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unarchiveConversation(String conversationId) async {
    try {
      final userId = _ref.read(currentUserIdProvider).value;
      if (userId != null) {
        await _repository.unarchiveConversation(conversationId, userId);
        _ref.invalidate(conversationsProvider);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> muteConversation(String conversationId) async {
    try {
      final userId = _ref.read(currentUserIdProvider).value;
      if (userId != null) {
        await _repository.muteConversation(conversationId, userId);
        _ref.invalidate(conversationsProvider);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unmuteConversation(String conversationId) async {
    try {
      final userId = _ref.read(currentUserIdProvider).value;
      if (userId != null) {
        await _repository.unmuteConversation(conversationId, userId);
        _ref.invalidate(conversationsProvider);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPersonalDM(String recipientId) async {
    state = const AsyncValue.loading();
    try {
      final userId = _ref.read(currentUserIdProvider).value;
      final salonId = _ref.read(currentSalonIdProvider).value;

      if (userId == null || salonId == null) {
        throw Exception('User or Salon not found');
      }

      await _repository.createPersonalDMThread(salonId, userId, recipientId);
      state = const AsyncValue.data(null);
      _ref.invalidate(conversationsProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> createGroupChat(String title, List<String> participantIds) async {
    state = const AsyncValue.loading();
    try {
      final salonId = _ref.read(currentSalonIdProvider).value;

      if (salonId == null) {
        throw Exception('Salon not found');
      }

      await _repository.createGroupChatThread(salonId, title, participantIds);
      state = const AsyncValue.data(null);
      _ref.invalidate(conversationsProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final conversationNotifierProvider =
    StateNotifierProvider<ConversationNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ConversationNotifier(repository, ref);
});

// ============ FILTERS & COMPUTED ============

/// Gefilterte Conversations (nur aktive)
final activeConversationsProvider = FutureProvider<List<ChatThread>>((ref) async {
  final conversations = ref.watch(conversationsProvider).value ?? [];
  return conversations.where((c) => c.status == ThreadStatus.active).toList();
});

/// Archivierte Conversations
final archivedConversationsProvider = FutureProvider<List<ChatThread>>((ref) async {
  final conversations = ref.watch(conversationsProvider).value ?? [];
  return conversations.where((c) => c.status == ThreadStatus.archived).toList();
});

/// Unread Count für alle Conversations
final totalUnreadCountProvider = FutureProvider<int>((ref) async {
  final conversations = ref.watch(conversationsProvider).value ?? [];
  return conversations.fold<int>(0, (sum, c) => sum + c.unreadCount);
});

// ============ READ RECEIPTS ============

/// Get read receipts for a message
final messageReadsProvider = FutureProvider.family<List<String>, String>((ref, messageId) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMessageReads(messageId);
});

// ============ SEARCH ============

/// Suche Nachrichten innerhalb einer Conversation
final messageSearchProvider = FutureProvider.family<List<ChatMessage>, (String, String)>((ref, args) async {
  final (conversationId, query) = args;
  final repository = ref.watch(chatRepositoryProvider);
  
  if (query.isEmpty) return [];
  
  return repository.searchMessages(conversationId, query);
});

/// Suche Conversations nach Titel und Participants
final conversationSearchProvider = FutureProvider.family<List<ChatThread>, String>((ref, query) async {
  final repository = ref.watch(chatRepositoryProvider);
  final salonId = ref.watch(currentSalonIdProvider).value;
  
  if (salonId == null || query.isEmpty) return [];
  
  return repository.searchConversations(salonId, query);
});