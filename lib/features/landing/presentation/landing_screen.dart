import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../widgets/language_switcher.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/presentation/register_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(decoration: UiUtils.gradientPrimary()),

          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                _buildHeroSection(context),
                _buildFeaturesSection(context),
                _buildRolesSection(context),
                _buildCTASection(context),
                _buildFooter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.cut, color: AppColors.gold, size: 32),
              const SizedBox(width: 12),
              Text(
                'appName'.tr(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const LanguageSwitcher(),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: UiUtils.textGradient([
              AppColors.gold,
              AppColors.rose,
            ]),
            child: Text(
              'landing.title'.tr(),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 56,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'landing.subtitle'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPrimaryButton(
                context,
                'landing.bookAppointment'.tr(),
                Icons.calendar_month,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
              const SizedBox(width: 16),
              _buildSecondaryButton(
                context,
                'landing.registerSalon'.tr(),
                Icons.store,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      {
        'icon': Icons.calendar_today,
        'title': 'landing.features.easyBooking.title'.tr(),
        'description': 'landing.features.easyBooking.description'.tr(),
      },
      {
        'icon': Icons.people,
        'title': 'landing.features.customerManagement.title'.tr(),
        'description': 'landing.features.customerManagement.description'.tr(),
      },
      {
        'icon': Icons.insert_chart,
        'title': 'landing.features.analytics.title'.tr(),
        'description': 'landing.features.analytics.description'.tr(),
      },
      {
        'icon': Icons.notifications_active,
        'title': 'landing.features.notifications.title'.tr(),
        'description': 'landing.features.notifications.description'.tr(),
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'landing.features.title'.tr(),
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: features.map((feature) {
              return _buildFeatureCard(
                context,
                feature['icon'] as IconData,
                feature['title'] as String,
                feature['description'] as String,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      width: 280,
      decoration: UiUtils.liquidGlass(),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: UiUtils.gradientGold(),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRolesSection(BuildContext context) {
    final roles = [
      {
        'icon': Icons.person,
        'title': 'landing.roles.customer.title'.tr(),
        'description': 'landing.roles.customer.description'.tr(),
        'color': AppColors.rose,
      },
      {
        'icon': Icons.work,
        'title': 'landing.roles.employee.title'.tr(),
        'description': 'landing.roles.employee.description'.tr(),
        'color': AppColors.gold,
      },
      {
        'icon': Icons.admin_panel_settings,
        'title': 'landing.roles.admin.title'.tr(),
        'description': 'landing.roles.admin.description'.tr(),
        'color': AppColors.sage,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      decoration: UiUtils.gradientPrimary(),
      child: Column(
        children: [
          Text(
            'landing.roles.title'.tr(),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: roles.map((role) {
              return _buildRoleCard(
                context,
                role['icon'] as IconData,
                role['title'] as String,
                role['description'] as String,
                role['color'] as Color,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color accentColor,
  ) {
    return Container(
      width: 320,
      decoration: UiUtils.liquidGlass(),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accentColor, accentColor.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'landing.cta.title'.tr(),
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'landing.cta.subtitle'.tr(),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _buildPrimaryButton(
            context,
            'landing.cta.getStarted'.tr(),
            Icons.arrow_forward,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(color: AppColors.primary),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cut, color: AppColors.gold, size: 24),
              const SizedBox(width: 8),
              Text(
                'appName'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'landing.footer.tagline'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'landing.footer.privacy'.tr(),
                  style: TextStyle(color: AppColors.gold),
                ),
              ),
              Text('|', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
              TextButton(
                onPressed: () {},
                child: Text(
                  'landing.footer.terms'.tr(),
                  style: TextStyle(color: AppColors.gold),
                ),
              ),
              Text('|', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
              TextButton(
                onPressed: () {},
                child: Text(
                  'landing.footer.contact'.tr(),
                  style: TextStyle(color: AppColors.gold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© 2024 SalonManager. All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: UiUtils.gradientGold().copyWith(
            borderRadius: BorderRadius.circular(12),
            boxShadow: UiUtils.shadowGold(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: UiUtils.liquidGlass().copyWith(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
