import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/supabase_service.dart';

/// Salon data model
class SalonInfo {
  final String id;
  final String name;

  SalonInfo({required this.id, required this.name});

  factory SalonInfo.fromJson(Map<String, dynamic> json) {
    return SalonInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed Salon',
    );
  }
}

/// Identity state representing the current user's role and salon context
class IdentityState {
  final bool loading;
  final String? userId;
  final String? roleKey;
  final String? currentSalonId;
  final List<SalonInfo> availableSalons; // ← NEU: Liste aller Salons
  final String? error;

  const IdentityState({
    this.loading = false,
    this.userId,
    this.roleKey,
    this.currentSalonId,
    this.availableSalons = const [],
    this.error,
  });

  IdentityState copyWith({
    bool? loading,
    String? userId,
    String? roleKey,
    String? currentSalonId,
    List<SalonInfo>? availableSalons,
    String? error,
  }) {
    return IdentityState(
      loading: loading ?? this.loading,
      userId: userId ?? this.userId,
      roleKey: roleKey ?? this.roleKey,
      currentSalonId: currentSalonId ?? this.currentSalonId,
      availableSalons: availableSalons ?? this.availableSalons,
      error: error ?? this.error,
    );
  }

  bool get isIdentified => roleKey != null && userId != null;
}

/// Identity Provider - Manages user identity loading from Supabase
class IdentityNotifier extends StateNotifier<IdentityState> {
  final Ref _ref;
  bool _initialized = false;

  IdentityNotifier(this._ref) : super(const IdentityState()) {
    _initializeIdentity();
  }

  /// Initialize identity on app start if user is authenticated
  Future<void> _initializeIdentity() async {
    if (_initialized) return;
    _initialized = true;

    // Wait a bit for Supabase to restore session
    await Future.delayed(const Duration(milliseconds: 500));

    final supabase = _ref.read(supabaseServiceProvider);
    final authUser = supabase.client.auth.currentUser;

    if (authUser != null) {
      print('[Identity] User session found on app start, loading identity');
      await loadIdentity();
    } else {
      print('[Identity] No user session on app start');
    }
  }

  /// Load user identity from Supabase DB (EXACTLY like React UserRoleContext)
  /// 
  /// React reference: UserRoleContext.tsx - resolveRole()
  /// Query: supabase.from('user_roles').select('role').eq('user_id', user.id).maybeSingle()
  /// Default: 'customer' if no role found
  Future<void> loadIdentity() async {
    final supabase = _ref.read(supabaseServiceProvider);
    final authUser = supabase.client.auth.currentUser;

    if (authUser == null) {
      print('[Identity] No auth user found, clearing identity');
      state = const IdentityState(loading: false);
      return;
    }

    print('[Identity] Loading identity for user: ${authUser.id}');
    state = state.copyWith(loading: true, userId: authUser.id);

    try {
      // EXACT MATCH to React: from('user_roles').select('role').eq('user_id', user.id)
      final roleKey = await fetchRoleKeyFromDb(authUser.id);
      print('[Identity] ROLE(DB) = $roleKey for ${authUser.id}');

      // Fetch current salon ID and all available salons if user is not customer
      String? salonId;
      List<SalonInfo> salons = [];
      
      if (roleKey != 'customer') {
        final result = await _fetchAllSalonsForUser(authUser.id, roleKey);
        salons = result['salons'] as List<SalonInfo>;
        salonId = result['currentSalonId'] as String?;
        print('[Identity] Available Salons = ${salons.length}');
        print('[Identity] Current Salon ID = $salonId');
      }

      state = IdentityState(
        loading: false,
        userId: authUser.id,
        roleKey: roleKey,
        currentSalonId: salonId,
        availableSalons: salons,
      );
    } catch (e) {
      print('[Identity] ERROR loading identity: $e');
      state = IdentityState(
        loading: false,
        userId: authUser.id,
        error: e.toString(),
      );
    }
  }

