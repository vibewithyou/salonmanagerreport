# 📋 Supabase Setup Guide - Chat Module

**Status:** 100% Complete
**Last Updated:** Februar 2026
**Target Deployment:** Supabase PostgreSQL + Realtime

---

## 1️⃣ Pre-Deployment Checklist

- [ ] All Flutter code compiled without errors
- [ ] Migration file prepared: `supabase/migrations/20260216_chat_module_extended_schema.sql`
- [ ] Environment variables configured in `.env`
- [ ] Supabase project created and credentials available
- [ ] PostgreSQL version: 15+ (Supabase standard)

---

## 2️⃣ Database Setup

### Step 1: Execute SQL Migration

**Location:** `supabase/migrations/20260216_chat_module_extended_schema.sql`

**How to Apply:**

**Option A: Via Supabase UI**
1. Go to SQL Editor in Supabase Dashboard
2. Create new query
3. Copy entire migration file content
4. Execute query
5. Verify: Check "Migrations" tab shows the migration

**Option B: Via Supabase CLI** (Recommended)
```bash
supabase migration new chat_module_extended_schema
# Copy migration content into generated file
supabase db push
```

**What Gets Created:**

**Tables:**
```
✅ conversations
   - Added 'status' ENUM column (active, closed, archived)
   
✅ conversation_participants
   - Added 'archived_at' (timestamp)
   - Added 'is_muted' (boolean)
   - Added 'is_blocked' (boolean)
   - Added 'can_write' (boolean)
   - Added 'last_seen_at' (timestamp)
   - Added 'typing_until' (timestamp)
   
✅ messages
   - Added 'is_deleted' (boolean)
   - Added 'deleted_for_user_ids' (uuid[])
   - Added 'reactions' (jsonb) {emoji: [user_id, ...]}
   - Added 'pinned_by' (uuid)
   - Added 'edited_at' (timestamp)
   
✅ message_reads (NEW)
   - message_id (uuid) → FK messages.id
   - reader_id (uuid) → FK auth.users.id
   - read_at (timestamp)
   - Composite PK: (message_id, reader_id)
   
✅ typing_indicators (NEW)
   - conversation_id (uuid) → FK conversations.id
   - user_id (uuid) → FK auth.users.id
   - typing_until (timestamp)
   - Composite PK: (conversation_id, user_id)
```

**ENUMS:**
```
✅ conversation_type: 'direct_message', 'group', 'support'
✅ thread_status: 'active', 'closed', 'archived'
✅ chat_message_type: 'text', 'image', 'video', 'document', 'system'
✅ participant_role: 'owner', 'manager', 'member'
```

**Indices Created:**
```sql
-- Conversation queries
CREATE INDEX idx_conversations_salon_id ON conversations(salon_id);
CREATE INDEX idx_conversations_type ON conversations(type);

-- Participant queries
CREATE INDEX idx_participants_conversation_id ON conversation_participants(conversation_id);
CREATE INDEX idx_participants_user_id ON conversation_participant(user_id);

-- Message queries
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);

-- Read receipts
CREATE INDEX idx_message_reads_message_id ON message_reads(message_id);
CREATE INDEX idx_message_reads_reader_id ON message_reads(reader_id);

-- Typing indicators
CREATE INDEX idx_typing_conversation_id ON typing_indicators(conversation_id);
CREATE INDEX idx_typing_user_id ON typing_indicators(user_id);
```

---

### Step 2: Verify RLS Policies

**Critical:** Row-Level Security must be ENABLED on all chat tables

**Navigate to:** Supabase Dashboard → SQL Editor → "Verify Policies"

**For Each Table (conversations, conversation_participants, messages, message_reads):**

```sql
-- Check RLS is enabled
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversation_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE message_reads ENABLE ROW LEVEL SECURITY;
ALTER TABLE typing_indicators ENABLE ROW LEVEL SECURITY;
```

**Policies Included in Migration:**

