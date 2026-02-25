import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_item.freezed.dart';

/// Navigation Page enum - definiert alle verfügbaren Seiten
enum NavigationPage {
  // Hauptseiten
  home,
  salon,
  gallery,
  appointments,
  chats,
  profile,
  
  // Salon Unterseiten
  salonOverview,
  salonEmployees,
  salonCustomers,
  salonPos,
  salonInventory,
  salonSuppliers,
  salonConsumption,
  salonLoyalty,
  salonCoupons,
  salonReports,
  salonSeo,
  salonLocalSeo,
  salonPageEditor,
  
  // Galerie Unterseiten
  galleryInspiration,
  galleryPortfolio,
  galleryUpload,
  
  // Termine Unterseiten
  appointmentsCalendar,
  appointmentsSchedule,
  appointmentsBookings,
  appointmentsMap,
  appointmentsClosures,
  
  // Chat Unterseiten
  chatsTeam,
  chatsSupport,
  chatsAnnouncements,
  
  // Profil Unterseiten
  profileAccount,
  profileSecurity,
  profileNotifications,
  profilePreferences,
  profilePayments,
  profileSubscription,
  profileSettings,
}

/// Navigation Item Model - repräsentiert einen einzelnen Menüpunkt
@freezed
class NavigationItem with _$NavigationItem {
  const factory NavigationItem({
    required String id,
    required String label,
    required IconData icon,
    required NavigationPage page,
    String? route,
    @Default([]) List<NavigationItem> children,
    String? requiredPermission,
    @Default(true) bool isVisible,
    @Default(false) bool isExpanded,
    String? badge, // Für Notifications, z.B. "3" neue Nachrichten
  }) = _NavigationItem;
}

/// Navigation State - verwaltet den aktuellen Navigationszustand
@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState({
    @Default(NavigationPage.home) NavigationPage currentPage,
    @Default([]) List<String> expandedMenuIds,
    @Default([]) List<NavigationPage> navigationHistory,
    @Default(false) bool isMobileSidebarOpen,
    @Default(true) bool isDesktopSidebarExpanded,
  }) = _NavigationState;
}

/// Navigation Extension - Helper-Methoden für NavigationPage
extension NavigationPageExtension on NavigationPage {
  /// Gibt die Route für eine Seite zurück
  String get route {
    switch (this) {
      case NavigationPage.home:
        return '/admin/home';
      case NavigationPage.salon:
        return '/admin/salon';
      case NavigationPage.gallery:
        return '/admin/gallery';
      case NavigationPage.appointments:
        return '/admin/appointments';
      case NavigationPage.chats:
        return '/admin/chats';
      case NavigationPage.profile:
        return '/admin/profile';
      
      // Salon Unterseiten
      case NavigationPage.salonOverview:
        return '/admin/salon/overview';
      case NavigationPage.salonEmployees:
        return '/admin/salon/employees';
      case NavigationPage.salonCustomers:
        return '/admin/salon/customers';
      case NavigationPage.salonPos:
        return '/admin/salon/pos';
      case NavigationPage.salonInventory:
        return '/admin/salon/inventory';
      case NavigationPage.salonSuppliers:
        return '/admin/salon/suppliers';
      case NavigationPage.salonConsumption:
        return '/admin/salon/consumption';
      case NavigationPage.salonLoyalty:
        return '/admin/salon/loyalty';
      case NavigationPage.salonCoupons:
        return '/admin/salon/coupons';
      case NavigationPage.salonReports:
        return '/admin/salon/reports';
      case NavigationPage.salonSeo:
        return '/admin/salon/seo';
      case NavigationPage.salonLocalSeo:
        return '/admin/salon/local-seo';
      case NavigationPage.salonPageEditor:
        return '/admin/salon/page-editor';
      
      // Galerie Unterseiten
      case NavigationPage.galleryInspiration:
        return '/admin/gallery/inspiration';
      case NavigationPage.galleryPortfolio:
        return '/admin/gallery/portfolio';
      case NavigationPage.galleryUpload:
        return '/admin/gallery/upload';
      
      // Termine Unterseiten
      case NavigationPage.appointmentsCalendar:
        return '/admin/appointments/calendar';
      case NavigationPage.appointmentsSchedule:
        return '/admin/appointments/schedule';
      case NavigationPage.appointmentsBookings:
        return '/admin/appointments/bookings';
      case NavigationPage.appointmentsMap:
        return '/admin/appointments/map';
      case NavigationPage.appointmentsClosures:
        return '/admin/appointments/closures';
      
      // Chat Unterseiten
      case NavigationPage.chatsTeam:
        return '/admin/chats/team';
      case NavigationPage.chatsSupport:
        return '/admin/chats/support';
      case NavigationPage.chatsAnnouncements:
        return '/admin/chats/announcements';
      
      // Profil Unterseiten
      case NavigationPage.profileAccount:
        return '/admin/profile/account';
      case NavigationPage.profileSecurity:
        return '/admin/profile/security';
      case NavigationPage.profileNotifications:
        return '/admin/profile/notifications';
      case NavigationPage.profilePreferences:
        return '/admin/profile/preferences';
      case NavigationPage.profilePayments:
        return '/admin/profile/payments';
      case NavigationPage.profileSubscription:
        return '/admin/profile/subscription';
      case NavigationPage.profileSettings:
        return '/admin/profile/settings';
    }
  }

