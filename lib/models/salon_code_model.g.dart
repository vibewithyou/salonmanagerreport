// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalonCodeImpl _$$SalonCodeImplFromJson(Map<String, dynamic> json) =>
    _$SalonCodeImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      code: json['code'] as String,
      isActive: json['isActive'] as bool,
      generatedAt: json['generatedAt'] == null
          ? null
          : DateTime.parse(json['generatedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      generatedBy: json['generatedBy'] as String?,
    );

Map<String, dynamic> _$$SalonCodeImplToJson(_$SalonCodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'code': instance.code,
      'isActive': instance.isActive,
      'generatedAt': instance.generatedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'generatedBy': instance.generatedBy,
    };

_$SalonCodeVerifyRequestImpl _$$SalonCodeVerifyRequestImplFromJson(
  Map<String, dynamic> json,
) => _$SalonCodeVerifyRequestImpl(
  salonId: json['salonId'] as String,
  code: json['code'] as String,
);

Map<String, dynamic> _$$SalonCodeVerifyRequestImplToJson(
  _$SalonCodeVerifyRequestImpl instance,
) => <String, dynamic>{'salonId': instance.salonId, 'code': instance.code};

_$SalonCodeVerifyResponseImpl _$$SalonCodeVerifyResponseImplFromJson(
  Map<String, dynamic> json,
) => _$SalonCodeVerifyResponseImpl(
  isValid: json['isValid'] as bool,
  salonId: json['salonId'] as String,
  salonName: json['salonName'] as String?,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$$SalonCodeVerifyResponseImplToJson(
  _$SalonCodeVerifyResponseImpl instance,
) => <String, dynamic>{
  'isValid': instance.isValid,
  'salonId': instance.salonId,
  'salonName': instance.salonName,
  'errorMessage': instance.errorMessage,
};

_$EmployeeTimeCodeImpl _$$EmployeeTimeCodeImplFromJson(
  Map<String, dynamic> json,
) => _$EmployeeTimeCodeImpl(
  id: json['id'] as String,
  employeeId: json['employeeId'] as String,
  code: json['code'] as String,
  isActive: json['isActive'] as bool,
  generatedAt: json['generatedAt'] == null
      ? null
      : DateTime.parse(json['generatedAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  generatedBy: json['generatedBy'] as String?,
);

Map<String, dynamic> _$$EmployeeTimeCodeImplToJson(
  _$EmployeeTimeCodeImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'employeeId': instance.employeeId,
  'code': instance.code,
  'isActive': instance.isActive,
  'generatedAt': instance.generatedAt?.toIso8601String(),
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'generatedBy': instance.generatedBy,
};

_$EmployeeTimeCodeVerifyRequestImpl
_$$EmployeeTimeCodeVerifyRequestImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeTimeCodeVerifyRequestImpl(code: json['code'] as String);

Map<String, dynamic> _$$EmployeeTimeCodeVerifyRequestImplToJson(
  _$EmployeeTimeCodeVerifyRequestImpl instance,
) => <String, dynamic>{'code': instance.code};

_$EmployeeCodeVerifyResponseImpl _$$EmployeeCodeVerifyResponseImplFromJson(
  Map<String, dynamic> json,
) => _$EmployeeCodeVerifyResponseImpl(
  isValid: json['isValid'] as bool,
  employeeId: json['employeeId'] as String?,
  employeeName: json['employeeName'] as String?,
  employeeEmail: json['employeeEmail'] as String?,
  salonId: json['salonId'] as String?,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$$EmployeeCodeVerifyResponseImplToJson(
  _$EmployeeCodeVerifyResponseImpl instance,
) => <String, dynamic>{
  'isValid': instance.isValid,
  'employeeId': instance.employeeId,
  'employeeName': instance.employeeName,
  'employeeEmail': instance.employeeEmail,
  'salonId': instance.salonId,
  'errorMessage': instance.errorMessage,
};
