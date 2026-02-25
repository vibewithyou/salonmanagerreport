import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:js' as js;
import '../../../core/constants/app_colors.dart';
import '../../../core/auth/identity_provider.dart';
import '../../../providers/dashboard_providers.dart';
import '../../bookings/data/booking_repository.dart';
import '../presentation/salon_code_manager_tab.dart';
import '../presentation/module_management_tab.dart';
import '../presentation/employee_code_generator_tab.dart';
import '../presentation/activity_log_tab.dart';
import '../presentation/salon_settings_tab.dart';
import '../presentation/admin_employees_tab.dart';
import '../presentation/admin_services_tab.dart';
import '../presentation/workforce_management_tab.dart';
import '../../inventory/presentation/inventory_screen.dart';
import 'customers/ui/customers_tab.dart';
import 'coupons/ui/coupons_tab.dart';
import 'coupons/state/coupon_providers.dart';
import '../../salon_booking_link/ui/salon_booking_link_card.dart';
import '../../salon_booking_link/ui/salon_booking_link_settings.dart';
import '../../dashboard/presentation/time_tracking_tab.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _lastTabKey;


  /// Whitelist der erlaubten tab-Keys für Admin-Dashboard
  static const Map<String, int> _tabKeyToIndex = {
    'overview': 0,
    'appointments': 1,
    'salon': 2,
    'employees': 3,
    'customers': 4,
    'services': 5,
    'inventory': 6,
    'gallery': 7,
    'marketing': 8,
    'timetracking': 9,
    'time': 10,
    'saloncode': 11,
    'modules': 12,
    'employeecodes': 13,
    'activity': 14,
    'reports': 15,
    'settings': 16,
    'coupons': 17,
  };
  // TODO: Backend-Tab-Erweiterungen hier ergänzen (siehe .ai/TODO.md)
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 18, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AdminDashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Force re-sync when widget updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _syncTabWithRoute(context);
      }
    });
  }

  int _indexForTabKey(String? tabKey) {
    if (tabKey == null || !_tabKeyToIndex.containsKey(tabKey)) {
      // Logging für ungültige oder fehlende tab-Keys
      debugPrint('[AdminDashboard] Ungültiger oder fehlender tab-Key: "$tabKey". Fallback auf overview.');
      return 0;
    }
    return _tabKeyToIndex[tabKey]!;
  }

  void _syncTabWithRoute(BuildContext context) {
    final tabKey = GoRouterState.of(context).uri.queryParameters['tab'];
    // Robust: Nur gültige tab-Keys akzeptieren, sonst fallback auf overview
    if (tabKey == _lastTabKey) {
      return;
    }
    _lastTabKey = tabKey;
    final targetIndex = _indexForTabKey(tabKey);
    // Update sofort, um Flackern/Loop zu vermeiden
    if (_tabController.index != targetIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _tabController.index != targetIndex) {
          _tabController.animateTo(targetIndex);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _syncTabWithRoute(context);
    final identity = ref.watch(identityProvider);
    final salonId = identity.currentSalonId;
    final salons = identity.availableSalons;

    if (salonId == null || salonId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin-Dashboard')),
        body: const Center(
          child: Text('Kein Salon ausgewaehlt. Bitte Salon waehlen.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin-Dashboard'),
        actions: [
          // Salon Switcher
          if (salons.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: DropdownButton<String>(
                value: salonId,
                dropdownColor: Colors.white,
                items: salons
                    .map(
                      (salon) => DropdownMenuItem<String>(
                        value: salon.id,
                        child: Text(
                          salon.name,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(identityProvider.notifier).setSalonId(value);
                  }
                },
              ),
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _OverviewTab(),
          _AppointmentsTab(),
          _SalonTab(),
          AdminEmployeesTab(salonId: salonId),
          CustomersTab(salonId: salonId),
          const AdminServicesTab(),
          _InventoryTab(),
          _GalleryTab(),
          _MarketingTab(salonId: salonId),
          TimeTrackingTab(salonId: salonId), // timetracking
          TimeTrackingTab(salonId: salonId), // time (Index 10, produktiv)
          SalonCodeManagerTab(salonId: salonId),
          ModuleManagementTab(salonId: salonId),
          EmployeeCodeGeneratorTab(salonId: salonId),
          ActivityLogTab(salonId: salonId),
          _ReportsTab(),
          SalonSettingsTab(salonId: salonId),
          CouponsTab(salonId: salonId),
        ],
      ),
    );
  }
}

// Tab 1: Overview
class _OverviewTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final identity = ref.watch(identityProvider);

    final salonId = identity.currentSalonId;

    if (salonId == null || salonId.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Salon wird geladen...', style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    // Get the dashboard service from providers
    final dashboardService = ref.watch(dashboardServiceProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard Übersicht',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Load real statistics from Supabase
          FutureBuilder<List<dynamic>>(
            future: Future.wait([
              dashboardService.getTodayAppointmentCount(salonId),
              dashboardService.getEmployeeCount(salonId),
              dashboardService.getTodayRevenue(salonId),
              dashboardService.getTodayNewCustomerCount(salonId),
              dashboardService.getTodayOverviewTrendStats(salonId),
              dashboardService.getCurrentMonthOverviewStats(salonId),
              dashboardService.getMonthOverviewTrendStats(salonId),
              dashboardService.getDailyRevenueSeries(salonId),
              dashboardService.getTopServices(salonId),
              dashboardService.getEmployeePerformance(salonId),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Daten werden geladen...',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return _buildErrorCard(
                  'Fehler beim Laden der Daten: ${snapshot.error}',
                );
              }

              // Extract loaded data
              final todayAppointments = snapshot.data?[0] as int? ?? 0;
              final activeEmployees = snapshot.data?[1] as int? ?? 0;
              final todayRevenue = snapshot.data?[2] as double? ?? 0.0;
              final newCustomersToday = snapshot.data?[3] as int? ?? 0;
                final todayTrendStats =
                  snapshot.data?[4] as Map<String, double>? ?? const {};

              final monthStats =
                  snapshot.data?[5] as Map<String, dynamic>? ?? const {};
                final monthTrendStats =
                  snapshot.data?[6] as Map<String, double>? ?? const {};
              final dailyRevenue =
                  (snapshot.data?[7] as List?)?.cast<Map<String, dynamic>>() ??
                  const <Map<String, dynamic>>[];
              final topServices =
                  (snapshot.data?[8] as List?)?.cast<Map<String, dynamic>>() ??
                  const <Map<String, dynamic>>[];
              final employeePerformance =
                  (snapshot.data?[9] as List?)?.cast<Map<String, dynamic>>() ??
                  const <Map<String, dynamic>>[];

              final totalRevenue =
                  (monthStats['totalRevenue'] as num?)?.toDouble() ?? 0.0;
              final totalAppointments =
                  (monthStats['totalAppointments'] as int?) ?? 0;
              final averageBookingValue =
                  (monthStats['averageBookingValue'] as num?)?.toDouble() ??
                  0.0;
              final completionRate =
                  (monthStats['completionRate'] as num?)?.toDouble() ?? 0.0;

                final todayAppointmentsChange =
                  todayTrendStats['todayAppointmentsChangePct'];
                final todayRevenueChange =
                  todayTrendStats['todayRevenueChangePct'];
                final todayCustomersChange =
                  todayTrendStats['todayNewCustomersChangePct'];

                final monthRevenueChange =
                  monthTrendStats['monthRevenueChangePct'];
                final monthAppointmentsChange =
                  monthTrendStats['monthAppointmentsChangePct'];
                final monthAvgBookingValueChange =
                  monthTrendStats['monthAverageBookingValueChangePct'];
                final monthCompletionRateChange =
                  monthTrendStats['monthCompletionRateChangePct'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildKPICard(
                        context,
                        'Termine Heute',
                        '$todayAppointments',
                        LucideIcons.calendar,
                        AppColors.primary,
                        changePercent: todayAppointmentsChange,
                      ),
                      _buildKPICard(
                        context,
                        'Mitarbeiter Aktiv',
                        '$activeEmployees',
                        LucideIcons.users,
                        AppColors.success,
                      ),
                      _buildKPICard(
                        context,
                        'Umsatz Heute',
                        '€${todayRevenue.toStringAsFixed(2)}',
                        LucideIcons.euro,
                        AppColors.gold,
                        changePercent: todayRevenueChange,
                      ),
                      _buildKPICard(
                        context,
                        'Neue Kunden',
                        '$newCustomersToday',
                        LucideIcons.userPlus,
                        AppColors.info,
                        changePercent: todayCustomersChange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.6,
                    children: [
                      _buildKPICard(
                        context,
                        'Umsatz (Monat)',
                        '€${totalRevenue.toStringAsFixed(0)}',
                        LucideIcons.trendingUp,
                        AppColors.rose,
                        changePercent: monthRevenueChange,
                      ),
                      _buildKPICard(
                        context,
                        'Termine (Monat)',
                        '$totalAppointments',
                        LucideIcons.calendar,
                        AppColors.sage,
                        changePercent: monthAppointmentsChange,
                      ),
                      _buildKPICard(
                        context,
                        'Ø Buchungswert',
                        '€${averageBookingValue.toStringAsFixed(0)}',
                        LucideIcons.euro,
                        AppColors.gold,
                        changePercent: monthAvgBookingValueChange,
                      ),
                      _buildKPICard(
                        context,
                        'Abschlussrate',
                        '${completionRate.toStringAsFixed(0)}%',
                        LucideIcons.barChart3,
                        AppColors.info,
                        changePercent: monthCompletionRateChange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildRevenueBarsCard(
                    context,
                    title: 'Tagesumsatz (letzte 14 Tage)',
                    data: dailyRevenue,
                  ),
                  const SizedBox(height: 16),
                  _buildTopServicesCard(context, topServices),
                  const SizedBox(height: 16),
                  _buildEmployeePerformanceCard(context, employeePerformance),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Tab 2: Appointments
class _AppointmentsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AppointmentsTab> createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends ConsumerState<_AppointmentsTab> {
  bool _showWeek = false;

  Future<_AppointmentBuckets> _loadAppointments(String salonId) async {
    final bookingRepo = ref.read(bookingRepositoryProvider);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfWeek = startOfDay
        .add(const Duration(days: 7))
        .add(const Duration(hours: 23, minutes: 59, seconds: 59));
    final fourYearsAgo = DateTime(now.year - 4, now.month, now.day);

    final all = await bookingRepo.getSalonAppointments(
      salonId: salonId,
      startDate: fourYearsAgo,
      endDate: endOfWeek,
    );

    final upcoming = all.where((a) => a.startTime.isAfter(now)).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final week =
        all
            .where(
              (a) =>
                  !a.startTime.isBefore(startOfDay) &&
                  !a.startTime.isAfter(endOfWeek),
            )
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final archived =
        all
            .where(
              (a) =>
                  a.startTime.isBefore(startOfDay) &&
                  !a.startTime.isBefore(fourYearsAgo),
            )
            .toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));

    return _AppointmentBuckets(
      upcoming: upcoming.take(5).toList(),
      week: week,
      archived: archived,
    );
  }

  Future<void> _updateStatus(String appointmentId, String newStatus) async {
    try {
      await ref
          .read(bookingRepositoryProvider)
          .updateAppointmentStatus(
            appointmentId: appointmentId,
            status: newStatus,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status auf "$newStatus" gesetzt.')),
      );
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status konnte nicht aktualisiert werden: $e')),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'confirmed':
        return AppColors.info;
      case 'cancelled':
        return AppColors.error;
      case 'pending':
      default:
        return AppColors.warning;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'Abgeschlossen';
      case 'confirmed':
        return 'Bestätigt';
      case 'cancelled':
        return 'Storniert';
      case 'pending':
      default:
        return 'Ausstehend';
    }
  }

  String _formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year;
    return '$d.$m.$y';
  }

  String _formatTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final identity = ref.watch(identityProvider);
    final salonId = identity.currentSalonId;

    if (salonId == null || salonId.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<_AppointmentBuckets>(
      future: _loadAppointments(salonId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorCard(
            'Termine konnten nicht geladen werden: ${snapshot.error}',
          );
        }

        final buckets =
            snapshot.data ??
            const _AppointmentBuckets(upcoming: [], week: [], archived: []);
        final activeList = _showWeek ? buckets.week : buckets.upcoming;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Terminverwaltung',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _showWeek = !_showWeek),
                      icon: Icon(
                        _showWeek ? LucideIcons.list : LucideIcons.calendarDays,
                      ),
                      label: Text(_showWeek ? 'Nächste 5' : '7 Tage'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 36),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text('Nächste 5: ${buckets.upcoming.length}')),
                  Chip(label: Text('7 Tage: ${buckets.week.length}')),
                  Chip(label: Text('Archiv: ${buckets.archived.length}')),
                ],
              ),
              const SizedBox(height: 16),
              if (activeList.isEmpty)
                _buildComingSoonCard(
                  context,
                  _showWeek
                      ? 'Keine Termine in den nächsten 7 Tagen.'
                      : 'Keine anstehenden Termine gefunden.',
                )
              else
                ...activeList.map(
                  (appointment) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _statusColor(
                          appointment.status,
                        ).withValues(alpha: 0.15),
                        child: Icon(
                          LucideIcons.calendar,
                          color: _statusColor(appointment.status),
                          size: 18,
                        ),
                      ),
                      title: Text(
                        appointment.guestName?.isNotEmpty == true
                            ? appointment.guestName!
                            : 'Kunde',
                      ),
                      subtitle: Text(
                        '${_formatDate(appointment.startTime)} • ${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}\n'
                        'Service: ${appointment.serviceId ?? 'N/A'}',
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        tooltip: 'Status ändern',
                        onSelected: (status) =>
                            _updateStatus(appointment.id, status),
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'pending',
                            child: Text('Ausstehend'),
                          ),
                          PopupMenuItem(
                            value: 'confirmed',
                            child: Text('Bestätigt'),
                          ),
                          PopupMenuItem(
                            value: 'completed',
                            child: Text('Abgeschlossen'),
                          ),
                          PopupMenuItem(
                            value: 'cancelled',
                            child: Text('Storniert'),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              appointment.status,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _statusLabel(appointment.status),
                            style: TextStyle(
                              color: _statusColor(appointment.status),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text('Archiv (letzte 4 Jahre)'),
                subtitle: Text('${buckets.archived.length} Termine'),
                children: buckets.archived.isEmpty
                    ? [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Text('Keine archivierten Termine vorhanden.'),
                        ),
                      ]
                    : buckets.archived
                          .take(20)
                          .map(
                            (appointment) => ListTile(
                              dense: true,
                              leading: const Icon(
                                LucideIcons.archive,
                                size: 16,
                              ),
                              title: Text(
                                appointment.guestName?.isNotEmpty == true
                                    ? appointment.guestName!
                                    : 'Kunde',
                              ),
                              subtitle: Text(
                                '${_formatDate(appointment.startTime)} • ${_statusLabel(appointment.status)}',
                              ),
                            ),
                          )
                          .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AppointmentBuckets {
  final List<AppointmentData> upcoming;
  final List<AppointmentData> week;
  final List<AppointmentData> archived;

  const _AppointmentBuckets({
    required this.upcoming,
    required this.week,
    required this.archived,
  });
}

// Tab 3: Salon
class _SalonTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final identity = ref.watch(identityProvider);
    final salonId = identity.currentSalonId;

    if (salonId == null || salonId.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Salon wird geladen...', style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    String getBasePath() {
      try {
        final href = js.context['window']['location']['href'] as String;
        final uri = Uri.parse(href);
        final cleanPath = uri.path.endsWith('/') && uri.path != '/'
            ? uri.path.substring(0, uri.path.length - 1)
            : uri.path;
        return '${uri.origin}$cleanPath';
      } catch (e) {
        return 'https://salonmanager.app';
      }
    }

    final basePath = getBasePath();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saloneinstellungen',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Konfiguration und Salonspezifische Einstellungen.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          // Booking Link Card mit QR-Code
          SalonBookingLinkCard(salonId: salonId, basePath: basePath),
          const SizedBox(height: 16),
          // Booking-Aktivierung Toggle
          SalonBookingEnabledToggle(salonId: salonId),
          const SizedBox(height: 24),
          // Link zu vollständigen Saloneinstellungen
          Card(
            child: InkWell(
              onTap: () {
                // Navigate to full settings
                context.go('/admin?tab=settings');
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(LucideIcons.settings, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vollständige Saloneinstellungen',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Öffnungszeiten, Feiertage, Zahlungsmethoden und mehr',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(LucideIcons.chevronRight, color: Colors.grey[400]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tab 4: Employees
// ignore: unused_element
class _EmployeesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildComingSoonTab(
      context,
      'Mitarbeiter',
      'Verwaltung von Mitarbeiterkonten und Berechtigungen.',
      LucideIcons.users,
    );
  }
}

// Tab 5: Services
// implemented in ../presentation/admin_services_tab.dart

// Tab 6: Inventory
class _InventoryTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salonId = ref.watch(identityProvider).currentSalonId;
    return InventoryScreen(salonId: salonId);
  }
}

// Tab 7: Gallery
class _GalleryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildComingSoonTab(
      context,
      'Galerie',
      'Verwaltung von Salon-Bildergalerie und Portfolios.',
      LucideIcons.image,
    );
  }
}

// Tab 8: Marketing
class _MarketingTab extends ConsumerWidget {
  final String salonId;

  const _MarketingTab({required this.salonId});

  void _showCampaignSnackBar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title gestartet')),
    );
  }

  Widget _buildCampaignTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: TextButton(
          onPressed: () => _showCampaignSnackBar(context, title),
          child: const Text('Starten'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponState = ref.watch(couponListNotifierProvider(salonId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Marketing',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Coupons, Aktionen und Kundenkampagnen zentral verwalten.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          couponState.when(
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Coupon-Statistiken werden geladen...'),
                  ],
                ),
              ),
            ),
            error: (message) => Card(
              child: ListTile(
                leading: const Icon(LucideIcons.alertTriangle),
                title: const Text('Coupons konnten nicht geladen werden'),
                subtitle: Text(message),
              ),
            ),
            loaded: (coupons) {
              final activeCoupons = coupons.where((c) => c.isActive).length;
              final today = DateTime.now();
              final endingSoon = coupons
                  .where(
                    (c) =>
                        c.endDate != null &&
                        c.endDate!.isAfter(today) &&
                        c.endDate!.isBefore(today.add(const Duration(days: 7))),
                  )
                  .length;

              return Row(
                children: [
                  Expanded(
                    child: _buildKPICard(
                      context,
                      'Coupons gesamt',
                      '${coupons.length}',
                      LucideIcons.ticket,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildKPICard(
                      context,
                      'Aktiv',
                      '$activeCoupons',
                      LucideIcons.badgeCheck,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildKPICard(
                      context,
                      'Enden bald',
                      '$endingSoon',
                      LucideIcons.clock3,
                      AppColors.warning,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(LucideIcons.tag),
              title: const Text('Gutscheine & Rabatte verwalten'),
              subtitle: const Text(
                'Öffnet die Coupon-Verwaltung mit Erstellen, Bearbeiten und Einlösen.',
              ),
              trailing: FilledButton(
                onPressed: () => context.go('/admin?tab=coupons'),
                child: const Text('Öffnen'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Kampagnen',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          _buildCampaignTile(
            context,
            icon: LucideIcons.mail,
            title: 'E-Mail Kampagne',
            description: 'Newsletter an Bestandskunden versenden.',
          ),
          _buildCampaignTile(
            context,
            icon: LucideIcons.messageSquare,
            title: 'SMS Erinnerungen',
            description: 'Terminerinnerungen für kommende Buchungen.',
          ),
          _buildCampaignTile(
            context,
            icon: LucideIcons.cake,
            title: 'Geburtstags-Aktionen',
            description: 'Automatische Glückwünsche mit Gutschein-Code.',
          ),
        ],
      ),
    );
  }
}

// Tab 10: Reports
class _ReportsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends ConsumerState<_ReportsTab> {
  int _activeSectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final identity = ref.watch(identityProvider);
    final salonId = identity.currentSalonId;

    if (salonId == null || salonId.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final dashboardService = ref.watch(dashboardServiceProvider);

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        dashboardService.getCurrentMonthOverviewStats(salonId),
        dashboardService.getDailyRevenueSeries(salonId),
        dashboardService.getTopServices(salonId),
        dashboardService.getEmployeePerformance(salonId),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorCard(
            'Fehler beim Laden der Berichte: ${snapshot.error}',
          );
        }

        final monthStats =
            snapshot.data?[0] as Map<String, dynamic>? ?? const {};
        final dailyRevenue =
            (snapshot.data?[1] as List?)?.cast<Map<String, dynamic>>() ??
            const <Map<String, dynamic>>[];
        final topServices =
            (snapshot.data?[2] as List?)?.cast<Map<String, dynamic>>() ??
            const <Map<String, dynamic>>[];
        final employeePerformance =
            (snapshot.data?[3] as List?)?.cast<Map<String, dynamic>>() ??
            const <Map<String, dynamic>>[];

        final totalRevenue =
            (monthStats['totalRevenue'] as num?)?.toDouble() ?? 0.0;
        final totalAppointments =
            (monthStats['totalAppointments'] as int?) ?? 0;
        final averageBookingValue =
            (monthStats['averageBookingValue'] as num?)?.toDouble() ?? 0.0;
        final completionRate =
            (monthStats['completionRate'] as num?)?.toDouble() ?? 0.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Berichte & Analysen',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Monatliche Geschäftsauswertung',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8,
                children: [
                  _buildKPICard(
                    context,
                    'Gesamtumsatz',
                    '€${totalRevenue.toStringAsFixed(0)}',
                    LucideIcons.euro,
                    AppColors.primary,
                  ),
                  _buildKPICard(
                    context,
                    'Termine',
                    '$totalAppointments',
                    LucideIcons.calendar,
                    AppColors.sage,
                  ),
                  _buildKPICard(
                    context,
                    'Ø Buchungswert',
                    '€${averageBookingValue.toStringAsFixed(0)}',
                    LucideIcons.trendingUp,
                    AppColors.gold,
                  ),
                  _buildKPICard(
                    context,
                    'Abschlussrate',
                    '${completionRate.toStringAsFixed(0)}%',
                    LucideIcons.barChart3,
                    AppColors.rose,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSectionChip('Umsatz', 0, LucideIcons.lineChart),
                  _buildSectionChip('Services', 1, LucideIcons.scissors),
                  _buildSectionChip('Mitarbeiter', 2, LucideIcons.users),
                ],
              ),
              const SizedBox(height: 16),
              if (_activeSectionIndex == 0)
                _buildRevenueBarsCard(
                  context,
                  title: 'Tagesumsatz',
                  data: dailyRevenue,
                )
              else if (_activeSectionIndex == 1)
                _buildTopServicesCard(context, topServices)
              else
                _buildEmployeePerformanceCard(context, employeePerformance),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionChip(String label, int index, IconData icon) {
    final isActive = _activeSectionIndex == index;
    return ChoiceChip(
      selected: isActive,
      onSelected: (_) {
        setState(() {
          _activeSectionIndex = index;
        });
      },
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

// Tab 11: Settings
// ignore: unused_element
class _SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildComingSoonTab(
      context,
      'Einstellungen',
      'Allgemeine Salon-Einstellungen, Benachrichtigungen, Integrationen und Sicherheit.',
      LucideIcons.settings,
    );
  }
}

// ============ Helper Widgets ============

Widget _buildKPICard(
  BuildContext context,
  String title,
  String value,
  IconData icon,
  Color color,
  {double? changePercent}
) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatPercentChange(changePercent),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: changePercent == null
                        ? AppColors.textSecondary
                        : changePercent >= 0
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildErrorCard(String message) {
  return Card(
    color: AppColors.error.withValues(alpha: 0.1),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(LucideIcons.alertTriangle, color: AppColors.error),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildComingSoonCard(BuildContext context, String message) {
  return Card(
    color: AppColors.info.withValues(alpha: 0.1),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(LucideIcons.info, color: AppColors.info),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildRevenueBarsCard(
  BuildContext context, {
  required String title,
  required List<Map<String, dynamic>> data,
}) {
  final latestDeltaPercent = data.isEmpty
      ? null
      : (data.last['deltaPercentPrevDay'] as num?)?.toDouble();

  final maxRevenue = data.isEmpty
      ? 0.0
      : data
            .map((entry) => (entry['revenue'] as num?)?.toDouble() ?? 0.0)
            .reduce((a, b) => a > b ? a : b);

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (latestDeltaPercent != null) ...[
            const SizedBox(height: 6),
            _buildPercentBadge(
              context,
              '${_formatPercentChange(latestDeltaPercent)} vs. Vortag',
              latestDeltaPercent,
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((entry) {
                final revenue = (entry['revenue'] as num?)?.toDouble() ?? 0.0;
                final label = entry['label']?.toString() ?? '';
                final sharePercent =
                  (entry['sharePercent'] as num?)?.toDouble() ?? 0.0;
                final heightFactor = maxRevenue <= 0
                    ? 0.0
                    : (revenue / maxRevenue);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: heightFactor,
                              widthFactor: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${sharePercent.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTopServicesCard(
  BuildContext context,
  List<Map<String, dynamic>> services,
) {
  final totalRevenue = services.fold<double>(
    0.0,
    (sum, entry) => sum + ((entry['revenue'] as num?)?.toDouble() ?? 0.0),
  );

  final maxRevenue = services.isEmpty
      ? 0.0
      : services
            .map((entry) => (entry['revenue'] as num?)?.toDouble() ?? 0.0)
            .reduce((a, b) => a > b ? a : b);

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Services',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (services.isEmpty)
            const Text(
              'Keine Service-Daten verfügbar.',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            ...services.map((service) {
              final revenue = (service['revenue'] as num?)?.toDouble() ?? 0.0;
              final count = (service['count'] as int?) ?? 0;
              final completedCount = (service['completedCount'] as int?) ?? 0;
              final plannedCount = (service['plannedCount'] as int?) ?? 0;
              final name = service['name']?.toString() ?? 'Unbekannt';
              final ratio = maxRevenue <= 0 ? 0.0 : (revenue / maxRevenue);
              final sharePct = totalRevenue <= 0
                  ? 0.0
                  : (revenue / totalRevenue) * 100;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '€${revenue.toStringAsFixed(0)} • $completedCount abgeschlossen • $plannedCount geplant • $count gesamt • ${sharePct.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: ratio,
                      minHeight: 8,
                      backgroundColor: AppColors.muted,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.gold,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    ),
  );
}

Widget _buildEmployeePerformanceCard(
  BuildContext context,
  List<Map<String, dynamic>> employees,
) {
  final totalRevenue = employees.fold<double>(
    0.0,
    (sum, entry) => sum + ((entry['revenue'] as num?)?.toDouble() ?? 0.0),
  );

  final maxRevenue = employees.isEmpty
      ? 0.0
      : employees
            .map((entry) => (entry['revenue'] as num?)?.toDouble() ?? 0.0)
            .reduce((a, b) => a > b ? a : b);

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mitarbeiter-Performance',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (employees.isEmpty)
            const Text(
              'Keine Mitarbeiter-Daten verfügbar.',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            ...employees.map((employee) {
              final revenue = (employee['revenue'] as num?)?.toDouble() ?? 0.0;
              final appointments = (employee['appointments'] as int?) ?? 0;
              final completedAppointments =
                (employee['completedCount'] as int?) ??
                (employee['completedAppointments'] as int?) ??
                0;
              final plannedAppointments =
                (employee['plannedCount'] as int?) ??
                (employee['plannedAppointments'] as int?) ??
                0;
              final name = employee['name']?.toString() ?? 'Unbekannt';
              final ratio = maxRevenue <= 0 ? 0.0 : (revenue / maxRevenue);
              final sharePct = totalRevenue <= 0
                  ? 0.0
                  : (revenue / totalRevenue) * 100;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '€${revenue.toStringAsFixed(0)} • $completedAppointments abgeschlossen • $plannedAppointments geplant • $appointments gesamt • ${sharePct.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: ratio,
                      minHeight: 8,
                      backgroundColor: AppColors.muted,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.sage,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    ),
  );
}

Widget _buildPercentBadge(
  BuildContext context,
  String label,
  double value,
) {
  final isPositive = value >= 0;
  final color = isPositive ? AppColors.success : AppColors.error;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

String _formatPercentChange(double? value) {
  if (value == null) {
    return '—';
  }
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

Widget buildComingSoonTab(
  BuildContext context,
  String title,
  String description,
  IconData icon,
) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.construction, color: AppColors.warning),
                const SizedBox(width: 12),
                const Text(
                  'In Entwicklung',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
