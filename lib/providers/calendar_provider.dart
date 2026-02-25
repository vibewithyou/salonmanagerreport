import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calendar_model.dart';
import '../services/supabase_service.dart';

// Supabase Service Provider
final calendarSupabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

// Calendar events for selected month
final calendarEventsProvider = FutureProvider.family<List<CalendarEvent>, DateTime>((ref, date) async {
  final supabaseService = ref.watch(calendarSupabaseServiceProvider);
  
  try {
    final user = supabaseService.currentUser;
    if (user == null) return [];

    // Get salon ID
    final salonResponse = await supabaseService.client
        .from('salons')
        .select('id')
        .eq('owner_id', user.id)
        .single();

    final salonId = salonResponse['id'];

    // Get events for the entire month
    final startOfMonth = DateTime(date.year, date.month, 1);
    final endOfMonth = DateTime(date.year, date.month + 1, 0);

    final response = await supabaseService.client
        .from('bookings')
        .select()
        .eq('salon_id', salonId)
        .gte('appointment_date', startOfMonth.toIso8601String())
        .lte('appointment_date', endOfMonth.toIso8601String())
        .order('appointment_date', ascending: true);

    return (response as List)
        .map((e) => CalendarEvent.fromJson({
              'id': e['id'],
              'salon_id': e['salon_id'],
              'title': e['service_id'], // Placeholder, should be service name
              'description': e['notes'],
              'start_time': e['appointment_date'],
              'end_time': DateTime.parse(e['appointment_date'])
                  .add(Duration(minutes: e['duration_minutes'] ?? 60))
                  .toIso8601String(),
              'event_type': 'appointment',
              'status': e['status'],
              'created_at': e['created_at'],
              'updated_at': e['updated_at'],
            }))
        .toList();
  } catch (e) {
    return [];
  }
});

// Upcoming appointments (next 7 days)
final upcomingAppointmentsProvider = FutureProvider<List<CalendarEvent>>((ref) async {
  final supabaseService = ref.watch(calendarSupabaseServiceProvider);
  
  try {
    final user = supabaseService.currentUser;
    if (user == null) return [];

    // Get salon ID
    final salonResponse = await supabaseService.client
        .from('salons')
        .select('id')
        .eq('owner_id', user.id)
        .single();

    final salonId = salonResponse['id'];

    final now = DateTime.now();
    final weekLater = now.add(const Duration(days: 7));

    final response = await supabaseService.client
        .from('bookings')
        .select()
        .eq('salon_id', salonId)
        .eq('status', 'confirmed')
        .gte('appointment_date', now.toIso8601String())
        .lte('appointment_date', weekLater.toIso8601String())
        .order('appointment_date', ascending: true)
        .limit(10);

    return (response as List)
        .map((e) => CalendarEvent.fromJson({
              'id': e['id'],
              'salon_id': e['salon_id'],
              'title': e['service_id'],
              'description': e['notes'],
              'start_time': e['appointment_date'],
              'end_time': DateTime.parse(e['appointment_date'])
                  .add(Duration(minutes: e['duration_minutes'] ?? 60))
                  .toIso8601String(),
              'event_type': 'appointment',
              'status': e['status'],
              'created_at': e['created_at'],
              'updated_at': e['updated_at'],
            }))
        .toList();
  } catch (e) {
    return [];
  }
});

// Appointment summary stats
final appointmentSummaryProvider = FutureProvider<AppointmentSummary>((ref) async {
  final supabaseService = ref.watch(calendarSupabaseServiceProvider);
  
  try {
    final user = supabaseService.currentUser;
    if (user == null) {
      return const AppointmentSummary(
        totalAppointments: 0,
        completedAppointments: 0,
        cancelledAppointments: 0,
        pendingAppointments: 0,
      );
    }

    // Get salon ID
    final salonResponse = await supabaseService.client
        .from('salons')
        .select('id')
        .eq('owner_id', user.id)
        .single();

    final salonId = salonResponse['id'];

    // Get all appointments for this month
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final allAppointments = await supabaseService.client
        .from('bookings')
        .select()
        .eq('salon_id', salonId)
        .gte('appointment_date', startOfMonth.toIso8601String())
        .lte('appointment_date', endOfMonth.toIso8601String());

    final total = allAppointments.length;
    int completed = 0;
    int cancelled = 0;
    int pending = 0;

    for (var apt in allAppointments) {
      switch (apt['status']) {
        case 'completed':
          completed++;
          break;
        case 'cancelled':
          cancelled++;
          break;
        case 'confirmed':
        case 'pending':
          pending++;
          break;
      }
    }

    return AppointmentSummary(
      totalAppointments: total,
      completedAppointments: completed,
      cancelledAppointments: cancelled,
      pendingAppointments: pending,
    );
  } catch (e) {
    return const AppointmentSummary(
      totalAppointments: 0,
      completedAppointments: 0,
      cancelledAppointments: 0,
      pendingAppointments: 0,
    );
  }
});

// Calendar notifier for managing calendar operations
final calendarNotifierProvider =
    StateNotifierProvider<CalendarNotifier, AsyncValue<void>>((ref) {
  final supabaseService = ref.watch(calendarSupabaseServiceProvider);
  return CalendarNotifier(supabaseService, ref);
});

class CalendarNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseService _supabaseService;
  final Ref _ref;

  CalendarNotifier(this._supabaseService, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> createEvent(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _supabaseService.client
          .from('calendar_events')
          .insert([data]);

      state = const AsyncValue.data(null);
      _ref.invalidate(calendarEventsProvider);
      _ref.invalidate(appointmentSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.client
          .from('calendar_events')
          .update(data)
          .eq('id', eventId);

      state = const AsyncValue.data(null);
      _ref.invalidate(calendarEventsProvider);
      _ref.invalidate(appointmentSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.client
          .from('bookings')
          .update({'status': 'cancelled'}).eq('id', appointmentId);

      state = const AsyncValue.data(null);
      _ref.invalidate(calendarEventsProvider);
      _ref.invalidate(upcomingAppointmentsProvider);
      _ref.invalidate(appointmentSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> completeAppointment(String appointmentId) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.client
          .from('bookings')
          .update({'status': 'completed'}).eq('id', appointmentId);

      state = const AsyncValue.data(null);
      _ref.invalidate(calendarEventsProvider);
      _ref.invalidate(upcomingAppointmentsProvider);
      _ref.invalidate(appointmentSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
