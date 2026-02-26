import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/time_tracking/application/providers/time_tracking_providers.dart';
import '../../../../services/supabase_service.dart';
import '../../data/shifts_repository.dart';
import '../../domain/shift.dart';

final shiftsRepositoryProvider = Provider<ShiftsRepository>((ref) {
  final client = ref.watch(supabaseServiceProvider).client;
  return ShiftsRepository(client);
});

class ShiftRangeQuery {
  const ShiftRangeQuery({required this.scope, required this.focusedDay});

  final TimeTrackingScope scope;
  final DateTime focusedDay;
}

/// Liefert alle Schichten für einen Monat, je nach Rolle:
/// - Mitarbeiter: nur eigene Schichten
/// - Manager/Owner: alle Schichten des Salons
final shiftsForMonthProvider = FutureProvider.family<List<Shift>, ShiftRangeQuery>((ref, query) async {
  final from = DateTime(query.focusedDay.year, query.focusedDay.month, 1);
  final to = DateTime(query.focusedDay.year, query.focusedDay.month + 1, 0, 23, 59, 59);
  final repo = ref.watch(shiftsRepositoryProvider);
  final isManager = query.scope.isManager; // Muss im Scope bereitgestellt werden
  if (isManager) {
    // Alle Schichten des Salons
    return repo.listShiftsForSalon(
      salonId: query.scope.salonId,
      from: from,
      to: to,
    );
  } else {
    // Nur eigene Schichten
    return repo.listShiftsForStaff(
      salonId: query.scope.salonId,
      staffId: query.scope.staffId,
      from: from,
      to: to,
    );
  }
});
