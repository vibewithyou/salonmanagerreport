# 📁 File Picker Integration & Advanced Message Search

**Status:** ✅ Complete
**Release Date:** Februar 2026
**Features:** 2 Major Enhancements

---

## 🎯 Overview

This document covers two new powerful features added to the Chat Module:

1. **File Picker Integration** - Professional file selection with image_picker & file_picker packages
2. **Advanced Message Search** - Full-featured search with filters, date ranges, and message types

---

## 1️⃣ File Picker Integration

### Architecture

```
FilePickerIntegration (Static Utility Class)
├── pickImage() → Single image from gallery
├── pickVideo() → Single video from gallery
├── pickMultipleImages() → Multiple images at once
├── pickFile() → Any file type
├── pickDocument() → PDF, Word, Excel, PowerPoint
├── pickPDF() → PDF files only
└── Utility Methods
    ├── getFileSizeString() → Format bytes to KB/MB
    ├── isImage() → Check if file is image
    ├── isVideo() → Check if file is video
    └── isDocument() → Check if file is document

UI Components
├── AdvancedFilePickerButton → Popup menu with drag options
├── AdvancedAttachmentPreview → Display attachment with icon & size
└── AttachmentUploadProgress → Visual upload progress bar
```

### Features

**Image Selection:**
- ✅ Single image picker with compression (85% quality)
- ✅ Multiple images picker (bulk select)
- ✅ Auto-compress images > 10MB to 1080x1920
- ✅ Respects device orientation (portrait/landscape)

**Video Selection:**
- ✅ Video picker from gallery
- ✅ Optional duration limit
- ✅ File size validation (max 50MB)
- ✅ Support for MP4, AVI, MOV, MKV formats

**Document Selection:**
- ✅ Multi-format support (PDF, Word, Excel, PowerPoint)
- ✅ Custom file type filtering
- ✅ File size validation (max 50MB)
- ✅ Extensible for additional formats

**File Management:**
- ✅ Formatted file size display (B, KB, MB)
- ✅ File type detection by extension
- ✅ Progress tracking during upload
- ✅ Error handling with try-catch

---

### Implementation Details

**File:** `lib/features/chat/presentation/widgets/file_picker_widget.dart`

#### Static Methods

```dart
// Single image from gallery with optional compression
File? image = await FilePickerIntegration.pickImage(
  source: ImageSource.gallery,
  compress: true,
);

// Multiple images at once
List<File> images = await FilePickerIntegration.pickMultipleImages(
  compress: true,
);

// Video with duration limit
File? video = await FilePickerIntegration.pickVideo(
  maxDuration: Duration(minutes: 10),
);

// Any document type
File? file = await FilePickerIntegration.pickFile(
  type: FileType.custom,
  allowedExtensions: ['pdf', 'docx'],
);

// Specifically PDF
File? pdf = await FilePickerIntegration.pickPDF();

// Document bundle (PDF, Office)
File? doc = await FilePickerIntegration.pickDocument();
```

#### Size Constants

```dart
const int maxFileSizeMB = 50;        // Overall file limit
const int maxImageSizeMB = 10;       // Image compression threshold
```

#### Image Compression

- Quality: 70% (optimized for quality/size balance)
- Max resolution: 1080x1920
- Output format: JPEG
- Automatic if file > 10MB

#### Supported File Types

| Type | Extensions |
|------|-----------|
| **Image** | jpg, jpeg, png, gif, webp, bmp |
| **Video** | mp4, avi, mov, mkv, wmv, flv |
| **Document** | pdf, doc, docx, xls, xlsx, ppt, pptx |

---

### UI Components

#### 1. AdvancedFilePickerButton

Replacement for old `AttachmentUploadWidget` with improved UX.

```dart
AdvancedFilePickerButton(
  onFilePicked: (file, type) {
    // Handle single file
    print('File: ${file.path}, Type: $type');
  },
  onMultipleFilesPicked: (files) {
    // Handle multiple files
    print('Files: ${files.length}');
  },
  allowMultiple: true,
  allowCompressionToggle: false,
)
```

**Features:**
- Loading state with spinner
- Popup menu with 4 options (Photo, Video, Document + Audio placeholder)
- Color-coded icons by type
- Long-press support for additional actions

**Menu Options:**
```
📷 Photo (Single)
🎬 Video
📄 Document
🔊 Audio (Coming Soon - disabled)
```

#### 2. AdvancedAttachmentPreview

Display attached files before sending.

