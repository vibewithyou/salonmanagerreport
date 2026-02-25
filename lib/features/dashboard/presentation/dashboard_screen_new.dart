import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../widgets/language_switcher.dart';
import '../../../services/supabase_service.dart';
import '../../../providers/auth_provider.dart';
import '../../booking/presentation/booking_wizard_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          _buildSidebar(context, currentUserAsync),

          // Main Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey.shade50, Colors.white],
                ),
              ),
              child: _buildPage(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, AsyncValue currentUserAsync) {
    return Container(
      width: 280,
      decoration: UiUtils.gradientPrimary(),
      child: Column(
        children: [
          // Header with Logo
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: UiUtils.gradientGold(),
                  child: const Icon(Icons.cut, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'appName'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                currentUserAsync.when(
                  data: (userData) => Text(
                    userData?.fullName ?? 'dashboard.guest'.tr(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white30, height: 1),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard,
                  title: 'dashboard.overview'.tr(),
                  selected: _selectedIndex == 0,
                  onTap: () => _selectPage(0),
                ),
                _SidebarItem(
                  icon: Icons.calendar_today,
                  title: 'dashboard.appointments'.tr(),
                  selected: _selectedIndex == 1,
                  onTap: () => _selectPage(1),
                ),
                _SidebarItem(
                  icon: Icons.store,
                  title: 'customer.browseSalons'.tr(),
                  selected: _selectedIndex == 2,
                  onTap: () => _selectPage(2),
                ),
                _SidebarItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'conversations.title'.tr(),
                  selected: _selectedIndex == 3,
                  onTap: () => _selectPage(3),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(color: Colors.white30, height: 1),
                ),
                const SizedBox(height: 8),
                _SidebarItem(
                  icon: Icons.person,
                  title: 'dashboard.profile'.tr(),
                  selected: _selectedIndex == 4,
                  onTap: () => _selectPage(4),
                ),
                _SidebarItem(
                  icon: Icons.settings,
                  title: 'dashboard.settings'.tr(),
                  selected: _selectedIndex == 5,
                  onTap: () => _selectPage(5),
                ),
              ],
            ),
          ),

          // Language Switcher
          const Padding(padding: EdgeInsets.all(16), child: LanguageSwitcher()),

          // Logout
          Container(
            padding: const EdgeInsets.all(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await SupabaseService().signOut();
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed('/');
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'auth.logout'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
    );
  }

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 1:
        return const BookingDashboard();
      case 2:
        return const SalonsDashboard();
      case 3:
        return const ChatDashboard();
      case 4:
        return const ProfileDashboard();
      case 5:
        return const SettingsDashboard();
      default:
        return const MainDashboard();
    }
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: selected
                ? BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                  )
                : null,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected
                      ? AppColors.gold
                      : Colors.white.withOpacity(0.8),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.white.withOpacity(0.8),
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (selected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Dashboard Pages

class MainDashboard extends ConsumerWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          currentUserAsync.when(
            data: (userData) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: UiUtils.textGradient([
                    AppColors.gold,
                    AppColors.rose,
                  ]),
                  child: Text(
                    '${'dashboard.welcome'.tr()}, ${userData?.firstName ?? 'dashboard.guest'.tr()}!',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'dashboard.welcomeMessage'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => Text('dashboard.welcome'.tr()),
          ),

          const SizedBox(height: 32),

          // Quick Actions
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _QuickActionCard(
                icon: Icons.calendar_today,
                title: 'booking.newBooking'.tr(),
                subtitle: 'booking.bookAppointment'.tr(),
                color: AppColors.gold,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BookingWizardScreen(),
                    ),
                  );
                },
              ),
              _QuickActionCard(
                icon: Icons.store,
                title: 'customer.browseSalons'.tr(),
                subtitle: 'customer.findSalon'.tr(),
                color: AppColors.rose,
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.history,
                title: 'customer.myBookings'.tr(),
                subtitle: 'customer.viewHistory'.tr(),
                color: AppColors.sage,
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.person,
                title: 'dashboard.profile'.tr(),
                subtitle: 'common.manageProfile'.tr(),
                color: AppColors.primary,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Upcoming Appointments
          Text(
            'dashboard.upcomingAppointments'.tr(),
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: UiUtils.liquidGlass(),
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 64,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'dashboard.noAppointments'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'dashboard.bookFirstAppointment'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
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

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: UiUtils.liquidGlass(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookingDashboard extends StatelessWidget {
  const BookingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'customer.myBookings'.tr(),
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          Container(
            decoration: UiUtils.liquidGlass(),
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                Icon(
                  Icons.event_busy,
                  size: 64,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'dashboard.noBookings'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'dashboard.createFirstBooking'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BookingWizardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: UiUtils.gradientGold().copyWith(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'booking.newBooking'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.add, color: Colors.white),
                        ],
                      ),
                    ),
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

class SalonsDashboard extends StatelessWidget {
  const SalonsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'customer.browseSalons'.tr(),
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          Container(
            decoration: UiUtils.liquidGlass(),
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                Icon(
                  Icons.store_outlined,
                  size: 64,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'dashboard.noSalons'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'dashboard.salonsComingSoon'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
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

class ChatDashboard extends StatelessWidget {
  const ChatDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'conversations.title'.tr(),
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          Container(
            decoration: UiUtils.liquidGlass(),
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'dashboard.noMessages'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'dashboard.messagesComingSoon'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
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

class ProfileDashboard extends StatelessWidget {
  const ProfileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'dashboard.profile'.tr(),
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          Container(
            decoration: UiUtils.liquidGlass(),
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 64,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'dashboard.profileComingSoon'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
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

class SettingsDashboard extends StatelessWidget {
  const SettingsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'dashboard.settings'.tr(),
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          Container(
            decoration: UiUtils.liquidGlass(),
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                Icon(
                  Icons.settings_outlined,
                  size: 64,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'dashboard.settingsComingSoon'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
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
