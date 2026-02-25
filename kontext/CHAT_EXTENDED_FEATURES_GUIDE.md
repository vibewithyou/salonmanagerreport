# 🚀 Chat Module - Extended Features Implementation Guide

**Last Updated:** 16.02.2026  
**Status:** Advanced Features Ready for Integration

---

## 📋 Overview

This guide documents the implementation of extended features for the SalonManager Chat Module:

1. ✅ **Message Search** - Full-text search with highlighting
2. ✅ **Attachment Upload UI** - File/Image/Video picker with preview
3. ✅ **User Online Status** - Real-time presence indicators
4. ✅ **Message Reactions** - Emoji reactions to messages
5. ✅ **Message Pinning** - Pin important messages
6. ⏳ **Advanced Search with Filters** - Complex search with date range, sender, type

---

## 🔍 Message Search

### Implementation Location
- **Provider:** `messageSearchProvider` in `lib/features/chat/application/providers/chat_providers.dart`
- **Repository:** `searchMessages()` method in `lib/features/chat/data/repository/chat_repository.dart`
- **UI:** `lib/features/chat/presentation/screens/message_search_screen.dart`

### Features
- Full-text search using PostgreSQL `ilike` (case-insensitive)
- Search results limited to 100 messages
- Text highlighting with yellow background
- Sender avatar and timestamp display

### Usage Example
```dart
// Trigger search
final results = ref.watch(messageSearchProvider((conversationId, 'hello')));

//  Navigate to search screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => MessageSearchScreen(conversationId: conversationId),
  ),
);
```

### Integration in Chat Detail
Add search button to `ChatDetailScreen` appBar:
```dart
IconButton(
  icon: Icon(LucideIcons.search),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessageSearchScreen(
          conversationId: conversationId,
        ),
      ),
    );
  },
),
```

---

## 📎 Attachment Upload UI

### Implementation Location
- **Widget:** `lib/features/chat/presentation/widgets/attachment_widget.dart`
- **Models:** `AttachmentType` enum (image, video, file)
- **Repository:** Ready for `uploadAttachment()` implementation

### Components Available

#### 1. AttachmentUploadWidget
Popup menu for selecting attachment type:
```dart
AttachmentUploadWidget(
  onFilePicked: (file, type) {
    // Handle file upload
    // TODO: Implement Supabase Storage upload
  },
),
```

#### 2. AttachmentPreviewWidget
Display selected file before sending:
```dart
AttachmentPreviewWidget(
  file: selectedFile,
  type: AttachmentType.image,
  onRemove: () => setState(() => selectedFile = null),
),
```

#### 3. AttachmentUploadProgressWidget
Show progress during upload:
```dart
AttachmentUploadProgressWidget(
  fileName: 'photo.jpg',
  progress: 0.65,
  onCancel: () => cancelUpload(),
),
```

### Integration Steps

1. **Add to Chat Message Input:**
```dart
Row(
  children: [
    AttachmentUploadWidget(
      onFilePicked: _uploadAttachment,
    ),
    Expanded(
      child: TextField(...),
    ),
    SendButton(...),
  ],
)
```

2. **Implement Upload Handler:**
```dart
Future<void> _uploadAttachment(File file, AttachmentType type) async {
  // 1. Show progress
  setState(() => _isUploading = true);
  
  // 2. Upload to Supabase Storage
  final path = 'chats/$conversationId/${DateTime.now().millisecondsSinceEpoch}';
  final response = await ref.read(chatRepositoryProvider)
    .uploadAttachment(conversationId, file, type);
  
  // 3. Include URL in message
  await sendMessage(attachmentUrls: [response]);
  
  setState(() => _isUploading = false);
}
```

3. **Create Supabase Storage Bucket:**
```bash
# In Supabase: Storage → Create new bucket
# Name: chat-attachments
# Public: false (use signed URLs)
```

4. **Implement Repository Upload Method:**
```dart
Future<String> uploadAttachment(String conversationId, File file, AttachmentType type) async {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final path = 'chat-attachments/$conversationId/$timestamp';
  
  await _supabase.storage.from('chat-attachments').upload(path, file);
  
  return _supabase.storage        .from('chat-attachments')
    .getPublicUrl(path);
}
```

---

## 👥 User Online Status

