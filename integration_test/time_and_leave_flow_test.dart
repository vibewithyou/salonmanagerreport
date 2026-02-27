import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('time tracking and leave flow', () {
    testWidgets('employee starts/stops time entry and manager approves leave', (tester) async {
      final repo = _InMemoryWorkforceRepo();

      const employeeId = 'fixture-employee';
      const managerId = 'fixture-manager';

      final started = repo.startEntry(employeeId);
      expect(started.checkOutAt, isNull);

      final stopped = repo.stopEntry(started.id);
      expect(stopped.checkOutAt, isNotNull);

      final leave = repo.createLeaveRequest(employeeId: employeeId, reason: 'Vacation');
      expect(leave.status, 'pending');

      final approved = repo.approveLeave(leave.id, managerId: managerId);
      expect(approved.status, 'approved');
      expect(approved.approvedBy, managerId);
    });
  });
}

class _TimeEntry {
  _TimeEntry({required this.id, required this.employeeId, required this.checkInAt, this.checkOutAt});

  final String id;
  final String employeeId;
  final DateTime checkInAt;
  final DateTime? checkOutAt;

  _TimeEntry copyWith({DateTime? checkOutAt}) => _TimeEntry(
        id: id,
        employeeId: employeeId,
        checkInAt: checkInAt,
        checkOutAt: checkOutAt ?? this.checkOutAt,
      );
}

class _LeaveRequest {
  _LeaveRequest({required this.id, required this.employeeId, required this.reason, required this.status, this.approvedBy});

  final String id;
  final String employeeId;
  final String reason;
  final String status;
  final String? approvedBy;

  _LeaveRequest copyWith({String? status, String? approvedBy}) => _LeaveRequest(
        id: id,
        employeeId: employeeId,
        reason: reason,
        status: status ?? this.status,
        approvedBy: approvedBy ?? this.approvedBy,
      );
}

class _InMemoryWorkforceRepo {
  int _id = 0;
  final Map<String, _TimeEntry> _entries = {};
  final Map<String, _LeaveRequest> _leaveRequests = {};

  _TimeEntry startEntry(String employeeId) {
    final entry = _TimeEntry(
      id: 'entry-${++_id}',
      employeeId: employeeId,
      checkInAt: DateTime.now(),
    );
    _entries[entry.id] = entry;
    return entry;
  }

  _TimeEntry stopEntry(String entryId) {
    final existing = _entries[entryId]!;
    final updated = existing.copyWith(checkOutAt: DateTime.now());
    _entries[entryId] = updated;
    return updated;
  }

  _LeaveRequest createLeaveRequest({required String employeeId, required String reason}) {
    final req = _LeaveRequest(
      id: 'leave-${++_id}',
      employeeId: employeeId,
      reason: reason,
      status: 'pending',
    );
    _leaveRequests[req.id] = req;
    return req;
  }

  _LeaveRequest approveLeave(String leaveId, {required String managerId}) {
    final existing = _leaveRequests[leaveId]!;
    final updated = existing.copyWith(status: 'approved', approvedBy: managerId);
    _leaveRequests[leaveId] = updated;
    return updated;
  }
}
