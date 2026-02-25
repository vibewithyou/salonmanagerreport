import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salonmanager/models/activity_log_model.dart';

/// Service for managing activity logs and audit trails
class ActivityLogService {
  final SupabaseClient _supabase;

  ActivityLogService(this._supabase);

  /// Log an activity to the database
  Future<bool> logActivity({
    required String salonId,
    required String userId,
    required String userName,
    required ActivityType type,
    required String description,
    Map<String, dynamic>? metadata,
    String? ipAddress,
    String? userAgent,
  }) async {
    try {
      final response = await _supabase.rpc(
        'log_activity',
        params: {
          'p_salon_id': salonId,
          'p_user_id': userId,
          'p_user_name': userName,
          'p_type': type.name,
          'p_description': description,
          'p_metadata': metadata,
        },
      );

      return response != null;
    } catch (e) {
      print('Error logging activity: $e');
      return false;
    }
  }

  /// Get activity logs for a salon
  Future<List<ActivityLog>> getActivityLogs({
    required String salonId,
    ActivityType? typeFilter,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      var query = _supabase
          .from('activity_logs')
          .select()
          .eq('salon_id', salonId);

      if (typeFilter != null) {
        query = query.eq('type', typeFilter.name);
      }

      final response = await query
          .order('timestamp', ascending: false)
          .limit(limit);

      return response.map((e) => ActivityLog.fromJson(e)).toList();
    } catch (e) {
      print('Error getting activity logs: $e');
      return [];
    }
  }

  /// Get activity logs by type using RPC
  Future<List<ActivityLog>> getActivityLogsByType({
    required String salonId,
    required ActivityType type,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase.rpc(
        'get_activity_log',
        params: {
          'p_salon_id': salonId,
          'p_limit': limit,
          'p_offset': offset,
          'p_type_filter': type.name,
        },
      );

      return (response as List<Map<String, dynamic>>)
          .map(ActivityLog.fromJson)
          .toList();
    } catch (e) {
      print('Error getting activity logs by type: $e');
      return [];
    }
  }

  /// Get activity log summary (count by type)
  Future<Map<ActivityType, int>> getActivityLogSummary(String salonId) async {
    try {
      final response = await _supabase
          .from('activity_logs')
          .select('type')
          .eq('salon_id', salonId);

      Map<ActivityType, int> summary = {};

      for (final log in response) {
        final type = ActivityType.values.firstWhere(
          (e) => e.name == log['type'],
          orElse: () => ActivityType.other,
        );
        summary[type] = (summary[type] ?? 0) + 1;
      }

      return summary;
    } catch (e) {
      print('Error getting activity log summary: $e');
      return {};
    }
  }

  /// Get recent login activities
  Future<List<ActivityLog>> getRecentLogins(
    String salonId, {
    int limit = 10,
  }) async {
    try {
      final response = await _supabase
          .from('activity_logs')
          .select()
          .eq('salon_id', salonId)
          .inFilter('type', [
            ActivityType.employeeLogin.name,
            ActivityType.adminLogin.name,
            ActivityType.customerLogin.name,
          ])
          .order('timestamp', ascending: false)
          .limit(limit);

      return response.map((e) => ActivityLog.fromJson(e)).toList();
    } catch (e) {
      print('Error getting recent logins: $e');
      return [];
    }
  }

  /// Get recent code-related activities
  Future<List<ActivityLog>> getRecentCodeActivities(
    String salonId, {
    int limit = 20,
  }) async {
    try {
      final response = await _supabase
          .from('activity_logs')
          .select()
          .eq('salon_id', salonId)
          .inFilter('type', [
            ActivityType.salonCodeGenerated.name,
            ActivityType.salonCodeReset.name,
            // ActivityType.salonCodeVerified removed (doesn't exist in enum)
            ActivityType.employeeCodeGenerated.name,
          ])
          .order('timestamp', ascending: false)
          .limit(limit);

      return response.map((e) => ActivityLog.fromJson(e)).toList();
    } catch (e) {
      print('Error getting recent code activities: $e');
      return [];
    }
  }

  /// Get activities for a specific user
  Future<List<ActivityLog>> getUserActivities(
    String userId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('activity_logs')
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false)
          .range(offset, offset + limit - 1);

      return response.map((e) => ActivityLog.fromJson(e)).toList();
    } catch (e) {
      print('Error getting user activities: $e');
      return [];
    }
  }

  /// Delete activity logs older than specified days
  Future<bool> deleteOldActivityLogs(
    String salonId, {
    required int daysOld,
  }) async {
    try {
      await _supabase
          .from('activity_logs')
          .delete()
          .eq('salon_id', salonId)
          .lt('timestamp', DateTime.now().subtract(Duration(days: daysOld)));

      return true;
    } catch (e) {
      print('Error deleting old activity logs: $e');
      return false;
    }
  }
}