### Implementation Location
- **Widgets:** `lib/features/chat/presentation/widgets/online_status_widget.dart`
- **Models:** Update `ChatParticipant` with `lastSeenAt` and `typingUntil` fields
- **Database:** Fields already in `conversation_participants` table

### Components Available

#### 1. OnlineStatusIndicator
Minimal status dot (12x12 px):
```dart
OnlineStatusIndicator(
  lastSeenAt: participant.lastSeenAt,
  isTyping: participant.typingUntil != null,
  size: 12,
)
```

**Colors:**
- 🟢 Green: Online (< 5 min)
- 🟡 Yellow: Away (< 1 hour)
- ⚫ Grey: Offline

#### 2. OnlineStatusTile
Full participant status with avatar:
```dart
OnlineStatusTile(
  userName: participant.userName,
  avatarUrl: participant.avatarUrl,
  lastSeenAt: participant.lastSeenAt,
  isTyping: isTyping,
)
```

### Integration Steps

1. **Update ChatParticipant Model:**
```dart
@freezed
class ChatParticipant with _$ChatParticipant {
  const factory ChatParticipant({
    // ... existing fields ...
    DateTime? lastSeenAt,
    DateTime? typingUntil,
  }) = _ChatParticipant;
}
```

2. **Add Status Indicator to Inbox Tile:**
```dart
ListTile(
  title: Row(
    children: [
      Expanded(child: Text(thread.title)),
      OnlineStatusIndicator(
        lastSeenAt: thread.participants.first.lastSeenAt,
      ),
    ],
  ),
)
```

3. **Update `last_seen_at` on Message Read:**
```dart
Future<void> markMessageAsRead(String messageId, String userId) async {
  // ... mark as read ...
  
  // Update last_seen_at for this user
  await _supabase
    .from('conversation_participants')
    .update({'last_seen_at': DateTime.now().toIso8601String()})
    .match({'conversation_id': conversationId, 'user_id': userId});
}
```

4. **Track Typing with TTL:**
```dart
Future<void> setTyping(String conversationId, String userId) async {
  await _supabase
    .from('typing_indicators')
    .upsert({
      'conversation_id': conversationId,
      'user_id': userId,
      'expires_at': DateTime.now().add(Duration(seconds: 3)),
    });
}
```

---

## 😊 Message Reactions

### Implementation Location
- **Widgets:** `lib/features/chat/presentation/widgets/reaction_widget.dart`
- **Repository:** `addReaction()`, `removeReaction()` methods
- **Database:** `reactions` JSONB field in messages table

### Components Available

#### 1. ReactionPickerWidget
Grid of emoji options:
```dart
ReactionPickerWidget(
  messageId: messageId,
  onEmojiSelected: (emoji) {
    ref.read(chatNotifierProvider.notifier)
      .addReaction(messageId, emoji);
  },
)
```

**Default Emojis:** 👍 ❤️ 😂 😮 😢 🔥

#### 2. ReactionDisplay
Shows reaction counts:
```dart
ReactionDisplay(
  messageId: messageId,
  reactions: message.reactions,
  onReactionTap: (emoji) {
    // Toggle reaction (add if not exists, remove  if exists)
  },
)
```

### Integration Steps

1 **Add Long-Press Menu with Reactions:**
```dart
PopupMenuButton<String>(
  itemBuilder: (context) => [
    PopupMenuItem(
      child: Text('React'),
      onTap: () => _showReactionPicker(),
    ),
  ],
),
```

2. **Show Reaction Picker:**
```dart
void _showReactionPicker(String messageId) {
  showModalBottomSheet(
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(16),
      child: ReactionPickerWidget(
        messageId: messageId,
        onEmojiSelected: (emoji) => ref.read(chatNotifierProvider.notifier)
          .addReaction(messageId, emoji),
      ),
    ),
  );
}
```

3. **Display Reactions Below Message:**
```dart
Padding(
  padding: const EdgeInsets.only(top: 8),
  child: ReactionDisplay(
    messageId: message.id,
    reactions: message.reactions,
    onReactionTap: (emoji) {
      // Toggle reaction
      if (message.reactions?.containsKey(emoji) ?? false) {
        _removeReaction(message.id, emoji);
      } else {
        _addReaction(message.id, emoji);
      }
    },
  ),
)
```

