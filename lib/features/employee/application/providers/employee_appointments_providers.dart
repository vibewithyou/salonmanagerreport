import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/time_tracking/application/providers/time_tracking_providers.dart';
import '../../../../services/supabase_service.dart';
import '../../data/employee_appointments_repository.dart';
import '../../domain/employee_appointment.dart';

final employeeAppointmentsRepositoryProvider = Provider<EmployeeAppointmentsRepository>((ref) {
  return EmployeeAppointmentsRepository(ref.watch(supabaseServiceProvider).client);
});

final employeeAppointmentsProvider = FutureProvider.family<List<EmployeeAppointment>, TimeTrackingScope>((ref, scope) {
  return ref.watch(employeeAppointmentsRepositoryProvider).listForStaff(
        salonId: scope.salonId,
        staffUserId: scope.staffId,
      );
});
