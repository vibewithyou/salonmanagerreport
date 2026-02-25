import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/navigation_item.dart';

/// Navigation State Provider - verwaltet den globalen Navigationszustand
final navigationStateProvider =
    StateNotifierProvider<NavigationStateNotifier, NavigationState>((ref) {
  return NavigationStateNotifier();
});

class NavigationStateNotifier extends StateNotifier<NavigationState> {
  NavigationStateNotifier() : super(const NavigationState());

  /// Navigiert zu einer neuen Seite
  void navigateToPage(NavigationPage page) {
    state = state.copyWith(
      currentPage: page,
      navigationHistory: [...state.navigationHistory, page],
    );
  }

  /// Toggle Menü (erweitern/kollabieren)
  void toggleMenu(String menuId) {
    final expandedIds = List<String>.from(state.expandedMenuIds);
    if (expandedIds.contains(menuId)) {
      expandedIds.remove(menuId);
    } else {
      expandedIds.add(menuId);
    }
    state = state.copyWith(expandedMenuIds: expandedIds);
  }

  /// Öffnet oder schließt die mobile Sidebar
  void toggleMobileSidebar() {
    state = state.copyWith(isMobileSidebarOpen: !state.isMobileSidebarOpen);
  }

  /// Schließt die mobile Sidebar
  void closeMobileSidebar() {
    state = state.copyWith(isMobileSidebarOpen: false);
  }

  /// Toggle Desktop Sidebar (erweitern/kollabieren)
  void toggleDesktopSidebar() {
    state = state.copyWith(
      isDesktopSidebarExpanded: !state.isDesktopSidebarExpanded,
    );
  }

  /// Geht eine Seite in der Historie zurück
  void goBack() {
    if (state.navigationHistory.length > 1) {
      final newHistory = List<NavigationPage>.from(state.navigationHistory)
        ..removeLast();
      state = state.copyWith(
        currentPage: newHistory.last,
        navigationHistory: newHistory,
      );
    }
  }

  /// Setzt den Navigationszustand zurück
  void reset() {
    state = const NavigationState();
  }
}

