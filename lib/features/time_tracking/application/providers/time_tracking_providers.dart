import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/identity_provider.dart';
import '../../../../services/supabase_service.dart';
import '../../data/time_tracking_repository.dart';
import '../../domain/time_entry.dart';

class TimeTrackingScope {
  const TimeTrackingScope({required this.salonId, required this.staffId});

  final String salonId;
  final String staffId;
}

final timeTrackingRepositoryProvider = Provider<TimeTrackingRepository>((ref) {
  final client = ref.watch(supabaseServiceProvider).client;
  return TimeTrackingRepository(client);
});

final activeTimeTrackingScopeProvider = Provider<TimeTrackingScope?>((ref) {
  final identity = ref.watch(identityProvider);
  final salonId = identity.currentSalonId;
  final staffId = identity.userId;

  if (salonId == null || staffId == null) {
    return null;
  }

  return TimeTrackingScope(salonId: salonId, staffId: staffId);
});

final timeEntriesProvider = FutureProvider.family<List<TimeEntry>, TimeTrackingScope>((
  ref,
  scope,
) {
  final repository = ref.watch(timeTrackingRepositoryProvider);
  final from = DateTime.now().subtract(const Duration(days: 30));
  return repository.listForStaff(
    salonId: scope.salonId,
    staffId: scope.staffId,
    from: from,
  );
});

final openTimeEntryProvider = StreamProvider.family<TimeEntry?, TimeTrackingScope>((
  ref,
  scope,
) {
  final repository = ref.watch(timeTrackingRepositoryProvider);
  return repository
      .watchOpenEntry(salonId: scope.salonId, staffId: scope.staffId)
      .map((entries) => entries.isEmpty ? null : entries.first);
});
