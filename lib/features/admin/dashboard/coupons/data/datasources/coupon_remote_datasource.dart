import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/coupon.dart';
import '../models/coupon_redemption.dart';

class CouponRemoteDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all coupons for a salon
  Future<List<Coupon>> getCoupons(String salonId) async {
    try {
      final response = await _supabase
          .from('coupons')
          .select()
          .eq('salon_id', salonId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Coupon.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load coupons: $e');
    }
  }

  /// Get a single coupon by ID
  Future<Coupon> getCouponById(String couponId) async {
    try {
      final response = await _supabase
          .from('coupons')
          .select()
          .eq('id', couponId)
          .single();

      return Coupon.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load coupon: $e');
    }
  }

  /// Create a new coupon
  Future<Coupon> createCoupon(Map<String, dynamic> couponData) async {
    try {
      final normalizedCode = (couponData['code'] as String?)
          ?.trim()
          .toUpperCase();
      if (normalizedCode == null || normalizedCode.isEmpty) {
        throw Exception('Coupon code is required');
      }

      final normalizedData = Map<String, dynamic>.from(couponData)
        ..['code'] = normalizedCode;

      final existing = await _supabase
          .from('coupons')
          .select('id')
          .eq('salon_id', normalizedData['salon_id'])
          .eq('code', normalizedCode)
          .maybeSingle();

      if (existing != null) {
        throw Exception('Coupon code already exists for this salon');
      }

      final response = await _supabase
          .from('coupons')
          .insert(normalizedData)
          .select()
          .single();

      return Coupon.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create coupon: $e');
    }
  }

  /// Update an existing coupon
  Future<Coupon> updateCoupon(
    String couponId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final normalizedUpdates = Map<String, dynamic>.from(updates);
      if (normalizedUpdates.containsKey('code')) {
        final normalizedCode = (normalizedUpdates['code'] as String?)
            ?.trim()
            .toUpperCase();
        if (normalizedCode == null || normalizedCode.isEmpty) {
          throw Exception('Coupon code is required');
        }

        final currentCoupon = await _supabase
            .from('coupons')
            .select('salon_id')
            .eq('id', couponId)
            .single();

        final existing = await _supabase
            .from('coupons')
            .select('id')
            .eq('salon_id', currentCoupon['salon_id'])
            .eq('code', normalizedCode)
            .neq('id', couponId)
            .maybeSingle();

        if (existing != null) {
          throw Exception('Coupon code already exists for this salon');
        }

        normalizedUpdates['code'] = normalizedCode;
      }

      final response = await _supabase
          .from('coupons')
          .update(normalizedUpdates)
          .eq('id', couponId)
          .select()
          .single();

      return Coupon.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update coupon: $e');
    }
  }

  /// Delete a coupon (soft delete by setting is_active to false)
  Future<void> deleteCoupon(String couponId) async {
    try {
      await _supabase
          .from('coupons')
          .update({'is_active': false})
          .eq('id', couponId);
    } catch (e) {
      throw Exception('Failed to delete coupon: $e');
    }
  }

  /// Get redemptions for a specific coupon
  Future<List<CouponRedemption>> getCouponRedemptions(String couponId) async {
    try {
      final response = await _supabase
          .from('coupon_redemptions')
          .select('''
            *,
            customer_profiles!coupon_redemptions_customer_profile_id_fkey(
              first_name,
              last_name
            )
          ''')
          .eq('coupon_id', couponId)
          .order('redeemed_at', ascending: false);

      return (response as List).map((json) {
        final data = json as Map<String, dynamic>;
        // Flatten customer name
        if (data['customer_profiles'] != null) {
          final customer = data['customer_profiles'] as Map<String, dynamic>;
          data['customer_name'] =
              '${customer['first_name']} ${customer['last_name']}';
        }
        return CouponRedemption.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load redemptions: $e');
    }
  }

  /// Create a redemption entry for a coupon
  Future<void> createRedemption({
    required String couponId,
    required String customerProfileId,
    required String salonId,
    String? transactionId,
  }) async {
    try {
      final coupon = await _supabase
          .from('coupons')
          .select('id, is_active, start_date, end_date')
          .eq('id', couponId)
          .eq('salon_id', salonId)
          .maybeSingle();

      if (coupon == null) {
        throw Exception('Coupon does not exist for this salon');
      }

      final isActive = coupon['is_active'] == true;
      if (!isActive) {
        throw Exception('Coupon is inactive');
      }

      final now = DateTime.now();
      final startDateRaw = coupon['start_date'];
      final endDateRaw = coupon['end_date'];

      if (startDateRaw != null) {
        final startDate = DateTime.parse(startDateRaw as String);
        if (now.isBefore(startDate)) {
          throw Exception('Coupon is not yet valid');
        }
      }

      if (endDateRaw != null) {
        final endDate = DateTime.parse(endDateRaw as String);
        if (now.isAfter(endDate)) {
          throw Exception('Coupon has expired');
        }
      }

      final data = <String, dynamic>{
        'coupon_id': couponId,
        'customer_profile_id': customerProfileId,
        'salon_id': salonId,
      };
      if (transactionId != null && transactionId.isNotEmpty) {
        data['transaction_id'] = transactionId;
      }

      await _supabase.from('coupon_redemptions').insert(data);
    } catch (e) {
      throw Exception('Failed to create redemption: $e');
    }
  }

  /// Get redemption count for a coupon
  Future<int> getRedemptionCount(String couponId) async {
    try {
      final response = await _supabase
          .from('coupon_redemptions')
          .select('id')
          .eq('coupon_id', couponId)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      return 0;
    }
  }
}