| Table | Policy | Description |
|-------|--------|-------------|
| `conversations` | `salon_access_policy` | User can access if member of salon |
| `conversation_participants` | `participant_view_by_user` | User can view own participations |
| `conversation_participants` | `participant_update_own` | User can update their own record |
| `messages` | `message_select_policy` | User can read if conversation participant |
| `messages` | `message_insert_policy` | User can send if can_write permission |
| `message_reads` | `message_read_insert_policy` | User can mark own reads |
| `typing_indicators` | `typing_indicator_policy` | User can update own typing status |

**Verify Execution:**
```sql
-- Check policies exist
SELECT tablename, policyname FROM pg_policies 
WHERE schemaname = 'public' 
  AND tablename IN ('conversations', 'conversation_participants', 'messages', 'message_reads', 'typing_indicators');
```

Expected output: 10 policies listed

---

### Step 3: Enable Realtime on Tables

**Required for:** Real-time message updates, typing indicators, online status

**Method A: Via Supabase UI**
1. Database → Replication
2. For each table, toggle "Realtime" ON:
   - ✅ messages
   - ✅ typing_indicators
   - ✅ conversation_participants (for status updates)
   - ✅ message_reads (for receipt updates)

**Method B: Via SQL**
```sql
-- If using Supabase CLI
supabase realtime add conversations
supabase realtime add conversation_participants
supabase realtime add messages
supabase realtime add message_reads
supabase realtime add typing_indicators
```

**Verify:**
```sql
SELECT * FROM pg_publication_tables WHERE pubname = 'supabase_realtime';
```

---

### Step 4: Configure Indexes for Performance

```sql
-- Already included in migration, but verify:

-- Conversation queries (inbox loading)
CREATE INDEX IF NOT EXISTS idx_conversations_salon_id 
ON conversations(salon_id) 
WHERE status != 'archived';

-- Message queries (chat history, search)
CREATE INDEX IF NOT EXISTS idx_messages_conversation_id_created 
ON messages(conversation_id, created_at DESC) 
WHERE NOT is_deleted;

-- Read receipts (receipt checking)
CREATE INDEX IF NOT EXISTS idx_message_reads_message_id 
ON message_reads(message_id);

-- Typing indicators (cleaning expired)
CREATE INDEX IF NOT EXISTS idx_typing_expires 
ON typing_indicators(typing_until) 
WHERE typing_until < NOW();
```

---

## 3️⃣ Storage Setup (Attachments)

### Create Storage Bucket

**Via Supabase UI:**
1. Storage → Buckets → New bucket
2. Name: `chat-attachments`
3. Make public: **NO** (use signed URLs)
4. Click "Create bucket"

**Via SQL:**
```sql
INSERT INTO storage.buckets (id, name, public) 
VALUES ('chat-attachments', 'chat-attachments', false);
```

### RLS Policy for Attachments

```sql
-- Allow authenticated users to upload to their conversations
CREATE POLICY "Users can upload chat attachments"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'chat-attachments' 
  AND auth.role() = 'authenticated'
);

-- Allow users to download their conversation attachments
CREATE POLICY "Users can download chat attachments"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'chat-attachments' 
  AND auth.role() = 'authenticated'
);
```

---

## 4️⃣ Functions & Triggers (Auto-Management)

### Function 1: Auto-Close Booking Chats

```sql
-- Automatically close support chats when booking is completed
CREATE OR REPLACE FUNCTION close_expired_booking_chats()
RETURNS void AS $$
BEGIN
  UPDATE conversations
  SET status = 'closed', updated_at = NOW()
  WHERE type = 'support'
    AND id IN (
      SELECT c.id FROM conversations c
      INNER JOIN bookings b ON c.related_booking_id = b.id
      WHERE b.status = 'completed'
        AND c.status = 'active'
        AND b.checkout_date < NOW() - INTERVAL '24 hours'
    );
END;
$$ LANGUAGE plpgsql;

-- Schedule to run daily (requires pg_cron extension)
-- SELECT cron.schedule('close-expired-booking-chats', '0 0 * * *', 'SELECT close_expired_booking_chats()');
```

