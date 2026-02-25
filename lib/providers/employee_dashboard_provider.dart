import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/employee/data/employee_dashboard_repository.dart';
import '../models/employee_dashboard_dto.dart';

/// Provider: Get salon services (POS Tab)
final salonServicesProvider = FutureProvider.family<
    List<SalonServiceDto>,
    String>((ref, salonId) async {
  final repository = ref.watch(employeeDashboardRepositoryProvider);
  return repository.getSalonServices(salonId);
});

/// Provider: Get salon customers (Customers Tab)
final salonCustomersProvider = FutureProvider.family<
    List<SalonCustomerDto>,
    String>((ref, salonId) async {
  final repository = ref.watch(employeeDashboardRepositoryProvider);
  return repository.getSalonCustomers(salonId);
});

/// Provider: Get employee portfolio (Portfolio Tab)
final employeePortfolioProvider = FutureProvider.family<
    List<EmployeePortfolioImageDto>,
    String>((ref, employeeId) async {
  final repository = ref.watch(employeeDashboardRepositoryProvider);
  return repository.getEmployeePortfolio(employeeId);
});

/// Provider: Get employee portfolio with tags
final employeePortfolioWithTagsProvider = FutureProvider.family<
    List<EmployeePortfolioImageWithTagsDto>,
    String>((ref, employeeId) async {
  final repository = ref.watch(employeeDashboardRepositoryProvider);
  return repository.getEmployeePortfolioWithTags(employeeId);
});

/// Provider: Get past appointments (Past Appointments Tab)
final pastAppointmentsProvider = FutureProvider.family<
    List<PastAppointmentDto>,
    (String employeeId, int limit)>((ref, params) async {
  final repository = ref.watch(employeeDashboardRepositoryProvider);
  return repository.getPastAppointments(
    employeeId: params.$1,
    limit: params.$2,
  );
});

/// Provider: Get appointment statistics
final appointmentStatisticsProvider = FutureProvider.family<
    AppointmentStatisticsDto,
    String>((ref, employeeId) async {
  final repository = ref.watch(employeeDashboardRepositoryProvider);
  return repository.getAppointmentStatistics(employeeId);
});

/// Provider: Get customer with history
final customerWithHistoryProvider = FutureProvider.family<
    CustomerWithHistoryDto?,
    String>((ref, customerId) async {
  final repository = ref.watch(employeeDashboardRepositoryProvider);
  return repository.getCustomerWithHistory(customerId);
});

/// Cache invalidation helpers
final employeeDashboardCacheProvider = StateNotifierProvider<
    EmployeeDashboardCacheNotifier,
    EmployeeDashboardCacheState>((ref) {
  return EmployeeDashboardCacheNotifier(ref);
});

class EmployeeDashboardCacheState {
  final String? lastSalonId;
  final String? lastEmployeeId;
  final DateTime? lastRefresh;

  EmployeeDashboardCacheState({
    this.lastSalonId,
    this.lastEmployeeId,
    this.lastRefresh,
  });
}

class EmployeeDashboardCacheNotifier
    extends StateNotifier<EmployeeDashboardCacheState> {
  final Ref ref;

  EmployeeDashboardCacheNotifier(this.ref)
      : super(EmployeeDashboardCacheState());

  void refreshSalonServices(String salonId) {
    ref.invalidate(salonServicesProvider(salonId));
    state = EmployeeDashboardCacheState(
      lastSalonId: salonId,
      lastRefresh: DateTime.now(),
    );
  }

  void refreshSalonCustomers(String salonId) {
    ref.invalidate(salonCustomersProvider(salonId));
    state = EmployeeDashboardCacheState(
      lastSalonId: salonId,
      lastRefresh: DateTime.now(),
    );
  }

  void refreshEmployeePortfolio(String employeeId) {
    ref.invalidate(employeePortfolioProvider(employeeId));
    ref.invalidate(employeePortfolioWithTagsProvider(employeeId));
    state = EmployeeDashboardCacheState(
      lastEmployeeId: employeeId,
      lastRefresh: DateTime.now(),
    );
  }

  void refreshPastAppointments(String employeeId, int limit) {
    ref.invalidate(pastAppointmentsProvider((employeeId, limit)));
    state = EmployeeDashboardCacheState(
      lastEmployeeId: employeeId,
      lastRefresh: DateTime.now(),
    );
  }

  void refreshAppointmentStatistics(String employeeId) {
    ref.invalidate(appointmentStatisticsProvider(employeeId));
    state = EmployeeDashboardCacheState(
      lastEmployeeId: employeeId,
      lastRefresh: DateTime.now(),
    );
  }

  void refreshAll(String salonId, String employeeId) {
    refreshSalonServices(salonId);
    refreshSalonCustomers(salonId);
    refreshEmployeePortfolio(employeeId);
    refreshPastAppointments(employeeId, 50);
    refreshAppointmentStatistics(employeeId);
  }
}
