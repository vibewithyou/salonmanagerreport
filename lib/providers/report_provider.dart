import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';
import '../services/supabase_service.dart';
import '../services/dashboard_service.dart';
import 'auth_provider.dart';

final reportSupabaseServiceProvider = Provider<SupabaseService>(
  (ref) => SupabaseService(),
);

final reportDashboardServiceProvider = Provider<DashboardService>((ref) {
  final supabaseService = ref.watch(reportSupabaseServiceProvider);
  return DashboardService(supabaseService.client);
});

final reportDataProvider = FutureProvider<ReportData>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  final dashboardService = ref.watch(reportDashboardServiceProvider);

  if (user?.salonId == null) {
    return const ReportData(
      totalEmployees: 0,
      totalRevenue: 0,
      totalBookings: 0,
      totalCustomers: 0,
      avgBookingValue: 0,
      revenueByMonth: [],
      bookingsByService: [],
    );
  }

  try {
    final salonId = user!.salonId!;

    // Fetch all statistics in parallel
    final results = await Future.wait([
      dashboardService.getEmployeeCount(salonId),
      dashboardService.getTotalRevenue(salonId),
      dashboardService.getAppointmentCount(salonId),
      dashboardService.getCustomerCount(salonId),
    ]);

    final totalEmployees = results[0] as int;
    final totalRevenue = results[1] as double;
    final totalBookings = results[2] as int;
    final totalCustomers = results[3] as int;

    // Calculate average booking value
    final avgBookingValue = totalBookings > 0
        ? totalRevenue / totalBookings
        : 0.0;

    // TODO: Fetch revenue by month and bookings by service from Supabase
    // For now, returning empty lists as this requires additional queries

    return ReportData(
      totalEmployees: totalEmployees,
      totalRevenue: totalRevenue,
      totalBookings: totalBookings,
      totalCustomers: totalCustomers,
      avgBookingValue: avgBookingValue,
      revenueByMonth: [],
      bookingsByService: [],
    );
  } catch (e) {
    return const ReportData(
      totalEmployees: 0,
      totalRevenue: 0,
      totalBookings: 0,
      totalCustomers: 0,
      avgBookingValue: 0,
      revenueByMonth: [],
      bookingsByService: [],
    );
  }
});
