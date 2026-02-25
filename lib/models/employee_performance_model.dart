import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_performance_model.freezed.dart';
part 'employee_performance_model.g.dart';

/// Dashboard-specific metrics for an employee
@freezed
class EmployeePerformance with _$EmployeePerformance {
  const factory EmployeePerformance({
    required String employeeId,
    required String employeeName,
    required String roleId,
    String? avatarUrl,
    // Performance metrics
    required int appointmentsThisMonth,
    required int appointmentsThisWeek,
    required double averageRating,
    required int totalReviews,
    // Financial metrics
    required double revenueThisMonth,
    required double commissionThisMonth,
    required double targetRevenue,
    // Status
    required bool isActive,
    required bool isOnLeave,
    required DateTime? leaveEndDate,
    // Time tracking
    required int hoursWorkedThisWeek,
    required int scheduledHoursThisWeek,
    // Attendance
    required int presentDays,
    required int absentDays,
    required int lateDays,
    // Last activity
    DateTime? lastAppointment,
    DateTime? lastLogin,
  }) = _EmployeePerformance;

  factory EmployeePerformance.fromJson(Map<String, dynamic> json) =>
      _$EmployeePerformanceFromJson(json);
}

/// Detailed performance metrics for a specific period
@freezed
class PerformanceMetrics with _$PerformanceMetrics {
  const factory PerformanceMetrics({
    required String metricName,
    required double value,
    required double target,
    required double percentage, // value/target * 100
    required String status, // "on-track", "below-target", "exceeding"
    String? trend, // "up", "down", "stable"
    double? previousValue,
  }) = _PerformanceMetrics;

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) =>
      _$PerformanceMetricsFromJson(json);
}

/// Employee schedule for the week/month
@freezed
class EmployeeSchedule with _$EmployeeSchedule {
  const factory EmployeeSchedule({
    required String employeeId,
    required DateTime date,
    required String dayName, // "Montag", "Dienstag", etc.
    required double scheduledHours,
    required double workedHours,
    required int appointmentCount,
    required double totalRevenue,
    required bool isWorkDay,
    String? notes,
  }) = _EmployeeSchedule;

  factory EmployeeSchedule.fromJson(Map<String, dynamic> json) =>
      _$EmployeeScheduleFromJson(json);
}

/// Attendance record for an employee
@freezed
class AttendanceRecord with _$AttendanceRecord {
  const factory AttendanceRecord({
    required String employeeId,
    required DateTime date,
    required String status, // "present", "absent", "late", "early-leave", "on-leave"
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? hoursWorked,
    String? notes,
  }) = _AttendanceRecord;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordFromJson(json);
}

/// Employee skills and certifications
@freezed
class EmployeeSkill with _$EmployeeSkill {
  const factory EmployeeSkill({
    required String skillId,
    required String skillName,
    required String category, // "service", "tool", "language", "certification"
    required int proficiencyLevel, // 1-5
    DateTime? acquiredDate,
    DateTime? expiryDate,
    String? certification,
  }) = _EmployeeSkill;

  factory EmployeeSkill.fromJson(Map<String, dynamic> json) =>
      _$EmployeeSkillFromJson(json);
}

/// Employee statistics for dashboard display
@freezed
class EmployeeStats with _$EmployeeStats {
  const factory EmployeeStats({
    required int totalEmployees,
    required int activeEmployees,
    required int onLeaveCount,
    required int newEmployeesThisMonth,
    required double averageSalonRating,
    required double totalRevenueThisMonth,
    required double averageRevenuePerEmployee,
    required int totalAppointmentsThisMonth,
  }) = _EmployeeStats;

  factory EmployeeStats.fromJson(Map<String, dynamic> json) =>
      _$EmployeeStatsFromJson(json);
}
