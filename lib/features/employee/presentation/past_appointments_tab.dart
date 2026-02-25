import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/employee_dashboard_dto.dart';
import '../../../providers/employee_dashboard_provider.dart';

/// PastAppointmentsTab Widget - displays past appointments with date range filter
class PastAppointmentsTab extends ConsumerStatefulWidget {
  final String employeeId;

  const PastAppointmentsTab({
    required this.employeeId,
    super.key,
  });

  @override
  ConsumerState<PastAppointmentsTab> createState() => _PastAppointmentsTabState();
}

class _PastAppointmentsTabState extends ConsumerState<PastAppointmentsTab> {
  late DateTimeRange _dateRange;
  String _filterStatus = 'all'; // all, completed, cancelled, pending
  List<PastAppointmentDto> _filteredAppointments = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateRange = DateTimeRange(
      start: now.subtract(const Duration(days: 90)),
      end: now,
    );
  }

  void _filterAppointments(List<PastAppointmentDto> appointments) {
    _filteredAppointments = appointments.where((apt) {
      // Filter by date range
      final isInRange = apt.startTime.isAfter(_dateRange.start) &&
          apt.startTime.isBefore(_dateRange.end.add(const Duration(days: 1)));

      if (!isInRange) return false;

      // Filter by status
      if (_filterStatus != 'all' && apt.status != _filterStatus) {
        return false;
      }

      return true;
    }).toList();

    // Sort by date descending (newest first)
    _filteredAppointments.sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  void _showDateRangePicker() async {
    final newRange = await showDateRangePickerDialog(
      context,
      initialStart: _dateRange.start,
      initialEnd: _dateRange.end,
    );

    if (newRange != null) {
      setState(() {
        _dateRange = newRange;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(pastAppointmentsProvider((widget.employeeId, 500)));
    final statsAsync = ref.watch(appointmentStatisticsProvider(widget.employeeId));

    return appointmentsAsync.when(
      data: (appointments) {
        _filterAppointments(appointments);

        return Column(
          children: [
            // Header with Date Range Filter
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Date Range Selector
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _showDateRangePicker,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.gold.withOpacity(0.5)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.calendar,
                                  color: AppColors.gold,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('d. MMM yyyy', 'de')
                                            .format(_dateRange.start),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${(_dateRange.duration.inDays + 1)} Tage',
                                        style: const TextStyle(
                                          color: AppColors.gold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  LucideIcons.chevronDown,
                                  color: Colors.white70,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Quick Range Buttons
                      _buildQuickRangeButton('30T', 30),
                      const SizedBox(width: 8),
                      _buildQuickRangeButton('90T', 90),
                      const SizedBox(width: 8),
                      _buildQuickRangeButton('1J', 365),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStatusFilter('Alle', 'all'),
                        const SizedBox(width: 8),
                        _buildStatusFilter('Abgeschlossen', 'completed'),
                        const SizedBox(width: 8),
                        _buildStatusFilter('Abgebrochen', 'cancelled'),
                        const SizedBox(width: 8),
                        _buildStatusFilter('Ausstehend', 'pending'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Statistics Panel
            statsAsync.when(
              data: (stats) => Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.gold.withOpacity(0.2), Colors.amber.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Gesamt',
                      '${stats.totalAppointments}',
                      LucideIcons.calendar,
                    ),
                    Container(height: 40, width: 1, color: AppColors.gold.withOpacity(0.3)),
                    _buildStatItem(
                      'Abgeschlossen',
                      '${stats.totalCompleted}',
                      LucideIcons.checkCircle,
                    ),
                    Container(height: 40, width: 1, color: AppColors.gold.withOpacity(0.3)),
                    _buildStatItem(
                      'Ertrag',
                      '€${stats.totalRevenue.toStringAsFixed(2)}',
                      LucideIcons.euro,
                    ),
                    Container(height: 40, width: 1, color: AppColors.gold.withOpacity(0.3)),
                    _buildStatItem(
                      'Quote',
                      '${(stats.completionRate * 100).toStringAsFixed(0)}%',
                      LucideIcons.trendingUp,
                    ),
                  ],
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Appointments List
            Expanded(
              child: _filteredAppointments.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _filteredAppointments.length,
                      itemBuilder: (context, index) {
                        return _PastAppointmentCard(
                          appointment: _filteredAppointments[index],
                          onTap: () => _showAppointmentDetails(
                            context,
                            _filteredAppointments[index],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.alertCircle,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Fehler beim Laden der Termine',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(pastAppointmentsProvider((widget.employeeId, 500)));
              },
              icon: const Icon(LucideIcons.rotateCw),
              label: const Text('Erneut versuchen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickRangeButton(String label, int days) {
    final isActive = _dateRange.duration.inDays == days;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            final now = DateTime.now();
            _dateRange = DateTimeRange(
              start: now.subtract(Duration(days: days)),
              end: now,
            );
          });
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.gold.withOpacity(0.3) : Colors.transparent,
            border: Border.all(
              color: isActive ? AppColors.gold : Colors.white24,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.gold : Colors.white70,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilter(String label, String status) {
    final isSelected = _filterStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = selected ? status : 'all';
        });
      },
      backgroundColor: Colors.grey[900],
      selectedColor: AppColors.gold.withOpacity(0.3),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.gold : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.gold : Colors.white24,
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.gold, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.calendar,
              size: 48,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Keine Termine gefunden',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Versuchen Sie einen anderen Zeitraum',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context, PastAppointmentDto appointment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _AppointmentDetailsSheet(appointment: appointment),
    );
  }
}

class _PastAppointmentCard extends StatelessWidget {
  final PastAppointmentDto appointment;
  final VoidCallback onTap;

  const _PastAppointmentCard({
    required this.appointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Date Badge
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
                      DateFormat('d. MMM', 'de').format(appointment.startTime),
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm').format(appointment.startTime),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Appointment Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getCustomerName(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (appointment.appointmentNumber != null)
                      Text(
                        'Nummer: ${appointment.appointmentNumber}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatusBadge(appointment.status),
                        const Spacer(),
                        if (appointment.price != null)
                          Row(
                            children: [
                              const Icon(LucideIcons.euro, size: 14, color: AppColors.gold),
                              const SizedBox(width: 4),
                              Text(
                                '${appointment.price!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),
              const Icon(LucideIcons.chevronRight, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  String _getCustomerName() {
    if (appointment.guestName != null && appointment.guestName!.isNotEmpty) {
      return appointment.guestName!;
    }
    return 'Kundin/Kunde';
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    String label;

    switch (status) {
      case 'completed':
        color = Colors.green;
        icon = LucideIcons.checkCircle;
        label = 'Abgeschlossen';
        break;
      case 'cancelled':
        color = Colors.red;
        icon = LucideIcons.xCircle;
        label = 'Abgebrochen';
        break;
      case 'pending':
        color = Colors.orange;
        icon = LucideIcons.clock;
        label = 'Ausstehend';
        break;
      case 'confirmed':
        color = Colors.blue;
        icon = LucideIcons.checkCircle;
        label = 'Bestätigt';
        break;
      default:
        color = Colors.grey;
        icon = LucideIcons.circle;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentDetailsSheet extends StatelessWidget {
  final PastAppointmentDto appointment;

  const _AppointmentDetailsSheet({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppColors.gold, width: 2)),
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Termin-Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEEE, d. MMMM yyyy', 'de')
                            .format(appointment.startTime),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Customer Info
              _buildDetailSection('Kundin/Kunde', [
                _buildDetailRow(LucideIcons.user, 'Name', _getCustomerName()),
                if (appointment.guestEmail != null)
                  _buildDetailRow(LucideIcons.mail, 'E-Mail', appointment.guestEmail!),
              ]),
              const SizedBox(height: 24),

              // Appointment Info
              _buildDetailSection('Termin-Information', [
                _buildDetailRow(
                  LucideIcons.clock,
                  'Zeit',
                  DateFormat('HH:mm').format(appointment.startTime),
                ),
                _buildDetailRow(
                  LucideIcons.calendar,
                  'Datum',
                  DateFormat('d. MMMM yyyy', 'de').format(appointment.startTime),
                ),
                if (appointment.appointmentNumber != null)
                  _buildDetailRow(
                    LucideIcons.hash,
                    'Nummer',
                    appointment.appointmentNumber!,
                  ),
              ]),
              const SizedBox(height: 24),

              // Status & Price
              _buildDetailSection('Status & Zahlung', [
                Row(
                  children: [
                    const Icon(LucideIcons.info, color: AppColors.gold, size: 18),
                    const SizedBox(width: 12),
                    const Text(
                      'Status:',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadgeLarge(appointment.status),
                  ],
                ),
                const SizedBox(height: 12),
                if (appointment.price != null)
                  Row(
                    children: [
                      const Icon(LucideIcons.euro, color: AppColors.gold, size: 18),
                      const SizedBox(width: 12),
                      const Text(
                        'Betrag:',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '€${appointment.price!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
              ]),
              const SizedBox(height: 32),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.download),
                  label: const Text('Rechnung herunterladen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.share2),
                  label: const Text('Teilen'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.gold,
                    side: const BorderSide(color: AppColors.gold),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCustomerName() {
    if (appointment.guestName != null && appointment.guestName!.isNotEmpty) {
      return appointment.guestName!;
    }
    return 'Kundin/Kunde';
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.info, color: AppColors.gold, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items,
      ],
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

  Widget _buildStatusBadgeLarge(String status) {
    Color color;
    IconData icon;
    String label;

    switch (status) {
      case 'completed':
        color = Colors.green;
        icon = LucideIcons.checkCircle;
        label = 'Abgeschlossen';
        break;
      case 'cancelled':
        color = Colors.red;
        icon = LucideIcons.xCircle;
        label = 'Abgebrochen';
        break;
      case 'pending':
        color = Colors.orange;
        icon = LucideIcons.clock;
        label = 'Ausstehend';
        break;
      case 'confirmed':
        color = Colors.blue;
        icon = LucideIcons.checkCircle;
        label = 'Bestätigt';
        break;
      default:
        color = Colors.grey;
        icon = LucideIcons.circle;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Date Range Picker Dialog
Future<DateTimeRange?> showDateRangePickerDialog(
  BuildContext context, {
  required DateTime initialStart,
  required DateTime initialEnd,
}) {
  return showDialog<DateTimeRange>(
    context: context,
    builder: (context) => _DateRangePickerDialog(
      initialStart: initialStart,
      initialEnd: initialEnd,
    ),
  );
}

class _DateRangePickerDialog extends StatefulWidget {
  final DateTime initialStart;
  final DateTime initialEnd;

  const _DateRangePickerDialog({
    required this.initialStart,
    required this.initialEnd,
  });

  @override
  State<_DateRangePickerDialog> createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<_DateRangePickerDialog> {
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Zeitraum wählen',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(
              'Von',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            subtitle: Text(
              DateFormat('d. MMM yyyy', 'de').format(_start),
              style: const TextStyle(color: AppColors.gold, fontSize: 14),
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _start,
                firstDate: DateTime(2000),
                lastDate: _end,
              );
              if (picked != null) {
                setState(() => _start = picked);
              }
            },
          ),
          ListTile(
            title: const Text(
              'Bis',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            subtitle: Text(
              DateFormat('d. MMM yyyy', 'de').format(_end),
              style: const TextStyle(color: AppColors.gold, fontSize: 14),
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _end,
                firstDate: _start,
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => _end = picked);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen', style: TextStyle(color: Colors.white70)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, DateTimeRange(start: _start, end: _end)),
          child: const Text('OK', style: TextStyle(color: AppColors.gold)),
        ),
      ],
    );
  }
}
