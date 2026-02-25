/// Chat Feature Module
/// 
/// Exportiert alle öffentlichen APIs des Chat-Moduls für einfache Imports.
/// 
/// Verwendung:
/// ```dart
/// import 'package:salonmanager/features/chat/chat.dart';
/// 
/// // Direkt auf Screens, Models, Providers zugreifen
/// // Navigator.push(...ChatInboxScreen());
/// // ref.watch(conversationsProvider);
/// ```

// Domain Models
export 'domain/models/chat_thread.dart';

// Data DTOs
export 'data/dto/chat_thread_dto.dart';

// Repository
export 'data/repository/chat_repository.dart';

// Riverpod Providers
export 'application/providers/chat_providers.dart';

// UI Screens
export 'presentation/screens/chat_inbox_screen.dart';
export 'presentation/screens/chat_detail_screen.dart';
export 'presentation/screens/chat_info_screen.dart';
export 'presentation/screens/message_search_screen.dart';

// UI Widgets
export 'presentation/widgets/read_receipt_widget.dart';
export 'presentation/widgets/reaction_widget.dart';
export 'presentation/widgets/attachment_widget.dart' hide AttachmentType;
export 'presentation/widgets/online_status_widget.dart';
export 'presentation/widgets/pinned_message_widget.dart';
export 'presentation/widgets/file_picker_widget.dart';
export 'presentation/widgets/advanced_message_search.dart';

