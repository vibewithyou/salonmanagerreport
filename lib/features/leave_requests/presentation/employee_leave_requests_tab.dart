import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../time_tracking/application/providers/time_tracking_providers.dart';
import '../application/providers/leave_request_providers.dart';

class EmployeeLeaveRequestsTab extends ConsumerStatefulWidget {
  const EmployeeLeaveRequestsTab({super.key});

  @override
  ConsumerState<EmployeeLeaveRequestsTab> createState() => _EmployeeLeaveRequestsTabState();
}

class _EmployeeLeaveRequestsTabState extends ConsumerState<EmployeeLeaveRequestsTab> {
  String _type = 'vacation';
  DateTime? _startAt;
  DateTime? _endAt;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = ref.watch(activeTimeTrackingScopeProvider);
    if (scope == null) {
      return const Center(child: Text('Salon oder Benutzerkontext fehlt.'));
    }

    final requestsAsync = ref.watch(leaveRequestsProvider(scope));

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildForm(scope),
          ),
          Expanded(
            child: requestsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Fehler: $error', style: const TextStyle(color: Colors.white70))),
              data: (requests) {
                if (requests.isEmpty) {
                  return const Center(child: Text('Keine Anträge vorhanden', style: TextStyle(color: Colors.white54)));
                }
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return ListTile(
                      title: Text('${_label(request.type)} • ${DateFormat('dd.MM.yyyy').format(request.startAt)} - ${DateFormat('dd.MM.yyyy').format(request.endAt)}', style: const TextStyle(color: Colors.white)),
                      subtitle: Text(request.reason ?? '-', style: const TextStyle(color: Colors.white70)),
                      trailing: _statusChip(request.status),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(TimeTrackingScope scope) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _type,
              items: const [
                DropdownMenuItem(value: 'vacation', child: Text('Urlaub')),
                DropdownMenuItem(value: 'sick', child: Text('Krank')),
                DropdownMenuItem(value: 'other', child: Text('Sonstiges')),
              ],
              onChanged: (value) => setState(() => _type = value ?? 'vacation'),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextButton(onPressed: () async {
                final date = await showDatePicker(context: context, firstDate: DateTime.now().subtract(const Duration(days: 365)), lastDate: DateTime.now().add(const Duration(days: 365)), initialDate: _startAt ?? DateTime.now());
                if (date != null) setState(() => _startAt = date);
              }, child: Text(_startAt == null ? 'Start' : DateFormat('dd.MM.yyyy').format(_startAt!)))),
              Expanded(child: TextButton(onPressed: () async {
                final date = await showDatePicker(context: context, firstDate: DateTime.now().subtract(const Duration(days: 365)), lastDate: DateTime.now().add(const Duration(days: 365)), initialDate: _endAt ?? _startAt ?? DateTime.now());
                if (date != null) setState(() => _endAt = date);
              }, child: Text(_endAt == null ? 'Ende' : DateFormat('dd.MM.yyyy').format(_endAt!)))),
            ]),
            TextField(controller: _reasonController, decoration: const InputDecoration(hintText: 'Grund (optional)')),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_startAt == null || _endAt == null) return;
                  try {
                    await ref.read(leaveRequestsRepositoryProvider).createRequest(
                      salonId: scope.salonId,
                      staffId: scope.staffId,
                      type: _type,
                      startAt: _startAt!,
                      endAt: _endAt!,
                      reason: _reasonController.text.trim().isEmpty ? null : _reasonController.text.trim(),
                    );
                    _reasonController.clear();
                    setState(() {
                      _startAt = null;
                      _endAt = null;
                      _type = 'vacation';
                    });
                    ref.invalidate(leaveRequestsProvider(scope));
                  } catch (error) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Antrag fehlgeschlagen: $error')));
                  }
                },
                child: const Text('Antrag senden'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = switch (status) {
      'approved' => Colors.green,
      'rejected' => Colors.red,
      _ => Colors.orange,
    };
    return Chip(label: Text(status), backgroundColor: color.withOpacity(0.2), labelStyle: TextStyle(color: color));
  }

  String _label(String type) => switch (type) {
    'vacation' => 'Urlaub',
    'sick' => 'Krank',
    _ => 'Sonstiges',
  };
}