```dart
AdvancedAttachmentPreview(
  file: pickedFile,
  type: AttachmentType.image,
  onRemove: () => setState(() => _attachment = null),
  showSize: true,
)
```

**Display:**
- File icon (color-coded by type)
- File name (truncated with ellipsis)
- File size formatted (KB/MB)
- Remove button (X icon)

**Colors by Type:**
- 🔵 **Image** → Blue
- 🟣 **Video** → Purple
- 🟠 **Document** → Orange
- ⚪ **Other** → Grey

#### 3. AttachmentUploadProgress

Show progress during file upload.

```dart
AttachmentUploadProgress(
  fileName: 'document.pdf',
  progress: 0.65,
  isComplete: false,
)
```

**Display:**
- File name
- Progress percentage (0-100%)
- Progress bar with color change on complete
- Colors: Primary → Green on completion

---

### Integration Example

**In ChatDetailScreen:**

```dart
class ChatDetailScreen extends ConsumerStatefulWidget {
  // ...
  
  late File? _selectedAttachment;
  late AttachmentType? _attachmentType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat messages list
        Expanded(child: _buildMessagesList()),
        
        // Message input area
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // File Picker
              AdvancedFilePickerButton(
                onFilePicked: (file, type) {
                  setState(() {
                    _selectedAttachment = file;
                    _attachmentType = type;
                  });
                },
              ),
              // Text input
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type message...',
                  ),
                ),
              ),
              // Send button
              IconButton(
                icon: const Icon(LucideIcons.send),
                onPressed: () => _sendMessage(),
              ),
            ],
          ),
        ),
        
        // Preview selected attachment
        if (_selectedAttachment != null)
          AdvancedAttachmentPreview(
            file: _selectedAttachment!,
            type: _attachmentType!,
            onRemove: () {
              setState(() {
                _selectedAttachment = null;
                _attachmentType = null;
              });
            },
          ),
      ],
    );
  }
}
```

---

## 2️⃣ Advanced Message Search

### Architecture

```
AdvancedMessageSearch (UI Widget)
├── Search TextField
├── Filter Chips (clickable filters)
├── Active Filters Display (removable tags)
└── Bottom Sheets
    ├── Message Type Filter
    └── Date Range Filter

MessageSearchParams (Data Class)
├── toSupabaseQuery() → Generate SQL WHERE clause
├── hasActiveFilters → Bool check
└── copyWith() → Immutable copy with updates
```

### Features

**Search Capabilities:**
- ✅ Full-text search on message content
- ✅ Filter by message type (text, image, video, document)
- ✅ Filter by date range (from/to)
- ✅ Filter by reactions (has emoji reactions)
- ✅ Filter by pinned status
- ✅ Real-time search results

**UI Elements:**
- ✅ Search field with clear button
- ✅ Quick filter chips (clickable)
- ✅ Active filters display as removable tags
- ✅ Modal bottom sheets for complex filters
- ✅ Clear all filters button

**Data Handling:**
- ✅ Immutable `MessageSearchParams` object
- ✅ Automatic Supabase query generation
- ✅ Type-safe enum-based filtering
- ✅ Date formatting (MMM d, yyyy)

---

### Filters Explained

#### 1. Text Search (Query)

```dart
// Find messages containing "hello"
MessageSearchParams(query: 'hello')
// Generates: WHERE content @@ plainto_tsquery('hello')
```

**Behavior:**
- Case-insensitive full-text search
- Uses PostgreSQL's full-text search (efficient)
- Searches across message content
- Highlights matching terms in results

#### 2. Message Type Filter

```dart
MessageSearchParams(messageType: ChatMessageType.image)
// Generates: WHERE message_type = 'image'
```

**Available Types:**
- `text` - Text messages only
- `image` - Photos/screenshots
- `video` - Video files
- `document` - PDFs, Word, Excel, etc.
- `system` - System notifications (user joined, etc.)

#### 3. Date Range Filter

```dart
MessageSearchParams(
  dateFrom: DateTime(2026, 2, 1),
  dateTo: DateTime(2026, 2, 15),
)
// Generates: WHERE created_at >= '2026-02-01' AND created_at <= '2026-02-15'
```

**Behavior:**
- Filters by message creation date
- Shows date picker on tap
- Can use only "from" or only "to"
- Displayed as "MMM d, yyyy" format

#### 4. Reactions Filter

```dart
MessageSearchParams(hasReactions: true)
// Generates: WHERE reactions IS NOT NULL AND reactions != '{}'
```

**Behavior:**
- Shows only messages with emoji reactions
- Useful for highlighting community engagement
- Works with any emoji type

