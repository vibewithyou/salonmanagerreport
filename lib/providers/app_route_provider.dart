import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'auth_provider.dart';

/// Bestimmt, zu welchem Screen der Benutzer weitergeleitet werden soll
enum AppRoute {
  splash,
  entry,
  customerDashboard,
  employeeDashboard,
  adminDashboard,
  bookingWizard,
}

/// Provider, der die richtige Route basierend auf Auth-State und Rolle bestimmt
final appRouteProvider = StreamProvider<AppRoute>((ref) async* {
  final supabaseService = ref.watch(supabaseServiceProvider);
  
  // Nutze die authStateChanges Stream vom SupabaseService
  await for (final user in supabaseService.authStateChanges) {
    // Benutzer nicht angemeldet -> Entry Screen (nicht Splash, damit man wählen kann)
    if (user == null) {
      debugPrint('[Router] User logged out -> Entry Screen');
      yield AppRoute.entry;
    } else {
      debugPrint('[Router] User authenticated: ${user.id}');
      
      // Benutzer angemeldet -> Lade Profil und bestimme Rolle
      try {
        final profile = await supabaseService.getUserProfile(user.id);
        
        if (profile == null) {
          debugPrint('[Router] Profile not found for user ${user.id} -> Entry Screen');
          yield AppRoute.entry;
          continue;
        }

        final roleString = profile['role'] as String?;
        final role = _parseRole(roleString);
        
        debugPrint('[Router] User role determined: $role (raw: $roleString)');

        switch (role) {
          case UserRole.customer:
            debugPrint('[Router] Routing to Customer Dashboard');
            yield AppRoute.customerDashboard;
            break;
          case UserRole.employee:
          case UserRole.stylist:
            debugPrint('[Router] Routing to Employee Dashboard');
            yield AppRoute.employeeDashboard;
            break;
          case UserRole.admin:
          case UserRole.owner:
          case UserRole.manager:
            debugPrint('[Router] Routing to Admin Dashboard');
            yield AppRoute.adminDashboard;
            break;
        }
      } catch (e, stackTrace) {
        debugPrint('[Router] Error loading profile: $e');
        debugPrintStack(stackTrace: stackTrace);
        // Fehler beim Laden des Profils -> Entry Screen
        yield AppRoute.entry;
      }
    }
  }
});

UserRole _parseRole(String? role) {
  switch (role?.toLowerCase()) {
    case 'employee':
      return UserRole.employee;
    case 'admin':
      return UserRole.admin;
    case 'owner':
      return UserRole.owner;
    default:
      return UserRole.customer;
  }
}

