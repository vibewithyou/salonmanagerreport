import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../models/appointment_model_simple.dart';
import '../../../providers/dashboard_providers.dart';
// TODO: Refactor to use BookingRepository instead of appointment_service

class CustomerDashboardScreenNew extends ConsumerWidget {
  const CustomerDashboardScreenNew({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authServiceProvider).currentUser;
    final appointments = ref.watch(customerAppointmentsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context, user?.firstName ?? 'Kunde'),
            
            const SizedBox(height: 24),

            // Quick Actions Grid
            _buildQuickActionsGrid(context),

            const SizedBox(height: 32),

            // Upcoming Appointments
            Text(
              'Meine Termine',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            appointments.when(
              data: (list) => list.isEmpty
                  ? _buildEmptyState(context)
                  : _buildAppointmentsList(context, list),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Fehler: $e'),
            ),

            const SizedBox(height: 32),

            // Become Salon Owner CTA
            _buildOwnerCTA(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, String userName) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final timeOfDay = now.hour < 12
        ? 'Guten Morgen'
        : now.hour < 18
            ? 'Guten Tag'
            : 'Guten Abend';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gold.withValues(alpha: 0.2),
            AppColors.rose.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeOfDay,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userName,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, d. MMMM yyyy', 'de').format(now),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: LucideIcons.calendar,
        label: 'Termin buchen',
        color: AppColors.gold,
        onTap: () => context.go('/booking'),
      ),
      _QuickAction(
        icon: LucideIcons.clock,
        label: 'Meine Termine',
        color: AppColors.rose,
        onTap: () => context.go('/my-appointments'),
      ),
      _QuickAction(
        icon: LucideIcons.image,
        label: 'Galerie',
        color: AppColors.sage,
        onTap: () => context.go('/gallery'),
      ),
      _QuickAction(
        icon: LucideIcons.sparkles,
        label: 'Inspiration',
        color: AppColors.primary,
        onTap: () => context.go('/inspiration'),
      ),
      _QuickAction(
        icon: LucideIcons.messageCircle,
        label: 'Nachrichten',
        color: AppColors.info,
        onTap: () => context.go('/conversations'),
      ),
      _QuickAction(
        icon: LucideIcons.headphones,
        label: 'Support',
        color: AppColors.success,
        onTap: () => context.go('/support-chat'),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) => _buildQuickActionCard(
        context,
        actions[index],
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, _QuickAction action) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: action.onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  action.icon,
                  color: action.color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                action.label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(
    BuildContext context,
    List<AppointmentSimple> appointments,
  ) {
    return Column(
      children: appointments.map((apt) => _buildAppointmentCard(context, apt)).toList(),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, AppointmentSimple appointment) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(appointment.status);
    final statusText = _getStatusText(appointment.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(LucideIcons.calendar, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEE, d. MMM yyyy', 'de').format(appointment.startTime),
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                Icon(LucideIcons.clock, size: 16, color: AppColors.textSecondary),
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
                  Icon(LucideIcons.user, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    appointment.stylistName!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${appointment.price.toStringAsFixed(2)} €',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Show details modal
                  },
                  child: const Text('Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            LucideIcons.calendarX,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Keine bevorstehenden Termine',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/booking'),
            icon: const Icon(LucideIcons.plus),
            label: const Text('Termin buchen'),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerCTA(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.crown,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Saloninhaber werden',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Verwalten Sie Ihren eigenen Salon mit unserem professionellen Management-System.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/salon-setup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
            ),
            child: const Text('Jetzt starten'),
          ),
        ],
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

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
