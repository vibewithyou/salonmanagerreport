import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';
import '../../../services/workforce_service.dart';

/// Booking repository provider
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return BookingRepository(supabaseService.client);
});

/// Repository for booking/appointment operations
class BookingRepository {
  final SupabaseClient _client;

  BookingRepository(this._client);

  /// Create a guest booking (no user account required)
  Future<AppointmentData> createGuestBooking({
    required String salonId,
    required String serviceId,
    required String? employeeId,
    required String guestName,
    required String guestEmail,
    required String? guestPhone,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
    List<String>? images,
    bool termsAccepted = false,
    bool privacyAccepted = false,
  }) async {
    try {
      await _ensureBookingAllowed(
        salonId: salonId,
        serviceId: serviceId,
        employeeId: employeeId,
        startTime: startTime,
        endTime: endTime,
      );

      // Get customer profile first (or create if doesn't exist)
      final customerRepo = _client;
      final existingCustomer = await customerRepo
          .from('customer_profiles')
          .select()
          .eq('email', guestEmail)
          .maybeSingle();

      String customerId = existingCustomer?['id'] as String? ?? '';

      if (customerId.isEmpty) {
        // Create a guest customer profile
        final newCustomer = await customerRepo.from('customer_profiles').insert({
          'salon_id': salonId,
          'first_name': guestName.split(' ').first,
          'last_name': guestName.split(' ').length > 1 
              ? guestName.split(' ').sublist(1).join(' ')
              : '',
          'email': guestEmail,
          'phone': guestPhone,
        }).select().single();

        customerId = newCustomer['id'] as String;
      }

      // Create appointment
      final appointment = await _client.from('appointments').insert({
        'salon_id': salonId,
        'customer_profile_id': customerId,
        'service_id': serviceId,
        'employee_id': employeeId,
        'guest_name': guestName,
        'guest_email': guestEmail,
        'guest_phone': guestPhone,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'status': 'pending',
        'notes': notes,
        'images': images ?? [],
        'terms_accepted': termsAccepted,
        'privacy_accepted': privacyAccepted,
      }).select().single();

      return AppointmentData.fromJson(appointment);
    } catch (e) {
      throw Exception('Failed to create guest booking: $e');
    }
  }

