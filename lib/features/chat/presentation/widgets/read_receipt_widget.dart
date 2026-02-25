import 'package:flutter/material.dart';

class ReadReceiptIndicator extends StatelessWidget {
  final bool isSent;
  final bool isDelivered;
  final bool isRead;
  final double size;

  const ReadReceiptIndicator({
    super.key,
    required this.isSent,
    required this.isDelivered,
    required this.isRead,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    // Wenn noch nicht gesendet, zeige nichts
    if (!isSent) {
      return SizedBox(width: size, height: size);
    }

    // 1 Haken: Gesendet
    if (!isDelivered && !isRead) {
      return _buildSingleTick(context);
    }

    // 2 graue Haken: Angekommen (aber nicht gelesen)
    if (isDelivered && !isRead) {
      return _buildDoubleTick(context, isBlue: false);
    }

    // 2 blaue Haken: Gelesen
    if (isDelivered && isRead) {
      return _buildDoubleTick(context, isBlue: true);
    }

    return SizedBox(width: size, height: size);
  }

  Widget _buildSingleTick(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Icon(
        Icons.check,
        size: size,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _buildDoubleTick(BuildContext context, {required bool isBlue}) {
    return SizedBox(
      width: size + 6,
      height: size,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Icon(
              Icons.check,
              size: size,
              color: isBlue ? Colors.blue : Colors.grey.shade500,
            ),
          ),
          Positioned(
            left: 6,
            child: Icon(
              Icons.check,
              size: size,
              color: isBlue ? Colors.blue : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tooltip version showing detailed status
class ReadReceiptTooltip extends StatelessWidget {
  final bool isSent;
  final bool isDelivered;
  final bool isRead;
  final DateTime? sentAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;

  const ReadReceiptTooltip({
    super.key,
    required this.isSent,
    required this.isDelivered,
    required this.isRead,
    this.sentAt,
    this.deliveredAt,
    this.readAt,
  });

  String get _statusText {
    if (isRead && readAt != null) {
      return 'Gelesen um ${_formatTime(readAt!)}';
    }
    if (isDelivered && deliveredAt != null) {
      return 'Angekommen um ${_formatTime(deliveredAt!)}';
    }
    if (isSent && sentAt != null) {
      return 'Gesendet um ${_formatTime(sentAt!)}';
    }
    return 'Wird gesendet...';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _statusText,
      child: ReadReceiptIndicator(
        isSent: isSent,
        isDelivered: isDelivered,
        isRead: isRead,
      ),
    );
  }
}
