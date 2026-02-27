import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth
import '../../features/auth/presentation/entry_screen_new.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_choice_screen.dart';
import '../../features/auth/presentation/register_customer_screen.dart';
import '../../features/auth/presentation/register_owner_screen.dart';
import '../../features/auth/presentation/invite_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/role_loading_screen.dart';
import '../../features/onboarding/presentation/splash_screen.dart';

// Dashboards
import '../../features/admin/dashboard/admin_dashboard_screen.dart';
import '../../features/employee/presentation/employee_dashboard_screen.dart';
import '../../features/dashboard/presentation/customer_dashboard_screen.dart';

// Features
import '../../features/booking/presentation/booking_wizard_screen_complete.dart';
import '../../features/booking/presentation/salon_map_screen.dart';
import '../../features/booking/presentation/salon_map_search_screen.dart';
import '../../features/booking/presentation/salon_list_search_screen.dart';
import '../../features/booking/presentation/guest_booking_screen.dart';
import '../../features/booking/presentation/availability_picker_screen.dart';
import '../../features/booking/presentation/employee_selection_screen.dart';
import '../../features/gallery/presentation/gallery_screen.dart';
import '../../features/customer/presentation/crm_dashboard_screen.dart';
import '../../features/settings/presentation/security_privacy_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/salon/presentation/salon_selection_screen.dart';
import '../../features/salon/presentation/salon_setup_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/loyalty/presentation/loyalty_levels_screen.dart';
import '../../features/employee/presentation/employee_management_screen.dart';
import '../../features/inventory/presentation/inventory_screen.dart';
import '../../features/pos/presentation/pos_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/coupons/presentation/coupons_screen.dart';
import '../../features/chat/chat.dart';  // Chat Module
import 'feature_in_progress_screen.dart';

// Core
import '../../services/auth_service.dart';
import '../navigation/app_shell.dart';
import '../auth/user_role_helpers.dart';
import '../auth/identity_provider.dart';
import 'router_refresh_notifier.dart';

const String kAdminPrimaryPath = '/admin';