4. **Track User Reactions (Optional):**
```dart
// Store in separate table for more advanced features
CREATE TABLE message_reactions (
  id uuid PRIMARY KEY,
  message_id uuid REFERENCES messages(id),
  user_id uuid REFERENCES profiles(id),
  emoji text NOT NULL,
  created_at timestamptz,
  UNIQUE(message_id, user_id, emoji)
);
```

---

## 📌 Message Pinning

### Implementation Location
- **Widgets:** `lib/features/chat/presentation/widgets/pinned_message_widget.dart`
- **Repository:** `pinMessage()`, `unpinMessage()` methods
- **Database:** `pinned_by`, `pinned_at` fields in messages table

### Components Available

#### 1. PinnedMessageBanner
Shows currently pinned message at top:
```dart
PinnedMessageBanner(
  pinnedMessage: messages.firstWhereOrNull((m) => m.pinnedBy != null),
  onDismiss: () => _hidePinnedBanner(),
)
```

#### 2. PinnedMessagesPanel
Scrollable list of all pinned messages:
```dart
PinnedMessagesPanel(
  conversationId: conversationId,
  pinnedMessages: messages.where((m) => m.pinnedBy != null).toList(),
)
```

### Integration Steps

1. **Add Banner to Chat Detail Top:**
```dart
Column(
  children: [
    PinnedMessageBanner(
      pinnedMessage: messages?.firstWhereOrNull((m) => m.pinnedBy != null),
    ),
    Expanded(
      child: messagesList(),
    ),
  ],
)
```

2. **Add Pin Option to Message Actions:**
```dart
PopupMenuItem(
  value: 'pin',
  child: Row(
    children: [
      Icon(LucideIcons.pin, size: 16),
      SizedBox(width: 8),
      Text('Pin message'),
    ],
  ),
),
```

3. **Implement Pin Action:**
```dart
void _pinMessage(String messageId) async {
  await ref.read(chatNotifierProvider.notifier)
    .pinMessage(messageId);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Message pinned')),
  );
}
```

4. **Show Pin Count in Info Screen:**
```dart
Text(
  '📌 ${pinnedMessages.length} pinned',
  style: theme.textTheme.labelSmall,
),
```

---

## 🔎 Advanced Search with Filters

### Roadmap Implementation

#### Phase 1: Basic (Already Done)
- [x] Full-text message search
- [x] Search in single conversation
- [x] Text highlighting

#### Phase 2: Planned
- [ ] Multi-conversation search
- [ ] Filter by sender
- [ ] Filter by message type (text/image/video)
- [ ] Date range picker
- [ ] Filter by reactions

### Filter Model
```dart
@freezed
class ChatSearchFilter with _$ChatSearchFilter {
  const factory ChatSearchFilter({
    required String salonId,
    String? conversationId,
    String? senderId,
    ChatMessageType? messageType,
    DateTime? fromDate,
    DateTime? toDate,
    String? query,
    bool? reactedToByMe,
    bool? pinnedOnly,
  }) = _ChatSearchFilter;
}
```

### Provider
```dart
final advancedSearchProvider = FutureProvider.family(
  (ref, ChatSearchFilter filter) async {
    final repo = ref.watch(chatRepositoryProvider);
    return repo.searchWithFilters(filter);
  },
);
```

### UI Example
```dart
class AdvancedSearchScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AdvancedSearchScreen> createState() => 
    _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends ConsumerState<AdvancedSearchScreen> {
  late ChatSearchFilter filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced Search')),
      body: Column(
        children: [
          // Search query input
          TextField(
            onChanged: (query) => setState(() => 
              filter = filter.copyWith(query: query)
            ),
          ),
          
          // Date range picker
          ElevatedButton(
            onPressed: () => _pickDateRange(),
            child: Text('From ${filter.fromDate?.toString() ?? 'any'}'),
          ),
          
          // Sender filter
          DropdownButton<String>(
            items: sendersList,
            onChanged: (senderId) => setState(() => 
              filter = filter.copyWith(senderId: senderId)
            ),
          ),
          
          // Message type filter
          Wrap(
            children: ChatMessageType.values.map((type) => 
              FilterChip(
                label: Text(type.name),
                selected: filter.messageType == type,
                onSelected: (_) => setState(() =>
                  filter = filter.copyWith(messageType: type)
                ),
              ),
            ),
          ),
          
          // Search button
          ElevatedButton(
            onPressed: () => _search(),
            child: Text('Search'),
          ),
          
          // Results
          Expanded(
            child: ref.watch(advancedSearchProvider(filter)).when(
              data: (results) => SearchResultsList(results),
              // ...
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 📊 Dashboard Integration

### ✅ Completed Integrations

#### 1. Main Dashboard (`dashboard_screen.dart`)
- Chat sidebar item already present
- Integrated `ChatInboxScreen` into case 3
- Icon: chat_bubble_outline
- Label: `conversations.title` (localized)

#### 2. Customer Dashboard (`customer_dashboard_screen.dart`)
- Added "Nachrichten" quick action button
- Routes to `/messages` path
- Icon: LucideIcons.messageCircle
- Color: Colors.blue

#### 3. Admin Dashboard (`admin_dashboard_screen.dart`)
- Added new "💬 Support" tab at index 3
- Placeholder implementation (ready for full feature)
- Routes support through chat system

### 🔄 Future Dashboard Enhancements

**Employee Portal:**
```dart
// Add Messages tab to employee dashboard
TabBar(
  tabs: [
    Tab(text: 'Overview'),
    Tab(text: 'Appointments'),
    Tab(text: 'Messages'), // NEW
  ],
)