  /// Create a booking for authenticated customer
  Future<AppointmentData> createCustomerBooking({
    required String salonId,
    required String customerId,
    required String serviceId,
    required String? employeeId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
    List<String>? images,
    bool termsAccepted = false,
    bool privacyAccepted = false,
  }) async {
    try {
      await _ensureBookingAllowed(
        salonId: salonId,
        serviceId: serviceId,
        employeeId: employeeId,
        startTime: startTime,
        endTime: endTime,
      );

      final appointment = await _client.from('appointments').insert({
        'salon_id': salonId,
        'customer_profile_id': customerId,
        'service_id': serviceId,
        'employee_id': employeeId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'status': 'pending',
        'notes': notes,
        'images': images ?? [],
        'terms_accepted': termsAccepted,
        'privacy_accepted': privacyAccepted,
      }).select().single();

      return AppointmentData.fromJson(appointment);
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Get appointment by ID
  Future<AppointmentData?> getAppointmentById(String appointmentId) async {
    try {
      final data = await _client
          .from('appointments')
          .select()
          .eq('id', appointmentId)
          .maybeSingle();

      if (data == null) return null;

      return AppointmentData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch appointment: $e');
    }
  }

  /// Get appointments for a salon (for admin/employee calendar)
  Future<List<AppointmentData>> getSalonAppointments({
    required String salonId,
    DateTime? startDate,
    DateTime? endDate,
    String? employeeId,
    String? status,
  }) async {
    try {
      var query = _client
          .from('appointments')
          .select()
          .eq('salon_id', salonId);

      if (employeeId != null) {
        query = query.eq('employee_id', employeeId);
      }

      if (status != null) {
        query = query.eq('status', status);
      }

      if (startDate != null) {
        query = query.gte('start_time', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('start_time', endDate.toIso8601String());
      }

      final data = await query.order('start_time', ascending: true);

      return (data as List)
          .map((json) => AppointmentData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch appointments: $e');
    }
  }

  /// Get customer's appointments
  Future<List<AppointmentData>> getCustomerAppointments(String customerId) async {
    try {
      final data = await _client
          .from('appointments')
          .select()
          .eq('customer_id', customerId)
          .gte('start_time', DateTime.now().toIso8601String())
          .order('start_time', ascending: true);

      return (data as List)
          .map((json) => AppointmentData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch customer appointments: $e');
    }
  }

  /// Get employee's appointments
  Future<List<AppointmentData>> getEmployeeAppointments(String employeeId) async {
    try {
      final data = await _client
          .from('appointments')
          .select()
          .eq('employee_id', employeeId)
          .gte('start_time', DateTime.now().toIso8601String())
          .order('start_time', ascending: true);

      return (data as List)
          .map((json) => AppointmentData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch employee appointments: $e');
    }
  }

  /// Update appointment status
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    try {
      await _client
          .from('appointments')
          .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', appointmentId);
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }

  /// Update appointment details
  Future<void> updateAppointment({
    required String appointmentId,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    String? notes,
    List<String>? images,
  }) async {
    try {
      final updates = <String, dynamic>{
        if (startTime != null) 'start_time': startTime.toIso8601String(),
        if (endTime != null) 'end_time': endTime.toIso8601String(),
        if (status != null) 'status': status,
        if (notes != null) 'notes': notes,
        if (images != null) 'images': images,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (updates.isNotEmpty) {
        await _client
            .from('appointments')
            .update(updates)
            .eq('id', appointmentId);
      }
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }

  /// Cancel appointment
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await updateAppointmentStatus(
        appointmentId: appointmentId,
        status: 'cancelled',
      );
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }

  /// Upload booking image to storage
  Future<String> uploadBookingImage({
    required String salonId,
    required String appointmentId,
    required List<int> imageBytes,
    required String fileName,
  }) async {
    try {
      final path = 'bookings/$salonId/$appointmentId/$fileName';
      
      await _client.storage
          .from('booking-images')
          .uploadBinary(path, Uint8List.fromList(imageBytes));

      final publicUrl = _client.storage
          .from('booking-images')
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Get available time slots for a service on a specific date
  Future<List<TimeSlot>> getAvailableSlots({
    required String salonId,
    required String serviceId,
    required DateTime date,
    String? employeeId,
  }) async {
    try {
      final workforceService = WorkforceService(_client);

      // Query appointments for the date
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      var query = _client
          .from('appointments')
          .select()
          .eq('salon_id', salonId)
          .gte('start_time', startOfDay.toIso8601String())
          .lt('start_time', endOfDay.toIso8601String());

      if (employeeId != null) {
        query = query.eq('employee_id', employeeId);
      }

      final occupiedSlots = await query;

      // Get service duration
      final service = await _client
          .from('services')
          .select('duration_minutes')
          .eq('id', serviceId)
          .single();

      final durationMinutes = service['duration_minutes'] as int? ?? 30;

      final openingHours = await workforceService.getSalonOpeningHours(salonId);
      final dayKey = _dayKeyFromWeekday(date.weekday);
      final dayHours = openingHours[dayKey];
      if (dayHours == null || dayHours.closed) {
        return [];
      }

      final openMinutes = _parseMinutes(dayHours.open);
      final closeMinutes = _parseMinutes(dayHours.close);
      if (openMinutes == null || closeMinutes == null || closeMinutes <= openMinutes) {
        return [];
      }

      // Generate available slots (opening hours, 30-minute intervals)
      final now = DateTime.now();
      final slots = <TimeSlot>[];

      var current = DateTime(
        date.year,
        date.month,
        date.day,
        openMinutes ~/ 60,
        openMinutes % 60,
      );

      final endTime = DateTime(
        date.year,
        date.month,
        date.day,
        closeMinutes ~/ 60,
        closeMinutes % 60,
      );

      while (current.add(Duration(minutes: durationMinutes)).isBefore(endTime)) {
        final slotEnd = current.add(Duration(minutes: durationMinutes));

        // Check if slot is occupied
        bool isOccupied = (occupiedSlots as List).any((apt) {
          final aptStart = DateTime.parse(apt['start_time'] as String);
          final aptEnd = DateTime.parse(apt['end_time'] as String);
          return current.isBefore(aptEnd) && slotEnd.isAfter(aptStart);
        });

        final blockReasons = await workforceService.getBookingBlockReasons(
          salonId: salonId,
          startTime: current,
          endTime: slotEnd,
          employeeId: employeeId,
        );

        // Only show future slots
        if (!isOccupied && blockReasons.isEmpty && current.isAfter(now)) {
          slots.add(TimeSlot(
            startTime: current,
            endTime: slotEnd,
          ));
        }

        current = current.add(const Duration(minutes: 30));
      }

      return slots;
    } catch (e) {
      throw Exception('Failed to fetch available slots: $e');
    }
  }

  Future<void> _ensureBookingAllowed({
    required String salonId,
    required String serviceId,
    required String? employeeId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final workforceService = WorkforceService(_client);
    final reasons = await workforceService.getBookingBlockReasons(
      salonId: salonId,
      startTime: startTime,
      endTime: endTime,
      employeeId: employeeId,
    );

    if (reasons.isEmpty) {
      final free = await _client.rpc(
        'has_free_slot',
        params: {
          'salon_id': salonId,
          'service_id': serviceId,
          'start_time': startTime.toIso8601String(),
          'end_time': endTime.toIso8601String(),
          'employee_id': employeeId,
        },
      );

      if (free == true) {
        return;
      }

      reasons.add('Das Zeitfenster ist nicht mehr verfügbar.');
    }

    throw Exception('Buchung blockiert: ${reasons.join(' | ')}');
  }

  static int? _parseMinutes(String value) {
    final normalized = value.trim();
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(normalized);
    if (match == null) {
      return null;
    }

    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    if (hour == null || minute == null) {
      return null;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }
    return hour * 60 + minute;
  }

  static String _dayKeyFromWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
        return 'sunday';
      default:
        return 'monday';
    }
  }
}

/// Appointment/Booking data model
class AppointmentData {
  final String id;
  final String salonId;
  final String? customerId;
  final String? employeeId;
  final String? serviceId;
  final String? guestName;
  final String? guestEmail;
  final String? guestPhone;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final String? notes;
  final List<String>? images;
  final double? price;
  final bool termsAccepted;
  final bool privacyAccepted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AppointmentData({
    required this.id,
    required this.salonId,
    this.customerId,
    this.employeeId,
    this.serviceId,
    this.guestName,
    this.guestEmail,
    this.guestPhone,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.notes,
    this.images,
    this.price,
    required this.termsAccepted,
    required this.privacyAccepted,
    required this.createdAt,
    this.updatedAt,
  });

  Duration get duration => endTime.difference(startTime);
  bool get isGuest => guestName != null && customerId == null;
  bool get isConfirmed => status == 'confirmed' || status == 'completed';
  bool get isPending => status == 'pending';
  bool get isCancelled => status == 'cancelled';

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      customerId: json['customer_id'] as String?,
      employeeId: json['employee_id'] as String?,
      serviceId: json['service_id'] as String?,
      guestName: json['guest_name'] as String?,
      guestEmail: json['guest_email'] as String?,
      guestPhone: json['guest_phone'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      status: json['status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      images: (json['images'] as List?)?.cast<String>(),
      price: (json['price'] as num?)?.toDouble(),
      termsAccepted: json['terms_accepted'] as bool? ?? false,
      privacyAccepted: json['privacy_accepted'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
}

/// Time slot for availability
class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;

  TimeSlot({
    required this.startTime,
    required this.endTime,
  });

  @override
  String toString() => '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}';
}