/// Navigation Items Provider - liefert alle Navigationselemente
final navigationItemsProvider = Provider<List<NavigationItem>>((ref) {
  return [
    // HOME
    NavigationItem(
      id: 'home',
      label: 'Home',
      icon: Icons.home_rounded,
      page: NavigationPage.home,
      route: NavigationPage.home.route,
    ),

    // SALON
    NavigationItem(
      id: 'salon',
      label: 'Salon',
      icon: Icons.business_rounded,
      page: NavigationPage.salon,
      route: NavigationPage.salon.route,
      children: [
        NavigationItem(
          id: 'salon_overview',
          label: 'Meine Salons',
          icon: Icons.store_rounded,
          page: NavigationPage.salonOverview,
          route: NavigationPage.salonOverview.route,
        ),
        NavigationItem(
          id: 'salon_employees',
          label: 'Mitarbeiter',
          icon: Icons.people_rounded,
          page: NavigationPage.salonEmployees,
          route: NavigationPage.salonEmployees.route,
          requiredPermission: 'employees:manage',
        ),
        NavigationItem(
          id: 'salon_customers',
          label: 'Kunden',
          icon: Icons.person_rounded,
          page: NavigationPage.salonCustomers,
          route: NavigationPage.salonCustomers.route,
          requiredPermission: 'customers:view',
        ),
        NavigationItem(
          id: 'salon_pos',
          label: 'Kasse',
          icon: Icons.point_of_sale_rounded,
          page: NavigationPage.salonPos,
          route: NavigationPage.salonPos.route,
          requiredPermission: 'pos:access',
        ),
        NavigationItem(
          id: 'salon_inventory',
          label: 'Lager',
          icon: Icons.inventory_2_rounded,
          page: NavigationPage.salonInventory,
          route: NavigationPage.salonInventory.route,
          requiredPermission: 'inventory:manage',
        ),
        NavigationItem(
          id: 'salon_suppliers',
          label: 'Lieferanten',
          icon: Icons.local_shipping_rounded,
          page: NavigationPage.salonSuppliers,
          route: NavigationPage.salonSuppliers.route,
          requiredPermission: 'suppliers:manage',
        ),
        NavigationItem(
          id: 'salon_consumption',
          label: 'Verbrauch',
          icon: Icons.water_drop_rounded,
          page: NavigationPage.salonConsumption,
          route: NavigationPage.salonConsumption.route,
          requiredPermission: 'consumption:view',
        ),
        NavigationItem(
          id: 'salon_loyalty',
          label: 'Loyalty',
          icon: Icons.card_giftcard_rounded,
          page: NavigationPage.salonLoyalty,
          route: NavigationPage.salonLoyalty.route,
          requiredPermission: 'loyalty:manage',
        ),
        NavigationItem(
          id: 'salon_coupons',
          label: 'Coupons',
          icon: Icons.local_offer_rounded,
          page: NavigationPage.salonCoupons,
          route: NavigationPage.salonCoupons.route,
          requiredPermission: 'coupons:manage',
        ),
        NavigationItem(
          id: 'salon_reports',
          label: 'Berichte',
          icon: Icons.assessment_rounded,
          page: NavigationPage.salonReports,
          route: NavigationPage.salonReports.route,
          requiredPermission: 'reports:view',
        ),
        NavigationItem(
          id: 'salon_seo',
          label: 'SEO Dashboard',
          icon: Icons.search_rounded,
          page: NavigationPage.salonSeo,
          route: NavigationPage.salonSeo.route,
          requiredPermission: 'seo:manage',
        ),
        NavigationItem(
          id: 'salon_local_seo',
          label: 'Lokales SEO',
          icon: Icons.location_on_rounded,
          page: NavigationPage.salonLocalSeo,
          route: NavigationPage.salonLocalSeo.route,
          requiredPermission: 'seo:manage',
        ),
        NavigationItem(
          id: 'salon_page_editor',
          label: 'Seiten Editor',
          icon: Icons.edit_note_rounded,
          page: NavigationPage.salonPageEditor,
          route: NavigationPage.salonPageEditor.route,
          requiredPermission: 'pages:edit',
        ),
      ],
    ),

    // GALERIE
    NavigationItem(
      id: 'gallery',
      label: 'Galerie',
      icon: Icons.photo_library_rounded,
      page: NavigationPage.gallery,
      route: NavigationPage.gallery.route,
      children: [
        NavigationItem(
          id: 'gallery_inspiration',
          label: 'Inspiration',
          icon: Icons.lightbulb_rounded,
          page: NavigationPage.galleryInspiration,
          route: NavigationPage.galleryInspiration.route,
        ),
        NavigationItem(
          id: 'gallery_portfolio',
          label: 'Galerie',
          icon: Icons.collections_rounded,
          page: NavigationPage.galleryPortfolio,
          route: NavigationPage.galleryPortfolio.route,
          requiredPermission: 'gallery:view',
        ),
        NavigationItem(
          id: 'gallery_upload',
          label: 'Upload',
          icon: Icons.upload_file_rounded,
          page: NavigationPage.galleryUpload,
          route: NavigationPage.galleryUpload.route,
          requiredPermission: 'gallery:upload',
        ),
      ],
    ),

    // TERMINE
    NavigationItem(
      id: 'appointments',
      label: 'Termine',
      icon: Icons.event_rounded,
      page: NavigationPage.appointments,
      route: NavigationPage.appointments.route,
      children: [
        NavigationItem(
          id: 'appointments_calendar',
          label: 'Kalender',
          icon: Icons.calendar_today_rounded,
          page: NavigationPage.appointmentsCalendar,
          route: NavigationPage.appointmentsCalendar.route,
          requiredPermission: 'appointments:view',
        ),
        NavigationItem(
          id: 'appointments_schedule',
          label: 'Zeitplan',
          icon: Icons.schedule_rounded,
          page: NavigationPage.appointmentsSchedule,
          route: NavigationPage.appointmentsSchedule.route,
          requiredPermission: 'schedule:manage',
        ),
        NavigationItem(
          id: 'appointments_bookings',
          label: 'Buchungen',
          icon: Icons.book_online_rounded,
          page: NavigationPage.appointmentsBookings,
          route: NavigationPage.appointmentsBookings.route,
          requiredPermission: 'bookings:manage',
        ),
        NavigationItem(
          id: 'appointments_map',
          label: 'Karte',
          icon: Icons.map_rounded,
          page: NavigationPage.appointmentsMap,
          route: NavigationPage.appointmentsMap.route,
        ),
        NavigationItem(
          id: 'appointments_closures',
          label: 'Schließungen',
          icon: Icons.event_busy_rounded,
          page: NavigationPage.appointmentsClosures,
          route: NavigationPage.appointmentsClosures.route,
          requiredPermission: 'closures:manage',
        ),
      ],
    ),

    // CHATS
    NavigationItem(
      id: 'chats',
      label: 'Chats',
      icon: Icons.chat_rounded,
      page: NavigationPage.chats,
      route: NavigationPage.chats.route,
      children: [
        NavigationItem(
          id: 'chats_team',
          label: 'Team Chat',
          icon: Icons.groups_rounded,
          page: NavigationPage.chatsTeam,
          route: NavigationPage.chatsTeam.route,
          requiredPermission: 'chat:team',
        ),
        NavigationItem(
          id: 'chats_support',
          label: 'Support',
          icon: Icons.support_agent_rounded,
          page: NavigationPage.chatsSupport,
          route: NavigationPage.chatsSupport.route,
          requiredPermission: 'chat:support',
        ),
        NavigationItem(
          id: 'chats_announcements',
          label: 'Ankündigungen',
          icon: Icons.campaign_rounded,
          page: NavigationPage.chatsAnnouncements,
          route: NavigationPage.chatsAnnouncements.route,
          requiredPermission: 'chat:announce',
        ),
      ],
    ),

    // PROFIL
    NavigationItem(
      id: 'profile',
      label: 'Profil',
      icon: Icons.account_circle_rounded,
      page: NavigationPage.profile,
      route: NavigationPage.profile.route,
      children: [
        NavigationItem(
          id: 'profile_account',
          label: 'Mein Profil',
          icon: Icons.person_rounded,
          page: NavigationPage.profileAccount,
          route: NavigationPage.profileAccount.route,
        ),
        NavigationItem(
          id: 'profile_security',
          label: 'Sicherheit',
          icon: Icons.security_rounded,
          page: NavigationPage.profileSecurity,
          route: NavigationPage.profileSecurity.route,
        ),
        NavigationItem(
          id: 'profile_notifications',
          label: 'Benachrichtigungen',
          icon: Icons.notifications_rounded,
          page: NavigationPage.profileNotifications,
          route: NavigationPage.profileNotifications.route,
        ),
        NavigationItem(
          id: 'profile_preferences',
          label: 'Voreinstellungen',
          icon: Icons.tune_rounded,
          page: NavigationPage.profilePreferences,
          route: NavigationPage.profilePreferences.route,
        ),
        NavigationItem(
          id: 'profile_payments',
          label: 'Zahlungsmethoden',
          icon: Icons.payment_rounded,
          page: NavigationPage.profilePayments,
          route: NavigationPage.profilePayments.route,
        ),
        NavigationItem(
          id: 'profile_subscription',
          label: 'Abo & Lizenz',
          icon: Icons.card_membership_rounded,
          page: NavigationPage.profileSubscription,
          route: NavigationPage.profileSubscription.route,
        ),
        NavigationItem(
          id: 'profile_settings',
          label: 'Erweiterte Einstellungen',
          icon: Icons.settings_rounded,
          page: NavigationPage.profileSettings,
          route: NavigationPage.profileSettings.route,
        ),
      ],
    ),
  ];
});

/// Provider für Bottom Navigation Items (nur Hauptmenüs)
final bottomNavigationItemsProvider = Provider<List<NavigationItem>>((ref) {
  final allItems = ref.watch(navigationItemsProvider);
  // Nur die 5 Hauptmenüs für Bottom Navigation (ohne Profil)
  return allItems.where((item) => item.children.isNotEmpty || item.id == 'home').take(5).toList();
});

/// Provider für aktuell ausgewählten Navigation Item
final currentNavigationItemProvider = Provider<NavigationItem?>((ref) {
  final navState = ref.watch(navigationStateProvider);
  final navItems = ref.watch(navigationItemsProvider);
  
  // Finde den aktuellen NavigationItem basierend auf der aktuellen Seite
  for (final item in navItems) {
    if (item.page == navState.currentPage) {
      return item;
    }
    // Prüfe Kinder
    for (final child in item.children) {
      if (child.page == navState.currentPage) {
        return child;
      }
    }
  }
  return null;
});
