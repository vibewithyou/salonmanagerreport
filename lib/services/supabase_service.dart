import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/config/supabase_config.dart';

/// Supabase service provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  SupabaseService._internal();

  factory SupabaseService() => _instance;

  SupabaseClient get client => Supabase.instance.client;
  User? get currentUser => client.auth.currentUser;

  /// Initialize Supabase
  Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
    } catch (e) {
      throw Exception('Failed to initialize Supabase: $e');
    }
  }

  /// Sign in with email and password (with optional Remember Me feature)
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final maskedEmail = _maskEmail(email);
    log('Auth sign-in started for $maskedEmail (rememberMe=$rememberMe)', name: 'SupabaseService');
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      log(
        'Auth sign-in success for $maskedEmail (userId=${response.user?.id ?? 'null'})',
        name: 'SupabaseService',
      );

      // If user enabled "Remember Me", save the session
      if (rememberMe && response.session != null) {
        await _saveRememberMeSession(email, response.session!);
      }

      return response;
    } catch (e, stackTrace) {
      log(
        'Auth sign-in failed for $maskedEmail',
        name: 'SupabaseService',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Save Remember Me session to SharedPreferences
  Future<void> _saveRememberMeSession(String email, Session session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expiryDate = DateTime.now().add(const Duration(days: 30));
      
      await prefs.setString('remember_me_email', email);
      await prefs.setString('remember_me_token', session.accessToken);
      await prefs.setString('remember_me_refresh', session.refreshToken ?? '');
      await prefs.setString('remember_me_expiry', expiryDate.toIso8601String());
      
      log('Remember Me session saved for ${_maskEmail(email)}', name: 'SupabaseService');
    } catch (e) {
      log('Failed to save Remember Me session', name: 'SupabaseService', error: e);
    }
  }

  /// Check and restore Remember Me session on app startup
  Future<bool> restoreRememberMeSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('remember_me_email');
      final accessToken = prefs.getString('remember_me_token');
      final expiryStr = prefs.getString('remember_me_expiry');

      // If any required value is missing or expiry date has passed, return false
      if (email == null || accessToken == null || expiryStr == null) {
        return false;
      }

      final expiryDate = DateTime.parse(expiryStr);
      if (DateTime.now().isAfter(expiryDate)) {
        // Expiry date has passed - clear the session
        await clearRememberMe();
        log('Remember Me session expired for ${_maskEmail(email)}', name: 'SupabaseService');
        return false;
      }

      // Session is still valid - user will be auto-logged in by Supabase
      // because the token is still in SharedPreferences
      log('Remember Me session valid for ${_maskEmail(email)}', name: 'SupabaseService');
      return true;
    } catch (e) {
      log('Failed to restore Remember Me session', name: 'SupabaseService', error: e);
      return false;
    }
  }

  /// Clear Remember Me session
  Future<void> clearRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('remember_me_email');
      await prefs.remove('remember_me_token');
      await prefs.remove('remember_me_refresh');
      await prefs.remove('remember_me_expiry');
      log('Remember Me session cleared', name: 'SupabaseService');
    } catch (e) {
      log('Failed to clear Remember Me session', name: 'SupabaseService', error: e);
    }
  }

  /// Check if Remember Me session exists
  Future<bool> hasRememberMeSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('remember_me_email') != null;
    } catch (e) {
      return false;
    }
  }

  /// Sign up with email and password (via Edge Function send-auth-email)
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final maskedEmail = _maskEmail(email);
    log(
      'Auth sign-up started for $maskedEmail (firstName=${_maskName(firstName)}, lastName=${_maskName(lastName)})',
      name: 'SupabaseService',
    );
    try {
      final response = await client.functions.invoke(
        'send-auth-email',
        body: {
          'type': 'signup',
          'email': email,
          'password': password,
          'name': '$firstName $lastName'.trim(),
          'language': 'de',
          'data': {'first_name': firstName, 'last_name': lastName},
        },
      );

      final status = response.status;
      if (status < 200 || status >= 300) {
        throw Exception('Edge function failed with status $status');
      }
      final data = response.data;
      if (data is Map && data['error'] != null) {
        throw Exception('Edge function error: ${data['error']}');
      }

      log('Auth sign-up email sent for $maskedEmail', name: 'SupabaseService');
    } catch (e, stackTrace) {
      log(
        'Auth sign-up failed for $maskedEmail',
        name: 'SupabaseService',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to sign up: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await clearRememberMe(); // Clear Remember Me session on logout
      await client.auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Reset password (via Edge Function send-auth-email)
  Future<void> resetPassword(String email) async {
    final maskedEmail = _maskEmail(email);
    try {
      final response = await client.functions.invoke(
        'send-auth-email',
        body: {'type': 'recovery', 'email': email, 'language': 'de'},
      );

      final status = response.status;
      if (status < 200 || status >= 300) {
        throw Exception('Edge function failed with status $status');
      }
      final data = response.data;
      if (data is Map && data['error'] != null) {
        throw Exception('Edge function error: ${data['error']}');
      }
      log('Auth recovery email sent for $maskedEmail', name: 'SupabaseService');
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  /// Get current user profile with role from user_roles table
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await client
          .from('user_roles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await client.from('profiles').update(data).eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Upload file to Supabase Storage
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required dynamic file,
  }) async {
    try {
      await client.storage.from(bucket).upload(path, file);
      final publicUrl = client.storage.from(bucket).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Delete file from Supabase Storage
  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      await client.storage.from(bucket).remove([path]);
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Listen to auth state changes - only SIGNED_IN and SIGNED_OUT events
  Stream<User?> get authStateChanges {
    return client.auth.onAuthStateChange
        .where((event) => 
            event.event == AuthChangeEvent.signedIn || 
            event.event == AuthChangeEvent.signedOut ||
            event.event == AuthChangeEvent.initialSession)
        .map((event) => event.session?.user);
  }

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Get user ID
  String? get userId => currentUser?.id;

  /// Get user email
  String? get userEmail => currentUser?.email;

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) {
      return '***';
    }
    final name = parts.first;
    final domain = parts.last;
    final maskedName = name.isEmpty
        ? '***'
        : name.length <= 2
        ? '${name[0]}***'
        : '${name.substring(0, 2)}***';
    return '$maskedName@$domain';
  }

  String _maskName(String name) {
    if (name.isEmpty) {
      return '***';
    }
    if (name.length == 1) {
      return '${name[0]}***';
    }
    return '${name.substring(0, 1)}***';
  }
}
