import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../notification_repository.dart';

class NotificationIconWithBadge extends StatefulWidget {
  final VoidCallback? onTap;
  final String userId;
  const NotificationIconWithBadge({Key? key, this.onTap, required this.userId}) : super(key: key);

  @override
  State<NotificationIconWithBadge> createState() => _NotificationIconWithBadgeState();
}

class _NotificationIconWithBadgeState extends State<NotificationIconWithBadge> {
  int unreadCount = 0;
  late final NotificationRepository repo;

  @override
  void initState() {
    super.initState();
    repo = NotificationRepository(Supabase.instance.client);
    _fetchUnreadCount();
  }

  Future<void> _fetchUnreadCount() async {
    final notifications = await repo.getNotifications(widget.userId);
    setState(() {
      unreadCount = notifications.where((n) => n['read_at'] == null).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: widget.onTap,
        ),
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