### Function 2: Clean Expired Typing Indicators

```sql
-- Remove typing indicators older than 10 seconds
CREATE OR REPLACE FUNCTION clean_expired_typing_indicators()
RETURNS void AS $$
BEGIN
  DELETE FROM typing_indicators
  WHERE typing_until < NOW();
END;
$$ LANGUAGE plpgsql;

-- Schedule to run every minute
-- SELECT cron.schedule('clean-typing-indicators', '* * * * *', 'SELECT clean_expired_typing_indicators()');
```

### Enable pg_cron Extension

**Via Supabase UI:**
1. SQL Editor → New Query
2. Run: `CREATE EXTENSION IF NOT EXISTS pg_cron;`

**Via CLI:**
```bash
supabase db execute -- "CREATE EXTENSION IF NOT EXISTS pg_cron;"
```

---

## 5️⃣ Environment Variables

### Flutter App (`.env`)

```env
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key (backend only)

# Chat Module Configuration
CHAT_ATTACHMENT_BUCKET=chat-attachments
CHAT_MAX_MESSAGE_LENGTH=5000
CHAT_MAX_ATTACHMENT_SIZE=52428800  # 50MB
CHAT_TYPING_TIMEOUT=5000  # milliseconds
CHAT_MESSAGE_BATCH_SIZE=20  # messages per infinite scroll load
```

### Configuration in `pubspec.yaml`

Ensure dependencies are locked:
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.10.0
  riverpod: ^2.5.1
  go_router: ^14.6.2
  freezed_annotation: ^2.4.1
  # ... others
```

---

## 6️⃣ Localization Strings

### Add to `assets/translations/en.json`

```json
{
  "chat": {
    "inbox_title": "Messages",
    "no_conversations": "No conversations yet",
    "new_chat": "New Chat",
    "search_conversations": "Search conversations",
    "search_messages": "Search messages",
    "message_sent": "Sent",
    "message_delivered": "Delivered",
    "message_read_by": "Read by {name}",
    "typing": "{name} is typing...",
    "online": "Online",
    "away": "Away",
    "offline": "Offline",
    "participants": "Participants",
    "add_participant": "Add participant",
    "conversation_info": "Conversation info",
    "mute_conversation": "Mute conversation",
    "unmute_conversation": "Unmute conversation",
    "archive_conversation": "Archive conversation",
    "unarchive_conversation": "Unarchive conversation",
    "delete_conversation": "Delete conversation",
    "close_conversation": "Close conversation",
    "reply": "Reply",
    "edit": "Edit",
    "delete": "Delete for me",
    "delete_for_all": "Delete for everyone",
    "pin": "Pin",
    "unpin": "Unpin",
    "reactions": "Reactions",
    "attachment": "Attachment",
    "attachment_upload_error": "Failed to upload attachment",
    "photo": "Photo",
    "video": "Video",
    "document": "Document",
    "send": "Send",
    "cancel": "Cancel",
    "conversation_closed": "This conversation is closed"
  }
}
```

### Add to `assets/translations/de.json`

```json
{
  "chat": {
    "inbox_title": "Nachrichten",
    "no_conversations": "Noch keine Unterhaltungen",
    "new_chat": "Neue Nachricht",
    "search_conversations": "Unterhaltungen durchsuchen",
    "search_messages": "Nachrichten durchsuchen",
    "message_sent": "Gesendet",
    "message_delivered": "Zugestellt",
    "message_read_by": "Gelesen von {name}",
    "typing": "{name} schreibt...",
    "online": "Online",
    "away": "Abwesend",
    "offline": "Offline",
    "participants": "Teilnehmer",
    "add_participant": "Teilnehmer hinzufügen",
    "conversation_info": "Unterhaltungsinfo",
    "mute_conversation": "Stummschalten",
    "unmute_conversation": "Ton einschalten",
    "archive_conversation": "Archivieren",
    "unarchive_conversation": "Aus Archiv wiederherstellen",
    "delete_conversation": "Löschen",
    "close_conversation": "Schließen",
    "reply": "Antworten",
    "edit": "Bearbeiten",
    "delete": "Für mich löschen",
    "delete_for_all": "Für alle löschen",
    "pin": "Anheften",
    "unpin": "Loslösen",
    "reactions": "Reaktionen",
    "attachment": "Anhang",
    "attachment_upload_error": "Fehler beim Upload",
    "photo": "Foto",
    "video": "Video",
    "document": "Dokument",
    "send": "Senden",
    "cancel": "Abbrechen",
    "conversation_closed": "Diese Unterhaltung ist geschlossen"
  }
}
```

---

## 7️⃣ Secrets & Authentication

### Add to Supabase Project Secrets

**Via Supabase Dashboard:**
1. Project Settings → Secrets
2. Add new secret:

```
Key: JWT_SECRET
Value: (Auto-generated by Supabase, copy from Authentication → API)
```

**Required JWT Scopes:**
- `auth` (user authentication)
- `postgres` (for RLS policies)

### Verify JWT Configuration

```sql
-- Check JWT settings
SHOW jwt.secret;
```

---

## 8️⃣ Testing Checklist

### Database Tests

```sql
-- 1. Test conversation creation
INSERT INTO conversations (id, salon_id, type, title, created_by)
VALUES ('test-conv-1', 'test-salon-1', 'group', 'Test Group', 'test-user-1');

