import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salonmanager/features/salon_booking_link/data/datasource/salon_booking_link_datasource.dart';
import 'package:salonmanager/features/salon_booking_link/data/models/salon_booking_link.dart';
import 'package:salonmanager/features/salon_booking_link/data/repository/salon_booking_link_repository.dart';

/// Provider für die SalonBookingLinkDatasource
final salonBookingLinkDatasourceProvider = Provider((ref) {
  final supabaseClient = Supabase.instance.client;
  return SalonBookingLinkDatasource(supabaseClient);
});

/// Provider für die SalonBookingLinkRepository
final salonBookingLinkRepositoryProvider = Provider((ref) {
  final datasource = ref.watch(salonBookingLinkDatasourceProvider);
  return SalonBookingLinkRepository(datasource);
});

/// Lädt den Buchungslink für einen Salon
///
/// Parameter:
/// - salonId: Die Salon-ID
/// - basePath: Der Basis-Pfad (z.B. "https://example.com" oder "https://example.com/app")
final salonBookingLinkProvider =
    FutureProvider.family<
      SalonBookingLink,
      ({String salonId, String basePath})
    >((ref, params) async {
      final repository = ref.watch(salonBookingLinkRepositoryProvider);
      return repository.getBookingLink(params.salonId, params.basePath);
    });

/// Lädt den booking_enabled Status für einen Salon
final salonBookingEnabledProvider = FutureProvider.family<bool, String>((
  ref,
  salonId,
) async {
  final datasource = ref.watch(salonBookingLinkDatasourceProvider);
  return datasource.getSalonBookingEnabled(salonId);
});

/// Notifier für die Verwaltung des booking_enabled Status
class SalonBookingEnabledNotifier extends StateNotifier<AsyncValue<bool>> {
  final SalonBookingLinkRepository _repository;
  final String _salonId;

  SalonBookingEnabledNotifier(
    this._repository,
    this._salonId,
    bool initialValue,
  ) : super(AsyncValue.data(initialValue));

  /// Aktualisiert den booking_enabled Status
  Future<void> updateBookingEnabled(bool enabled) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateBookingEnabled(_salonId, enabled);
      state = AsyncValue.data(enabled);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// StateNotifier Provider für booking_enabled Status Updates
final salonBookingEnabledNotifierProvider =
    StateNotifierProvider.family<
      SalonBookingEnabledNotifier,
      AsyncValue<bool>,
      String
    >((ref, salonId) {
      final repository = ref.watch(salonBookingLinkRepositoryProvider);
      // Initialisiere mit dem geladenem Status (default: false wenn noch nicht geladen)
      return SalonBookingEnabledNotifier(repository, salonId, true);
    });
