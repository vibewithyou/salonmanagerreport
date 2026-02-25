import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

@freezed
class Employee with _$Employee {
  const factory Employee({
    required String id,
    required String salonId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String role, // manager, stylist, receptionist, other
    required List<String> specialties, // list of service IDs
    double? commission, // commission percentage
    String? ssn,
    DateTime? hireDate,
    DateTime? birthDate,
    String? address,
    bool? isActive,
    int? yearsOfExperience,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Employee;

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
}

@freezed
class EmployeeSchedule with _$EmployeeSchedule {
  const factory EmployeeSchedule({
    required String id,
    required String employeeId,
    required String salonId,
    required String dayOfWeek, // monday, tuesday, etc.
    required String startTime, // HH:mm format
    required String endTime, // HH:mm format
    String? notes,
    bool? isOffDay,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EmployeeSchedule;

  factory EmployeeSchedule.fromJson(Map<String, dynamic> json) =>
      _$EmployeeScheduleFromJson(json);
}

@freezed
class EmployeeSummary with _$EmployeeSummary {
  const factory EmployeeSummary({
    required int totalEmployees,
    required int stylists,
    required int managers,
    required int receptionists,
    required int activeEmployees,
  }) = _EmployeeSummary;

  factory EmployeeSummary.fromJson(Map<String, dynamic> json) =>
      _$EmployeeSummaryFromJson(json);
}
