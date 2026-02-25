import 'package:freezed_annotation/freezed_annotation.dart';

part 'salon_code_model.freezed.dart';
part 'salon_code_model.g.dart';

@freezed
class SalonCode with _$SalonCode {
  const factory SalonCode({
    required String id,
    required String salonId,
    required String code,
    required bool isActive,
    DateTime? generatedAt,
    DateTime? expiresAt,
    String? generatedBy,
  }) = _SalonCode;

  factory SalonCode.fromJson(Map<String, dynamic> json) =>
      _$SalonCodeFromJson(json);
}

@freezed
class SalonCodeVerifyRequest with _$SalonCodeVerifyRequest {
  const factory SalonCodeVerifyRequest({
    required String salonId,
    required String code,
  }) = _SalonCodeVerifyRequest;

  factory SalonCodeVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$SalonCodeVerifyRequestFromJson(json);
}

@freezed
class SalonCodeVerifyResponse with _$SalonCodeVerifyResponse {
  const factory SalonCodeVerifyResponse({
    required bool isValid,
    required String salonId,
    String? salonName,
    String? errorMessage,
  }) = _SalonCodeVerifyResponse;

  factory SalonCodeVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$SalonCodeVerifyResponseFromJson(json);
}

@freezed
class EmployeeTimeCode with _$EmployeeTimeCode {
  const factory EmployeeTimeCode({
    required String id,
    required String employeeId,
    required String code,
    required bool isActive,
    DateTime? generatedAt,
    DateTime? expiresAt,
    String? generatedBy,
  }) = _EmployeeTimeCode;

  factory EmployeeTimeCode.fromJson(Map<String, dynamic> json) =>
      _$EmployeeTimeCodeFromJson(json);
}

@freezed
class EmployeeTimeCodeVerifyRequest with _$EmployeeTimeCodeVerifyRequest {
  const factory EmployeeTimeCodeVerifyRequest({
    required String code,
  }) = _EmployeeTimeCodeVerifyRequest;

  factory EmployeeTimeCodeVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$EmployeeTimeCodeVerifyRequestFromJson(json);
}

@freezed
class EmployeeCodeVerifyResponse with _$EmployeeCodeVerifyResponse {
  const factory EmployeeCodeVerifyResponse({
    required bool isValid,
    String? employeeId,
    String? employeeName,
    String? employeeEmail,
    String? salonId,
    String? errorMessage,
  }) = _EmployeeCodeVerifyResponse;

  factory EmployeeCodeVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$EmployeeCodeVerifyResponseFromJson(json);
}
