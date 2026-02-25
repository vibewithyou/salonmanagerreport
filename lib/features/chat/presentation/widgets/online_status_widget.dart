import 'package:flutter/material.dart';

class OnlineStatusIndicator extends StatelessWidget {
  final DateTime? lastSeenAt;
  final bool isTyping;
  final double size;

  const OnlineStatusIndicator({
    super.key,
    required this.lastSeenAt,
    this.isTyping = false,
    this.size = 12,
  });

  Color get _statusColor {
    if (isTyping) return Colors.orange;
    
    if (lastSeenAt == null) return Colors.grey;
    
    final now = DateTime.now();
    final difference = now.difference(lastSeenAt!);
    
    // Green: online (< 5 min)
    if (difference.inMinutes < 5) return Colors.green;
    
    // Yellow: away (< 1 hour)
    if (difference.inHours < 1) return Colors.yellow;
    
    // Grey: offline
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _statusColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _statusColor.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }
}

class OnlineStatusTile extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  final DateTime? lastSeenAt;
  final bool isTyping;

  const OnlineStatusTile({
    super.key,
    required this.userName,
    this.avatarUrl,
    required this.lastSeenAt,
    this.isTyping = false,
  });

  String get _statusText {
    if (isTyping) return 'typing...';
    
    if (lastSeenAt == null) return 'offline';
    
    final now = DateTime.now();
    final difference = now.difference(lastSeenAt!);
    
    if (difference.inMinutes < 5) return 'online';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    
    return 'offline';
  }

  Color get _statusColor {
    if (isTyping) return Colors.orange;
    
    if (lastSeenAt == null) return Colors.grey;
    
    final now = DateTime.now();
    final difference = now.difference(lastSeenAt!);
    
    if (difference.inMinutes < 5) return Colors.green;
    if (difference.inHours < 1) return Colors.yellow;
    
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null ? Text(userName.characters.first) : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: _statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Text(userName),
      subtitle: Text(
        _statusText,
        style: TextStyle(
          color: _statusColor,
          fontWeight: isTyping ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
