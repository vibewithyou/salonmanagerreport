import 'dart:convert';
import 'package:flutter/material.dart';
import 'notifications_repository.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId;
  final NotificationsRepository repository;

  const NotificationsScreen({
    Key? key,
    required this.userId,
    required this.repository,
  }) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _tabIndex = 0;
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() => _loading = true);
    final all = await widget.repository.listNotifications(widget.userId);
    setState(() {
      _notifications = all;
      _loading = false;
    });
  }

  Future<void> _markRead(String id) async {
    await widget.repository.markRead(id);
    await _fetchNotifications();
  }

  void _onTapNotification(Map<String, dynamic> notification) {
    final payload = notification['payload_json'] ?? {};
    if (payload is String) {
      try {
        final parsed = json.decode(payload);
        _navigateToRoute(parsed);
      } catch (_) {}
    } else {
      _navigateToRoute(payload);
    }
  }

  void _navigateToRoute(Map<String, dynamic> payload) {
    final route = payload['route'];
    if (route != null && route is String) {
      Navigator.of(context).pushNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => n['read_at'] == null).toList();
    final shown = _tabIndex == 0 ? _notifications : unread;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benachrichtigungen'),
        bottom: TabBar(
          onTap: (i) => setState(() => _tabIndex = i),
          tabs: const [
            Tab(text: 'Alle'),
            Tab(text: 'Ungelesen'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: shown.length,
              itemBuilder: (context, idx) {
                final n = shown[idx];
                return ListTile(
                  title: Text(n['title'] ?? ''),
                  subtitle: Text(n['body'] ?? ''),
                  trailing: n['read_at'] == null
                      ? IconButton(
                          icon: const Icon(Icons.mark_email_read),
                          onPressed: () => _markRead(n['id']),
                        )
                      : null,
                  onTap: () => _onTapNotification(n),
                );
              },
            ),
    );
  }
}
