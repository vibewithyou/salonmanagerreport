import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';

/// Loyalty repository provider
final loyaltyRepositoryProvider = Provider<LoyaltyRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return LoyaltyRepository(supabaseService.client);
});

/// Repository for loyalty and coupons
class LoyaltyRepository {
  final SupabaseClient _client;

  LoyaltyRepository(this._client);

  /// Get loyalty account for customer
  Future<LoyaltyAccount?> getCustomerLoyalty({
    required String salonId,
    required String customerId,
  }) async {
    try {
      final data = await _client
          .from('loyalty_accounts')
          .select()
          .eq('salon_id', salonId)
          .eq('customer_profile_id', customerId)
          .maybeSingle();

      if (data == null) return null;

      return LoyaltyAccount.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch loyalty account: $e');
    }
  }

  /// Create loyalty account
  Future<LoyaltyAccount> createLoyaltyAccount({
    required String salonId,
    required String customerId,
    double initialPoints = 0.0,
  }) async {
    try {
      final data = await _client.from('loyalty_accounts').insert({
        'salon_id': salonId,
        'customer_profile_id': customerId,
        'points_balance': initialPoints,
        'tier_level': 'bronze',
      }).select().single();

      return LoyaltyAccount.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create loyalty account: $e');
    }
  }

  /// Add points to loyalty account
  Future<void> addPoints({
    required String loyaltyId,
    required double points,
  }) async {
    try {
      final current = await _client
          .from('loyalty_accounts')
          .select('points_balance')
          .eq('id', loyaltyId)
          .single();

      final newBalance = (current['points_balance'] as num).toDouble() + points;

      await _client
          .from('loyalty_accounts')
          .update({'points_balance': newBalance})
          .eq('id', loyaltyId);
    } catch (e) {
      throw Exception('Failed to add points: $e');
    }
  }

  /// Redeem points
  Future<void> redeemPoints({
    required String loyaltyId,
    required double points,
  }) async {
    try {
      final current = await _client
          .from('loyalty_accounts')
          .select('points_balance')
          .eq('id', loyaltyId)
          .single();

      final balance = (current['points_balance'] as num).toDouble();

      if (balance < points) {
        throw Exception('Insufficient points balance');
      }

      final newBalance = balance - points;

      await _client
          .from('loyalty_accounts')
          .update({'points_balance': newBalance})
          .eq('id', loyaltyId);
    } catch (e) {
      throw Exception('Failed to redeem points: $e');
    }
  }

  /// Get all coupons for salon
  Future<List<Coupon>> getSalonCoupons(String salonId) async {
    try {
      final data = await _client
          .from('coupons')
          .select()
          .eq('salon_id', salonId)
          .eq('is_active', true);

      return (data as List)
          .map((json) => Coupon.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch coupons: $e');
    }
  }

  /// Get active coupons for salon (valid date range)
  Future<List<Coupon>> getActiveCoupons(String salonId) async {
    try {
      final now = DateTime.now();
      final data = await _client
          .from('coupons')
          .select()
          .eq('salon_id', salonId)
          .eq('is_active', true)
          .lte('start_date', now.toIso8601String())
          .gte('end_date', now.toIso8601String());

      return (data as List)
          .map((json) => Coupon.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch active coupons: $e');
    }
  }

  /// Validate coupon code
  Future<Coupon?> validateCoupon({
    required String salonId,
    required String code,
  }) async {
    try {
      final data = await _client
          .from('coupons')
          .select()
          .eq('salon_id', salonId)
          .eq('code', code.toUpperCase())
          .eq('is_active', true)
          .maybeSingle();

      if (data == null) return null;

      final coupon = Coupon.fromJson(data);

      // Check date validity
      final now = DateTime.now();
      if (coupon.startDate != null && now.isBefore(coupon.startDate!)) {
        return null; // Not yet valid
      }
      if (coupon.endDate != null && now.isAfter(coupon.endDate!)) {
        return null; // Expired
      }

      return coupon;
    } catch (e) {
      throw Exception('Failed to validate coupon: $e');
    }
  }

  /// Create coupon
  Future<Coupon> createCoupon({
    required String salonId,
    required String code,
    required String discountType,
    required double discountValue,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    double? minPoints,
    List<String>? targetTags,
  }) async {
    try {
      final data = await _client.from('coupons').insert({
        'salon_id': salonId,
        'code': code.toUpperCase(),
        'title': title,
        'description': description,
        'discount_type': discountType,
        'discount_value': discountValue,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'min_points': minPoints,
        'target_tags': targetTags,
        'is_active': true,
      }).select().single();

      return Coupon.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create coupon: $e');
    }
  }

  /// Redeem coupon
  Future<void> redeemCoupon({
    required String couponId,
    required String customerId,
    required String salonId,
  }) async {
    try {
      await _client.from('coupon_redemptions').insert({
        'coupon_id': couponId,
        'customer_profile_id': customerId,
        'salon_id': salonId,
        'redeemed_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to redeem coupon: $e');
    }
  }
}

/// Loyalty account model
class LoyaltyAccount {
  final String id;
  final String salonId;
  final String customerId;
  final double pointsBalance;
  final String? tierLevel;
  final DateTime createdAt;

  LoyaltyAccount({
    required this.id,
    required this.salonId,
    required this.customerId,
    required this.pointsBalance,
    this.tierLevel,
    required this.createdAt,
  });

  factory LoyaltyAccount.fromJson(Map<String, dynamic> json) {
    return LoyaltyAccount(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      customerId: json['customer_profile_id'] as String? ?? '',
      pointsBalance: (json['points_balance'] as num?)?.toDouble() ?? 0.0,
      tierLevel: json['tier_level'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}

/// Coupon model
class Coupon {
  final String id;
  final String salonId;
  final String code;
  final String? title;
  final String? description;
  final String discountType; // 'percentage' or 'fixed'
  final double discountValue;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minPoints;
  final List<String>? targetTags;
  final bool isActive;
  final String? createdBy;
  final DateTime createdAt;

  Coupon({
    required this.id,
    required this.salonId,
    required this.code,
    this.title,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.startDate,
    this.endDate,
    this.minPoints,
    this.targetTags,
    required this.isActive,
    this.createdBy,
    required this.createdAt,
  });

  bool get isExpired => endDate != null && DateTime.now().isAfter(endDate!);
  bool get isPercentage => discountType == 'percentage';
  bool get isFixed => discountType == 'fixed';

  double calculateDiscount(double amount) {
    if (isPercentage) {
      return amount * (discountValue / 100);
    } else {
      return discountValue;
    }
  }

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      title: json['title'] as String?,
      description: json['description'] as String?,
      discountType: json['discount_type'] as String? ?? 'percentage',
      discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date'] as String) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date'] as String) : null,
      minPoints: (json['min_points'] as num?)?.toDouble(),
      targetTags: (json['target_tags'] as List?)?.cast<String>(),
      isActive: json['is_active'] as bool? ?? true,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}
