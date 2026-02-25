import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

/// Guard to check if user has selected a salon
class SalonGuard {
  final Ref ref;

  SalonGuard(this.ref);

  /// Check if user has selected a salon
  bool hasSalonSelected() {
    final authService = ref.read(authServiceProvider);
    final user = authService.currentUser;
    
    if (user == null) return false;
    
    // Customers don't need salon selection
    if (user.role == UserRole.customer) return true;
    
    // Admin, Manager, Employee need salon selection
    return user.currentSalonId != null && user.currentSalonId!.isNotEmpty;
  }

  /// Get redirect path if salon is not selected
  String? checkSalonAccess(String requestedPath) {
    final authService = ref.read(authServiceProvider);
    final user = authService.currentUser;
    
    if (user == null) return '/auth';
    
    // Skip salon check for customers and public routes
    if (user.role == UserRole.customer) return null;
    
    final salonRequiredRoutes = [
      '/admin',
      '/employee',
      '/inventory',
      '/pos',
      '/reports',
      '/gallery',
      '/calendar',
      '/schedule',
    ];
    
    // Check if requested path requires salon
    final requiresSalon = salonRequiredRoutes.any(
      (route) => requestedPath.startsWith(route),
    );
    
    if (requiresSalon && !hasSalonSelected()) {
      if (kDebugMode) {
        print('SalonGuard: No salon selected, redirecting to /select-salon');
      }
      return '/select-salon';
    }
    
    return null;
  }
}