-- 2. Test participant insertion
INSERT INTO conversation_participants (id, conversation_id, user_id, role)
VALUES ('part-1', 'test-conv-1', 'test-user-1', 'owner');

-- 3. Test message insertion
INSERT INTO messages (id, conversation_id, sender_id, content, message_type)
VALUES ('msg-1', 'test-conv-1', 'test-user-1', 'Hello World', 'text');

-- 4. Test read receipt insertion
INSERT INTO message_reads (message_id, reader_id)
VALUES ('msg-1', 'test-user-1');

-- 5. Verify RLS works (should only see own data)
SELECT * FROM conversations WHERE id = 'test-conv-1';
```

### Flutter Integration Tests

```dart
// Test 1: Connect to Supabase
final supabase = Supabase.instance.client;
assert(supabase.auth.currentUser != null);

// Test 2: Can insert conversation
final conv = await chatRepository.createConversation(...);
assert(conv.id.isNotEmpty);

// Test 3: Can send message
final msg = await chatRepository.sendMessage(...);
assert(msg.id.isNotEmpty);

// Test 4: Can mark message as read
await chatRepository.markMessageAsRead(msg.id);
final reads = await chatRepository.getMessageReads(msg.id);
assert(reads.contains(currentUserId));
```

---

## 9️⃣ Deployment Steps (In Order)

**Step 1: Database**
- [ ] Execute migration file
- [ ] Verify all tables created
- [ ] Verify all RLS policies enabled
- [ ] Enable Realtime on 5 tables

**Step 2: Storage**
- [ ] Create `chat-attachments` bucket
- [ ] Configure RLS policies

**Step 3: Functions**
- [ ] Create `close_expired_booking_chats()` function
- [ ] Create `clean_expired_typing_indicators()` function
- [ ] Enable `pg_cron` extension
- [ ] Schedule cron jobs (optional)

**Step 4: Configuration**
- [ ] Update Flutter `.env` file
- [ ] Update `pubspec.yaml` versions
- [ ] Add localization strings (en.json + de.json)
- [ ] Configure project secrets

**Step 5: Testing**
- [ ] Run database tests
- [ ] Run Flutter integration tests
- [ ] Test real-time updates (messages, typing)
- [ ] Test attachments upload/download
- [ ] Test read receipts

**Step 6: Deployment**
- [ ] Build Flutter app (release mode)
- [ ] Test on staging environment
- [ ] Test on production environment
- [ ] Monitor for errors

---

## 🔟 Post-Deployment Verification

### Monitoring

**Check Logs:**
```
Supabase Dashboard → Logs → Database → Audit logs
```

**Monitor Real-time Events:**
```
Supabase Dashboard → Realtime → Status
```

**Check Database Health:**
```sql
SELECT 
  schemaname,
  tablename,
  n_live_tup as live_rows,
  n_dead_tup as dead_rows
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY n_live_tup DESC;
```

### Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| "RLS policy violation" | User doesn't have permission | Verify salon_id matches & RLS policy enabled |
| Messages not real-time | Realtime not enabled | Enable on messages table |
| Read receipts not updating | messageReadsProvider not watched | Check ChatDetailScreen imports |
| Attachments 403 error | Storage RLS policy missing | Configure storage.objects policies |
| Typing indicators linger | Cleanup function not scheduled | Enable pg_cron & schedule function |

---

## 1️⃣1️⃣ Rollback Instructions

If something goes wrong:

**Option 1: Revert Migration**
```sql
DROP TABLE message_reads;
DROP TABLE typing_indicators;
ALTER TABLE messages DROP COLUMN IF EXISTS edited_at;
ALTER TABLE messages DROP COLUMN IF EXISTS pinned_by;
-- ... continue for other columns
```

**Option 2: Restore from Backup**
```bash
supabase db pull  # Pull latest schema
supabase db reset  # Reset to last backup
```

**Option 3: Contact Supabase Support**
- Go to Supabase Dashboard → Help → Support
- Provide migration file & error logs

---

## 1️⃣2️⃣ Performance Tuning

### Query Optimization

```sql
-- Analyze query performance
EXPLAIN ANALYZE
SELECT * FROM messages 
WHERE conversation_id = 'conv-123'
ORDER BY created_at DESC
LIMIT 20;

