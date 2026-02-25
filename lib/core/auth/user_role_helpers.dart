import '../../models/user_model.dart';

/// Extension on UserRole to safely get string representation
extension UserRoleX on UserRole {
  /// Get the string key for this role (e.g. 'admin', 'customer')
  String get key {
    switch (this) {
      case UserRole.customer:
        return 'customer';
      case UserRole.employee:
        return 'employee';
      case UserRole.stylist:
        return 'stylist';
      case UserRole.manager:
        return 'manager';
      case UserRole.admin:
        return 'admin';
      case UserRole.owner:
        return 'owner';
    }
  }

  /// Check if this is an admin-level role (owner, admin, manager)
  bool get isAdmin {
    return this == UserRole.owner ||
        this == UserRole.admin ||
        this == UserRole.manager;
  }

  /// Check if this is an employee role (employee, stylist, manager, admin, owner)
  bool get isEmployee {
    return this == UserRole.employee ||
        this == UserRole.stylist ||
        this == UserRole.manager ||
        this == UserRole.admin ||
        this == UserRole.owner;
  }

  /// Get the home route for this role
  String get homeRoute {
    if (isAdmin) {
      return '/admin';
    } else if (this == UserRole.employee || this == UserRole.stylist) {
      return '/employee';
    } else {
      return '/customer';
    }
  }

  /// Get the display name for this role (German)
  String get displayName {
    switch (this) {
      case UserRole.customer:
        return 'Kunde';
      case UserRole.employee:
        return 'Mitarbeiter';
      case UserRole.stylist:
        return 'Stylist';
      case UserRole.manager:
        return 'Leitung';
      case UserRole.admin:
        return 'Admin';
      case UserRole.owner:
        return 'Saloninhaber';
    }
  }
}

/// Convert string from Supabase to UserRole
/// Maps: customer→customer, salon_owner/owner→owner, admin→admin, stylist→stylist, employee/stylist→employee
UserRole? userRoleFromString(String? value) {
  if (value == null) return null;
  
  final normalizedRole = value.toLowerCase().trim();
  
  // Map Supabase string values to UserRole enum
  switch (normalizedRole) {
    case 'customer':
      return UserRole.customer;
    case 'salon_owner':
    case 'owner':
      return UserRole.owner;
    case 'admin':
      return UserRole.admin;
    case 'stylist':
      return UserRole.stylist;
    case 'employee':
      return UserRole.employee;
    case 'manager':
      return UserRole.manager;
    default:
      return UserRole.customer; // Default to customer for unknown roles
  }
}

/// Get role from employee position string
UserRole getRoleFromPosition(String? position) {
  if (position == null) return UserRole.employee;
  
  final lowerPosition = position.toLowerCase();
  
  if (lowerPosition.contains('inhaber') || lowerPosition.contains('owner')) {
    return UserRole.owner;
  } else if (lowerPosition.contains('admin')) {
    return UserRole.admin;
  } else if (lowerPosition.contains('manager') || lowerPosition.contains('leitung')) {
    return UserRole.manager;
  } else if (lowerPosition.contains('stylist')) {
    return UserRole.stylist;
  } else {
    return UserRole.employee;
  }
}

// ============================================================================
// STRING-BASED ROLE HELPERS (for role-key strings from DB)
// ============================================================================

/// Normalize a role key from database (handles variations like salon_owner → owner)
String normalizeRoleKey(String? roleKey) {
  if (roleKey == null) return 'customer';
  
  final normalized = roleKey.toLowerCase().trim();
  
  // Map common variations to canonical keys
  switch (normalized) {
    case 'salon_owner':
      return 'owner';
    case 'platform_admin':
      return 'admin';
    default:
      return normalized;
  }
}

/// Check if a role key represents an admin-level role
/// Returns true for: admin, owner, manager, salon_owner, platform_admin
bool isAdminRole(String? roleKey) {
  if (roleKey == null) return false;
  
  final normalized = normalizeRoleKey(roleKey);
  
  return normalized == 'admin' ||
      normalized == 'owner' ||
      normalized == 'manager';
}

/// Get the home route for a given role key
/// - Admin roles (admin/owner/manager) → /admin
/// - Employee roles (stylist/employee) → /employee
/// - Customer → /customer
/// - Unknown → /entry
String homeRouteForRole(String? roleKey) {
  print('\n========================================');
  print('[Routing] 🎯 homeRouteForRole() called');
  print('[Routing] Input roleKey: "$roleKey"');
  
  if (roleKey == null) {
    print('[Routing] ⚠️ roleKey is NULL');
    print('[Routing] → Returning: /entry');
    print('========================================\n');
    return '/entry';
  }
  
  final normalized = normalizeRoleKey(roleKey);
  print('[Routing] Normalized: "$normalized"');
  
  String route;
  if (isAdminRole(normalized)) {
    route = '/admin';
    print('[Routing] ✅ Admin role detected');
  } else if (normalized == 'stylist' || normalized == 'employee') {
    route = '/employee';
    print('[Routing] ✅ Employee role detected');
  } else if (normalized == 'customer') {
    route = '/customer';
    print('[Routing] ✅ Customer role detected');
  } else {
    route = '/entry';
    print('[Routing] ⚠️ Unknown role');
  }
  
  print('[Routing] → Returning: $route');
  print('========================================\n');
  return route;
}

/// Check if a role key represents an employee-level role (includes admin roles)
bool isEmployeeRole(String? roleKey) {
  if (roleKey == null) return false;
  
  final normalized = normalizeRoleKey(roleKey);
  
  return normalized == 'employee' ||
      normalized == 'stylist' ||
      normalized == 'manager' ||
      normalized == 'admin' ||
      normalized == 'owner';
}

/// Get display name for role key (German)
String roleDisplayName(String? roleKey) {
  if (roleKey == null) return 'Unbekannt';
  
  final normalized = normalizeRoleKey(roleKey);
  
  switch (normalized) {
    case 'customer':
      return 'Kunde';
    case 'employee':
      return 'Mitarbeiter';
    case 'stylist':
      return 'Stylist';
    case 'manager':
      return 'Leitung';
    case 'admin':
      return 'Admin';
    case 'owner':
      return 'Saloninhaber';
    default:
      return 'Unbekannt';
  }
}
