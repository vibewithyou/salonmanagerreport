# Chat Module - SalonManager

Ein professionelles, WhatsApp-ähnliches Chat-Modul für SalonManager mit vollem Realtime-Support, Message-Editing, Reply-To, Attachments und mehr.

## 🎯 Features

### Chat-Typen
- **Personal DM**: 1:1 Mitarbeiter-zu-Mitarbeiter oder Mitarbeiter-zu-Chef
- **Gruppen-Chat**: Mehrpersonen Conversations (z.B. "Chef-Team")
- **Support-Chat**: Salon/Staff ↔ Plattform-Support (RLS-protected)
- **Termin-Chat**: Customer ↔ Stylist (Auto-close nach Terminende + 12h Grace)

### WhatsApp-ähnliche Features
✅ **Message Management**
- Nachrichten bearbeiten (mit `edited_at` Tracking)
- Nachrichten löschen "für mich" (soft-delete)
- Nachrichten "für alle zurückziehen" (mit Ersatztext in UI)
- Reply-To Support

✅ **Conversation Management**
- Chats archivieren (pro User)
- Chats stummschalten (Notifications aus)
- Teilnehmer blockieren (stoppt Schreiben)
- Conversation Status: active/closed/archived

✅ **Read Receipts**
- `message_reads` Tabelle trackt Read-Status pro User
- UI zeigt "Delivered" / "Read" Status

✅ **Typing Indicator**
- Realtime-Presence über `typing_indicators` Table
- TTL von 3 Sekunden
- Auto-cleanup via pg_cron Function

✅ **Attachments**
- Support für Images, Files, Video, Voice
- Über Supabase Storage
- `message_type` Enum für Typ-Tracking

### UI/Design
- Modernes Dark/Light Mode kompatibles Design
- WhatsApp-ähnliche Message Bubbles
- Unread-Count Badges
- Message Grouping (User + Time)
- Date Separators
- Long-Press Actions auf Nachrichten
- Search/Filter in Inbox

## 📁 Projektstruktur

```
lib/features/chat/
├── domain/
│   └── models/
│       └── chat_thread.dart          # Hauptmodels (ChatThread, ChatMessage, etc)
├── data/
│   ├── dto/
│   │   └── chat_thread_dto.dart      # Data Transfer Objects + Konversionen
│   └── repository/
│       └── chat_repository.dart      # Supabase API Implementierung
├── application/
│   └── providers/
│       └── chat_providers.dart       # Riverpod State Management
└── presentation/
    └── screens/
        ├── chat_inbox_screen.dart    # Chatliste (mit Suche, Archive-Filter)
        ├── chat_detail_screen.dart   # Message-View
        ├── chat_info_screen.dart     # Participants, Settings, Actions
        └── chat_inbox_screen.dart    # OLD - jetzt umgebaut
```

## 🚀 Quick Start

### 1. Import des Moduls

```dart
import 'package:salonmanager/features/chat/chat.dart';

// Oder granular:
import 'package:salonmanager/features/chat/presentation/screens/chat_inbox_screen.dart';
import 'package:salonmanager/features/chat/application/providers/chat_providers.dart';
```

### 2. Inbox anzeigen

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => const ChatInboxScreen(),
  ),
);
```

### 3. Riverpod Providers verwenden

```dart
class MyChatWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Alle Conversations für den aktuellen User
    final conversations = ref.watch(conversationsProvider);
    
    // Messages in einem Chat
    final messages = ref.watch(
      messagesProvider((conversationId, limit: 50, offset: 0))
    );
    
    // Unread Count
    final unreadCount = ref.watch(totalUnreadCountProvider);
    
    return Text('${unreadCount} unread messages');
  }
}
```

### 4. Eine Nachricht senden

```dart
// Mit StateNotifier
ref.read(chatNotifierProvider.notifier).sendMessage(
  conversationId,
  currentUserId,
  content: 'Hallo!',
  type: ChatMessageType.text,
);
```

### 5. Conversation Aktionen

```dart
final conversationNotifier = ref.read(conversationNotifierProvider.notifier);

// Archive
await conversationNotifier.archiveConversation(threadId);

// Mute
await conversationNotifier.muteConversation(threadId);

// Create new PM
await conversationNotifier.createPersonalDM(recipientId);