/// Router configuration provider with guards
final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(routerRefreshNotifierProvider);

  print('[RouterProvider] Creating router (one-time setup)');

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,  // ← This makes router re-evaluate redirects!
    redirect: (context, state) {
      final location = state.matchedLocation;

      String? redirectTo(String target) {
        if (location == target) {
          return null;
        }
        return target;
      }
      
      // Get current auth and identity state from ProviderContainer
      final container = ProviderScope.containerOf(context);
      final authService = container.read(authServiceProvider);
      final identity = container.read(identityProvider);
      
      final isAuth = authService.isAuthenticated;
      final user = authService.currentUser;
      final identityLoading = identity.loading;
      final roleKey = identity.roleKey;

      // Debug logging
      print('\n========================================');
      print('[Router] 🔄 REDIRECT CHECK');
      print('[Router] Location: $location');
      print('[Router] Authenticated: $isAuth');
      print('[Router] User: ${user?.email ?? "null"}');
      print('[Router] Identity Loading: $identityLoading');
      print('[Router] Role Key: "$roleKey"');
      print('========================================');

      // Public routes - no auth required
      final publicRoutes = [
        '/splash',
        '/entry',
        '/login',
        '/register',
        '/register/customer',
        '/register/owner',
        '/invite',
        '/booking/guest',
        '/auth/forgot-password',
      ];

      final adminOnlyPrefixes = [
        kAdminPrimaryPath,
        '/crm',
        '/employees',
        '/suppliers',
        '/service-consumption',
        '/loyalty-settings',
        '/coupons',
        '/closures',
      ];

      final staffOnlyPrefixes = [
        '/employee',
        '/inventory',
        '/pos',
        '/reports',
        '/schedule',
      ];

      final customerOnlyPrefixes = [
        '/customer',
        '/loyalty',
      ];

      final salonRequiredPrefixes = [
        kAdminPrimaryPath,
        '/employee',
        '/inventory',
        '/pos',
        '/reports',
        '/calendar',
        '/schedule',
        '/employees',
        '/suppliers',
        '/service-consumption',
        '/loyalty-settings',
        '/closures',
      ];

      // Role-loading screen - redirect when identity is ready
      if (location == '/role-loading') {
        if (!isAuth || user == null) {
          return redirectTo('/entry');
        }

        // If authenticated AND identity finished loading AND we have a valid role
        if (isAuth && !identityLoading) {
          final targetRoute = homeRouteForRole(roleKey);
          print('[Router] ✅ Identity loaded on /role-loading, redirecting to $targetRoute');
          print('========================================\n');
          return redirectTo(targetRoute);
        }
        // Still loading or no auth - stay on role-loading
        return null;
      }

      // If on public route
      if (publicRoutes.any((route) => location.startsWith(route))) {
        // If authenticated and trying to access auth screens OR splash
        if (isAuth && user != null && 
            (location.startsWith('/login') || 
             location.startsWith('/register') || 
             location == '/entry' ||
             location == '/splash')) {  // ← Added splash check
          // BLOCKING: If identity is still loading, go to loading screen
          if (identityLoading) {
            print('[Router] ⏳ Identity loading, showing /role-loading');
            print('========================================\n');
            return redirectTo('/role-loading');
          }
          
          // If role not loaded, stay on entry (error state)
          if (roleKey == null || roleKey == 'unknown') {
            print('[Router] ❌ Role unknown/null after loading, staying on /entry');
            print('========================================\n');
            return redirectTo('/entry');
          }
          
          // Use role key for redirect
          final targetRoute = homeRouteForRole(roleKey);
          print('[Router] ✅ Redirecting authenticated user to $targetRoute');
          print('========================================\n');
          return redirectTo(targetRoute);
        }
        print('[Router] ✅ Allowing access to public route');
        print('========================================\n');
        return null;  // Allow access to public routes
      }

      // Protected routes require auth
      if (!isAuth || user == null) {
        print('[Router] 🔒 Not authenticated, redirecting to /entry');
        print('========================================\n');
        return redirectTo('/entry');
      }

      // CRITICAL: Block routing until identity is loaded
      if (identityLoading) {
        print('[Router] ⏳ Identity still loading, blocking with /role-loading');
        print('========================================\n');
        return redirectTo('/role-loading');
      }

      // If identity load failed or role unknown
      if (roleKey == null || roleKey == 'unknown') {
        print('[Router] ❌ Role unknown after auth, redirecting to /entry');
        print('========================================\n');
        return redirectTo('/entry');
      }

      // Get role-based flags
      final userIsAdmin = isAdminRole(roleKey);
      final userIsEmployee = roleKey == 'stylist' || roleKey == 'employee';
      final userIsCustomer = roleKey == 'customer';

      print('[Router] 🎭 Role Analysis:');
      print('[Router]   Is Admin: $userIsAdmin');
      print('[Router]   Is Employee: $userIsEmployee');
      print('[Router]   Is Customer: $userIsCustomer');

      // Check salon selection for non-customers
      if (!userIsCustomer) {
        final requiresSalon = salonRequiredPrefixes.any((route) => location.startsWith(route));

        // Use identity.currentSalonId instead of user.currentSalonId
        // because Identity loads it correctly from DB
        if (requiresSalon &&
            (identity.currentSalonId == null || identity.currentSalonId!.isEmpty)) {
          print('[Router] 🏪 Salon selection required (no salon in identity)');
          print('[Router] → Redirecting to /select-salon');
          print('========================================\n');
          return redirectTo('/select-salon');
        }
      }

      // STRICT Role-based access control
      final targetRoute = homeRouteForRole(roleKey);

      if (adminOnlyPrefixes.any((route) => location.startsWith(route)) && !userIsAdmin) {
        print('[Router] 🚫 Non-admin trying to access admin route');
        print('[Router] → Redirecting to $targetRoute');
        print('========================================\n');
        return redirectTo(targetRoute);
      }

      if (staffOnlyPrefixes.any((route) => location.startsWith(route)) && !(userIsAdmin || userIsEmployee)) {
        print('[Router] 🚫 Customer trying to access staff-only route');
        print('[Router] → Redirecting to $targetRoute');
        print('========================================\n');
        return redirectTo(targetRoute);
      }

      if (customerOnlyPrefixes.any((route) => location.startsWith(route)) && !userIsCustomer) {
        print('[Router] 🚫 Non-customer trying to access customer route');
        print('[Router] → Redirecting to $targetRoute');
        print('========================================\n');
        return redirectTo(targetRoute);
      }

      print('[Router] ✅ Access granted to $location');
      print('========================================\n');
      return null;
    },
    routes: [
      // ==================== PUBLIC ROUTES ====================
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/role-loading',
        builder: (context, state) => const RoleLoadingScreen(),
      ),
      GoRoute(
        path: '/entry',
        builder: (context, state) => const EntryScreenNew(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterChoiceScreen(),
      ),
      GoRoute(
        path: '/register/customer',
        builder: (context, state) => const RegisterCustomerScreen(),
      ),
      GoRoute(
        path: '/register/owner',
        builder: (context, state) => const RegisterOwnerScreen(),
      ),
      GoRoute(
        path: '/invite',
        builder: (context, state) => const InviteScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/booking/guest',
        builder: (context, state) => const GuestBookingScreen(),
      ),
      // Old routes for compatibility
      GoRoute(
        path: '/auth',
        builder: (context, state) => const EntryScreenNew(),
      ),
      GoRoute(
        path: '/auth/login',
        redirect: (context, state) => '/login',
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) => const BookingWizardScreenNew(),
      ),
      GoRoute(
        path: '/booking/availability',
        builder: (context, state) => const AvailabilityPickerScreen(),
      ),
      GoRoute(
        path: '/booking/employee-selection',
        builder: (context, state) => const EmployeeSelectionScreen(),
      ),

      // Dashboard compatibility adapters (temporary)
      GoRoute(
        path: '/dashboard',
        redirect: (context, state) {
          final container = ProviderScope.containerOf(context);
          final roleKey = container.read(identityProvider).roleKey;
          return homeRouteForRole(roleKey);
        },
      ),
      GoRoute(
        path: '/admin-dashboard',
        redirect: (context, state) => kAdminPrimaryPath,
      ),
      GoRoute(
        path: '/dashboard/admin',
        redirect: (context, state) => kAdminPrimaryPath,
      ),
      GoRoute(
        path: '/dashboard/admin/:tab',
        redirect: (context, state) {
          final tab = state.pathParameters['tab'];
          if (tab == null || tab.isEmpty) {
            return kAdminPrimaryPath;
          }
          return '$kAdminPrimaryPath?tab=$tab';
        },
      ),
      GoRoute(
        path: '/admin/home',
        redirect: (context, state) => kAdminPrimaryPath,
      ),
      GoRoute(
        path: '/employee-dashboard',
        redirect: (context, state) => '/employee',
      ),

      // ==================== PROTECTED ROUTES WITH SHELL ====================
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // ========== SALON SELECTION ==========
          GoRoute(
            path: '/select-salon',
            builder: (context, state) => const SalonSelectionScreen(),
          ),
          GoRoute(
            path: '/salon-setup',
            builder: (context, state) => const SalonSetupScreen(),
          ),

          // ========== ADMIN DASHBOARD ==========
          GoRoute(
            path: kAdminPrimaryPath,
            builder: (context, state) => const AdminDashboardScreen(),
          ),

          // ========== EMPLOYEE DASHBOARD ==========
          GoRoute(
            path: '/employee',
            builder: (context, state) => const EmployeeDashboardScreen(),
          ),

          // ========== CUSTOMER DASHBOARD ==========
          GoRoute(
            path: '/customer',
            builder: (context, state) => const CustomerDashboardScreen(),
          ),

          // ========== COMMON FEATURES ==========
          GoRoute(
            path: '/my-appointments',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/salon-map',
            builder: (context, state) => const SalonMapScreen(),
          ),
          GoRoute(
            path: '/salon-map-search',
            builder: (context, state) => const SalonMapSearchScreen(),
          ),
          GoRoute(
            path: '/salon-list-search',
            builder: (context, state) => const SalonListSearchScreen(),
          ),
          GoRoute(
            path: '/gallery',
            builder: (context, state) => const GalleryScreen(),
          ),
          GoRoute(
            path: '/inspiration',
            builder: (context, state) => const FeatureInProgressScreen(
              title: 'Inspiration',
              message: 'Das Inspirations-Feature wird aktuell weiter ausgebaut.',
            ),
          ),
          // ========== CHAT MODULE ==========
          GoRoute(
            path: '/messages',
            builder: (context, state) => const ChatInboxScreen(),
            routes: [
              GoRoute(
                path: ':conversationId',
                builder: (context, state) {
                  final conversationId = state.pathParameters['conversationId']!;
                  return ChatDetailScreen(conversationId: conversationId);
                },
                routes: [
                  GoRoute(
                    path: 'info',
                    builder: (context, state) {
                      final conversationId = state.pathParameters['conversationId']!;
                      return ChatInfoScreen(conversationId: conversationId);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/support',
            builder: (context, state) => const ChatInboxScreen(conversationType: 'support'),
          ),
          GoRoute(
            path: '/conversations',
            redirect: (context, state) => '/messages',
          ),
          GoRoute(
            path: '/crm',
            builder: (context, state) => const CRMDashboardScreen(),
          ),
          GoRoute(
            path: '/security-privacy',
            builder: (context, state) => const SecurityPrivacyScreen(),
          ),

          // ========== ADMIN/MANAGER FEATURES ==========
          GoRoute(
            path: '/inventory',
            builder: (context, state) => const InventoryScreen(),
          ),
          GoRoute(
            path: '/pos',
            builder: (context, state) => const POSScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsDashboard(),
          ),

          // ========== LEGACY ROUTES (no production placeholders) ==========
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/schedule',
            redirect: (context, state) {
              final container = ProviderScope.containerOf(context);
              final roleKey = container.read(identityProvider).roleKey;

              if (roleKey == 'employee') {
                return '/employee?tab=schedule';
              }

              return '$kAdminPrimaryPath?tab=time';
            },
          ),
          GoRoute(
            path: '/booking-map',
            redirect: (context, state) => '/salon-map',
          ),
          GoRoute(
            path: '/closures',
            redirect: (context, state) => '$kAdminPrimaryPath?tab=settings',
          ),
          GoRoute(
            path: '/employees',
            builder: (context, state) => const EmployeeManagementScreen(),
          ),
          GoRoute(
            path: '/suppliers',
            builder: (context, state) => const FeatureInProgressScreen(
              title: 'Lieferanten',
              message: 'Das Lieferanten-Modul wird aktuell vorbereitet.',
            ),
          ),
          GoRoute(
            path: '/service-consumption',
            builder: (context, state) => const FeatureInProgressScreen(
              title: 'Service-Verbrauch',
              message: 'Die Verbrauchsauswertung für Services ist in Arbeit.',
            ),
          ),
          GoRoute(
            path: '/loyalty-settings',
            builder: (context, state) => const LoyaltyLevelsScreen(),
          ),
          GoRoute(
            path: '/coupons',
            builder: (context, state) => const CouponsScreen(),
          ),
          GoRoute(
            path: '/loyalty',
            builder: (context, state) => const FeatureInProgressScreen(
              title: 'Treuekarte',
              message: 'Die Treuekarten-Ansicht wird aktuell fertiggestellt.',
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileDashboard(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Fehler')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Seite nicht gefunden',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/entry'),
              child: const Text('Zur Startseite'),
            ),
          ],
        ),
      ),
    ),
  );
});
