import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/employee_dashboard_dto.dart';
import '../../../services/supabase_service.dart';

/// Employee Dashboard Repository Provider
final employeeDashboardRepositoryProvider =
    Provider<EmployeeDashboardRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return EmployeeDashboardRepository(supabaseService.client);
});

/// Repository for Employee Dashboard data queries
class EmployeeDashboardRepository {
  final SupabaseClient _client;

  EmployeeDashboardRepository(this._client);

  /// Get all services for a salon (POS Tab)
  /// Query: services table filtered by salon_id
  /// Returns: Service name, price, duration, category
  Future<List<SalonServiceDto>> getSalonServices(String salonId) async {
    try {
      final data = await _client
          .from('services')
          .select()
          .eq('salon_id', salonId)
          .eq('is_active', true)
          .order('category', ascending: true)
          .order('name', ascending: true);

      return (data as List)
          .map((json) => SalonServiceDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch salon services: $e');
    }
  }

  /// Get all customers of a salon (Customers Tab)
  /// Query: customer_profiles table with appointment history
  /// Returns: Customer info + last visits + total spending
  Future<List<SalonCustomerDto>> getSalonCustomers(String salonId) async {
    try {
      final data = await _client
          .from('customer_profiles')
          .select(
              'id, first_name, last_name, phone, email, created_at, updated_at')
          .eq('salon_id', salonId)
            .isFilter('deleted_at', null)
          .order('updated_at', ascending: false);

      List<SalonCustomerDto> customers = [];

      for (var customerJson in data as List) {
        // Get appointment history for each customer
        final appointmentData = await _client
            .from('appointments')
            .select('id, start_time, status, price')
            .eq('customer_profile_id', customerJson['id'])
            .inFilter('status', ['completed', 'cancelled'])
            .order('start_time', ascending: false)
            .limit(10);

        final appointments =
            (appointmentData as List).map((json) => AppointmentSummaryDto.fromJson(json)).toList();

        // Calculate total spending
        final totalSpending = appointments
            .where((a) => a.status == 'completed')
            .fold<double>(0, (sum, a) => sum + (a.price ?? 0));

        // Get last visit
        final lastVisit = appointments.isNotEmpty
            ? appointments.firstWhere((a) => a.status == 'completed',
                orElse: () => appointments.first)
            : null;

        customers.add(SalonCustomerDto.fromJson(
          customerJson,
          appointments: appointments,
          totalSpending: totalSpending,
          lastVisitDate: lastVisit?.startTime,
        ));
      }

      return customers;
    } catch (e) {
      throw Exception('Failed to fetch salon customers: $e');
    }
  }

  /// Get employee portfolio images (Portfolio Tab)
  /// Query: gallery_images table filtered by employee_id
  /// Returns: Image URLs, captions, hairstyle info
  Future<List<EmployeePortfolioImageDto>> getEmployeePortfolio(
      String employeeId) async {
    try {
      final data = await _client
          .from('gallery_images')
          .select()
          .eq('employee_id', employeeId)
          .order('created_at', ascending: false);

      return (data as List)
          .map((json) => EmployeePortfolioImageDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch employee portfolio: $e');
    }
  }

  /// Get employee portfolio images by employee_id with tags
  /// Query: gallery_images joined with gallery_image_tags
  /// Returns: Images with associated tags
  Future<List<EmployeePortfolioImageWithTagsDto>>
      getEmployeePortfolioWithTags(String employeeId) async {
    try {
      final data = await _client
          .from('gallery_images')
          .select('''
            id,
            image_url,
            caption,
            created_at,
            color,
            hairstyle,
            mime_type,
            file_size,
            height,
            width,
            gallery_image_tags(tag_id)
          ''')
          .eq('employee_id', employeeId)
          .order('created_at', ascending: false);

      return (data as List)
          .map((json) => EmployeePortfolioImageWithTagsDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch employee portfolio with tags: $e');
    }
  }

  /// Get past appointments for employee (Past Appointments Tab)
  /// Query: appointments table with status = completed or cancelled
  /// Returns: Last 4 years of appointments
  Future<List<PastAppointmentDto>> getPastAppointments({
    required String employeeId,
    int limit = 50,
    int? offsetDays = 1461, // ~4 years
  }) async {
    try {
      final cutoffDate = DateTime.now()
          .subtract(Duration(days: offsetDays ?? 1461))
          .toIso8601String();

      var query = _client
          .from('appointments')
          .select(
              'id, customer_profile_id, guest_name, guest_email, service_id, start_time, status, price, appointment_number')
          .eq('employee_id', employeeId)
            .inFilter('status', ['completed', 'cancelled'])
          .lte('start_time', DateTime.now().toIso8601String())
          .gte('start_time', cutoffDate)
          .order('start_time', ascending: false)
          .limit(limit);

      final data = await query;

      return (data as List)
          .map((json) => PastAppointmentDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch past appointments: $e');
    }
  }

  /// Get appointment statistics for employee
  /// Query: appointments table with aggregations
  /// Returns: Total appointments, completed, cancelled, total revenue
  Future<AppointmentStatisticsDto> getAppointmentStatistics(
      String employeeId) async {
    try {
      final allAppointments = await _client
          .from('appointments')
          .select()
          .eq('employee_id', employeeId)
          .inFilter('status', ['completed', 'cancelled']);

      int totalCompleted = 0;
      int totalCancelled = 0;
      double totalRevenue = 0;

      for (var appointment in allAppointments as List) {
        final status = appointment['status'] as String;
        final price = (appointment['price'] as num?)?.toDouble() ?? 0;

        if (status == 'completed') {
          totalCompleted++;
          totalRevenue += price;
        } else if (status == 'cancelled') {
          totalCancelled++;
        }
      }

      return AppointmentStatisticsDto(
        totalAppointments: totalCompleted + totalCancelled,
        totalCompleted: totalCompleted,
        totalCancelled: totalCancelled,
        totalRevenue: totalRevenue,
        completionRate: totalCompleted +
                    totalCancelled >
                0
            ? (totalCompleted / (totalCompleted + totalCancelled)) * 100
            : 0,
      );
    } catch (e) {
      throw Exception('Failed to fetch appointment statistics: $e');
    }
  }

  /// Get customer profile with full history
  /// Query: customer_profiles with appointments
  /// Returns: Customer full details with all appointments
  Future<CustomerWithHistoryDto?> getCustomerWithHistory(
      String customerId) async {
    try {
      final customerData = await _client
          .from('customer_profiles')
          .select()
          .eq('id', customerId)
          .maybeSingle();

      if (customerData == null) return null;

      final appointments = await _client
          .from('appointments')
          .select()
          .eq('customer_profile_id', customerId)
          .order('start_time', ascending: false);

      return CustomerWithHistoryDto.fromJson(
        customerData,
        appointments: (appointments as List)
            .map((a) => AppointmentSummaryDto.fromJson(a))
            .toList(),
      );
    } catch (e) {
      throw Exception('Failed to fetch customer with history: $e');
    }
  }
}
