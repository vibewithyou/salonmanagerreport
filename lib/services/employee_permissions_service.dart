import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salonmanager/models/employee_permission_model.dart';
import 'package:salonmanager/models/module_settings_model.dart';

class EmployeePermissionsService {
  final SupabaseClient _supabase;

  EmployeePermissionsService(this._supabase);

  Future<List<EmployeePermission>> getEmployeePermissions(
    String employeeId,
  ) async {
    try {
      final response = await _supabase
          .from('employee_permissions')
          .select()
          .eq('employee_id', employeeId)
          .order('module_type');

      return response.map((item) => EmployeePermission.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> upsertEmployeePermission({
    required String salonId,
    required String employeeId,
    required ModuleType moduleType,
    required List<ModulePermission> permissions,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _supabase.from('employee_permissions').upsert({
        'salon_id': salonId,
        'employee_id': employeeId,
        'module_type': moduleType.name,
        'permissions': permissions.map((p) => p.name).toList(),
        'updated_at': now,
        'created_at': now,
      }, onConflict: 'employee_id,module_type').select();

      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setEmployeePermissions({
    required String salonId,
    required String employeeId,
    required Map<ModuleType, List<ModulePermission>> permissionsByModule,
  }) async {
    try {
      await _supabase
          .from('employee_permissions')
          .delete()
          .eq('employee_id', employeeId);

      if (permissionsByModule.isEmpty) return true;

      final now = DateTime.now().toIso8601String();
      final rows = permissionsByModule.entries.map((entry) {
        return {
          'salon_id': salonId,
          'employee_id': employeeId,
          'module_type': entry.key.name,
          'permissions': entry.value.map((p) => p.name).toList(),
          'created_at': now,
          'updated_at': now,
        };
      }).toList();

      await _supabase.from('employee_permissions').insert(rows);
      return true;
    } catch (e) {
      return false;
    }
  }
}
