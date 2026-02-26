import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/leave_request.dart';
import '../widgets/leave_status_badge.dart';
import '../../application/providers/leave_request_providers.dart';

class ManagerLeaveRequestsScreen extends ConsumerWidget {
  final String salonId;
  const ManagerLeaveRequestsScreen({Key? key, required this.salonId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveRequestsAsync = ref.watch(pendingLeaveRequestsProvider(salonId));
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Leave Requests')),
      body: leaveRequestsAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text('No pending leave requests.'));
          }
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return ListTile(
                title: Text(req.staffId),
                subtitle: Text('${req.startAt} - ${req.endAt}\n${req.reason ?? ''}'),
                trailing: LeaveStatusBadge(status: req.status),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => _LeaveRequestDetailDialog(request: req, salonId: salonId),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _LeaveRequestDetailDialog extends ConsumerStatefulWidget {
  final LeaveRequest request;
  final String salonId;
  const _LeaveRequestDetailDialog({required this.request, required this.salonId});

  @override
  ConsumerState<_LeaveRequestDetailDialog> createState() => _LeaveRequestDetailDialogState();
}

class _LeaveRequestDetailDialogState extends ConsumerState<_LeaveRequestDetailDialog> {
  final _commentController = TextEditingController();
  bool _loading = false;

  Future<void> _handleAction(String status) async {
    setState(() => _loading = true);
    try {
      await ref.read(leaveRequestsRepositoryProvider).updateStatus(
        widget.request.id,
        status,
        comment: _commentController.text,
      );
      ref.invalidate(pendingLeaveRequestsProvider(widget.salonId));
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request ${status == 'approved' ? 'approved' : 'rejected'}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    return AlertDialog(
      title: Text('Leave Request'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Staff: ${req.staffName ?? req.staffId}'),
          Text('From: ${req.startDate}'),
          Text('To: ${req.endDate}'),
          if (req.reason != null) Text('Reason: ${req.reason}'),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(labelText: 'Comment (optional)'),
            minLines: 1,
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : () => _handleAction('rejected'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Reject'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : () => _handleAction('approved'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Approve'),
        ),
      ],
    );
  }
}
