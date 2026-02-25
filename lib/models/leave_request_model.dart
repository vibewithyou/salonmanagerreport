import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_request_model.freezed.dart';
part 'leave_request_model.g.dart';

enum LeaveType {
  vacation,
  sick,
  personal,
  other,
}

enum LeaveStatus {
  pending,
  approved,
  rejected,
}

/// Leave request model
@freezed
class LeaveRequest with _$LeaveRequest {
  const factory LeaveRequest({
    required String id,
    required String employeeId,
    required String employeeName,
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required LeaveStatus status,
    String? adminNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LeaveRequest;

  factory LeaveRequest.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestFromJson(json);
}
