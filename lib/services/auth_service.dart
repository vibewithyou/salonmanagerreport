import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/activity_log_model.dart';
import '../core/auth/user_role_helpers.dart';
import '../features/auth/data/user_repository.dart';
import 'supabase_service.dart';

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

/// Authentication service
class AuthService {
  final Ref _ref;
  User? _currentUser;
  bool _isAuthenticated = false;

  AuthService(this._ref) {
    _initAuth();
  }

  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;

  Future<void> _initAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null && token.isNotEmpty) {
        // Validate token with backend
        await _validateToken(token);
      }
    } catch (e) {
      _isAuthenticated = false;
      _currentUser = null;
    }
  }

  Future<void> _validateToken(String token) async {
    try {
      final supabase = _ref.read(supabaseServiceProvider);
      final session = supabase.client.auth.currentSession;
      
      if (session != null) {
        // Build user from auth session and employee data
        _currentUser = await _buildUserFromSession(session.user);
        _isAuthenticated = true;
      }
    } catch (e) {
      _isAuthenticated = false;
      _currentUser = null;
    }
  }

  Future<User> _buildUserFromSession(dynamic authUser) async {
    final supabase = _ref.read(supabaseServiceProvider);
    final userRepository = _ref.read(userRepositoryProvider);
    final metadata = authUser.userMetadata ?? {};
    
    // Get user role from user_roles table via UserRepository
    UserRole role = UserRole.customer;
    String? salonId;
    
    try {
      final roleStr = await userRepository.fetchRole(authUser.id);
      if (roleStr != null) {
        role = userRoleFromString(roleStr) ?? UserRole.customer;
      }
    } catch (e) {
      print('Error fetching user role: $e');
      role = UserRole.customer;
    }

    try {
      final employeeData = await supabase.client
          .from('employees')
          .select('salon_id')
          .eq('user_id', authUser.id)
          .eq('is_active', true)
          .maybeSingle();

      if (employeeData != null) {
        salonId = employeeData['salon_id'] as String?;
      }

      if (salonId == null || salonId!.isEmpty) {
        final ownedSalons = await supabase.client
            .from('salons')
            .select('id')
            .eq('owner_id', authUser.id)
            .order('created_at', ascending: true);

        if (ownedSalons is List && ownedSalons.isNotEmpty) {
          salonId = (ownedSalons.first as Map<String, dynamic>)['id'] as String?;
        }
      }
    } catch (e) {
      print('Error fetching user salon context: $e');
    }
    
    return User(
      id: authUser.id,
      email: authUser.email ?? '',
      firstName: metadata['first_name'] as String?,
      lastName: metadata['last_name'] as String?,
      phone: metadata['phone'] as String?,
      avatar: metadata['avatar'] as String?,
      role: role,
      emailVerified: authUser.emailConfirmedAt != null,
      createdAt: DateTime.parse(authUser.createdAt),
      updatedAt: authUser.updatedAt != null ? DateTime.parse(authUser.updatedAt) : null,
      lastLogin: authUser.lastSignInAt != null ? DateTime.parse(authUser.lastSignInAt) : null,
      twoFactorEnabled: false,
      salonId: salonId,
      currentSalonId: salonId,
    );
  }

  Future<bool> login(String email, String password) async {
    try {
      final supabase = _ref.read(supabaseServiceProvider);
      final response = await supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null && response.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.session!.accessToken);
        
        // Build user from session data
        _currentUser = await _buildUserFromSession(response.user!);
        _isAuthenticated = true;
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
    String? salonName,
    String? phone,
  }) async {
    try {
      final supabase = _ref.read(supabaseServiceProvider);
      final response = await supabase.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          if (salonName != null) 'salon_name': salonName,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.session != null && response.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.session!.accessToken);
        
        // Build user from session data
        _currentUser = await _buildUserFromSession(response.user!);
        _isAuthenticated = true;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final supabase = _ref.read(supabaseServiceProvider);
      await supabase.client.auth.signOut();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      
      _currentUser = null;
      _isAuthenticated = false;
    } catch (e) {
      // Handle error
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      final supabase = _ref.read(supabaseServiceProvider);
      await supabase.client.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== CODE-BASED AUTHENTICATION ====================
  
  /// Login with Salon Code (for admin/owner/manager)
  Future<bool> loginWithSalonCode({
    required String salonId,
    required String salonCode,
    required String adminEmail,
    required String adminPassword,
  }) async {
    try {
      // First verify salon code
      final supabase = _ref.read(supabaseServiceProvider);
      final verifyResponse = await supabase.client.functions.invoke(
        'verify-salon-code',
        body: {'salon_id': salonId, 'code': salonCode},
      );

      if (verifyResponse.data == null || 
          !(verifyResponse.data as Map)['is_valid'] == true) {
        return false;
      }

      // Then verify email/password
      final authResponse = await supabase.client.auth.signInWithPassword(
        email: adminEmail,
        password: adminPassword,
      );

      if (authResponse.session != null && authResponse.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', authResponse.session!.accessToken);
        await prefs.setString('salon_code', salonCode);
        await prefs.setString('salon_id', salonId);
        
        // Build user from session
        _currentUser = await _buildUserFromSession(authResponse.user!);
        _isAuthenticated = true;

        // Log activity
        await _logActivity(
          salonId: salonId,
          userId: authResponse.user!.id,
          userName: adminEmail,
          type: ActivityType.adminLogin,
          description: 'Admin login with salon code',
        );

        return true;
      }
      return false;
    } catch (e) {
      print('Salon code login error: $e');
      return false;
    }
  }

  /// Login with Employee Time Code (for employees)
  Future<bool> loginWithEmployeeTimeCode({
    required String employeeCode,
  }) async {
    try {
      final supabase = _ref.read(supabaseServiceProvider);
      
      // Verify employee code
      final verifyResponse = await supabase.client.functions.invoke(
        'verify-employee-code',
        body: {'code': employeeCode},
      );

      if (verifyResponse.data == null || 
          !(verifyResponse.data as Map)['is_valid'] == true) {
        return false;
      }

      final responseData = verifyResponse.data as Map;
      final employeeId = responseData['employee_id'] as String?;
      final salonId = responseData['salon_id'] as String?;

      if (employeeId == null || salonId == null) {
        return false;
      }

      // Create ephemeral session for employee
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('employee_time_code', employeeCode);
      await prefs.setString('employee_id', employeeId);
      await prefs.setString('salon_id', salonId);

      // Build basic user model for employee
      _currentUser = User(
        id: employeeId,
        email: responseData['employee_email'] as String? ?? 'employee@salon.local',
        firstName: responseData['employee_name'] as String?,
        lastName: null,
        phone: null,
        avatar: null,
        role: UserRole.employee,
        emailVerified: true,
        createdAt: DateTime.now(),
        updatedAt: null,
        lastLogin: DateTime.now(),
        twoFactorEnabled: false,
        salonId: salonId,
        currentSalonId: salonId,
      );
      _isAuthenticated = true;

      // Log activity
      await _logActivity(
        salonId: salonId,
        userId: employeeId,
        userName: responseData['employee_name'] as String? ?? 'Employee',
        type: ActivityType.employeeLogin,
        description: 'Employee login with time code',
      );

      return true;
    } catch (e) {
      print('Employee code login error: $e');
      return false;
    }
  }

  /// Log activity to audit trail
  Future<void> _logActivity({
    required String salonId,
    required String userId,
    required String userName,
    required ActivityType type,
    required String description,
  }) async {
    try {
      final supabase = _ref.read(supabaseServiceProvider);
      await supabase.client.from('activity_logs').insert({
        'salon_id': salonId,
        'user_id': userId,
        'user_name': userName,
        'type': type.toString().split('.').last,
        'description': description,
        'timestamp': DateTime.now().toIso8601String(),
        'metadata': {
          'platform': 'flutter',
        },
      });
    } catch (e) {
      print('Activity log error: $e');
    }
  }

  /// Verify if current user has admin privileges
  bool get isAdmin => _currentUser?.role == UserRole.admin || 
                      _currentUser?.role == UserRole.owner ||
                      _currentUser?.role == UserRole.manager;

  /// Verify if current user is employee
  bool get isEmployee => _currentUser?.role == UserRole.employee || 
                         _currentUser?.role == UserRole.stylist;

  /// Verify if current user is customer
  bool get isCustomer => _currentUser?.role == UserRole.customer;
}