  /// Fetch role key from Supabase DB
  /// TABLE: user_roles
  /// COLUMN: role
  /// QUERY: SELECT role FROM user_roles WHERE user_id = :userId
  /// 
  /// Returns: "admin", "manager", "stylist", "customer", etc.
  /// EXACTLY like React: supabase.from('user_roles').select('role').eq('user_id', user.id).maybeSingle()
  Future<String> fetchRoleKeyFromDb(String userId) async {
    final supabase = _ref.read(supabaseServiceProvider);

    print('\n========================================');
    print('[Identity] 🔍 Fetching role from user_roles');
    print('[Identity] User ID: $userId');
    print('========================================');

    try {
      // Query ALL columns first to see what we get
      final response = await supabase.client
          .from('user_roles')
          .select('*')
          .eq('user_id', userId)
          .maybeSingle();

      print('[Identity] 📦 Raw DB Response:');
      print('[Identity] ${response.toString()}');

      if (response == null) {
        // React default: if no role found, default to 'customer'
        print('[Identity] ❌ No user_roles entry found');
        print('[Identity] ✅ Defaulting to: customer');
        print('========================================\n');
        return 'customer';
      }

      // Extract role from response
      final roleKey = response['role'] as String?;
      
      print('[Identity] 📋 Extracted Fields:');
      print('[Identity]   user_id: ${response['user_id']}');
      print('[Identity]   role: $roleKey');
      print('[Identity]   salon_id: ${response['salon_id'] ?? 'null'}');
      
      if (roleKey == null || roleKey.isEmpty) {
        print('[Identity] ⚠️ Role is null/empty');
        print('[Identity] ✅ Defaulting to: customer');
        print('========================================\n');
        return 'customer';
      }

      print('[Identity] ✅ Role found: "$roleKey"');
      print('[Identity]   Length: ${roleKey.length}');
      print('[Identity]   Lowercase: "${roleKey.toLowerCase()}"');
      print('========================================\n');
      return roleKey;
      
    } catch (e, stackTrace) {
      print('[Identity] ❌ ERROR fetching role:');
      print('[Identity] $e');
      print('[Identity] Stack trace:');
      print(stackTrace);
      print('[Identity] ✅ Defaulting to: customer');
      print('========================================\n');
      return 'customer';
    }
  }

  /// Fetch all salons for user based on their role
  /// Returns: {'salons': List<SalonInfo>, 'currentSalonId': String?}
  Future<Map<String, dynamic>> _fetchAllSalonsForUser(
    String userId,
    String roleKey,
  ) async {
    final supabase = _ref.read(supabaseServiceProvider);

    print('[Identity] 🏪 Fetching all salons for role: $roleKey');

    if (roleKey == 'admin' || roleKey == 'owner') {
      print('[Identity] → Checking salons table (owner lookup)');
      // Admin/Owner: get ALL salons they own
      final response = await supabase.client
          .from('salons')
          .select('id, name')
          .eq('owner_id', userId)
          .order('created_at', ascending: true);

      final salons = (response as List)
          .map((e) => SalonInfo.fromJson(e as Map<String, dynamic>))
          .toList();

      final currentSalonId = salons.isNotEmpty ? salons.first.id : null;
      print('[Identity] → Found ${salons.length} salons');
      print('[Identity] → Current salon ID: ${currentSalonId ?? "null"}');

      return {
        'salons': salons,
        'currentSalonId': currentSalonId,
      };
    } else if (roleKey == 'stylist' || roleKey == 'employee') {
      print('[Identity] → Checking employees table');
      // Employee: get salon from employees table
      final response = await supabase.client
          .from('employees')
          .select('salon_id, salons(id, name)')
          .eq('user_id', userId)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) {
        print('[Identity] → No employee record found');
        return {'salons': <SalonInfo>[], 'currentSalonId': null};
      }

      final salonId = response['salon_id'] as String?;
      final salonData = response['salons'] as Map<String, dynamic>?;

      if (salonId != null && salonData != null) {
        final salon = SalonInfo.fromJson(salonData);
        print('[Identity] → Found salon: ${salon.name}');
        return {
          'salons': [salon],
          'currentSalonId': salonId,
        };
      }

      return {'salons': <SalonInfo>[], 'currentSalonId': null};
    }

    print('[Identity] → No salon lookup needed for role: $roleKey');
    return {'salons': <SalonInfo>[], 'currentSalonId': null};
  }

  /// Change current salon (for switching between owned salons)
  void setSalonId(String salonId) {
    state = state.copyWith(currentSalonId: salonId);
  }

  /// Clear identity (on logout)
  void clear() {
    state = const IdentityState(loading: false);
  }
}

/// Provider for identity state
final identityProvider = StateNotifierProvider<IdentityNotifier, IdentityState>((ref) {
  return IdentityNotifier(ref);
});