  /// Gibt den deutschen Label-Text zurück
  String get label {
    switch (this) {
      case NavigationPage.home:
        return 'Home';
      case NavigationPage.salon:
        return 'Salon';
      case NavigationPage.gallery:
        return 'Galerie';
      case NavigationPage.appointments:
        return 'Termine';
      case NavigationPage.chats:
        return 'Chats';
      case NavigationPage.profile:
        return 'Profil';
      
      // Salon Unterseiten
      case NavigationPage.salonOverview:
        return 'Übersicht';
      case NavigationPage.salonEmployees:
        return 'Mitarbeiter';
      case NavigationPage.salonCustomers:
        return 'Kunden';
      case NavigationPage.salonPos:
        return 'Kasse';
      case NavigationPage.salonInventory:
        return 'Lager';
      case NavigationPage.salonSuppliers:
        return 'Lieferanten';
      case NavigationPage.salonConsumption:
        return 'Verbrauch';
      case NavigationPage.salonLoyalty:
        return 'Loyalty';
      case NavigationPage.salonCoupons:
        return 'Coupons';
      case NavigationPage.salonReports:
        return 'Berichte';
      case NavigationPage.salonSeo:
        return 'SEO Dashboard';
      case NavigationPage.salonLocalSeo:
        return 'Lokales SEO';
      case NavigationPage.salonPageEditor:
        return 'Seiten Editor';
      
      // Galerie Unterseiten
      case NavigationPage.galleryInspiration:
        return 'Inspiration';
      case NavigationPage.galleryPortfolio:
        return 'Galerie';
      case NavigationPage.galleryUpload:
        return 'Upload';
      
      // Termine Unterseiten
      case NavigationPage.appointmentsCalendar:
        return 'Kalender';
      case NavigationPage.appointmentsSchedule:
        return 'Zeitplan';
      case NavigationPage.appointmentsBookings:
        return 'Buchungen';
      case NavigationPage.appointmentsMap:
        return 'Karte';
      case NavigationPage.appointmentsClosures:
        return 'Schließungen';
      
      // Chat Unterseiten
      case NavigationPage.chatsTeam:
        return 'Team Chat';
      case NavigationPage.chatsSupport:
        return 'Support';
      case NavigationPage.chatsAnnouncements:
        return 'Ankündigungen';
      
      // Profil Unterseiten
      case NavigationPage.profileAccount:
        return 'Mein Profil';
      case NavigationPage.profileSecurity:
        return 'Sicherheit';
      case NavigationPage.profileNotifications:
        return 'Benachrichtigungen';
      case NavigationPage.profilePreferences:
        return 'Voreinstellungen';
      case NavigationPage.profilePayments:
        return 'Zahlungsmethoden';
      case NavigationPage.profileSubscription:
        return 'Abo & Lizenz';
      case NavigationPage.profileSettings:
        return 'Erweiterte Einstellungen';
    }
  }

  /// Prüft, ob es sich um eine Hauptseite handelt
  bool get isMainPage {
    return [
      NavigationPage.home,
      NavigationPage.salon,
      NavigationPage.gallery,
      NavigationPage.appointments,
      NavigationPage.chats,
      NavigationPage.profile,
    ].contains(this);
  }
}