#### 5. Pinned Filter

```dart
MessageSearchParams(isPinned: true)
// Generates: WHERE pinned_by IS NOT NULL
```

**Behavior:**
- Shows only pinned messages
- Useful for highlighting important info
- Works with pinned message panel

---

### Implementation Details

**File:** `lib/features/chat/presentation/widgets/advanced_message_search.dart`

#### MessageSearchParams Class

```dart
class MessageSearchParams {
  final String? query;                    // Full-text search
  final ChatMessageType? messageType;     // Message type filter
  final String? senderId;                 // (Future) Filter by sender
  final DateTime? dateFrom;               // Date range start
  final DateTime? dateTo;                 // Date range end
  final List<String>? excludeSenderIds;   // (Future) Exclude users
  final bool? hasReactions;               // Has emoji reactions
  final bool? isPinned;                   // Pinned messages only
  
  // Convert to Supabase WHERE clause
  String toSupabaseQuery() { ... }
  
  // Check if any filter is active
  bool get hasActiveFilters { ... }
  
  // Create copy with updated fields
  MessageSearchParams copyWith({ ... }) { ... }
}
```

#### UI Components

**Search TextField:**
- Real-time search as user types
- Clear button (X icon) appears when text entered
- Sends query to `onSearch` callback

**Filter Chips:**
- Quick-access buttons: Message Type, Date Range, Reactions, Pinned
- Change color when filter is active
- Show down arrow indicator
- Tap to open filter bottom sheet

**Active Filters Tags:**
- Display all active filters as removable pills
- Each tag shows specific filter value
- X button removes individual filters
- "Clear" button resets all filters

**Bottom Sheets:**

*Message Type Filter:*
```
All Messages
Text Messages
Images
Videos
Documents
```

*Date Range Filter:*
```
[📅 From: MMM d, yyyy]
[📅 To: MMM d, yyyy]
[Apply Button]
```

---

### Integration Example

**In MessageSearchScreen:**

```dart
class MessageSearchScreen extends ConsumerWidget {
  final String conversationId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Messages'),
      ),
      body: Column(
        children: [
          // Advanced search with filters
          AdvancedMessageSearch(
            conversationId: conversationId,
            onSearch: (params) {
              // Rebuild with new search results
              ref.refresh(
                messageSearchProvider((
                  conversationId,
                  params.toSupabaseQuery(),
                ))
              );
            },
          ),
          
          // Display search results
          Expanded(
            child: _buildSearchResults(ref),
          ),
        ],
      ),
    );
  }
}
```

---

### Search Results Display

Results show:
- ✅ Sender avatar
- ✅ Sender name
- ✅ Message content with highlighted search term (yellow background)
- ✅ Message timestamp (HH:mm format)
- ✅ Message type icon (image/video/document)
- ✅ Tap to navigate to message in conversation

---

## 📊 Database Query Generation

### Example Queries

**Search text with type filter:**
```sql
SELECT * FROM messages
WHERE conversation_id = 'conv-123'
  AND content @@ plainto_tsquery('deadline')
  AND message_type = 'document'
ORDER BY created_at DESC
LIMIT 20;
```

**Date range + reactions:**
```sql
SELECT * FROM messages
WHERE conversation_id = 'conv-123'
  AND created_at >= '2026-02-01'
  AND created_at <= '2026-02-28'
  AND reactions IS NOT NULL
  AND reactions != '{}'
ORDER BY created_at DESC
LIMIT 20;
```

**Pinned messages only:**
```sql
SELECT * FROM messages
WHERE conversation_id = 'conv-123'
  AND pinned_by IS NOT NULL
ORDER BY created_at DESC
LIMIT 50;
```

---

## 🔌 Package Dependencies

**New packages added to pubspec.yaml:**

```yaml
dependencies:
  file_picker: ^8.0.0              # File/folder selection
  image_picker: ^1.1.0             # Already present
  flutter_image_compress: ^2.3.0   # Already present
```

**For iOS (Xcode configuration required):**
```
Info.plist additions:
- NSPhotoLibraryUsageDescription
- NSCameraUsageDescription
- NSMicrophoneUsageDescription
```

**For Android (AndroidManifest.xml additions):**
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

---

## 🎨 Theme Integration

Both features use existing theme system:

```dart
// Colors from Theme
Theme.of(context).colorScheme.primary       // Primary actions
Theme.of(context).colorScheme.surface       // Backgrounds
Theme.of(context).colorScheme.outline       // Borders
Theme.of(context).textTheme.bodySmall       // Small text
Theme.of(context).textTheme.labelSmall      // Labels
```

