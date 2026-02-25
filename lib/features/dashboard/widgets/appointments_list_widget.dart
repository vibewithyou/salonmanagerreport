import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/appointment_model_simple.dart';

class AppointmentsListWidget extends ConsumerWidget {
  final List<AppointmentSimple> appointments;
  final bool showActions;
  final Function(AppointmentSimple)? onAppointmentTap;

  const AppointmentsListWidget({
    super.key,
    required this.appointments,
    this.showActions = false,
    this.onAppointmentTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.calendarX,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Termine vorhanden',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _buildAppointmentCard(context, appointment);
      },
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    AppointmentSimple appointment,
  ) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(appointment.status);
    final statusText = _getStatusText(appointment.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onAppointmentTap != null
            ? () => onAppointmentTap!(appointment)
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      appointment.serviceName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(LucideIcons.user,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    appointment.customerName,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(LucideIcons.calendar,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEE, d. MMM yyyy', 'de')
                        .format(appointment.startTime),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  Icon(LucideIcons.clock,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('HH:mm').format(appointment.startTime),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              if (appointment.stylistName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(LucideIcons.scissors,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      appointment.stylistName!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
              if (showActions) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${appointment.price.toStringAsFixed(2)} €',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Show details
                      },
                      icon: const Icon(LucideIcons.moreHorizontal, size: 16),
                      label: const Text('Details'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return AppColors.warning;
      case AppointmentStatus.confirmed:
        return AppColors.success;
      case AppointmentStatus.completed:
        return AppColors.info;
      case AppointmentStatus.cancelled:
      case AppointmentStatus.noShow:
        return AppColors.error;
    }
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Ausstehend';
      case AppointmentStatus.confirmed:
        return 'Bestätigt';
      case AppointmentStatus.completed:
        return 'Abgeschlossen';
      case AppointmentStatus.cancelled:
        return 'Storniert';
      case AppointmentStatus.noShow:
        return 'Nicht erschienen';
    }
  }
}
