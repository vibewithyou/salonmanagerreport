import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonmanager/providers/dashboard_providers.dart';

class ActivityLogTab extends ConsumerWidget {
  final String salonId;

  const ActivityLogTab({required this.salonId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activityLog = ref.watch(activityLogProvider);

    return activityLog.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Fehler: $error')),
      data: (logs) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 Aktivitätsprotokoll',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${logs.length} Aktivitäten',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            if (logs.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Keine Aktivitäten vorhanden'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final timestamp = DateTime.parse(log['timestamp'] as String);
                  final now = DateTime.now();
                  final difference = now.difference(timestamp);
                  String timeAgo;

                  if (difference.inMinutes < 1) {
                    timeAgo = 'gerade eben';
                  } else if (difference.inMinutes < 60) {
                    timeAgo = 'vor ${difference.inMinutes} Min.';
                  } else if (difference.inHours < 24) {
                    timeAgo = 'vor ${difference.inHours} h';
                  } else {
                    timeAgo = 'vor ${difference.inDays} d';
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                      color: isDark ? Colors.grey[900] : Colors.grey[50],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getActionColor(log['action'] as String? ?? '')
                                .withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            _getActionIcon(log['action'] as String? ?? ''),
                            color: _getActionColor(log['action'] as String? ?? ''),
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log['description'] as String? ??
                                    log['action'] as String? ??
                                    'Unbekannte Aktivität',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 2),
                              Text(
                                timeAgo,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark
                                          ? Colors.grey[500]
                                          : Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'create':
      case 'add':
        return Colors.green;
      case 'update':
      case 'edit':
        return Colors.blue;
      case 'delete':
      case 'remove':
        return Colors.red;
      case 'login':
      case 'signin':
        return Colors.purple;
      case 'logout':
      case 'signout':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'create':
      case 'add':
        return Icons.add_circle;
      case 'update':
      case 'edit':
        return Icons.edit;
      case 'delete':
      case 'remove':
        return Icons.delete;
      case 'login':
      case 'signin':
        return Icons.login;
      case 'logout':
      case 'signout':
        return Icons.logout;
      default:
        return Icons.info;
    }
  }
}
