import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../admin_navigation/widgets/navigation_layout.dart';
import '../../admin_navigation/models/navigation_item.dart';
import '../../../core/constants/app_colors.dart';

/// Home Overview Screen - Hauptseite mit Dashboard-Übersicht
class HomeOverviewScreen extends ConsumerWidget {
  const HomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationLayout(
      page: NavigationPage.home,
      child: _buildContent(context, ref),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          _buildWelcomeHeader(context, isDark),
          const SizedBox(height: 32),

          // Quick Stats Cards
          _buildStatsGrid(context, isDark),
          const SizedBox(height: 32),

          // Quick Actions
          _buildQuickActions(context, isDark),
          const SizedBox(height: 32),

          // Recent Activities
          _buildRecentActivities(context, isDark),
        ],
      ),
    );
  }

  /// Welcome Header
  Widget _buildWelcomeHeader(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Willkommen zurück! 👋',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Hier ist eine Übersicht deiner Salon-Aktivitäten',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
        ),
      ],
    );
  }

  /// Stats Grid (4 Karten)
  Widget _buildStatsGrid(BuildContext context, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;
        final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth <= 1024;

        int crossAxisCount = 4;
        if (isTablet) {
          crossAxisCount = 2;
        } else if (!isDesktop) {
          crossAxisCount = 1;
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              context,
              isDark,
              icon: Icons.event_rounded,
              iconColor: Colors.blue,
              title: 'Termine Heute',
              value: '24',
              trend: '+12%',
              trendPositive: true,
            ),
            _buildStatCard(
              context,
              isDark,
              icon: Icons.people_rounded,
              iconColor: Colors.green,
              title: 'Aktive Kunden',
              value: '1,284',
              trend: '+8%',
              trendPositive: true,
            ),
            _buildStatCard(
              context,
              isDark,
              icon: Icons.euro_rounded,
              iconColor: Colors.orange,
              title: 'Umsatz (Monat)',
              value: '€12,450',
              trend: '+15%',
              trendPositive: true,
            ),
            _buildStatCard(
              context,
              isDark,
              icon: Icons.trending_up_rounded,
              iconColor: Colors.purple,
              title: 'Performance',
              value: '94%',
              trend: '+3%',
              trendPositive: true,
            ),
          ],
        );
      },
    );
  }

  /// Einzelne Stat Card
  Widget _buildStatCard(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String trend,
    required bool trendPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trendPositive
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 12,
                      color: trendPositive ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: trendPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Quick Actions Grid
  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schnellzugriff',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 1024;
            int crossAxisCount = isDesktop ? 4 : 2;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildQuickActionCard(
                  context,
                  isDark,
                  icon: Icons.add_rounded,
                  label: 'Neuer Termin',
                  color: AppColors.primary,
                ),
                _buildQuickActionCard(
                  context,
                  isDark,
                  icon: Icons.person_add_rounded,
                  label: 'Kunde hinzufügen',
                  color: Colors.green,
                ),
                _buildQuickActionCard(
                  context,
                  isDark,
                  icon: Icons.inventory_rounded,
                  label: 'Lagerbestand',
                  color: Colors.orange,
                ),
                _buildQuickActionCard(
                  context,
                  isDark,
                  icon: Icons.analytics_rounded,
                  label: 'Berichte',
                  color: Colors.blue,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Quick Action Card
  Widget _buildQuickActionCard(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // TODO: Navigation zu entsprechender Seite
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Recent Activities
  Widget _buildRecentActivities(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Letzte Aktivitäten',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? Colors.grey[700] : Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.event_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                title: Text('Neuer Termin gebucht'),
                subtitle: Text('Sarah Müller - Haarschnitt'),
                trailing: Text(
                  'vor ${index + 1} Min',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
