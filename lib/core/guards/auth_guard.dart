import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

/// Guard to check if user is authenticated
class AuthGuard {
  final Ref ref;

  AuthGuard(this.ref);

  /// Check if user is authenticated
  bool isAuthenticated() {
    final authService = ref.read(authServiceProvider);
    return authService.isAuthenticated;
  }

  /// Get current user or null
  User? getCurrentUser() {
    final authService = ref.read(authServiceProvider);
    return authService.currentUser;
  }

  /// Get redirect path based on authentication status and role
  String? getRedirectPath(String requestedPath) {
    final authService = ref.read(authServiceProvider);
    
    // Allow public routes
    final publicRoutes = ['/login', '/register', '/auth', '/booking', '/splash', '/auth/forgot-password'];
    if (publicRoutes.any((route) => requestedPath.startsWith(route))) {
      return null;
    }

    // Redirect to login if not authenticated
    if (!authService.isAuthenticated) {
      if (kDebugMode) {
        print('AuthGuard: Not authenticated, redirecting to /auth');
      }
      return '/auth';
    }

    // If authenticated and trying to access auth routes, redirect to dashboard
    if (publicRoutes.any((route) => requestedPath.startsWith(route))) {
      final user = authService.currentUser;
      if (user != null) {
        return _getDashboardPathForRole(user.role);
      }
    }

    return null;
  }

  String _getDashboardPathForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
      case UserRole.owner:
      case UserRole.manager:
        return '/admin';
      case UserRole.stylist:
      case UserRole.employee:
        return '/employee';
      case UserRole.customer:
        return '/customer';
    }
  }
}
