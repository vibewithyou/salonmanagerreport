import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/salon_model.dart';
import '../../models/booking_model.dart';
import '../../services/supabase_service.dart';

final supabaseProvider = Provider((ref) => SupabaseService());

// Temporary booking wizard state
final tempBookingWizardProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'salon_id': '',
    'service_id': '',
    'stylist_id': '',
    'appointment_date': null,
    'appointment_time': '',
    'duration_minutes': 60,
    'total_price': 0.0,
    'notes': '',
  };
});

// Salons
final salonsProvider = FutureProvider<List<Salon>>((ref) async {
  final supabase = ref.watch(supabaseProvider);
  try {
    final response = await supabase.client
        .from('salons')
        .select()
        .eq('is_active', true);

    return (response as List).map((json) => Salon.fromJson(json)).toList();
  } catch (e) {
    throw Exception('Failed to fetch salons: $e');
  }
});

// Services by Salon
final servicesBySalonProvider =
    FutureProvider.family<List<SalonService>, String>((ref, salonId) async {
      final supabase = ref.watch(supabaseProvider);
      try {
        final response = await supabase.client
            .from('salon_services')
            .select()
            .eq('salon_id', salonId)
            .eq('is_active', true)
            .order('name', ascending: true);

        return (response as List)
            .map((json) => SalonService.fromJson(json))
            .toList();
      } catch (e) {
        throw Exception('Failed to fetch services: $e');
      }
    });

// Stylists by Salon
final stylistsBySalonProvider = FutureProvider.family<List<Stylist>, String>((
  ref,
  salonId,
) async {
  final supabase = ref.watch(supabaseProvider);
  try {
    final response = await supabase.client
        .from('employees')
        .select()
        .eq('salon_id', salonId)
        .eq('is_active', true)
        .order('name', ascending: true);

    return (response as List).map((json) => Stylist.fromJson({
      'id': json['id'],
      'salon_id': json['salon_id'],
      'name': json['name'],
      'email': json['email'],
      'phone': json['phone'],
      'avatar': json['avatar'],
      'specialties': json['specialties'] ?? [],
      'is_active': json['is_active'],
      'created_at': json['created_at'],
    })).toList();
  } catch (e) {
    throw Exception('Failed to fetch stylists: $e');
  }
});

// Available time slots for a stylist on a specific date
final availableTimeSlotsProvider =
    FutureProvider.family<List<String>, (String, DateTime)>((ref, params) async {
  final supabase = ref.watch(supabaseProvider);
  final (stylistId, date) = params;

  try {
    // Get bookings for the stylist on that day
    final response = await supabase.client
        .from('bookings')
        .select('appointment_date, duration_minutes')
        .eq('stylist_id', stylistId)
        .gte('appointment_date', date.toIso8601String())
        .lt('appointment_date',
            date.add(const Duration(days: 1)).toIso8601String());

    final bookedSlots = <DateTime>[];
    for (var booking in response as List) {
      final apptDate = DateTime.parse(booking['appointment_date']);
      final duration = booking['duration_minutes'] ?? 60;
      bookedSlots.add(apptDate);
      bookedSlots.add(apptDate.add(Duration(minutes: duration)));
    }

    // Generate 15-minute intervals from 9 AM to 6 PM
    final slots = <String>[];
    final startHour = 9;
    final endHour = 18;

    for (int hour = startHour; hour < endHour; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        final slot = DateTime(date.year, date.month, date.day, hour, minute);
        
        bool isAvailable = true;
        for (final booked in bookedSlots) {
          if (slot.isAtSameMomentAs(booked)) {
            isAvailable = false;
            break;
          }
        }
        
        if (isAvailable) {
          slots.add('${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
        }
      }
    }

    return slots;
  } catch (e) {
    return [];
  }
});

// Bookings for user
final userBookingsProvider = FutureProvider<List<Appointment>>((ref) async {
  final supabase = ref.watch(supabaseProvider);
  final userId = supabase.userId;

  if (userId == null) {
    throw Exception('User not authenticated');
  }

  try {
    final response = await supabase.client
        .from('bookings')
        .select()
        .eq('customer_id', userId)
        .order('appointment_date', ascending: false);

    return (response as List)
        .map((json) => Appointment.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception('Failed to fetch bookings: $e');
  }
});

// Create booking notifier
final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<Appointment?>>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return BookingNotifier(supabase, ref);
});

class BookingNotifier extends StateNotifier<AsyncValue<Appointment?>> {
  final SupabaseService _supabase;
  final Ref _ref;

  BookingNotifier(this._supabase, this._ref) : super(const AsyncValue.data(null));

  Future<Appointment?> createBooking(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final userId = _supabase.userId;
      if (userId == null) throw Exception('User not authenticated');

      final bookingData = {
        ...data,
        'customer_id': userId,
        'status': 'confirmed',
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase.client
          .from('bookings')
          .insert([bookingData])
          .select()
          .single();

      _ref.invalidate(userBookingsProvider);

      final appointment = Appointment.fromJson(response);
      state = AsyncValue.data(appointment);
      return appointment;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _supabase.client
          .from('bookings')
          .update({'status': 'cancelled'}).eq('id', bookingId);

      _ref.invalidate(userBookingsProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> rescheduleBooking(
      String bookingId, DateTime newDateTime) async {
    try {
      await _supabase.client
          .from('bookings')
          .update({'appointment_date': newDateTime.toIso8601String()})
          .eq('id', bookingId);

      _ref.invalidate(userBookingsProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
