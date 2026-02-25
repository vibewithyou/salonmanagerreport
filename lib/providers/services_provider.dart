import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/salon_code_service.dart';
import '../../services/activity_log_service.dart';
import '../../services/module_settings_service.dart';
import '../../services/salon_settings_service.dart';
import '../../services/dashboard_service.dart';
import '../../services/employee_dashboard_service.dart';

/// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Salon Code Service Provider
final salonCodeServiceProvider = Provider<SalonCodeService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SalonCodeService(client);
});

/// Activity Log Service Provider
final activityLogServiceProvider = Provider<ActivityLogService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ActivityLogService(client);
});

/// Module Settings Service Provider
final moduleSettingsServiceProvider = Provider<ModuleSettingsService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ModuleSettingsService(client);
});

/// Salon Settings Service Provider
final salonSettingsServiceProvider = Provider<SalonSettingsService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SalonSettingsService(client);
});

/// Dashboard Service Provider
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DashboardService(client);
});

/// Employee Dashboard Service Provider
final employeeDashboardServiceProvider = Provider<EmployeeDashboardService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return EmployeeDashboardService(client);
});
