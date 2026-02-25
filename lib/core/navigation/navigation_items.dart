import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Navigation item model
class NavigationItem {
  final String label;
  final String path;
  final IconData icon;

  const NavigationItem({
    required this.label,
    required this.path,
    required this.icon,
  });
}

/// Navigation group model
class NavigationGroup {
  final String id;
  final String label;
  final List<NavigationItem> items;

  const NavigationGroup({
    required this.id,
    required this.label,
    required this.items,
  });
}

/// Get navigation items based on user role
List<NavigationGroup> getNavigationItems(String role) {
  if (role == 'admin' || role == 'manager' || role == 'owner') {
    return [..._adminNavigationGroups, ..._commonNavigationGroups];
  } else if (role == 'employee' || role == 'stylist') {
    return [..._employeeNavigationGroups, ..._commonNavigationGroups];
  } else {
    return [..._customerNavigationGroups, ..._commonNavigationGroups];
  }
}

/// Admin/Manager navigation groups
final _adminNavigationGroups = [
  const NavigationGroup(
    id: 'dashboard-tabs',
    label: 'Dashboard',
    items: [
      NavigationItem(
        label: 'Übersicht',
        path: '/admin',
        icon: LucideIcons.layoutDashboard,
      ),
      NavigationItem(
        label: 'Termine',
        path: '/admin?tab=appointments',
        icon: LucideIcons.calendar,
      ),
      NavigationItem(
        label: 'Salon',
        path: '/admin?tab=salon',
        icon: LucideIcons.store,
      ),
      NavigationItem(
        label: 'Mitarbeiter',
        path: '/admin?tab=employees',
        icon: LucideIcons.users,
      ),
      NavigationItem(
        label: 'Kunden',
        path: '/admin?tab=customers',
        icon: LucideIcons.userCircle,
      ),
      NavigationItem(
        label: 'Dienstleistungen',
        path: '/admin?tab=services',
        icon: LucideIcons.scissors,
      ),
      NavigationItem(
        label: 'Lager',
        path: '/admin?tab=inventory',
        icon: LucideIcons.package,
      ),
      NavigationItem(
        label: 'Galerie',
        path: '/admin?tab=gallery',
        icon: LucideIcons.image,
      ),
      NavigationItem(
        label: 'Marketing',
        path: '/admin?tab=marketing',
        icon: LucideIcons.megaphone,
      ),
      NavigationItem(
        label: 'Dienstplan',
        path: '/admin?tab=time',
        icon: LucideIcons.clock,
      ),
      NavigationItem(
        label: 'Saloncode',
        path: '/admin?tab=saloncode',
        icon: LucideIcons.lock,
      ),
      NavigationItem(
        label: 'Module',
        path: '/admin?tab=modules',
        icon: LucideIcons.layoutGrid,
      ),
      NavigationItem(
        label: 'Mitarbeitercodes',
        path: '/admin?tab=employeecodes',
        icon: LucideIcons.key,
      ),
      NavigationItem(
        label: 'Aktivitäten',
        path: '/admin?tab=activity',
        icon: LucideIcons.zap,
      ),
      NavigationItem(
        label: 'Berichte',
        path: '/admin?tab=reports',
        icon: LucideIcons.barChart3,
      ),
      NavigationItem(
        label: 'Einstellungen',
        path: '/admin?tab=settings',
        icon: LucideIcons.settings,
      ),
    ],
  ),
  const NavigationGroup(
    id: 'appointments',
    label: 'Termine',
    items: [
      NavigationItem(
        label: 'Kalender',
        path: '/calendar',
        icon: LucideIcons.calendar,
      ),
      NavigationItem(
        label: 'Zeiterfassung',
        path: '/admin?tab=timetracking',
        icon: LucideIcons.timer,
      ),
      NavigationItem(
        label: 'Dienstplan',
        path: '/admin?tab=time',
        icon: LucideIcons.calendarClock,
      ),
      NavigationItem(
        label: 'Buchungen',
        path: '/booking',
        icon: LucideIcons.bookOpen,
      ),
      NavigationItem(
        label: 'Karte',
        path: '/booking-map',
        icon: LucideIcons.map,
      ),
    ],
  ),
  const NavigationGroup(
    id: 'salon',
    label: 'Salon',
    items: [
      NavigationItem(
        label: 'Mitarbeiter',
        path: '/employees',
        icon: LucideIcons.users,
      ),
      NavigationItem(
        label: 'Lager',
        path: '/inventory',
        icon: LucideIcons.package,
      ),
      NavigationItem(
        label: 'Lieferanten',
        path: '/suppliers',
        icon: LucideIcons.truck,
      ),
      NavigationItem(
        label: 'Service-Verbrauch',
        path: '/service-consumption',
        icon: LucideIcons.barChart,
      ),
      NavigationItem(
        label: 'Treueprogramm',
        path: '/loyalty-settings',
        icon: LucideIcons.gift,
      ),
      NavigationItem(
        label: 'Gutscheine',
        path: '/coupons',
        icon: LucideIcons.ticket,
      ),
      NavigationItem(
        label: 'Coupons',
        path: '/admin?tab=coupons',
        icon: LucideIcons.badgePercent,
      ),
      NavigationItem(
        label: 'Berichte',
        path: '/reports',
        icon: LucideIcons.fileText,
      ),
    ],
  ),
  const NavigationGroup(
    id: 'gallery',
    label: 'Galerie',
    items: [
      NavigationItem(
        label: 'Galerie',
        path: '/gallery',
        icon: LucideIcons.image,
      ),
    ],
  ),
  const NavigationGroup(
    id: 'communication',
    label: 'Kommunikation',
    items: [
      NavigationItem(
        label: 'Gespräche',
        path: '/messages',
        icon: LucideIcons.messageCircle,
      ),
    ],
  ),
];