-- Optimize with index
CREATE INDEX idx_messages_conversation_created 
ON messages(conversation_id, created_at DESC) 
WHERE NOT is_deleted;
```

### Database Statistics

```sql
-- Update statistics for query planner
ANALYZE messages;
ANALYZE conversations;
ANALYZE conversation_participants;
```

### Cache Configuration

In Flutter, message lists use Riverpod caching:
- Pages cache 20 messages at a time
- Infinite scroll keeps memory bounded
- Provider auto-disposes after 5 min inactivity

---

## 1️⃣3️⃣ Support & Escalation

**Before Contacting Support:**
1. Check Supabase status page: https://status.supabase.com
2. Review logs in Dashboard → Logs
3. Test with `supabase status` CLI command
4. Verify RLS policies with test SQL query

**Contact Supabase:**
- Dashboard → Help → Contact Support
- Include: Error logs, migration file, RLS policies

**Flutter Chat Module Support:**
- Check [CHAT_MODULE_IMPLEMENTATION.md](./CHAT_MODULE_IMPLEMENTATION.md)
- Check [CHAT_EXTENDED_FEATURES_GUIDE.md](./CHAT_EXTENDED_FEATURES_GUIDE.md)
- Review code in `lib/features/chat/`

---

## Summary

✅ **Complete Setup Checklist:**
1. Database migration executed
2. RLS policies verified (10 policies)
3. Realtime enabled (5 tables)
4. Storage bucket created
5. Functions & triggers configured
6. Environment variables set
7. Localization strings added
8. All tests passing
9. Monitoring configured
10. Rollback plan documented

**Estimated Setup Time:** 30-45 minutes

**Support Contact:** Supabase Dashboard Help Panel

---

**Next Step:** Deploy to production with [FINAL_CHAT_MODULE_SUMMARY.md](./FINAL_CHAT_MODULE_SUMMARY.md) for system overview.
