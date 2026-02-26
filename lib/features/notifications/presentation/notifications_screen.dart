import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // TODO: Replace with repository integration
  List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'title': 'Willkommen!',
      'body': 'Du hast dich erfolgreich angemeldet.',
      'read_at': null,
      'payload_json': {'route': '/dashboard'},
      'created_at': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'id': 2,
      'title': 'Neuer Termin',
      'body': 'Ein neuer Termin wurde gebucht.',
      'read_at': DateTime.now(),
      'payload_json': {'route': '/appointments'},
      'created_at': DateTime.now().subtract(const Duration(hours: 1)),
    },
  ];

  int get unreadCount => notifications.where((n) => n['read_at'] == null).length;

  void markAsRead(int id) {
    setState(() {
      final idx = notifications.indexWhere((n) => n['id'] == id);
      if (idx != -1) notifications[idx]['read_at'] = DateTime.now();
    });
  }

  void onTapNotification(Map<String, dynamic> notification) {
    markAsRead(notification['id']);
    final route = notification['payload_json']?['route'] ?? '/';
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benachrichtigungen'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
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
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final n = notifications[index];
          final isRead = n['read_at'] != null;
          return ListTile(
            title: Text(n['title'] ?? ''),
            subtitle: Text(n['body'] ?? ''),
            trailing: isRead ? null : const Icon(Icons.circle, color: Colors.blue, size: 12),
            onTap: () => onTapNotification(n),
            tileColor: isRead ? null : Colors.blue.withOpacity(0.05),
          );
        },
      ),
    );
  }
}