/// Employee/Stylist navigation groups
final _employeeNavigationGroups = [
  const NavigationGroup(
    id: 'dashboard-tabs',
    label: 'Dashboard',
    items: [
      NavigationItem(
        label: 'Meine Termine',
        path: '/employee',
        icon: LucideIcons.calendar,
      ),
      NavigationItem(
        label: 'Zeiterfassung',
        path: '/employee?tab=timetracking',
        icon: LucideIcons.clock,
      ),
      NavigationItem(
        label: 'QR Check-in',
        path: '/employee?tab=qr',
        icon: LucideIcons.qrCode,
      ),
      NavigationItem(
        label: 'Urlaubsanträge',
        path: '/employee?tab=leave',
        icon: LucideIcons.palmtree,
      ),
      NavigationItem(
        label: 'Dienstplan',
        path: '/employee?tab=schedule',
        icon: LucideIcons.calendarDays,
      ),
    ],
  ),
  const NavigationGroup(
    id: 'work',
    label: 'Arbeit',
    items: [
      NavigationItem(
        label: 'Meine Termine',
        path: '/calendar',
        icon: LucideIcons.calendar,
      ),
      NavigationItem(
        label: 'POS',
        path: '/pos',
        icon: LucideIcons.creditCard,
      ),
    ],
  ),
  const NavigationGroup(
    id: 'personal',
    label: 'Persönlich',
    items: [
      NavigationItem(
        label: 'Portfolio',
        path: '/gallery',
        icon: LucideIcons.image,
      ),
    ],
  ),
];

/// Customer navigation groups
final _customerNavigationGroups = [
  const NavigationGroup(
    id: 'overview',
    label: 'Übersicht',
    items: [
      NavigationItem(
        label: 'Dashboard',
        path: '/customer',
        icon: LucideIcons.layoutDashboard,
      ),
    ],
  ),
  const NavigationGroup(
    id: 'bookings',
    label: 'Buchungen',
    items: [
      NavigationItem(
        label: 'Meine Termine',
        path: '/calendar',
        icon: LucideIcons.calendar,
      ),
      NavigationItem(
        label: 'Neuer Termin',
        path: '/booking',
        icon: LucideIcons.plus,
      ),
    ],
  ),
  const NavigationGroup(
    id: 'personal',
    label: 'Persönlich',
    items: [
      NavigationItem(
        label: 'Treuekarte',
        path: '/loyalty',
        icon: LucideIcons.gift,
      ),
    ],
  ),
];

/// Common navigation groups (all roles)
final _commonNavigationGroups = [
  const NavigationGroup(
    id: 'account',
    label: 'Konto',
    items: [
      NavigationItem(
        label: 'Profil',
        path: '/profile',
        icon: LucideIcons.user,
      ),
      NavigationItem(
        label: 'Einstellungen',
        path: '/settings',
        icon: LucideIcons.settings,
      ),
    ],
  ),
];
