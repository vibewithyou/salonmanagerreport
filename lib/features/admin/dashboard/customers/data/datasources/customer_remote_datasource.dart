import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/customer_profile.dart';
import '../models/customer_appointment.dart';
import '../models/booking_media.dart';

class CustomerRemoteDatasource {
  final SupabaseClient _supabase;

  CustomerRemoteDatasource(this._supabase);

  /// Fetch all customers for a salon, ordered by last name
  Future<List<CustomerProfile>> getCustomers(String salonId) async {
    print('[CustomerDatasource] 🌐 Querying Supabase for salon: $salonId');
    try {
      final response = await _supabase
          .from('customer_profiles')
          .select()
          .eq('salon_id', salonId)
          .order('last_name', ascending: true);

      print('[CustomerDatasource] 📦 Raw response length: ${(response as List).length}');
      
      final customers = (response as List)
          .map((json) => CustomerProfile.fromJson(json as Map<String, dynamic>))
          .toList();
      
      print('[CustomerDatasource] ✅ Parsed ${customers.length} customer profiles');
      return customers;
    } catch (e, stackTrace) {
      print('[CustomerDatasource] ❌ Supabase query failed: $e');
      print('[CustomerDatasource] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Create a new customer profile
  /// Customer number is generated on the database side or here
  Future<CustomerProfile> createCustomer(CustomerProfile profile) async {
    // Generate customer number
    final customerNumber = await _generateCustomerNumber(profile.salonId);

    final data = profile.toJson()
      ..remove('id')
      ..remove('created_at')
      ..remove('updated_at')
      ..['customer_number'] = customerNumber;

    final response = await _supabase
        .from('customer_profiles')
        .insert(data)
        .select()
        .single();

    return CustomerProfile.fromJson(response);
  }

  /// Update an existing customer profile
  Future<CustomerProfile> updateCustomer(
    String customerId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _supabase
        .from('customer_profiles')
        .update(updates)
        .eq('id', customerId)
        .select()
        .single();

    return CustomerProfile.fromJson(response);
  }

  /// Soft delete a customer (set deleted_at)
  Future<void> deleteCustomer(String customerId) async {
    await _supabase
        .from('customer_profiles')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', customerId);
  }

  /// Hard delete a customer (permanent)
  Future<void> hardDeleteCustomer(String customerId) async {
    await _supabase.from('customer_profiles').delete().eq('id', customerId);
  }

  /// Get past appointments for a customer (last 5 years)
  Future<List<CustomerAppointment>> getCustomerAppointments(
    String customerId,
  ) async {
    final fiveYearsAgo = DateTime.now().subtract(const Duration(days: 365 * 5));

    final response = await _supabase
        .from('appointments')
        .select(
          'id, start_time, end_time, status, notes, guest_name, guest_email, guest_phone, price, buffer_before, buffer_after, image_url, customer_profile_id, appointment_number, service:services(name, duration_minutes, price)',
        )
        .eq('customer_profile_id', customerId)
        .gte('start_time', fiveYearsAgo.toIso8601String())
        .order('start_time', ascending: false);

    return (response as List)
        .map(
          (json) => CustomerAppointment.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<BookingMedia>> getBookingMediaForCustomer(String customerId) async {
    final response = await _supabase
        .from('booking_media')
        .select(
          'id, appointment_id, customer_profile_id, salon_id, media_type, file_url, file_path, mime_type, file_size, created_at',
        )
        .eq('customer_profile_id', customerId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => BookingMedia.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<BookingMedia>> getBookingMediaForAppointment(
    String appointmentId,
  ) async {
    final response = await _supabase
        .from('booking_media')
        .select(
          'id, appointment_id, customer_profile_id, salon_id, media_type, file_url, file_path, mime_type, file_size, created_at',
        )
        .eq('appointment_id', appointmentId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => BookingMedia.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> validateUpload({
    required String fileName,
    required String mimeType,
    required int fileSize,
  }) async {
    final response = await _supabase.functions.invoke(
      'validate-upload',
      body: {'fileName': fileName, 'mimeType': mimeType, 'fileSize': fileSize},
    );

    if (response.status < 200 || response.status >= 300) {
      throw Exception('Datei-Validierung fehlgeschlagen');
    }
  }

  Future<void> uploadBookingMedia({
    required String salonId,
    required String customerId,
    required String appointmentId,
    required String mediaType,
    required List<int> fileBytes,
    required String fileName,
    required String mimeType,
  }) async {
    final extension = fileName.contains('.') ? fileName.split('.').last : 'jpg';
    final path =
        '$salonId/$customerId/$appointmentId/$mediaType-${DateTime.now().millisecondsSinceEpoch}.$extension';

    await _supabase.storage
        .from('booking_media')
        .uploadBinary(
          path,
          Uint8List.fromList(fileBytes),
          fileOptions: FileOptions(contentType: mimeType, upsert: false),
        );

    final publicUrl = _supabase.storage.from('booking_media').getPublicUrl(path);

    await _supabase.from('booking_media').insert({
      'appointment_id': appointmentId,
      'customer_profile_id': customerId,
      'salon_id': salonId,
      'media_type': mediaType,
      'file_url': publicUrl,
      'file_path': path,
      'mime_type': mimeType,
      'file_size': fileBytes.length,
      'created_by': _supabase.auth.currentUser?.id,
    });
  }

  /// Generate customer number: prefix + YYYYMMDD + sequence
  Future<String> _generateCustomerNumber(String salonId) async {
    // Get salon info for prefix
    String prefix = 'cu';
    try {
      final salonData = await _supabase
          .from('salons')
          .select('name, owner_id')
          .eq('id', salonId)
          .single();

      final salonName = salonData['name'] as String? ?? '';
      final ownerId = salonData['owner_id'] as String?;

      String ownerFirst = '';
      if (ownerId != null) {
        final ownerProfile = await _supabase
            .from('profiles')
            .select('first_name')
            .eq('user_id', ownerId)
            .maybeSingle();
        ownerFirst = ownerProfile?['first_name'] as String? ?? '';
      }

      final salonInitial = salonName.trim().isNotEmpty
          ? salonName.trim()[0]
          : '';
      final ownerInitial = ownerFirst.trim().isNotEmpty
          ? ownerFirst.trim()[0]
          : '';

      if (salonInitial.isNotEmpty) {
        prefix =
            salonInitial.toLowerCase() +
            (ownerInitial.isNotEmpty ? ownerInitial.toLowerCase() : '');
      }
    } catch (e) {
      // Fallback to default prefix
    }

    // Date part
    final today = DateTime.now();
    final dateStr =
        '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';

    // Sequence number
    int nextSeq = 1;
    try {
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('customer_profiles')
          .select('id')
          .eq('salon_id', salonId)
          .gte('created_at', startOfDay.toIso8601String())
          .lt('created_at', endOfDay.toIso8601String());

      nextSeq = (response as List).length + 1;
    } catch (e) {
      // Fallback to sequence 1
    }

    return '$prefix$dateStr${nextSeq.toString().padLeft(5, '0')}';
  }
}
