// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_performance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeePerformanceImpl _$$EmployeePerformanceImplFromJson(
  Map<String, dynamic> json,
) => _$EmployeePerformanceImpl(
  employeeId: json['employeeId'] as String,
  employeeName: json['employeeName'] as String,
  roleId: json['roleId'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  appointmentsThisMonth: (json['appointmentsThisMonth'] as num).toInt(),
  appointmentsThisWeek: (json['appointmentsThisWeek'] as num).toInt(),
  averageRating: (json['averageRating'] as num).toDouble(),
  totalReviews: (json['totalReviews'] as num).toInt(),
  revenueThisMonth: (json['revenueThisMonth'] as num).toDouble(),
  commissionThisMonth: (json['commissionThisMonth'] as num).toDouble(),
  targetRevenue: (json['targetRevenue'] as num).toDouble(),
  isActive: json['isActive'] as bool,
  isOnLeave: json['isOnLeave'] as bool,
  leaveEndDate: json['leaveEndDate'] == null
      ? null
      : DateTime.parse(json['leaveEndDate'] as String),
  hoursWorkedThisWeek: (json['hoursWorkedThisWeek'] as num).toInt(),
  scheduledHoursThisWeek: (json['scheduledHoursThisWeek'] as num).toInt(),
  presentDays: (json['presentDays'] as num).toInt(),
  absentDays: (json['absentDays'] as num).toInt(),
  lateDays: (json['lateDays'] as num).toInt(),
  lastAppointment: json['lastAppointment'] == null
      ? null
      : DateTime.parse(json['lastAppointment'] as String),
  lastLogin: json['lastLogin'] == null
      ? null
      : DateTime.parse(json['lastLogin'] as String),
);

Map<String, dynamic> _$$EmployeePerformanceImplToJson(
  _$EmployeePerformanceImpl instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'employeeName': instance.employeeName,
  'roleId': instance.roleId,
  'avatarUrl': instance.avatarUrl,
  'appointmentsThisMonth': instance.appointmentsThisMonth,
  'appointmentsThisWeek': instance.appointmentsThisWeek,
  'averageRating': instance.averageRating,
  'totalReviews': instance.totalReviews,
  'revenueThisMonth': instance.revenueThisMonth,
  'commissionThisMonth': instance.commissionThisMonth,
  'targetRevenue': instance.targetRevenue,
  'isActive': instance.isActive,
  'isOnLeave': instance.isOnLeave,
  'leaveEndDate': instance.leaveEndDate?.toIso8601String(),
  'hoursWorkedThisWeek': instance.hoursWorkedThisWeek,
  'scheduledHoursThisWeek': instance.scheduledHoursThisWeek,
  'presentDays': instance.presentDays,
  'absentDays': instance.absentDays,
  'lateDays': instance.lateDays,
  'lastAppointment': instance.lastAppointment?.toIso8601String(),
  'lastLogin': instance.lastLogin?.toIso8601String(),
};

_$PerformanceMetricsImpl _$$PerformanceMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$PerformanceMetricsImpl(
  metricName: json['metricName'] as String,
  value: (json['value'] as num).toDouble(),
  target: (json['target'] as num).toDouble(),
  percentage: (json['percentage'] as num).toDouble(),
  status: json['status'] as String,
  trend: json['trend'] as String?,
  previousValue: (json['previousValue'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$PerformanceMetricsImplToJson(
  _$PerformanceMetricsImpl instance,
) => <String, dynamic>{
  'metricName': instance.metricName,
  'value': instance.value,
  'target': instance.target,
  'percentage': instance.percentage,
  'status': instance.status,
  'trend': instance.trend,
  'previousValue': instance.previousValue,
};

_$EmployeeScheduleImpl _$$EmployeeScheduleImplFromJson(
  Map<String, dynamic> json,
) => _$EmployeeScheduleImpl(
  employeeId: json['employeeId'] as String,
  date: DateTime.parse(json['date'] as String),
  dayName: json['dayName'] as String,
  scheduledHours: (json['scheduledHours'] as num).toDouble(),
  workedHours: (json['workedHours'] as num).toDouble(),
  appointmentCount: (json['appointmentCount'] as num).toInt(),
  totalRevenue: (json['totalRevenue'] as num).toDouble(),
  isWorkDay: json['isWorkDay'] as bool,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$EmployeeScheduleImplToJson(
  _$EmployeeScheduleImpl instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'date': instance.date.toIso8601String(),
  'dayName': instance.dayName,
  'scheduledHours': instance.scheduledHours,
  'workedHours': instance.workedHours,
  'appointmentCount': instance.appointmentCount,
  'totalRevenue': instance.totalRevenue,
  'isWorkDay': instance.isWorkDay,
  'notes': instance.notes,
};

_$AttendanceRecordImpl _$$AttendanceRecordImplFromJson(
  Map<String, dynamic> json,
) => _$AttendanceRecordImpl(
  employeeId: json['employeeId'] as String,
  date: DateTime.parse(json['date'] as String),
  status: json['status'] as String,
  checkInTime: json['checkInTime'] == null
      ? null
      : DateTime.parse(json['checkInTime'] as String),
  checkOutTime: json['checkOutTime'] == null
      ? null
      : DateTime.parse(json['checkOutTime'] as String),
  hoursWorked: (json['hoursWorked'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$AttendanceRecordImplToJson(
  _$AttendanceRecordImpl instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'date': instance.date.toIso8601String(),
  'status': instance.status,
  'checkInTime': instance.checkInTime?.toIso8601String(),
  'checkOutTime': instance.checkOutTime?.toIso8601String(),
  'hoursWorked': instance.hoursWorked,
  'notes': instance.notes,
};

_$EmployeeSkillImpl _$$EmployeeSkillImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeSkillImpl(
      skillId: json['skillId'] as String,
      skillName: json['skillName'] as String,
      category: json['category'] as String,
      proficiencyLevel: (json['proficiencyLevel'] as num).toInt(),
      acquiredDate: json['acquiredDate'] == null
          ? null
          : DateTime.parse(json['acquiredDate'] as String),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      certification: json['certification'] as String?,
    );

Map<String, dynamic> _$$EmployeeSkillImplToJson(_$EmployeeSkillImpl instance) =>
    <String, dynamic>{
      'skillId': instance.skillId,
      'skillName': instance.skillName,
      'category': instance.category,
      'proficiencyLevel': instance.proficiencyLevel,
      'acquiredDate': instance.acquiredDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'certification': instance.certification,
    };

_$EmployeeStatsImpl _$$EmployeeStatsImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeStatsImpl(
      totalEmployees: (json['totalEmployees'] as num).toInt(),
      activeEmployees: (json['activeEmployees'] as num).toInt(),
      onLeaveCount: (json['onLeaveCount'] as num).toInt(),
      newEmployeesThisMonth: (json['newEmployeesThisMonth'] as num).toInt(),
      averageSalonRating: (json['averageSalonRating'] as num).toDouble(),
      totalRevenueThisMonth: (json['totalRevenueThisMonth'] as num).toDouble(),
      averageRevenuePerEmployee: (json['averageRevenuePerEmployee'] as num)
          .toDouble(),
      totalAppointmentsThisMonth: (json['totalAppointmentsThisMonth'] as num)
          .toInt(),
    );

Map<String, dynamic> _$$EmployeeStatsImplToJson(_$EmployeeStatsImpl instance) =>
    <String, dynamic>{
      'totalEmployees': instance.totalEmployees,
      'activeEmployees': instance.activeEmployees,
      'onLeaveCount': instance.onLeaveCount,
      'newEmployeesThisMonth': instance.newEmployeesThisMonth,
      'averageSalonRating': instance.averageSalonRating,
      'totalRevenueThisMonth': instance.totalRevenueThisMonth,
      'averageRevenuePerEmployee': instance.averageRevenuePerEmployee,
      'totalAppointmentsThisMonth': instance.totalAppointmentsThisMonth,
    };
