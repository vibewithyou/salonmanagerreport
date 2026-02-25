import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salonmanager/models/salon_settings_model.dart';
import 'package:salonmanager/services/workforce_service.dart';

/// Service for managing salon settings, business hours, holidays, and payment methods
class SalonSettingsService {
  final SupabaseClient _supabase;
  WorkforceService get _workforce => WorkforceService(_supabase);

  SalonSettingsService(this._supabase);

  /// Get salon settings by ID
  Future<SalonSettings?> getSalonSettings(String salonId) async {
    try {
      final response = await _supabase
          .from('salon_settings')
          .select()
          .eq('salon_id', salonId)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        return SalonSettings.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error getting salon settings: $e');
      return null;
    }
  }

  /// Update salon basic information
  Future<bool> updateSalonInfo({
    required String salonId,
    required String name,
    String? description,
    String? address,
    String? city,
    String? postalCode,
    String? phone,
    String? email,
    String? website,
    String? taxId,
    String? bankAccount,
  }) async {
    try {
      await _supabase
          .from('salon_settings')
          .update({
            'salon_name': name,
            if (description != null) 'salon_description': description,
            if (address != null) 'address': address,
            if (city != null) 'city': city,
            if (postalCode != null) 'postal_code': postalCode,
            if (phone != null) 'phone': phone,
            if (email != null) 'email': email,
            if (website != null) 'website': website,
            if (taxId != null) 'tax_id': taxId,
            if (bankAccount != null) 'bank_account': bankAccount,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('salon_id', salonId);

      return true;
    } catch (e) {
      print('Error updating salon info: $e');
      return false;
    }
  }

  /// Get business hours for salon
  Future<List<BusinessHours>> getBusinessHours(String salonId) async {
    try {
      final openingHours = await _workforce.getSalonOpeningHours(salonId);

      final result = <BusinessHours>[];
      for (var day = 0; day < 7; day++) {
        final dayKey = _dayKeyFromIndex(day);
        final hours = openingHours[dayKey];

        result.add(
          BusinessHours(
            dayOfWeek: day,
            dayName: _dayNameFromIndex(day),
            isOpen: !(hours?.closed ?? true),
            openTime: hours?.closed == true ? null : hours?.open,
            closeTime: hours?.closed == true ? null : hours?.close,
          ),
        );
      }

      return result;
    } catch (e) {
      print('Error getting business hours: $e');
      return [];
    }
  }

  /// Update business hours for a day
  Future<bool> updateBusinessHours(
    String salonId,
    int dayOfWeek,
    bool isOpen,
    String? openTime,
    String? closeTime,
  ) async {
    try {
      await _workforce.updateSalonOpeningHour(
        salonId: salonId,
        dayKey: _dayKeyFromIndex(dayOfWeek),
        closed: !isOpen,
        open: openTime ?? '09:00',
        close: closeTime ?? '18:00',
      );

      return true;
    } catch (e) {
      print('Error updating business hours: $e');
      return false;
    }
  }

  /// Get holidays for salon
  Future<List<Holiday>> getHolidays(String salonId) async {
    try {
      final closures = await _workforce.getSalonClosures(salonId);

      return closures
          .map((closure) {
            final parsed = _parseHolidayReason(closure.reason);
            final rangeDescription = closure.startDate == closure.endDate
                ? null
                : 'Zeitraum: ${_toDate(closure.startDate)} bis ${_toDate(closure.endDate)}';

            final descriptionParts = <String>[];
            if (parsed.$2 != null && parsed.$2!.trim().isNotEmpty) {
              descriptionParts.add(parsed.$2!.trim());
            }
            if (rangeDescription != null) {
              descriptionParts.add(rangeDescription);
            }

            return Holiday(
              id: closure.id,
              salonId: closure.salonId,
              date: closure.startDate,
              name: parsed.$1,
              description: descriptionParts.isEmpty
                  ? null
                  : descriptionParts.join(' • '),
              createdAt: null,
            );
          })
          .toList();
    } catch (e) {
      print('Error getting holidays: $e');
      return [];
    }
  }

  /// Add holiday
  Future<bool> addHoliday(
    String salonId,
    DateTime date,
    String name, {
    String? description,
  }) async {
    try {
      final reason = _buildHolidayReason(name, description);
      await _workforce.addSalonClosure(
        salonId: salonId,
        startDate: date,
        endDate: date,
        reason: reason,
      );

      return true;
    } catch (e) {
      print('Error adding holiday: $e');
      return false;
    }
  }

  /// Delete holiday
  Future<bool> deleteHoliday(String holidayId) async {
    try {
      await _workforce.deleteSalonClosure(holidayId);
      return true;
    } catch (e) {
      print('Error deleting holiday: $e');
      return false;
    }
  }

  /// Get payment methods
  Future<List<PaymentMethod>> getPaymentMethods(String salonId) async {
    try {
      final response = await _supabase
          .from('payment_methods')
          .select()
          .eq('salon_id', salonId)
          .order('created_at');

      return response.map((e) => PaymentMethod.fromJson(e)).toList();
    } catch (e) {
      print('Error getting payment methods: $e');
      return [];
    }
  }

  /// Add payment method
  Future<bool> addPaymentMethod(
    String salonId,
    String name,
    String type, {
    Map<String, dynamic>? configuration,
  }) async {
    try {
      await _supabase.from('payment_methods').insert({
        'salon_id': salonId,
        'name': name,
        'type': type,
        'is_active': true,
        if (configuration != null) 'configuration': configuration,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error adding payment method: $e');
      return false;
    }
  }

  /// Toggle payment method active status
  Future<bool> togglePaymentMethod(String methodId, bool isActive) async {
    try {
      await _supabase
          .from('payment_methods')
          .update({'is_active': isActive})
          .eq('id', methodId);

      return true;
    } catch (e) {
      print('Error toggling payment method: $e');
      return false;
    }
  }

  /// Delete payment method
  Future<bool> deletePaymentMethod(String methodId) async {
    try {
      await _supabase.from('payment_methods').delete().eq('id', methodId);
      return true;
    } catch (e) {
      print('Error deleting payment method: $e');
      return false;
    }
  }

  /// Get active payment methods
  Future<List<PaymentMethod>> getActivePaymentMethods(String salonId) async {
    try {
      final response = await _supabase
          .from('payment_methods')
          .select()
          .eq('salon_id', salonId)
          .eq('is_active', true);

      return response.map((e) => PaymentMethod.fromJson(e)).toList();
    } catch (e) {
      print('Error getting active payment methods: $e');
      return [];
    }
  }

  static String _dayKeyFromIndex(int index) {
    switch (index) {
      case 0:
        return 'monday';
      case 1:
        return 'tuesday';
      case 2:
        return 'wednesday';
      case 3:
        return 'thursday';
      case 4:
        return 'friday';
      case 5:
        return 'saturday';
      case 6:
        return 'sunday';
      default:
        return 'monday';
    }
  }

  static String _dayNameFromIndex(int index) {
    switch (index) {
      case 0:
        return 'Montag';
      case 1:
        return 'Dienstag';
      case 2:
        return 'Mittwoch';
      case 3:
        return 'Donnerstag';
      case 4:
        return 'Freitag';
      case 5:
        return 'Samstag';
      case 6:
        return 'Sonntag';
      default:
        return 'Montag';
    }
  }

  static String _buildHolidayReason(String name, String? description) {
    final cleanedName = name.trim().isEmpty ? 'Feiertag' : name.trim();
    final cleanedDescription = description?.trim();

    if (cleanedDescription == null || cleanedDescription.isEmpty) {
      return 'Feiertag: $cleanedName';
    }

    return 'Feiertag: $cleanedName | $cleanedDescription';
  }

  static (String, String?) _parseHolidayReason(String? reason) {
    final raw = (reason ?? '').trim();
    if (raw.isEmpty) {
      return ('Feiertag/Schließtag', null);
    }

    if (raw.startsWith('Feiertag:')) {
      final payload = raw.replaceFirst('Feiertag:', '').trim();
      final parts = payload.split('|');
      final name = parts.first.trim().isEmpty ? 'Feiertag' : parts.first.trim();
      final description = parts.length > 1 ? parts.sublist(1).join('|').trim() : null;
      return (name, description?.isEmpty == true ? null : description);
    }

    return (raw, null);
  }

  static String _toDate(DateTime value) {
    final d = value.day.toString().padLeft(2, '0');
    final m = value.month.toString().padLeft(2, '0');
    final y = value.year.toString();
    return '$d.$m.$y';
  }
}
