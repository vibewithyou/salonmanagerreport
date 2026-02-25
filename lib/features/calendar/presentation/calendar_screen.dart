import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/calendar_provider.dart';
import '../../../models/calendar_model.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime selectedDate;
  late DateTime displayedMonth;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    displayedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  void _previousMonth() {
    setState(() {
      displayedMonth =
          DateTime(displayedMonth.year, displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      displayedMonth =
          DateTime(displayedMonth.year, displayedMonth.month + 1, 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  List<DateTime> _getCalendarDays(DateTime month) {
    List<DateTime> days = [];
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstDayOfWeek = firstDay.weekday;

    // Add previous month's days
    for (int i = firstDayOfWeek - 1; i > 0; i--) {
      days.add(firstDay.subtract(Duration(days: i)));
    }

    // Add current month's days
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    // Add next month's days
    final remainingDays = 42 - days.length;
    for (int i = 1; i <= remainingDays; i++) {
      days.add(DateTime(month.year, month.month + 1, i));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final calendarDays = _getCalendarDays(displayedMonth);
    final eventsAsync = ref.watch(calendarEventsProvider(displayedMonth));
    final summaryAsync = ref.watch(appointmentSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('calendar.title'.tr()),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Statistics Cards
            summaryAsync.when(
              data: (summary) => _buildStatisticsCards(summary),
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SizedBox(
                height: 100,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
                    padding: const EdgeInsets.all(16),
                    child: Text('Error loading statistics'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Calendar Header
            Container(
              decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _previousMonth,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text(
                        DateFormat('MMMM yyyy', context.locale.toString())
                            .format(displayedMonth),
                        style: AppStyles.headlineSmall,
                      ),
                      IconButton(
                        onPressed: _nextMonth,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Weekday Headers
                  GridView.count(
                    crossAxisCount: 7,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.5,
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        .map((day) => Center(
                              child: Text(
                                day,
                                style: AppStyles.labelSmall
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  // Calendar Grid
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: calendarDays.length,
                    itemBuilder: (context, index) {
                      final day = calendarDays[index];
                      final isCurrentMonth = day.month == displayedMonth.month;
                      final isSelected = day.year == selectedDate.year &&
                          day.month == selectedDate.month &&
                          day.day == selectedDate.day;
                      final isToday = day.year == DateTime.now().year &&
                          day.month == DateTime.now().month &&
                          day.day == DateTime.now().day;

                      return eventsAsync.when(
                        data: (events) {
                          final dayEvents = events
                              .where((e) {
                                final eventDate = e.startTime;
                                return eventDate.year == day.year &&
                                    eventDate.month == day.month &&
                                    eventDate.day == day.day;
                              })
                              .toList();

                          return InkWell(
                            onTap: isCurrentMonth ? () => _selectDate(day) : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.3)
                                    : isToday
                                        ? AppColors.primary.withOpacity(0.1)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: isToday && !isSelected
                                    ? Border.all(
                                        color: AppColors.primary,
                                        width: 2,
                                      )
                                    : isSelected
                                        ? Border.all(
                                            color: AppColors.primary,
                                            width: 2,
                                          )
                                        : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    day.day.toString(),
                                    style: AppStyles.bodySmall.copyWith(
                                      color: isCurrentMonth
                                          ? Colors.black87
                                          : Colors.grey,
                                      fontWeight: isSelected || isToday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  if (dayEvents.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          dayEvents.length.clamp(0, 3),
                                          (i) => Container(
                                            width: 4,
                                            height: 4,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 1),
                                            decoration: BoxDecoration(
                                              color: _getEventColor(
                                                  dayEvents[i].eventType),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                        loading: () => Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.3)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(day.day.toString()),
                          ),
                        ),
                        error: (err, stack) => Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.3)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(day.day.toString()),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Day View - Selected Day Appointments
            Container(
              decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'calendar.day_appointments'.tr(args: [
                      DateFormat('dd.MM.yyyy').format(selectedDate),
                    ]),
                    style: AppStyles.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  ref.watch(calendarEventsProvider(displayedMonth)).when(
                        data: (events) {
                          final dayEvents = events
                              .where((e) {
                                final eventDate = e.startTime;
                                return eventDate.year == selectedDate.year &&
                                    eventDate.month == selectedDate.month &&
                                    eventDate.day == selectedDate.day;
                              })
                              .toList();

                          if (dayEvents.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text('calendar.no_appointments'.tr()),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dayEvents.length,
                            itemBuilder: (context, index) {
                              final apt = dayEvents[index];
                              return _buildAppointmentCard(apt, context);
                            },
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (err, stack) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Error: $err'),
                        ),
                      ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Upcoming Week
            Container(
              decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'calendar.upcoming_week'.tr(),
                    style: AppStyles.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  ref.watch(upcomingAppointmentsProvider).when(
                        data: (appointments) {
                          if (appointments.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text('calendar.no_appointments'.tr()),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: appointments.length,
                            itemBuilder: (context, index) {
                              final apt = appointments[index];
                              return _buildAppointmentCard(apt, context);
                            },
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (err, stack) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Error: $err'),
                        ),
                      ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(AppointmentSummary summary) {
    return Row(
      children: [
        _buildStatCard(
          'calendar.total'.tr(),
          summary.totalAppointments.toString(),
          AppColors.primary,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          'calendar.completed'.tr(),
          summary.completedAppointments.toString(),
          Colors.green,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          'calendar.pending'.tr(),
          summary.pendingAppointments.toString(),
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppStyles.headlineMedium.copyWith(color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppStyles.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(CalendarEvent appointment, BuildContext context) {
    final startTime = appointment.startTime;
    final endTime = appointment.endTime;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 56,
          decoration: BoxDecoration(
            color: _getEventColor(appointment.eventType),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          appointment.title,
          style: AppStyles.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}',
              style: AppStyles.labelSmall,
            ),
            if (appointment.status == 'cancelled')
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Cancelled',
                  style: AppStyles.labelSmall.copyWith(color: Colors.red),
                ),
              ),
          ],
        ),
        trailing: _buildAppointmentStatus(appointment.status),
        onTap: () {
          _showAppointmentDetails(context, appointment);
        },
      ),
    );
  }

  Widget _buildAppointmentStatus(String status) {
    Color statusColor;
    String statusLabel;

    switch (status) {
      case 'completed':
        statusColor = Colors.green;
        statusLabel = '✓';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusLabel = '✕';
        break;
      case 'confirmed':
        statusColor = AppColors.primary;
        statusLabel = '●';
        break;
      default:
        statusColor = Colors.orange;
        statusLabel = '◐';
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Text(
        statusLabel,
        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getEventColor(String eventType) {
    switch (eventType) {
      case 'appointment':
        return const Color(0xFFE8A08F); // Rose
      case 'break':
        return Colors.orange;
      case 'holiday':
        return Colors.purple;
      case 'event':
        return AppColors.primary;
      default:
        return Colors.grey;
    }
  }

  void _showAppointmentDetails(BuildContext context, CalendarEvent appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appointment.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'calendar.status'.tr()}: ${appointment.status}'),
            const SizedBox(height: 8),
            Text('${'calendar.type'.tr()}: ${appointment.eventType}'),
            const SizedBox(height: 8),
            if (appointment.description?.isNotEmpty ?? false)
              Text('${'calendar.notes'.tr()}: ${appointment.description}'),
          ],
        ),
        actions: [
          if (appointment.status != 'completed' &&
              appointment.status != 'cancelled')
            TextButton(
              onPressed: () {
                ref
                    .read(calendarNotifierProvider.notifier)
                    .completeAppointment(appointment.id ?? '');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('calendar.appointment_completed'.tr()),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('calendar.complete'.tr()),
            ),
          if (appointment.status != 'cancelled')
            TextButton(
              onPressed: () {
                ref
                    .read(calendarNotifierProvider.notifier)
                    .cancelAppointment(appointment.id ?? '');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('calendar.appointment_cancelled'.tr()),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('calendar.cancel'.tr()),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