No custom theme tokens needed - uses Material Design defaults.

---

## 📚 Usage Examples

### Example 1: Pick and Send Image

```dart
final file = await FilePickerIntegration.pickImage();
if (file != null) {
  await chatNotifier.sendMessage(
    conversationId: 'conv-123',
    content: 'Check this out!',
    attachment: file,
    messageType: ChatMessageType.image,
  );
}
```

### Example 2: Search with Multiple Filters

```dart
final searchParams = MessageSearchParams(
  query: 'important',
  messageType: ChatMessageType.document,
  dateFrom: DateTime(2026, 2, 1),
  hasReactions: true,
);

final results = await chatRepository.searchMessages(
  conversationId: 'conv-123',
  params: searchParams,
);
```

### Example 3: Bulk Image Upload

```dart
final images = await FilePickerIntegration.pickMultipleImages();
for (final image in images) {
  await chatNotifier.sendMessage(
    conversationId: 'conv-123',
    content: '',
    attachment: image,
    messageType: ChatMessageType.image,
  );
}
```

---

## 🚀 Performance Considerations

**File Picker:**
- ✅ Runs on isolate (doesn't block UI)
- ✅ Image compression uses FlutterImageCompress (native performance)
- ✅ Memory-efficient streaming for large files

**Message Search:**
- ✅ Uses PostgreSQL full-text search (indexed, fast)
- ✅ Filters applied server-side (minimal data transfer)
- ✅ Results cached in Riverpod (re-use without re-query)
- ✅ Only searches active conversation (not global)

**Best Practices:**
```dart
// ✅ Good - compress images before sending
var image = await FilePickerIntegration.pickImage(compress: true);

// ✅ Good - specific search queries
var params = MessageSearchParams(
  query: 'invoice',
  messageType: ChatMessageType.document,
);

// ❌ Avoid - searching all message types without filter
var params = MessageSearchParams(query: 'the');  // Too broad
```

---

## 🐛 Error Handling

Both features have comprehensive error handling:

**File Picker Errors:**
```dart
try {
  final file = await FilePickerIntegration.pickImage();
} catch (e) {
  // User cancelled selection
  // OR Permission denied
  // OR File access error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

**Search Errors:**
- Invalid query: Empty results returned
- Database error: Error state shown in UI
- Network error: Retries handled by Supabase client

---

## 📱 Platform-Specific Notes

**iOS:**
- Requires `NSPhotoLibraryUsageDescription` in Info.plist
- Requires `NSCameraUsageDescription` if using camera
- Image picker uses PHPickerViewController (iOS 14+)

**Android:**
- Requires `READ_EXTERNAL_STORAGE` permission
- Requires `WRITE_EXTERNAL_STORAGE` for some operations
- File picker uses system file picker (Android 5+)

**Windows/macOS:**
- File picker fully supported
- Image picker limited (no camera access)
- Desktop search optimized for local files

---

## 🔮 Future Enhancements

**File Picker:**
- [ ] Audio file picker (with recorder)
- [ ] Camera capture (photo/video)
- [ ] Document scanner integration
- [ ] Drag-and-drop support
- [ ] Recent files history

**Message Search:**
- [ ] Search by sender name
- [ ] Advanced boolean search (AND, OR, NOT)
- [ ] Search across conversations (global search)
- [ ] Saved search queries
- [ ] Search analytics/insights
- [ ] AI-powered search suggestions

---

## 📞 Support & Troubleshooting

### File Picker Issues

| Issue | Solution |
|-------|----------|
| Permission denied | Check Android/iOS permissions in OS settings |
| Image too large | Compression runs automatically if > 10MB |
| File not found after selection | Platform returned invalid path - retry picker |
| Picker doesn't open | Check OS file picker implementation |

### Search Issues

| Issue | Solution |
|-------|----------|
| No results found | Try broader search term or fewer filters |
| Search is slow | Add date range filter to limit scope |
| Filters not applying | Check that filter is enabled (colored chip) |
| Old results showing | Clear cache: `ref.refresh(messageSearchProvider)` |

---

## Summary

**File Picker Integration:** Professional, user-friendly file selection supporting images, videos, documents with automatic compression and progress tracking.

**Advanced Message Search:** Powerful filtering system with full-text search, type filtering, date ranges, and reaction/pinning filters for comprehensive message discovery.

**Both features are production-ready and fully integrated into the Chat Module!**

---

**Version:** 1.0
**Status:** ✅ Complete & Integrated
**Last Updated:** Februar 2026