// Show unread badge
Badge(
  label: Text(unreadCount.toString()),
  child: Tab(text: 'Messages'),
)
```

**Mobile Responsive:**
```dart
// For mobile: show chat in drawer/bottom navigation
if (ResponsiveBreakpoints.isMobile(context)) {
  FloatingActionButton(
    onPressed: () => context.go('/messages'),
    child: Icon(LucideIcons.messageCircle),
  )
}
```

---

## 🧪 Testing Checklist

### Unit Tests
- [ ] `searchMessages()` returns correct results
- [ ] `addReaction()` increments emoji count
- [ ] `pinMessage()` sets pinned_by and timestamp
- [ ] Soft-delete respects user-specific deletion

### Widget Tests
- [ ] `MessageSearchScreen` highlights text correctly
- [ ] `ReactionPickerWidget` emits correct emoji
- [ ] `PinnedMessageBanner` updates when message pinned
- [ ] `AttachmentUploadWidget` shows correct menu items

### Integration Tests
- [ ] User A searches message in conversation A
- [ ] User A adds reaction, User B sees count
- [ ] User A pins message, banner shows for User B
- [ ] User A uploads image, preview shows before send

### Manual Tests (QA Checklist)
- [ ] Search finds messages with partial match
- [ ] Pinned message persists across app restart
- [ ] Old messages can't be reacted to (closed threads)
- [ ] Online status accurate within 5 seconds
- [ ] Attachment upload retries on network error

---

## 🚀 Deployment Checklist

- [ ] SQL migration executed in Supabase
- [ ] Supabase Storage bucket created (`chat-attachments`)
- [ ] Realtime enabled for all chat tables
- [ ] RLS policies tested with different users
- [ ] Localization strings added (de.json, en.json)
- [ ] Error handling and logging in place
- [ ] Performance tested with 1000+ messages
- [ ] Mobile responsiveness verified

---

## 📚 Dependencies

**Already Available:**
- `flutter_riverpod` 2.5.1 - State management
- `supabase_flutter` 2.10.0 - Backend
- `lucide_icons` 0.257.0 - Icons
- `easy_localization` 3.0.7 - i18n
- `intl` 0.19.0 - Date formatting

**To Add (Optional):**
```yaml
image_picker: ^1.0.0  # For attachment file picking
file_picker: ^5.0.0   # For document selection
cached_network_image: ^3.3.0  # For image caching
video_player: ^2.7.0  # For video playback
```

---

## 🆘 Troubleshooting

### Search Returns No Results
- Check Supabase full-text search configuration
- Verify `ilike` operator works with special characters
- Test with simple queries first

### Reactions Not Appearing
- Ensure `reactions` JSONB column in messages table
- Check RLS default allows updates to own messages
- Verify real-time subscription is active

### Attachments Upload Fails
- Verify Supabase Storage bucket exists and is accessible
- Check file size limits (default: 50MB)
- Verify signed URLs are generated correctly

### Online Status Not Updating
- Ensure `last_seen_at` field is populated on message read
- Check TTL/expiration logic for typing indicators
- Verify real-time streaming is enabled

---

**Last Updated:** 16.02.2026  
**For Support:** Contact Senior Flutter Engineer
