import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/time_entry_model.dart';
import '../../../providers/dashboard_providers.dart';
// TODO: Refactor to use EmployeeRepository instead of time_tracking_service

class TimeTrackingWidget extends ConsumerStatefulWidget {
  const TimeTrackingWidget({super.key});

  @override
  ConsumerState<TimeTrackingWidget> createState() => _TimeTrackingWidgetState();
}

class _TimeTrackingWidgetState extends ConsumerState<TimeTrackingWidget> {
  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(timeTrackingStatusProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Zeiterfassung',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        statusAsync.when(
          data: (status) => _buildStatusCard(context, status),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => _buildErrorCard(context, e.toString()),
        ),
        const SizedBox(height: 24),
        _buildTodayStats(context),
        const SizedBox(height: 24),
        _buildWeekStats(context),
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context, TimeEntryStatus status) {
    final theme = Theme.of(context);
    final isWorking = status.isCheckedIn;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isWorking
              ? [AppColors.success, AppColors.success.withValues(alpha: 0.7)]
              : [AppColors.info, AppColors.info.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            isWorking ? LucideIcons.arrowUp : LucideIcons.arrowDown,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            isWorking ? 'Arbeit läuft' : 'Nicht eingecheckt',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isWorking ? 'Eingecheckt seit heute' : 'Starte deine Arbeitszeit',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _toggleWorkStatus(isWorking),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: isWorking ? AppColors.success : AppColors.info,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: Icon(isWorking ? LucideIcons.logOut : LucideIcons.logIn),
              label: Text(
                isWorking ? 'Arbeit beenden' : 'Arbeit beginnen',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Card(
      color: AppColors.error.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(LucideIcons.alertCircle, color: AppColors.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Fehler beim Laden: $error',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.calendar, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'Heute',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatRow('Gearbeitet', '0:00 Std.'),
            const SizedBox(height: 8),
            _buildStatRow('Pause', '0:00 Std.'),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildStatRow(
              'Gesamt',
              '0:00 Std.',
              isHighlighted: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekStats(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.calendarDays, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'Diese Woche',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatRow('Arbeitstage', '0'),
            const SizedBox(height: 8),
            _buildStatRow('Gesamtstunden', '0:00 Std.'),
            const SizedBox(height: 8),
            _buildStatRow('Ø pro Tag', '0:00 Std.'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value,
      {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            color: isHighlighted ? AppColors.primary : null,
          ),
        ),
      ],
    );
  }

  Future<void> _toggleWorkStatus(bool isCurrentlyWorking) async {
    final timeTrackingService = ref.read(timeTrackingServiceProvider);

    try {
      if (isCurrentlyWorking) {
        await timeTrackingService.checkOut();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erfolgreich ausgecheckt'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await timeTrackingService.checkIn();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erfolgreich eingecheckt'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      // Refresh status
      ref.invalidate(timeTrackingStatusProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