// Create Group
await conversationNotifier.createGroupChat('Team Meeting', [user1, user2, user3]);
```

## 🗄️ Datenbank-Schema

### Wichtigste Tabellen

**conversations**
```sql
id (uuid) PRIMARY KEY
salon_id (uuid)                     -- Mandantenfähigkeit
type (enum: personal_dm, group_chat, support, booking_dm)
appointment_id (uuid)                -- Für booking_dm
title (text)                         -- Für group_chat
status (enum: active, closed, archived)
last_message_at (timestamp)
created_at, updated_at
```

**conversation_participants**
```sql
id, conversation_id, user_id
role (enum: member, admin, owner)
is_active (boolean)
last_read_message_id (uuid)         -- Für Read-Receipts
archived_at (timestamp)              -- Pro-User Archive
is_muted (boolean)
is_blocked (boolean)
can_write (boolean DEFAULT true)     -- Auto false bei closed threads
created_at, updated_at
```

**messages**
```sql
id (uuid) PRIMARY KEY
conversation_id (uuid) -> conversations
sender_id (uuid)
content (text)
message_type (enum: text, image, file, video, voice, system)
media_id (uuid) -> media_assets (future)
reply_to_message_id (uuid) -> messages (self-join)
edited_at (timestamp)
deleted_at (timestamp)               -- Soft-delete
deleted_for_user_ids (text[])        -- "Delete for Me" pro User
created_at, updated_at
```

**message_reads**
```sql
id (uuid) PRIMARY KEY
message_id (uuid) -> messages
user_id (uuid)
read_at (timestamp)
UNIQUE(message_id, user_id)         -- Pro User nur 1x read
```

**typing_indicators** (ephemeral)
```sql
id (uuid) PRIMARY KEY
conversation_id (uuid) -> conversations
user_id (uuid)
user_name (text)
started_at (timestamp)
expires_at (timestamp + 3 seconds)  -- Auto-cleanup via pg_cron
```

## 🔒 Row Level Security (RLS)

Alle auth-Policies sind implementiert in der Migration:

✅ Users sehen nur Conversations wo sie Participant sind
✅ Support-Role kann Support-Threads sehen
✅ Write-Permissions werden bei Booking-Thread-Close disabled
✅ Users können nur ihre eigenen Messages editieren
✅ Salon-Owner können Salon-interne Chats sehen

## ⚡ Realtime Features

Das Modul nutzt Supabase Realtime für:

1. **Message Streaming**
   ```dart
   final stream = ref.watch(
     messagesRealtimeProvider(conversationId)
   );
   ```

2. **Typing Indicators**
   ```dart
   // Publish Typing
   await _repository.publishTypingIndicator(conversationId, userId);
   
   // Subscribe
   final typing = ref.watch(typingRealtimeProvider(conversationId));
   ```

## 🔄 Auto-Close Booking Chats

Booking-DM Threads werden automatisch geschlossen (status='closed') wenn:
- Das Termin vorbei ist
- Zusätzlich 12h Grace Period vergeben ist

Die Funktion läuft via Supabase pg_cron:
```sql
SELECT cron.schedule(
  'close-booking-chats', 
  '*/5 * * * *',  -- Alle 5 Minuten
  'SELECT close_expired_booking_chats()'
);
```

## 📝 Migration

Die komplette DB-Migration wird bereitgestellt:

```bash
supabase/migrations/20260216_chat_module_extended_schema.sql
```

Diese kann direkt in Supabase SQL Editor ausgeführt werden oder via:
```bash
supabase migration up
```

## 🛠️ Konfiguration

### Theme Integration

Das Modul nutzt das bestehende App-Theme:
- `AppColors.primary` für Accents
- `AppColors.textPrimary/Secondary` für Text
- Dark/Light Mode wird automatisch unterstützt

### Lokalisierung

Strings können in `assets/translations/` ergänzt werden:
```json
{
  "chat": {
    "title": "Messages",
    "search_placeholder": "Search conversations...",
    "no_messages": "No messages yet"
  }
}
```

## 🐛 Error Handling

Alle asynchrone Operationen haben Error-States:

```dart
conversationsAsync.when(
  data: (conversations) { /* show */ },
  loading: () { /* loading spinner */ },
  error: (error, stack) { /* error UI */ },
);
```

## 📊 Performance Optimizations

- **Pagination**: Messages loaded with limit=50, infinite scroll enabled
- **Indices**: Auf allen Foreign Keys und Filter-Columns
- **Caching**: Riverpod invalidation bei Mutations
- **Filtering**: Client-side + Server-side WHERE clauses
- **TTL**: Typing-Indicators expire nach 3s

## 🔐 Security Notes

- **RLS aktiv**: Alle Tabellen mit Row-Level-Security
- **Salon-Isolation**: Jede Resource filtert nach salon_id
- **User-Isolation**: Users sehen nur ihre Conversations
- **Write-Control**: can_write Flag für Thread-Status Management

## 📄 Lizenz

Teil des SalonManager Projekts.

## 📞 Support & Entwicklung

Für Bugs, Feature-Requests oder Verbesserungen:
1. Das Modul folgt Clean Architecture patterns
2. Alle Tests sollten in `test/` sein
3. Code muss null-safety konform sein

---

**Stand**: Februar 2026 | **Version**: 1.0.0
