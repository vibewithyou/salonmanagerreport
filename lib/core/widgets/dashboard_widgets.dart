import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import 'design_system_widgets.dart';

/// Main Time Tracking Widget
class TimeTrackingWidget extends StatefulWidget {
  final String employeeId;
  final Function(TimeEntry)? onClockIn;
  final Function(TimeEntry)? onClockOut;

  const TimeTrackingWidget({
    Key? key,
    required this.employeeId,
    this.onClockIn,
    this.onClockOut,
  }) : super(key: key);

  @override
  State<TimeTrackingWidget> createState() => _TimeTrackingWidgetState();
}

class _TimeTrackingWidgetState extends State<TimeTrackingWidget>
    with TickerProviderStateMixin {
  bool _isClockedIn = false;
  DateTime? _clockInTime;
  DateTime? _clockOutTime;
  final List<TimeEntry> _entries = [];
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _clockIn() {
    setState(() {
      _clockInTime = DateTime.now();
      _isClockedIn = true;
    });
    widget.onClockIn?.call(TimeEntry(
      clockIn: _clockInTime!,
      clockOut: null,
    ));
  }

  void _clockOut() {
    setState(() {
      _clockOutTime = DateTime.now();
      _isClockedIn = false;
      if (_clockInTime != null) {
        _entries.add(TimeEntry(
          clockIn: _clockInTime!,
          clockOut: _clockOutTime!,
        ));
        _clockInTime = null;
        _clockOutTime = null;
      }
    });
    widget.onClockOut?.call(TimeEntry(
      clockIn: _clockInTime!,
      clockOut: _clockOutTime!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Clock Display
          Container(
            margin: EdgeInsets.all(AppSpacing.lg),
            child: GlassContainer(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                children: [
                  Text(
                    'time_tracking'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  
                  // Large Clock Display
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.gray800
                          : AppColors.gray100,
                      border: Border.all(
                        color: _isClockedIn
                            ? AppColors.primary
                            : AppColors.gray300,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<String>(
                            stream: _getTimeStream(),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ?? '00:00:00',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                      color: _isClockedIn
                                          ? AppColors.primary
                                          : AppColors.gray600,
                                    ),
                              );
                            },
                          ),
                          SizedBox(height: AppSpacing.md),
                          Text(
                            _isClockedIn ? 'clocked_in'.tr() : 'clocked_out'.tr(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: _isClockedIn
                                          ? AppColors.primary
                                          : AppColors.gray600,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.xl),

                  // Clock In/Out Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isClockedIn)
                        ScaleUpAnimation(
                          child: GestureDetector(
                            onTap: _clockIn,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.login,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'in'.tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        ScaleUpAnimation(
                          child: GestureDetector(
                            onTap: _clockOut,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.error,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.error.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'out'.tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Today's Summary
          if (_entries.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'today_summary'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  _buildTodaySummary(),
                ],
              ),
            ),

          SizedBox(height: AppSpacing.lg),

          // Time Entries List
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'recent_entries'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: AppSpacing.md),
                if (_entries.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: Text('no_entries'.tr()),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return _TimeEntryCard(entry: entry);
                    },
                  ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildTodaySummary() {
    final now = DateTime.now();
    double totalHours = 0;
    for (final entry in _entries) {
      totalHours +=
          entry.clockOut!.difference(entry.clockIn).inMinutes / 60;
    }

    if (_isClockedIn && _clockInTime != null) {
      totalHours +=
          now.difference(_clockInTime!).inMinutes / 60;
    }

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                'total_hours'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray600,
                    ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                totalHours.toStringAsFixed(2),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'entries'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray600,
                    ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                _entries.length.toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'status'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray600,
                    ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                _isClockedIn ? 'active'.tr() : 'inactive'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isClockedIn
                          ? AppColors.success
                          : AppColors.gray600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Stream<String> _getTimeStream() {
    return Stream.periodic(const Duration(seconds: 1), (_) {
      if (!_isClockedIn) {
        return '00:00:00';
      }

      final elapsed = DateTime.now().difference(_clockInTime!);
      final hours = elapsed.inHours;
      final minutes = elapsed.inMinutes % 60;
      final seconds = elapsed.inSeconds % 60;

      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }
}

/// Individual Time Entry Card
class _TimeEntryCard extends StatelessWidget {
  final TimeEntry entry;

  const _TimeEntryCard({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final duration = entry.clockOut!.difference(entry.clockIn);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.gray700 : AppColors.gray200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.2),
            ),
            child: Center(
              child: Icon(
                Icons.schedule,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(entry.clockIn),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${DateFormat('HH:mm').format(entry.clockIn)} - ${DateFormat('HH:mm').format(entry.clockOut!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.gray400
                            : AppColors.gray600,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${hours}h ${minutes}m',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              Text(
                '${duration.inHours + duration.inMinutes / 60}h',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.gray400
                          : AppColors.gray600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Time Entry Model
class TimeEntry {
  final DateTime clockIn;
  final DateTime? clockOut;

  TimeEntry({
    required this.clockIn,
    required this.clockOut,
  });
}

/// QR Check-in Widget
class QRCheckInWidget extends StatefulWidget {
  final String employeeId;
  final Function(String)? onCheckInSuccess;

  const QRCheckInWidget({
    Key? key,
    required this.employeeId,
    this.onCheckInSuccess,
  }) : super(key: key);

  @override
  State<QRCheckInWidget> createState() => _QRCheckInWidgetState();
}

class _QRCheckInWidgetState extends State<QRCheckInWidget> {
  bool _isScanning = false;
  String? _lastCheckIn;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'qr_check_in'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppSpacing.xl),

          // QR Scanner Placeholder
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isDark
                  ? AppColors.gray800
                  : AppColors.gray100,
            ),
            child: Center(
              child: Icon(
                _isScanning ? Icons.qr_code_scanner : Icons.qr_code_2,
                size: 80,
                color: AppColors.primary,
              ),
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          // Scan Button
          GestureDetector(
            onTap: () {
              setState(() => _isScanning = true);
              // Simulate QR scan
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  setState(() => _isScanning = false);
                  _lastCheckIn = DateFormat('HH:mm:ss').format(DateTime.now());
                  widget.onCheckInSuccess?.call('QR123456');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('check_in_success'.tr())),
                  );
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _isScanning ? 'scanning'.tr() : 'start_scan'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          // Last Check-in
          if (_lastCheckIn != null) ...[
            Text(
              'last_check_in'.tr(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.gray600,
                  ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              _lastCheckIn!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Appointments Overview Widget
class AppointmentsOverviewWidget extends StatefulWidget {
  final String employeeId;

  const AppointmentsOverviewWidget({
    Key? key,
    required this.employeeId,
  }) : super(key: key);

  @override
  State<AppointmentsOverviewWidget> createState() =>
      _AppointmentsOverviewWidgetState();
}

class _AppointmentsOverviewWidgetState
    extends State<AppointmentsOverviewWidget> {
  final appointments = [
    {
      'id': '1',
      'customer': 'Sarah Johnson',
      'service': 'Haircut',
      'time': '09:00 AM',
      'duration': '30 min',
      'status': 'confirmed'
    },
    {
      'id': '2',
      'customer': 'Emma Davis',
      'service': 'Color & Highlights',
      'time': '10:30 AM',
      'duration': '120 min',
      'status': 'confirmed'
    },
    {
      'id': '3',
      'customer': 'Lisa Wilson',
      'service': 'Styling',
      'time': '01:00 PM',
      'duration': '60 min',
      'status': 'pending'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Text(
            'today_appointments'.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final apt = appointments[index];
            final isConfirmed = apt['status'] == 'confirmed';

            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray800 : AppColors.gray100,
                border: Border.all(
                  color: isConfirmed
                      ? AppColors.primary
                      : AppColors.warning,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isConfirmed
                          ? AppColors.primary.withOpacity(0.2)
                          : AppColors.warning.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        color: isConfirmed
                            ? AppColors.primary
                            : AppColors.warning,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          apt['customer'] ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '${apt['service']} • ${apt['duration']}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: isDark
                                    ? AppColors.gray400
                                    : AppColors.gray600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        apt['time'] ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: AppSpacing.sm),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isConfirmed
                              ? AppColors.success.withOpacity(0.2)
                              : AppColors.warning.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          apt['status']?.toString().toUpperCase() ?? '',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isConfirmed
                                        ? AppColors.success
                                        : AppColors.warning,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
