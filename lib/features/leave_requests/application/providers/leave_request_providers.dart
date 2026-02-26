import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/time_tracking/application/providers/time_tracking_providers.dart';
import '../../../../services/supabase_service.dart';
import '../../data/leave_requests_repository.dart';
import '../../domain/leave_request.dart';

final leaveRequestsRepositoryProvider = Provider<LeaveRequestsRepository>((ref) {
  final client = ref.watch(supabaseServiceProvider).client;
  return LeaveRequestsRepository(client);
});


final leaveRequestsProvider = FutureProvider.family<List<LeaveRequest>, TimeTrackingScope>((ref, scope) {
  return ref
      .watch(leaveRequestsRepositoryProvider)
      .listMine(salonId: scope.salonId, staffId: scope.staffId);
});

/// Provider for all pending leave requests for a salon (manager/owner)
final pendingLeaveRequestsProvider = FutureProvider.family<List<LeaveRequest>, String>((ref, salonId) {
  return ref.watch(leaveRequestsRepositoryProvider).listPendingForSalon(salonId);
});
