import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salonmanager/models/module_settings_model.dart';

/// Service for managing module settings and feature flags
class ModuleSettingsService {
  final SupabaseClient _supabase;

  ModuleSettingsService(this._supabase);

  /// Get all module settings for a salon
  Future<List<ModuleSettings>> getModuleSettings(String salonId) async {
    try {
      final response = await _supabase
          .from('module_settings')
          .select()
          .eq('salon_id', salonId)
          .order('module_type');

      return response.map((e) => ModuleSettings.fromJson(e)).toList();
    } catch (e) {
      print('Error getting module settings: $e');
      return [];
    }
  }

  /// Get settings for a specific module
  Future<ModuleSettings?> getModuleSetting(
    String salonId,
    ModuleType moduleType,
  ) async {
    try {
      final response = await _supabase
          .from('module_settings')
          .select()
          .eq('salon_id', salonId)
          .eq('module_type', moduleType.name)
          .limit(1)
          .single();

      return ModuleSettings.fromJson(response);
    } catch (e) {
      print('Error getting module setting: $e');
      return null;
    }
  }

  /// Update module settings (enable/disable and permissions)
  Future<bool> updateModuleSetting({
    required String salonId,
    required ModuleType moduleType,
    required bool isEnabled,
    List<ModulePermission>? permissions,
    Map<String, dynamic>? configuration,
  }) async {
    try {
      final permissionStrings =
          permissions?.map((p) => p.name).toList() ?? ['view'];

      final now = DateTime.now();

      final response = await _supabase.from('module_settings').upsert({
        'salon_id': salonId,
        'module_type': moduleType.name,
        'is_enabled': isEnabled,
        'permissions': permissionStrings,
        'configuration': configuration,
        'enabled_at': isEnabled ? now.toIso8601String() : null,
        'disabled_at': !isEnabled ? now.toIso8601String() : null,
        'updated_at': now.toIso8601String(),
      }, onConflict: 'salon_id,module_type').select();

      return response.isNotEmpty;
    } catch (e) {
      print('Error updating module setting: $e');
      return false;
    }
  }

  /// Enable a module for a salon
  Future<bool> enableModule(
    String salonId,
    ModuleType moduleType, {
    List<ModulePermission>? permissions,
  }) async {
    return updateModuleSetting(
      salonId: salonId,
      moduleType: moduleType,
      isEnabled: true,
      permissions: permissions ?? [ModulePermission.view],
    );
  }

  /// Disable a module for a salon
  Future<bool> disableModule(String salonId, ModuleType moduleType) async {
    return updateModuleSetting(
      salonId: salonId,
      moduleType: moduleType,
      isEnabled: false,
    );
  }

  /// Get all enabled modules for a salon
  Future<List<ModuleSettings>> getEnabledModules(String salonId) async {
    try {
      final response = await _supabase
          .from('module_settings')
          .select()
          .eq('salon_id', salonId)
          .eq('is_enabled', true)
          .order('module_type');

      return response.map((e) => ModuleSettings.fromJson(e)).toList();
    } catch (e) {
      print('Error getting enabled modules: $e');
      return [];
    }
  }

  /// Get disabled modules for a salon
  Future<List<ModuleSettings>> getDisabledModules(String salonId) async {
    try {
      final response = await _supabase
          .from('module_settings')
          .select()
          .eq('salon_id', salonId)
          .eq('is_enabled', false)
          .order('module_type');

      return response.map((e) => ModuleSettings.fromJson(e)).toList();
    } catch (e) {
      print('Error getting disabled modules: $e');
      return [];
    }
  }

  /// Check if a module is enabled for a salon
  Future<bool> isModuleEnabled(String salonId, ModuleType moduleType) async {
    try {
      final response = await _supabase
          .from('module_settings')
          .select('is_enabled')
          .eq('salon_id', salonId)
          .eq('module_type', moduleType.name)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        return response['is_enabled'] ?? false;
      }
      // Default to true if not configured
      return true;
    } catch (e) {
      print('Error checking if module is enabled: $e');
      return false;
    }
  }

  /// Update module configuration
  Future<bool> updateModuleConfiguration(
    String salonId,
    ModuleType moduleType,
    Map<String, dynamic> configuration,
  ) async {
    try {
      final response = await _supabase
          .from('module_settings')
          .update({
            'configuration': configuration,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('salon_id', salonId)
          .eq('module_type', moduleType.name)
          .select();

      return response.isNotEmpty;
    } catch (e) {
      print('Error updating module configuration: $e');
      return false;
    }
  }

  /// Update module permissions
  Future<bool> updateModulePermissions(
    String salonId,
    ModuleType moduleType,
    List<ModulePermission> permissions,
  ) async {
    try {
      final permissionStrings = permissions.map((p) => p.name).toList();

      final response = await _supabase
          .from('module_settings')
          .update({
            'permissions': permissionStrings,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('salon_id', salonId)
          .eq('module_type', moduleType.name)
          .select();

      return response.isNotEmpty;
    } catch (e) {
      print('Error updating module permissions: $e');
      return false;
    }
  }

  /// Get module statistics (enabled vs disabled count)
  Future<Map<String, int>> getModuleStatistics(String salonId) async {
    try {
      final all = await getModuleSettings(salonId); // Uses cache if available
      final enabled = all.where((m) => m.isEnabled).length;
      final disabled = all.where((m) => !m.isEnabled).length;

      return {'total': all.length, 'enabled': enabled, 'disabled': disabled};
    } catch (e) {
      print('Error getting module statistics: $e');
      return {};
    }
  }
}
