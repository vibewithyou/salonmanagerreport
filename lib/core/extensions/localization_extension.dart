import 'package:easy_localization/easy_localization.dart';

/// Extension für einfachere Übersetzungen
extension StringLocalization on String {
  /// Übersetzt einen String (verwende .translate() statt .tr für Klarheit)
  String get translate {
    return this.tr();
  }

  /// Übersetzt einen String mit Parametern
  String trParams(Map<String, String> params) {
    return this.tr(namedArgs: params);
  }

  /// Übersetzt einen String mit gezählten Elementen
  String trPlural(int count, {Map<String, String>? args}) {
    return this.plural(count, namedArgs: args ?? {});
  }
}

/// Globale Übersetzungs-Funktionen
class Translations {
  // Common
  static const String appTitle = 'app_title';
  static const String appDescription = 'app_description';

  // Auth
  static const String adminLogin = 'auth.admin_login';
  static const String employeeLogin = 'auth.employee_login';
  static const String employeeCode = 'auth.employee_code';
  static const String salonCode = 'auth.salon_code';
  static const String invalidCode = 'auth.invalid_code';
  static const String sessionExpired = 'auth.session_expired';

  // Navigation
  static const String adminDashboard = 'navigation.admin_dashboard';
  static const String employeeDashboard = 'navigation.employee_dashboard';
  static const String modules = 'navigation.modules';
  static const String employees = 'navigation.employees';
  static const String permissions = 'navigation.permissions';
  static const String logs = 'navigation.logs';

  // Admin Dashboard
  static const String adminPanel = 'admin_dashboard.title';
  static const String moduleManagement = 'admin_dashboard.modules';
  static const String employeeManagement = 'admin_dashboard.employees';
  static const String activityLog = 'admin_dashboard.activity_log';
  static const String currentSalonCode = 'admin_dashboard.current_salon_code';
  static const String resetSalonCode = 'admin_dashboard.reset_salon_code';
  static const String moduleEnabled = 'admin_dashboard.module_enabled';
  static const String moduleDisabled = 'admin_dashboard.module_disabled';

  // Employee Dashboard
  static const String employeePanel = 'employee_dashboard.title';
  static const String timeTracking = 'employee_dashboard.time_tracking';
  static const String startTracking = 'employee_dashboard.start_tracking';
  static const String stopTracking = 'employee_dashboard.stop_tracking';
  static const String totalTimeToday = 'employee_dashboard.total_time_today';
  static const String sessionHistory = 'employee_dashboard.session_history';

  // Theme
  static const String lightTheme = 'theme.light';
  static const String darkTheme = 'theme.dark';

  // Language
  static const String languageLabel = 'language.language';
  static const String deutsch = 'language.deutsch';
  static const String english = 'language.english';

  // Common Actions
  static const String yes = 'common.yes';
  static const String no = 'common.no';
  static const String ok = 'common.ok';
  static const String cancel = 'common.cancel';
  static const String save = 'common.save';
  static const String delete = 'common.delete';
  static const String edit = 'common.edit';
  static const String add = 'common.add';
  static const String close = 'common.close';
  static const String logout = 'common.logout';
  static const String loading = 'common.loading';
  static const String error = 'common.error';
  static const String success = 'common.success';
  static const String copy = 'common.copy';
  static const String copied = 'common.copied';
  static const String tryAgain = 'common.try_again';
  static const String back = 'common.back';
  static const String next = 'common.next';
  static const String search = 'common.search';
  static const String noData = 'common.no_data';
  static const String noResults = 'common.no_results';

  // Errors
  static const String somethingWentWrong = 'errors.something_went_wrong';
  static const String networkError = 'errors.network_error';
  static const String serverError = 'errors.server_error';
}
