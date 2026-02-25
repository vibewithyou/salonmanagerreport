import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

/// Guard to check user roles and permissions
class RoleGuard {
  final Ref ref;

  RoleGuard(this.ref);

  /// Check if user has required role
  bool hasRole(UserRole requiredRole) {
    final authService = ref.read(authServiceProvider);
    final user = authService.currentUser;
    
    if (user == null) return false;
    
    return user.role == requiredRole;
  }

  /// Check if user has any of the required roles
  bool hasAnyRole(List<UserRole> requiredRoles) {
    final authService = ref.read(authServiceProvider);
    final user = authService.currentUser;
    
    if (user == null) return false;
    
    return requiredRoles.contains(user.role);
  }

  /// Check if user is admin or manager
  bool isAdminOrManager() {
    return hasAnyRole([UserRole.admin, UserRole.owner, UserRole.manager]);
  }

  /// Check if user is employee (stylist or employee)
  bool isEmployee() {
    return hasAnyRole([UserRole.stylist, UserRole.employee]);
  }

  /// Check if user is customer
  bool isCustomer() {
    return hasRole(UserRole.customer);
  }

  /// Get redirect path if user doesn't have required role
  String? checkRoleAccess(String requestedPath, List<UserRole> allowedRoles) {
    final authService = ref.read(authServiceProvider);
    final user = authService.currentUser;
    
    if (user == null) {
      if (kDebugMode) {
        print('RoleGuard: No user found, redirecting to /auth');
      }
      return '/auth';
    }

    if (!allowedRoles.contains(user.role)) {
      if (kDebugMode) {
        print('RoleGuard: User role ${user.role} not allowed for $requestedPath');
      }
      
      // Redirect to appropriate dashboard
      switch (user.role) {
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

    return null;
  }
}
