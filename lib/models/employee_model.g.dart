// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeImpl _$$EmployeeImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      specialties: (json['specialties'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      commission: (json['commission'] as num?)?.toDouble(),
      ssn: json['ssn'] as String?,
      hireDate: json['hireDate'] == null
          ? null
          : DateTime.parse(json['hireDate'] as String),
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      address: json['address'] as String?,
      isActive: json['isActive'] as bool?,
      yearsOfExperience: (json['yearsOfExperience'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$EmployeeImplToJson(_$EmployeeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
      'specialties': instance.specialties,
      'commission': instance.commission,
      'ssn': instance.ssn,
      'hireDate': instance.hireDate?.toIso8601String(),
      'birthDate': instance.birthDate?.toIso8601String(),
      'address': instance.address,
      'isActive': instance.isActive,
      'yearsOfExperience': instance.yearsOfExperience,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$EmployeeScheduleImpl _$$EmployeeScheduleImplFromJson(
  Map<String, dynamic> json,
) => _$EmployeeScheduleImpl(
  id: json['id'] as String,
  employeeId: json['employeeId'] as String,
  salonId: json['salonId'] as String,
  dayOfWeek: json['dayOfWeek'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  notes: json['notes'] as String?,
  isOffDay: json['isOffDay'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$EmployeeScheduleImplToJson(
  _$EmployeeScheduleImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'employeeId': instance.employeeId,
  'salonId': instance.salonId,
  'dayOfWeek': instance.dayOfWeek,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'notes': instance.notes,
  'isOffDay': instance.isOffDay,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_$EmployeeSummaryImpl _$$EmployeeSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$EmployeeSummaryImpl(
  totalEmployees: (json['totalEmployees'] as num).toInt(),
  stylists: (json['stylists'] as num).toInt(),
  managers: (json['managers'] as num).toInt(),
  receptionists: (json['receptionists'] as num).toInt(),
  activeEmployees: (json['activeEmployees'] as num).toInt(),
);

Map<String, dynamic> _$$EmployeeSummaryImplToJson(
  _$EmployeeSummaryImpl instance,
) => <String, dynamic>{
  'totalEmployees': instance.totalEmployees,
  'stylists': instance.stylists,
  'managers': instance.managers,
  'receptionists': instance.receptionists,
  'activeEmployees': instance.activeEmployees,
};
