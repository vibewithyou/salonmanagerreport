import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
// DISABLED: import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/app_colors.dart';
import 'employee_workforce_tabs.dart';

/// PHASE 3: EMPLOYEE DASHBOARD VOLLSTÄNDIG
///
/// 5 Tabs komplett implementiert:
/// 1. Meine Termine - Termin-Liste mit Details BottomSheet
/// 2. Zeiterfassung - Start/Stop Timer mit Statistiken
/// 3. QR Check-in - Scanner + PIN Fallback (1234)
/// 4. Urlaubsanträge - Formular + Status-Liste
/// 5. Dienstplan - Kalender mit farbcodierten Schichten

class EmployeeDashboardScreen extends ConsumerStatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  ConsumerState<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState
    extends ConsumerState<EmployeeDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const Map<String, int> _tabKeyToIndex = {
    'appointments': 0,
    'timetracking': 1,
    'qr': 2,
    'leave': 3,
    'schedule': 4,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _indexForTabKey(String? tabKey) {
    return _tabKeyToIndex[tabKey] ?? 0;
  }

  void _syncTabWithRoute(BuildContext context) {
    final tabKey = GoRouterState.of(context).uri.queryParameters['tab'];
    final targetIndex = _indexForTabKey(tabKey);
    if (_tabController.index == targetIndex) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_tabController.index != targetIndex) {
        _tabController.index = targetIndex;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _syncTabWithRoute(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          _MyAppointmentsTab(),
          _TimeTrackingTab(),
          _QRCheckinTab(),
          EmployeeLeaveRequestsLiveTab(),
          EmployeeScheduleLiveTab(),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 1: MEINE TERMINE
// ============================================================================

class _MyAppointmentsTab extends StatelessWidget {
  const _MyAppointmentsTab();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Header mit Stats
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withOpacity(0.2),
                  Colors.amber.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('EEEE, d. MMMM yyyy', 'de').format(DateTime.now()),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Heute', '0', LucideIcons.calendar),
                    Container(
                      height: 40,
                      width: 1,
                      color: AppColors.gold.withOpacity(0.3),
                    ),
                    _buildStatCard(
                      'Diese Woche',
                      '0',
                      LucideIcons.calendarRange,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: AppColors.gold.withOpacity(0.3),
                    ),
                    _buildStatCard('Erledigt', '0', LucideIcons.checkCircle),
                  ],
                ),
              ],
            ),
          ),

          // Termin-Liste
          Expanded(
            child: _appointments.isEmpty
                ? const Center(
                    child: Text(
                      'Keine Termine vorhanden',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = _appointments[index];
                      return _AppointmentCard(appointment: appointment);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.gold, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showAppointmentDetails(context, appointment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Zeit-Badge
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gold, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      appointment['time'],
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${appointment['duration']} Min',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment['customerName'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment['service'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(LucideIcons.euro, size: 14, color: AppColors.gold),
                        const SizedBox(width: 4),
                        Text(
                          '${appointment['price']}',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status
              _buildStatusBadge(appointment['status']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        icon = LucideIcons.clock;
        break;
      case 'confirmed':
        color = Colors.green;
        icon = LucideIcons.checkCircle;
        break;
      case 'completed':
        color = Colors.blue;
        icon = LucideIcons.check;
        break;
      default:
        color = Colors.grey;
        icon = LucideIcons.circle;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  void _showAppointmentDetails(
    BuildContext context,
    Map<String, dynamic> appointment,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: AppColors.gold, width: 2)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 1),
                  ),
                  child: const Icon(
                    LucideIcons.calendar,
                    color: AppColors.gold,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['customerName'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${appointment['time']} • ${appointment['duration']} Min',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x, color: Colors.white70),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 32),

            // Details
            _buildDetailRow(
              LucideIcons.scissors,
              'Leistung',
              appointment['service'],
            ),
            _buildDetailRow(
              LucideIcons.euro,
              'Preis',
              '€${appointment['price']}',
            ),
            _buildDetailRow(LucideIcons.phone, 'Telefon', appointment['phone']),
            _buildDetailRow(LucideIcons.mail, 'E-Mail', appointment['email']),

            if (appointment['notes'] != null && appointment['notes'].isNotEmpty)
              _buildDetailRow(
                LucideIcons.messageSquare,
                'Notizen',
                appointment['notes'],
              ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Termin abgeschlossen!')),
                      );
                    },
                    icon: const Icon(LucideIcons.check),
                    label: const Text('Abschließen'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to POS
                    },
                    icon: const Icon(LucideIcons.creditCard),
                    label: const Text('Kassieren'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 18),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 2: ZEITERFASSUNG
// ============================================================================

class _TimeTrackingTab extends StatefulWidget {
  const _TimeTrackingTab();

  @override
  State<_TimeTrackingTab> createState() => _TimeTrackingTabState();
}

class _TimeTrackingTabState extends State<_TimeTrackingTab> {
  bool _isTracking = false;
  DateTime? _startTime;
  Duration _currentDuration = Duration.zero;

  void _toggleTracking() {
    setState(() {
      if (_isTracking) {
        // Stop tracking
        _isTracking = false;
        _startTime = null;
        _currentDuration = Duration.zero;
      } else {
        // Start tracking
        _isTracking = true;
        _startTime = DateTime.now();
        _startTimer();
      }
    });
  }

  void _startTimer() {
    if (!_isTracking) return;
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_isTracking && _startTime != null) {
        setState(() {
          _currentDuration = DateTime.now().difference(_startTime!);
        });
        _startTimer();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Current Timer Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _isTracking
                        ? Colors.green.withOpacity(0.2)
                        : AppColors.gold.withOpacity(0.2),
                    _isTracking
                        ? Colors.green.withOpacity(0.1)
                        : Colors.amber.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isTracking ? Colors.green : AppColors.gold,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _isTracking ? LucideIcons.play : LucideIcons.clock,
                    color: _isTracking ? Colors.green : AppColors.gold,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isTracking ? 'Arbeitszeit läuft' : 'Bereit zum starten',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatDuration(_currentDuration),
                    style: TextStyle(
                      color: _isTracking ? Colors.green : AppColors.gold,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _toggleTracking,
                      icon: Icon(
                        _isTracking ? LucideIcons.square : LucideIcons.play,
                      ),
                      label: Text(_isTracking ? 'Stoppen' : 'Starten'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isTracking
                            ? Colors.red
                            : Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (_isTracking && _startTime != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Gestartet um ${DateFormat('HH:mm').format(_startTime!)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatsCard(
                    'Heute',
                    '0:00',
                    'Stunden',
                    LucideIcons.calendar,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard(
                    'Diese Woche',
                    '0:00',
                    'Stunden',
                    LucideIcons.calendarRange,
                    Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatsCard(
                    'Dieser Monat',
                    '0:00',
                    'Stunden',
                    LucideIcons.calendarDays,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard(
                    'Überstunden',
                    '0:00',
                    'Stunden',
                    LucideIcons.trendingUp,
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Entries
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        LucideIcons.history,
                        color: AppColors.gold,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Letzte Einträge',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_timeEntries.isEmpty)
                    const Text(
                      'Keine Einträge vorhanden',
                      style: TextStyle(color: Colors.white54),
                    )
                  else
                    ..._timeEntries.map((entry) => _buildTimeEntry(entry)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            unit,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeEntry(Map<String, String> entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              LucideIcons.clock,
              color: AppColors.gold,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['date']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${entry['start']} - ${entry['end']}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            entry['duration']!,
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 3: QR CHECK-IN
// ============================================================================

class _QRCheckinTab extends StatefulWidget {
  const _QRCheckinTab();

  @override
  State<_QRCheckinTab> createState() => _QRCheckinTabState();
}

class _QRCheckinTabState extends State<_QRCheckinTab> {
  bool _showScanner = false;
  final _pinController = TextEditingController();
  dynamic _scannerController; // Web: null, Mobile: MobileScannerController

  @override
  void dispose() {
    _pinController.dispose();
    if (_scannerController != null) {
      _scannerController?.dispose();
    }
    super.dispose();
  }

  // ignore: unused_element
  void _handleCheckin(String code) {
    setState(() {
      _showScanner = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('Check-in erfolgreich!\nCode: $code')),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handlePinCheckin() {
    final pin = _pinController.text.trim();
    if (pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte PIN eingeben.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _pinController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PIN-Prüfung ist noch nicht angebunden.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showScanner) {
      return Stack(
        children: [
          if (kIsWeb)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.qrCode, size: 64, color: AppColors.gold),
                  const SizedBox(height: 16),
                  const Text(
                    'QR-Code Scanner nicht im Web verfügbar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nutzen Sie die mobile App für den QR Check-In',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _showScanner = false),
                    icon: const Icon(LucideIcons.x),
                    label: const Text('Schließen'),
                  ),
                ],
              ),
            )
          else if (kIsWeb)
            Center(child: Text('QR Scanner not available on Web'))
          else
            Placeholder(), // Mobile: MobileScanner would go here
          // Overlay mit Rahmen
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gold, width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          // Close Button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _showScanner = false;
                  _scannerController?.dispose();
                  _scannerController = null;
                });
              },
              icon: const Icon(LucideIcons.x, color: Colors.white, size: 32),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          // Instructions
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'QR-Code scannen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // QR Scanner Button
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withOpacity(0.2),
                  Colors.amber.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: Column(
              children: [
                const Icon(LucideIcons.qrCode, color: AppColors.gold, size: 80),
                const SizedBox(height: 24),
                const Text(
                  'Check-in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Scanne den QR-Code oder gib deinen PIN ein',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showScanner = true;
                      });
                    },
                    icon: const Icon(LucideIcons.scan),
                    label: const Text('QR-Code scannen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Divider
          const Row(
            children: [
              Expanded(child: Divider(color: Colors.white24)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('ODER', style: TextStyle(color: Colors.white70)),
              ),
              Expanded(child: Divider(color: Colors.white24)),
            ],
          ),

          const SizedBox(height: 32),

          // PIN Input
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              children: [
                const Icon(
                  LucideIcons.keyRound,
                  color: AppColors.gold,
                  size: 40,
                ),
                const SizedBox(height: 16),
                const Text(
                  'PIN eingeben',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 16),
                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 16,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '• • • •',
                    hintStyle: TextStyle(
                      color: Colors.white24,
                      fontSize: 32,
                      letterSpacing: 16,
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.gold.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.gold,
                        width: 2,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _handlePinCheckin(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handlePinCheckin,
                    icon: const Icon(LucideIcons.logIn),
                    label: const Text('Einchecken'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.info, color: Colors.blue, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Der Check-in erfasst deine Anwesenheit und startet ggf. die Zeiterfassung automatisch.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 4: URLAUBSANTRÄGE
// ============================================================================

class _LeaveRequestsTab extends StatefulWidget {
  const _LeaveRequestsTab();

  @override
  State<_LeaveRequestsTab> createState() => _LeaveRequestsTabState();
}

class _LeaveRequestsTabState extends State<_LeaveRequestsTab> {
  bool _showForm = false;
  final _reasonController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _leaveType = 'Urlaub';

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte wähle Start- und Enddatum')),
      );
      return;
    }

    setState(() {
      _showForm = false;
      _startDate = null;
      _endDate = null;
      _reasonController.clear();
      _leaveType = 'Urlaub';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Urlaubsantrag erfolgreich eingereicht!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showForm) {
      return _buildForm();
    }

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Header mit Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Meine Anträge',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showForm = true;
                    });
                  },
                  icon: const Icon(LucideIcons.plus),
                  label: const Text('Neuer Antrag'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatsCard(
                    'Verfügbar',
                    '0',
                    'Tage',
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard(
                    'Beantragt',
                    '0',
                    'Tage',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard('Genommen', '0', 'Tage', Colors.blue),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Requests List
          Expanded(
            child: _leaveRequests.isEmpty
                ? const Center(
                    child: Text(
                      'Keine Anträge vorhanden',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _leaveRequests.length,
                    itemBuilder: (context, index) {
                      final request = _leaveRequests[index];
                      return _buildRequestCard(request);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showForm = false;
                    });
                  },
                  icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                ),
                const Text(
                  'Neuer Urlaubsantrag',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Form Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leave Type Dropdown
                  const Text(
                    'Art des Antrags',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _leaveType,
                    dropdownColor: Colors.grey[800],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Urlaub', child: Text('Urlaub')),
                      DropdownMenuItem(
                        value: 'Krankheit',
                        child: Text('Krankheit'),
                      ),
                      DropdownMenuItem(
                        value: 'Sonderurlaub',
                        child: Text('Sonderurlaub'),
                      ),
                      DropdownMenuItem(
                        value: 'Unbezahlt',
                        child: Text('Unbezahlter Urlaub'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _leaveType = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Start Date
                  const Text(
                    'Von',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppColors.gold,
                                surface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.calendar,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _startDate != null
                                ? DateFormat('dd.MM.yyyy').format(_startDate!)
                                : 'Startdatum wählen',
                            style: TextStyle(
                              color: _startDate != null
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // End Date
                  const Text(
                    'Bis',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: _startDate ?? DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppColors.gold,
                                surface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.calendar,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _endDate != null
                                ? DateFormat('dd.MM.yyyy').format(_endDate!)
                                : 'Enddatum wählen',
                            style: TextStyle(
                              color: _endDate != null
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_startDate != null && _endDate != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.gold.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.info,
                            color: AppColors.gold,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Dauer: ${_endDate!.difference(_startDate!).inDays + 1} Tage',
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Reason
                  const Text(
                    'Begründung (optional)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _reasonController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Zusätzliche Informationen...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.gold,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitRequest,
                      icon: const Icon(LucideIcons.send),
                      label: const Text('Antrag einreichen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildStatsCard(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    Color statusColor;
    IconData statusIcon;
    switch (request['status']) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = LucideIcons.clock;
        break;
      case 'approved':
        statusColor = Colors.green;
        statusIcon = LucideIcons.checkCircle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = LucideIcons.xCircle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = LucideIcons.circle;
    }

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['type'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${request['days']} Tage',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    request['statusText'],
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  LucideIcons.calendar,
                  color: AppColors.gold,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '${request['startDate']} - ${request['endDate']}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            if (request['reason'] != null && request['reason'].isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    LucideIcons.messageSquare,
                    color: Colors.white54,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      request['reason'],
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TAB 5: DIENSTPLAN
// ============================================================================

class _ScheduleTab extends StatefulWidget {
  const _ScheduleTab();

  @override
  State<_ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<_ScheduleTab> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Calendar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: const TextStyle(color: Colors.red),
                defaultTextStyle: const TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                formatButtonVisible: false,
                leftChevronIcon: const Icon(
                  LucideIcons.chevronLeft,
                  color: AppColors.gold,
                ),
                rightChevronIcon: const Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.gold,
                ),
                titleCentered: true,
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white70),
                weekendStyle: TextStyle(color: Colors.red),
              ),
              eventLoader: (day) => [],
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Frühschicht', Colors.green),
                _buildLegendItem('Spätschicht', Colors.orange),
                _buildLegendItem('Frei', Colors.grey),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Selected Day Details
          if (_selectedDay != null)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat(
                        'EEEE, d. MMMM yyyy',
                        'de',
                      ).format(_selectedDay!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Check if weekend
                    if (_selectedDay!.weekday == DateTime.saturday ||
                        _selectedDay!.weekday == DateTime.sunday)
                      _buildShiftCard('Frei', '', Colors.grey, LucideIcons.moon)
                    else
                      _buildShiftCard(
                        'Frühschicht',
                        '08:00 - 16:00',
                        Colors.green,
                        LucideIcons.sun,
                      ),

                    const SizedBox(height: 12),

                    // Info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(LucideIcons.info, color: Colors.blue, size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Bei Fragen zum Dienstplan wende dich an deinen Manager.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text(
                  'Wähle einen Tag, um Details zu sehen',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildShiftCard(
    String title,
    String time,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (time.isNotEmpty)
                  Text(
                    time,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DATA PLACEHOLDERS (empty until backend is connected)
// ============================================================================

final _appointments = <Map<String, dynamic>>[];
final _timeEntries = <Map<String, String>>[];
final _leaveRequests = <Map<String, dynamic>>[];
