import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salonmanager/models/salon_code_model.dart';

/// Service for managing salon codes and employee time codes
/// Connects to Supabase RPC functions
class SalonCodeService {
  final SupabaseClient _supabase;

  SalonCodeService(this._supabase);

  /// Verify if a salon code is valid
  Future<SalonCodeVerifyResponse> verifySalonCode({
    required String salonId,
    required String code,
  }) async {
    try {
      final response = await _supabase.rpc(
        'verify_salon_code',
        params: {'p_salon_id': salonId, 'p_code': code},
      );

      if (response != null) {
        final isValid = response['is_valid'] as bool? ?? false;
        return SalonCodeVerifyResponse(
          isValid: isValid,
          salonId: response['salon_id'] as String? ?? salonId,
          salonName: response['salon_name'] as String?,
          errorMessage: response['message'] as String?,
        );
      }

      return SalonCodeVerifyResponse(
        isValid: false,
        salonId: salonId,
        errorMessage: 'Invalid response from server',
      );
    } catch (e) {
      return SalonCodeVerifyResponse(
        isValid: false,
        salonId: salonId,
        errorMessage: 'Error verifying code: $e',
      );
    }
  }

  /// Generate a new salon code
  Future<Map<String, dynamic>> generateSalonCode(String salonId) async {
    try {
      final response = await _supabase.rpc(
        'generate_salon_code',
        params: {'p_salon_id': salonId},
      );

      return {
        'success': response['success'] ?? false,
        'code': response['code'],
        'message': response['message'],
      };
    } catch (e) {
      return {'success': false, 'message': 'Error generating code: $e'};
    }
  }

  /// Reset salon code to a new custom code
  Future<Map<String, dynamic>> resetSalonCode({
    required String salonId,
    required String newCode,
  }) async {
    try {
      final response = await _supabase.rpc(
        'reset_salon_code',
        params: {'p_salon_id': salonId, 'p_new_code': newCode},
      );

      return {
        'success': response['success'] ?? false,
        'code': response['code'],
        'message': response['message'],
      };
    } catch (e) {
      return {'success': false, 'message': 'Error resetting code: $e'};
    }
  }

  /// Generate a new employee time code
  Future<Map<String, dynamic>> generateEmployeeTimeCode(
    String employeeId,
  ) async {
    try {
      final response = await _supabase.rpc(
        'generate_employee_time_code',
        params: {'p_employee_id': employeeId},
      );

      return {
        'success': response['success'] ?? false,
        'code': response['code'],
        'message': response['message'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error generating employee code: $e',
      };
    }
  }

  /// Verify if an employee code is valid
  Future<EmployeeCodeVerifyResponse> verifyEmployeeCode(String code) async {
    try {
      final response = await _supabase.rpc(
        'verify_employee_code',
        params: {'p_code': code},
      );

      if (response != null) {
        final isValid = response['is_valid'] as bool? ?? false;
        return EmployeeCodeVerifyResponse(
          isValid: isValid,
          employeeId: response['employee_id'] as String?,
          employeeName: response['employee_name'] as String?,
          employeeEmail: response['employee_email'] as String?,
          salonId: response['salon_id'] as String?,
          errorMessage: response['message'] as String?,
        );
      }

      return EmployeeCodeVerifyResponse(
        isValid: false,
        errorMessage: 'Invalid response from server',
      );
    } catch (e) {
      return EmployeeCodeVerifyResponse(
        isValid: false,
        errorMessage: 'Error verifying code: $e',
      );
    }
  }

  /// Get current salon code from database
  Future<SalonCode?> getCurrentSalonCode(String salonId) async {
    try {
      final response = await _supabase
          .from('salon_codes')
          .select()
          .eq('salon_id', salonId)
          .eq('is_active', true)
          .limit(1)
          .single();

      return SalonCode.fromJson(response);
    } catch (e) {
      print('Error getting salon code: $e');
      return null;
    }
  }

  /// Get all employee time codes for a salon
  Future<List<EmployeeTimeCode>> getEmployeeTimeCodes(String salonId) async {
    try {
      final response = await _supabase
          .from('employee_time_codes')
          .select()
          .eq('salon_id', salonId)
          .eq('is_active', true)
          .order('generated_at', ascending: false);

      return response.map((e) => EmployeeTimeCode.fromJson(e)).toList();
    } catch (e) {
      print('Error getting employee time codes: $e');
      return [];
    }
  }

  /// Get employee time code for specific employee
  Future<EmployeeTimeCode?> getEmployeeTimeCode(String employeeId) async {
    try {
      final response = await _supabase
          .from('employee_time_codes')
          .select()
          .eq('employee_id', employeeId)
          .eq('is_active', true)
          .limit(1)
          .single();

      return EmployeeTimeCode.fromJson(response);
    } catch (e) {
      print('Error getting employee time code: $e');
      return null;
    }
  }
}
