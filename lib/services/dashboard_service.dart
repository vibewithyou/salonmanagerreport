import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salonmanager/models/dashboard_config_model.dart';
import 'package:salonmanager/models/employee_time_tracking_model.dart';
import 'package:salonmanager/models/salon_settings_model.dart';
import 'package:salonmanager/models/employee_model.dart';
import 'package:salonmanager/models/module_settings_model.dart';

class DashboardService {
  final SupabaseClient _supabase;

  DashboardService(this._supabase);

  // ==================== Dashboard Config ====================
  Future<DashboardConfig?> getDashboardConfig(String salonId) async {
    try {
      final response = await _supabase
          .from('salon_dashboard_config')
          .select()
          .eq('salon_id', salonId)
          .single();

      return DashboardConfig.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateDashboardConfig(
    String salonId,
    Map<String, dynamic> config,
  ) async {
    try {
      await _supabase
          .from('salon_dashboard_config')
          .update(config)
          .eq('salon_id', salonId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== Salon Code Management ====================
  Future<String?> getSalonCode(String salonId) async {
    try {
      final response = await _supabase.functions.invoke(
        'get-salon-code',
        body: {'salon_id': salonId},
      );

      if (response.data != null && response.data is Map) {
        return response.data['code'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> updateSalonCode(
    String salonId,
    String newCode, {
    bool regenerate = false,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'set-salon-code',
        body: {'salon_id': salonId, 'code': newCode, 'regenerate': regenerate},
      );

      if (response.data != null && response.data is Map) {
        return response.data['code'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> verifySalonCode(String salonId, String code) async {
    try {
      final response = await _supabase.functions.invoke(
        'verify-salon-code',
        body: {'salon_id': salonId, 'code': code},
      );

      if (response.data != null && response.data is Map) {
        return response.data['is_valid'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ==================== Employee Management ====================
  Future<List<Employee>> getEmployees(String salonId) async {
    try {
      final response = await _supabase
          .from('employees')
          .select()
          .eq('salon_id', salonId)
          .eq('is_active', true);

      return (response as List)
          .map((e) => Employee.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<Employee?> createEmployee(
    String salonId,
    String firstName,
    String lastName,
    String email,
    String phone,
    String role,
  ) async {
    try {
      final response = await _supabase
          .from('employees')
          .insert({
            'salon_id': salonId,
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'phone': phone,
            'role': role,
            'is_active': true,
            'hire_date': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return Employee.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateEmployee(
    String employeeId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _supabase.from('employees').update(data).eq('id', employeeId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteEmployee(String employeeId) async {
    try {
      await _supabase
          .from('employees')
          .update({'is_active': false})
          .eq('id', employeeId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== Employee Time Codes ====================
  Future<String?> generateEmployeeTimeCode(String employeeId) async {
    try {
      final response = await _supabase.functions.invoke(
        'set-employee-code',
        body: {'employee_id': employeeId, 'regenerate': true},
      );

      if (response.data != null && response.data is Map) {
        return response.data['code'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getEmployeeTimeCode(String employeeId) async {
    try {
      final response = await _supabase.functions.invoke(
        'get-employee-code',
        body: {'employee_id': employeeId},
      );

      if (response.data != null && response.data is Map) {
        return response.data['code'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== Time Tracking ====================
  Future<Map<String, dynamic>?> verifyEmployeeTimeCode(String timeCode) async {
    try {
      final response = await _supabase.rpc(
        'verify_employee_time_code',
        params: {'p_time_code': timeCode},
      );

      if (response is List && response.isNotEmpty) {
        return Map<String, dynamic>.from(response.first as Map);
      }

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> createTimeEntry(
    String salonId,
    String employeeId,
    String entryType,
    String? notes,
  ) async {
    try {
      final response = await _supabase.rpc(
        'create_dashboard_time_entry',
        params: {
          'p_salon_id': salonId,
          'p_employee_id': employeeId,
          'p_entry_type': entryType,
          'p_notes': notes,
        },
      );

      if (response is List && response.isNotEmpty) {
        return Map<String, dynamic>.from(response.first as Map);
      }

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isAdminEmployee(String employeeId) async {
    try {
      final response = await _supabase
          .from('employees')
          .select('position')
          .eq('id', employeeId)
          .maybeSingle();

      if (response == null) return false;

      final position = (response['position'] as String? ?? '').toLowerCase();
      return position.contains('inhaber') ||
          position.contains('owner') ||
          position.contains('admin') ||
          position.contains('manager') ||
          position.contains('leitung');
    } catch (e) {
      return false;
    }
  }

  Future<bool> logDashboardActivity({
    required String salonId,
    String? userId,
    required String action,
    Map<String, dynamic>? details,
  }) async {
    try {
      await _supabase.from('dashboard_activity_log').insert({
        'salon_id': salonId,
        'user_id': userId,
        'action': action,
        'details': details,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<TimeEntry>> getDailyWorkload(String salonId, String date) async {
    try {
      final response = await _supabase.rpc(
        'get_daily_employee_workload',
        params: {'p_salon_id': salonId, 'p_date': date},
      );

      return (response as List)
          .map((e) => TimeEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>?> getActiveEmployeesToday(String salonId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T').first;
      final response = await _supabase.rpc(
        'get_daily_employee_workload',
        params: {'p_salon_id': salonId, 'p_date': today},
      );

      if (response is List) {
        return response
            .map((entry) => Map<String, dynamic>.from(entry as Map))
            .toList(growable: false);
      }

      return const <Map<String, dynamic>>[];
    } catch (e) {
      return null;
    }
  }

  Future<List<TimeEntry>> getWeeklyWorkload(
    String salonId,
    String startDate,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_employee_workload_week',
        params: {'p_salon_id': salonId, 'p_start_date': startDate},
      );

      return (response as List)
          .map((e) => TimeEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateTimeEntry(
    String entryId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _supabase
          .from('dashboard_time_entries')
          .update(data)
          .eq('id', entryId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTimeEntry(String entryId) async {
    try {
      await _supabase.from('dashboard_time_entries').delete().eq('id', entryId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== Salon Settings ====================
  Future<SalonSettings?> getSalonSettings(String salonId) async {
    try {
      final response = await _supabase
          .from('salon_settings')
          .select()
          .eq('salon_id', salonId)
          .single();

      return SalonSettings.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateSalonSettings(
    String salonId,
    Map<String, dynamic> settings,
  ) async {
    try {
      await _supabase
          .from('salon_settings')
          .update(settings)
          .eq('salon_id', salonId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== Activity Log ====================
  Future<List<Map<String, dynamic>>> getActivityLog({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('activity_logs')
          .select()
          .order('timestamp', ascending: false)
          .limit(limit);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<bool> logActivity(
    String salonId,
    String userId,
    String action,
    String? description,
    Map<String, dynamic>? metadata,
  ) async {
    try {
      await _supabase.from('activity_logs').insert({
        'salon_id': salonId,
        'user_id': userId,
        'action': action,
        'description': description,
        'metadata': metadata,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== Module Settings ====================
  Future<List<ModuleSettings>> getModuleSettings(String salonId) async {
    try {
      final response = await _supabase
          .from('module_settings')
          .select()
          .eq('salon_id', salonId);

      return (response as List)
          .map((e) => ModuleSettings.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateModuleSettings(
    String salonId,
    ModuleType moduleType,
    bool isEnabled,
    List<String> permissions,
  ) async {
    try {
      await _supabase.from('module_settings').upsert({
        'salon_id': salonId,
        'module_type': moduleType.toString().split('.').last,
        'is_enabled': isEnabled,
        'permissions': permissions,
        'enabled_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== Module Management ====================
  /// Get all available modules with configuration
  Future<List<DashboardModule>> getAllModules(String salonId) async {
    try {
      // Get enabled modules from DB
      final enabledModules = await getModuleSettings(salonId);

      // Map to DashboardModule with default values
      final modules = <DashboardModule>[];

      for (final moduleType in ModuleType.values) {
        ModuleSettings? enabled;
        for (final module in enabledModules) {
          if (module.moduleType == moduleType) {
            enabled = module;
            break;
          }
        }

        modules.add(
          DashboardModule(
            type: moduleType,
            label: _getModuleLabel(moduleType),
            icon: _getModuleIcon(moduleType),
            description: _getModuleDescription(moduleType),
            isEnabled: enabled?.isEnabled ?? true,
            permissions: enabled?.permissions ?? [],
            isPremium: _isModulePremium(moduleType),
            isRequired: _isModuleRequired(moduleType),
          ),
        );
      }

      return modules;
    } catch (e) {
      return _getDefaultModules();
    }
  }

  /// Get default module configuration
  List<DashboardModule> _getDefaultModules() {
    return [
      DashboardModule(
        type: ModuleType.timeTracking,
        label: 'Zeiterfassung',
        icon: '⏱️',
        description: 'Arbeitszeiterfassung für Mitarbeiter',
        isEnabled: true,
        permissions: [ModulePermission.view, ModulePermission.create],
        isPremium: false,
        isRequired: true,
      ),
      DashboardModule(
        type: ModuleType.appointments,
        label: 'Termine',
        icon: '📅',
        description: 'Terminverwaltung und Buchungen',
        isEnabled: true,
        permissions: [
          ModulePermission.view,
          ModulePermission.create,
          ModulePermission.edit,
        ],
        isPremium: false,
        isRequired: true,
      ),
      DashboardModule(
        type: ModuleType.qrCheckin,
        label: 'QR Check-in',
        icon: '🔷',
        description: 'QR-Code basiertes Check-in System',
        isEnabled: true,
        permissions: [ModulePermission.view, ModulePermission.create],
        isPremium: false,
        isRequired: false,
      ),
      DashboardModule(
        type: ModuleType.leaveRequests,
        label: 'Urlaubsanträge',
        icon: '🏖️',
        description: 'Verwaltung von Urlaubsanträgen',
        isEnabled: true,
        permissions: [ModulePermission.view, ModulePermission.create],
        isPremium: false,
        isRequired: false,
      ),
      DashboardModule(
        type: ModuleType.shifts,
        label: 'Schichten',
        icon: '⏳',
        description: 'Schichtverwaltung für Mitarbeiter',
        isEnabled: true,
        permissions: [
          ModulePermission.view,
          ModulePermission.create,
          ModulePermission.edit,
        ],
        isPremium: false,
        isRequired: false,
      ),
      DashboardModule(
        type: ModuleType.pos,
        label: 'POS-System',
        icon: '💳',
        description: 'Kassensystem und Verkauf',
        isEnabled: false,
        permissions: [],
        isPremium: true,
        isRequired: false,
      ),
      DashboardModule(
        type: ModuleType.inventory,
        label: 'Lager',
        icon: '📦',
        description: 'Lagerverwaltung',
        isEnabled: false,
        permissions: [],
        isPremium: true,
        isRequired: false,
      ),
      DashboardModule(
        type: ModuleType.gallery,
        label: 'Galerie',
        icon: '📸',
        description: 'Bildergalerie und Portfolio',
        isEnabled: true,
        permissions: [
          ModulePermission.view,
          ModulePermission.create,
          ModulePermission.delete,
        ],
        isPremium: false,
        isRequired: false,
      ),
      DashboardModule(
        type: ModuleType.chat,
        label: 'Chat',
        icon: '💬',
        description: 'Chat und Nachrichtensystem',
        isEnabled: true,
        permissions: [ModulePermission.view, ModulePermission.create],
        isPremium: false,
        isRequired: false,
      ),
      DashboardModule(
        type: ModuleType.reports,
        label: 'Berichte',
        icon: '📊',
        description: 'Analysen und Berichte',
        isEnabled: true,
        permissions: [ModulePermission.view, ModulePermission.export],
        isPremium: true,
        isRequired: false,
      ),
      DashboardModule(
        type: ModuleType.loyaltyProgram,
        label: 'Loyalitätsprogramm',
        icon: '⭐',
        description: 'Kundentreueprogramm',
        isEnabled: false,
        permissions: [],
        isPremium: true,
        isRequired: false,
      ),
    ];
  }

  String _getModuleLabel(ModuleType type) {
    switch (type) {
      case ModuleType.timeTracking:
        return 'Zeiterfassung';
      case ModuleType.appointments:
        return 'Termine';
      case ModuleType.qrCheckin:
        return 'QR Check-in';
      case ModuleType.leaveRequests:
        return 'Urlaubsanträge';
      case ModuleType.shifts:
        return 'Schichten';
      case ModuleType.pos:
        return 'POS-System';
      case ModuleType.inventory:
        return 'Lager';
      case ModuleType.gallery:
        return 'Galerie';
      case ModuleType.chat:
        return 'Chat';
      case ModuleType.messaging:
        return 'Nachrichten';
      case ModuleType.reports:
        return 'Berichte';
      case ModuleType.coupons:
        return 'Coupons';
      case ModuleType.calendar:
        return 'Kalender';
      case ModuleType.loyaltyProgram:
        return 'Loyalitätsprogramm';
    }
  }

  String _getModuleIcon(ModuleType type) {
    switch (type) {
      case ModuleType.timeTracking:
        return '⏱️';
      case ModuleType.appointments:
        return '📅';
      case ModuleType.qrCheckin:
        return '🔷';
      case ModuleType.leaveRequests:
        return '🏖️';
      case ModuleType.shifts:
        return '⏳';
      case ModuleType.pos:
        return '💳';
      case ModuleType.inventory:
        return '📦';
      case ModuleType.gallery:
        return '📸';
      case ModuleType.chat:
        return '💬';
      case ModuleType.messaging:
        return '💌';
      case ModuleType.reports:
        return '📊';
      case ModuleType.coupons:
        return '🎟️';
      case ModuleType.calendar:
        return '📆';
      case ModuleType.loyaltyProgram:
        return '⭐';
    }
  }

  String _getModuleDescription(ModuleType type) {
    switch (type) {
      case ModuleType.timeTracking:
        return 'Arbeitszeiterfassung für Mitarbeiter';
      case ModuleType.appointments:
        return 'Terminverwaltung und Buchungen';
      case ModuleType.qrCheckin:
        return 'QR-Code basiertes Check-in System';
      case ModuleType.leaveRequests:
        return 'Verwaltung von Urlaubsanträgen';
      case ModuleType.shifts:
        return 'Schichtverwaltung für Mitarbeiter';
      case ModuleType.pos:
        return 'Kassensystem und Verkauf';
      case ModuleType.inventory:
        return 'Lagerverwaltung';
      case ModuleType.gallery:
        return 'Bildergalerie und Portfolio';
      case ModuleType.chat:
        return 'Chat und Messagingsystem';
      case ModuleType.messaging:
        return 'E-Mail und SMS Integration';
      case ModuleType.reports:
        return 'Analysen und Geschäftsberichte';
      case ModuleType.coupons:
        return 'Gutschein und Rabattverwaltung';
      case ModuleType.calendar:
        return 'Erweiterte Kalenderansicht';
      case ModuleType.loyaltyProgram:
        return 'Kundentreueprogramm und Punkte';
    }
  }

  bool _isModulePremium(ModuleType type) {
    return [
      ModuleType.pos,
      ModuleType.inventory,
      ModuleType.reports,
      ModuleType.loyaltyProgram,
    ].contains(type);
  }

  bool _isModuleRequired(ModuleType type) {
    return [ModuleType.timeTracking, ModuleType.appointments].contains(type);
  }

  // ==================== Dashboard Statistics ====================
  /// Get count of active employees for a salon
  Future<int> getEmployeeCount(String salonId) async {
    try {
      final response = await _supabase
          .from('employees')
          .select('id')
          .eq('salon_id', salonId)
          .eq('is_active', true);
      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Get count of appointments (bookings) for a salon
  Future<int> getAppointmentCount(String salonId) async {
    try {
      final response = await _supabase
          .from('appointments')
          .select('id')
          .eq('salon_id', salonId);
      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Get count of customers (unique customer profiles) for a salon
  Future<int> getCustomerCount(String salonId) async {
    try {
      final response = await _supabase
          .from('customer_profiles')
          .select('id')
          .eq('salon_id', salonId);
      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Get total revenue (sum of completed transactions) for a salon
  Future<double> getTotalRevenue(String salonId) async {
    try {
      final response = await _supabase
          .from('transactions')
          .select('total_amount')
          .eq('salon_id', salonId)
          .eq('payment_status', 'completed');

      double total = 0.0;
      for (final transaction in response as List) {
        final amount = transaction['total_amount'];
        if (amount != null) {
          total += (amount is int ? amount.toDouble() : amount as double);
        }
      }
      return total;
    } catch (e) {
      return 0.0;
    }
  }

  /// Get today's revenue (sum of transactions completed today)
  Future<double> getTodayRevenue(String salonId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final response = await _supabase
          .from('transactions')
          .select('total_amount')
          .eq('salon_id', salonId)
          .eq('payment_status', 'completed')
          .gte('created_at', startOfDay.toIso8601String())
          .lte('created_at', endOfDay.toIso8601String());

      double total = 0.0;
      for (final transaction in response as List) {
        final amount = transaction['total_amount'];
        if (amount != null) {
          total += (amount is int ? amount.toDouble() : amount as double);
        }
      }
      return total;
    } catch (e) {
      return 0.0;
    }
  }

  /// Get today's appointments count
  Future<int> getTodayAppointmentCount(String salonId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final response = await _supabase
          .from('appointments')
          .select('id')
          .eq('salon_id', salonId)
          .gte('start_time', startOfDay.toIso8601String())
          .lte('start_time', endOfDay.toIso8601String());

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Get today's new customers count
  Future<int> getTodayNewCustomerCount(String salonId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final response = await _supabase
          .from('customer_profiles')
          .select('id')
          .eq('salon_id', salonId)
          .gte('created_at', startOfDay.toIso8601String())
          .lte('created_at', endOfDay.toIso8601String());

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  Future<Map<String, double>> getTodayOverviewTrendStats(String salonId) async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final yesterday = now.subtract(const Duration(days: 1));
      final yesterdayStart = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
      );
      final yesterdayEnd = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
        23,
        59,
        59,
      );

      final todayAppointmentsFuture = _supabase
          .from('appointments')
          .select('id')
          .eq('salon_id', salonId)
          .gte('start_time', todayStart.toIso8601String())
          .lte('start_time', todayEnd.toIso8601String());

      final yesterdayAppointmentsFuture = _supabase
          .from('appointments')
          .select('id')
          .eq('salon_id', salonId)
          .gte('start_time', yesterdayStart.toIso8601String())
          .lte('start_time', yesterdayEnd.toIso8601String());

      final todayRevenueFuture = _supabase
          .from('transactions')
          .select('total_amount')
          .eq('salon_id', salonId)
          .eq('payment_status', 'completed')
          .gte('created_at', todayStart.toIso8601String())
          .lte('created_at', todayEnd.toIso8601String());

      final yesterdayRevenueFuture = _supabase
          .from('transactions')
          .select('total_amount')
          .eq('salon_id', salonId)
          .eq('payment_status', 'completed')
          .gte('created_at', yesterdayStart.toIso8601String())
          .lte('created_at', yesterdayEnd.toIso8601String());

      final todayCustomersFuture = _supabase
          .from('customer_profiles')
          .select('id')
          .eq('salon_id', salonId)
          .gte('created_at', todayStart.toIso8601String())
          .lte('created_at', todayEnd.toIso8601String());

      final yesterdayCustomersFuture = _supabase
          .from('customer_profiles')
          .select('id')
          .eq('salon_id', salonId)
          .gte('created_at', yesterdayStart.toIso8601String())
          .lte('created_at', yesterdayEnd.toIso8601String());

      final results = await Future.wait([
        todayAppointmentsFuture,
        yesterdayAppointmentsFuture,
        todayRevenueFuture,
        yesterdayRevenueFuture,
        todayCustomersFuture,
        yesterdayCustomersFuture,
      ]);

      final todayAppointments = (results[0] as List).length.toDouble();
      final yesterdayAppointments = (results[1] as List).length.toDouble();
      final todayRevenueRows = (results[2] as List)
          .cast<Map<String, dynamic>>();
      final yesterdayRevenueRows = (results[3] as List)
          .cast<Map<String, dynamic>>();
      final todayCustomers = (results[4] as List).length.toDouble();
      final yesterdayCustomers = (results[5] as List).length.toDouble();

      double todayRevenue = 0.0;
      for (final row in todayRevenueRows) {
        final amount = row['total_amount'];
        if (amount is num) {
          todayRevenue += amount.toDouble();
        } else if (amount is String) {
          todayRevenue += double.tryParse(amount) ?? 0.0;
        }
      }

      double yesterdayRevenue = 0.0;
      for (final row in yesterdayRevenueRows) {
        final amount = row['total_amount'];
        if (amount is num) {
          yesterdayRevenue += amount.toDouble();
        } else if (amount is String) {
          yesterdayRevenue += double.tryParse(amount) ?? 0.0;
        }
      }

      return {
        'todayAppointmentsChangePct': _calculateChangePercent(
          todayAppointments,
          yesterdayAppointments,
        ),
        'todayRevenueChangePct': _calculateChangePercent(
          todayRevenue,
          yesterdayRevenue,
        ),
        'todayNewCustomersChangePct': _calculateChangePercent(
          todayCustomers,
          yesterdayCustomers,
        ),
      };
    } catch (_) {
      return {
        'todayAppointmentsChangePct': 0.0,
        'todayRevenueChangePct': 0.0,
        'todayNewCustomersChangePct': 0.0,
      };
    }
  }

  Future<Map<String, double>> getMonthOverviewTrendStats(String salonId) async {
    try {
      final now = DateTime.now();
      final currentMonthStart = DateTime(now.year, now.month, 1);
      final currentMonthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      final previousMonthDate = DateTime(now.year, now.month - 1, 1);
      final previousMonthStart = DateTime(
        previousMonthDate.year,
        previousMonthDate.month,
        1,
      );
      final previousMonthEnd = DateTime(
        previousMonthDate.year,
        previousMonthDate.month + 1,
        0,
        23,
        59,
        59,
      );

      final currentStats = await _getOverviewStatsForPeriod(
        salonId,
        currentMonthStart,
        currentMonthEnd,
      );
      final previousStats = await _getOverviewStatsForPeriod(
        salonId,
        previousMonthStart,
        previousMonthEnd,
      );

      return {
        'monthRevenueChangePct': _calculateChangePercent(
          (currentStats['totalRevenue'] as num).toDouble(),
          (previousStats['totalRevenue'] as num).toDouble(),
        ),
        'monthAppointmentsChangePct': _calculateChangePercent(
          (currentStats['totalAppointments'] as num).toDouble(),
          (previousStats['totalAppointments'] as num).toDouble(),
        ),
        'monthAverageBookingValueChangePct': _calculateChangePercent(
          (currentStats['averageBookingValue'] as num).toDouble(),
          (previousStats['averageBookingValue'] as num).toDouble(),
        ),
        'monthCompletionRateChangePct': _calculateChangePercent(
          (currentStats['completionRate'] as num).toDouble(),
          (previousStats['completionRate'] as num).toDouble(),
        ),
      };
    } catch (_) {
      return {
        'monthRevenueChangePct': 0.0,
        'monthAppointmentsChangePct': 0.0,
        'monthAverageBookingValueChangePct': 0.0,
        'monthCompletionRateChangePct': 0.0,
      };
    }
  }

  Future<Map<String, dynamic>> getCurrentMonthOverviewStats(
    String salonId,
  ) async {
    try {
      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      return _getOverviewStatsForPeriod(salonId, monthStart, monthEnd);
    } catch (_) {
      return {
        'totalRevenue': 0.0,
        'totalAppointments': 0,
        'completedAppointments': 0,
        'cancelledAppointments': 0,
        'averageBookingValue': 0.0,
        'completionRate': 0.0,
      };
    }
  }

  Future<Map<String, dynamic>> _getOverviewStatsForPeriod(
    String salonId,
    DateTime periodStart,
    DateTime periodEnd,
  ) async {
    try {
      final response = await _supabase
          .from('appointments')
          .select('status, price')
          .eq('salon_id', salonId)
          .gte('start_time', periodStart.toIso8601String())
          .lte('start_time', periodEnd.toIso8601String());

      final rows = (response as List).cast<Map<String, dynamic>>();
      final totalAppointments = rows.length;
      final completedAppointments = rows
          .where((row) => row['status'] == 'completed')
          .length;
      final cancelledAppointments = rows
          .where((row) => row['status'] == 'cancelled')
          .length;

      double totalRevenue = 0.0;
      for (final row in rows.where((row) => row['status'] == 'completed')) {
        final value = row['price'];
        if (value is int) {
          totalRevenue += value.toDouble();
        } else if (value is double) {
          totalRevenue += value;
        } else if (value is String) {
          totalRevenue += double.tryParse(value) ?? 0.0;
        }
      }

      final averageBookingValue = completedAppointments == 0
          ? 0.0
          : totalRevenue / completedAppointments;

      final completionRate = totalAppointments == 0
          ? 0.0
          : (completedAppointments / totalAppointments) * 100;

      return {
        'totalRevenue': totalRevenue,
        'totalAppointments': totalAppointments,
        'completedAppointments': completedAppointments,
        'cancelledAppointments': cancelledAppointments,
        'averageBookingValue': averageBookingValue,
        'completionRate': completionRate,
      };
    } catch (_) {
      return {
        'totalRevenue': 0.0,
        'totalAppointments': 0,
        'completedAppointments': 0,
        'cancelledAppointments': 0,
        'averageBookingValue': 0.0,
        'completionRate': 0.0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getDailyRevenueSeries(
    String salonId, {
    int days = 14,
  }) async {
    try {
      final now = DateTime.now();
      final startDate = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: days - 1));

      final response = await _supabase
          .from('appointments')
          .select('start_time, status, price')
          .eq('salon_id', salonId)
          .gte('start_time', startDate.toIso8601String())
          .lte('start_time', now.toIso8601String())
          .order('start_time');

      final rows = (response as List).cast<Map<String, dynamic>>();
      final byDay = <String, Map<String, dynamic>>{};

      for (var i = 0; i < days; i++) {
        final date = startDate.add(Duration(days: i));
        final key = _toDayKey(date);
        byDay[key] = {
          'label': '${date.day}',
          'revenue': 0.0,
          'appointments': 0,
        };
      }

      for (final row in rows) {
        final startTimeRaw = row['start_time'];
        if (startTimeRaw == null) continue;
        final date = DateTime.tryParse(startTimeRaw.toString());
        if (date == null) continue;

        final key = _toDayKey(date);
        final target = byDay[key];
        if (target == null) continue;

        target['appointments'] = (target['appointments'] as int) + 1;

        if (row['status'] == 'completed') {
          final value = row['price'];
          final current = target['revenue'] as double;
          if (value is int) {
            target['revenue'] = current + value.toDouble();
          } else if (value is double) {
            target['revenue'] = current + value;
          } else if (value is String) {
            target['revenue'] = current + (double.tryParse(value) ?? 0.0);
          }
        }
      }

      final orderedKeys = byDay.keys.toList()..sort();
      double totalRangeRevenue = 0.0;
      for (final key in orderedKeys) {
        totalRangeRevenue +=
            (byDay[key]?['revenue'] as num?)?.toDouble() ?? 0.0;
      }

      for (var i = 0; i < orderedKeys.length; i++) {
        final key = orderedKeys[i];
        final currentRevenue =
            (byDay[key]?['revenue'] as num?)?.toDouble() ?? 0.0;
        final previousRevenue = i == 0
            ? 0.0
            : (byDay[orderedKeys[i - 1]]?['revenue'] as num?)?.toDouble() ??
                  0.0;

        byDay[key]?['sharePercent'] = totalRangeRevenue <= 0
            ? 0.0
            : (currentRevenue / totalRangeRevenue) * 100;
        byDay[key]?['deltaPercentPrevDay'] = _calculateChangePercent(
          currentRevenue,
          previousRevenue,
        );
      }

      return byDay.values.toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<Map<String, dynamic>>> getTopServices(
    String salonId, {
    int limit = 5,
  }) async {
    try {
      final response = await _supabase
          .from('appointments')
          .select('service_id, status, price, services(name)')
          .eq('salon_id', salonId);

      final rows = (response as List).cast<Map<String, dynamic>>();
      final map = <String, Map<String, dynamic>>{};

      for (final row in rows) {
        final serviceId = row['service_id']?.toString() ?? 'unknown';
        final services = row['services'];
        String serviceName = 'Unbekannt';
        if (services is Map<String, dynamic>) {
          serviceName = services['name']?.toString() ?? serviceName;
        }

        map.putIfAbsent(
          serviceId,
          () => {
            'name': serviceName,
            'count': 0,
            'completedCount': 0,
            'plannedCount': 0,
            'revenue': 0.0,
          },
        );

        final item = map[serviceId]!;
        item['count'] = (item['count'] as int) + 1;

        final status = row['status']?.toString();
        if (status == 'completed') {
          item['completedCount'] = (item['completedCount'] as int) + 1;
        } else if (status == 'pending' || status == 'confirmed') {
          item['plannedCount'] = (item['plannedCount'] as int) + 1;
        }

        if (status == 'completed') {
          final value = row['price'];
          if (value is int) {
            item['revenue'] = (item['revenue'] as double) + value.toDouble();
          } else if (value is double) {
            item['revenue'] = (item['revenue'] as double) + value;
          } else if (value is String) {
            item['revenue'] =
                (item['revenue'] as double) + (double.tryParse(value) ?? 0.0);
          }
        }
      }

      final list = map.values.toList()
        ..sort(
          (a, b) => (b['revenue'] as double).compareTo(a['revenue'] as double),
        );

      return list.take(limit).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeePerformance(
    String salonId, {
    int limit = 6,
  }) async {
    try {
      final response = await _supabase
          .from('appointments')
          .select('employee_id, status, price, employees(display_name)')
          .eq('salon_id', salonId);

      final rows = (response as List).cast<Map<String, dynamic>>();
      final map = <String, Map<String, dynamic>>{};

      for (final row in rows) {
        final employeeId = row['employee_id']?.toString() ?? 'unassigned';
        final employee = row['employees'];
        String name = 'Nicht zugewiesen';
        if (employee is Map<String, dynamic>) {
          name = employee['display_name']?.toString() ?? name;
        }

        map.putIfAbsent(
          employeeId,
          () => {
            'name': name,
            'appointments': 0,
            'completedCount': 0,
            'plannedCount': 0,
            'revenue': 0.0,
          },
        );

        final item = map[employeeId]!;
        item['appointments'] = (item['appointments'] as int) + 1;

        final status = row['status']?.toString();
        if (status == 'completed') {
          item['completedCount'] = (item['completedCount'] as int) + 1;
        } else if (status == 'pending' || status == 'confirmed') {
          item['plannedCount'] = (item['plannedCount'] as int) + 1;
        }

        if (status == 'completed') {
          final value = row['price'];
          if (value is int) {
            item['revenue'] = (item['revenue'] as double) + value.toDouble();
          } else if (value is double) {
            item['revenue'] = (item['revenue'] as double) + value;
          } else if (value is String) {
            item['revenue'] =
                (item['revenue'] as double) + (double.tryParse(value) ?? 0.0);
          }
        }
      }

      final list = map.values.toList()
        ..sort(
          (a, b) => (b['revenue'] as double).compareTo(a['revenue'] as double),
        );

      return list.take(limit).toList();
    } catch (_) {
      return const [];
    }
  }

  String _toDayKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  double _calculateChangePercent(double current, double previous) {
    if (previous == 0) {
      if (current == 0) {
        return 0.0;
      }
      return 100.0;
    }
    return ((current - previous) / previous) * 100;
  }
}
