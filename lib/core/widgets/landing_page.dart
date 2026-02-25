import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import 'design_system_widgets.dart';
import 'app_button.dart';

/// Landing Page Widget
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section
          _HeroSection(),
          SizedBox(height: AppSpacing.xxxl),

          // Features Grid
          _FeaturesSection(),
          SizedBox(height: AppSpacing.xxxl),

          // Roles Section
          _RolesSection(),
          SizedBox(height: AppSpacing.xxxl),

          // Pricing Section
          _PricingSection(),
          SizedBox(height: AppSpacing.xxxl),

          // CTA Section
          _CTASection(),
        ],
      ),
    );
  }
}

/// Hero Section with headline, description, and CTA
class _HeroSection extends StatefulWidget {
  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxxl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      'landing_page.modern_salon_management'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Headline
                  Text(
                    'landing_page.salon_management_simplified'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.displayMedium?.fontSize ?? 32,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Subheadline
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Text(
                      'landing_page.salon_software_description'.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.95),
                            height: 1.6,
                          ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // CTA Buttons
                  if (isMobile)
                    Column(
                      children: [
                        AppButton(
                          text: 'landing_page.get_started'.tr(),
                          onPressed: () {
                            Navigator.pushNamed(context, '/booking');
                          },
                          variant: ButtonVariant.primary,
                          showGlow: true,
                        ),
                        SizedBox(height: AppSpacing.md),
                        AppButton(
                          text: 'landing_page.learn_more'.tr(),
                          onPressed: () {},
                          variant: ButtonVariant.outline,
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                          text: 'landing_page.get_started'.tr(),
                          onPressed: () {
                            Navigator.pushNamed(context, '/booking');
                          },
                          variant: ButtonVariant.primary,
                          showGlow: true,
                        ),
                        SizedBox(width: AppSpacing.lg),
                        AppButton(
                          text: 'landing_page.learn_more'.tr(),
                          onPressed: () {},
                          variant: ButtonVariant.outline,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: AppSpacing.xxxl),

          // Hero Image / Illustration
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.primary.withValues(alpha: 0.08),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.dashboard_customize_outlined,
                size: 120,
                color: AppColors.primary.withOpacity(0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Features Grid Section
class _FeaturesSection extends StatelessWidget {
  final features = const [
    {
      'icon': Icons.calendar_month,
      'title': 'landing_page.booking_management',
      'description': 'landing_page.booking_management_desc',
    },
    {
      'icon': Icons.people_outline,
      'title': 'landing_page.customer_database',
      'description': 'landing_page.customer_database_desc',
    },
    {
      'icon': Icons.person_outline,
      'title': 'landing_page.employee_management',
      'description': 'landing_page.employee_management_desc',
    },
    {
      'icon': Icons.inventory_2_outlined,
      'title': 'landing_page.inventory_system',
      'description': 'landing_page.inventory_system_desc',
    },
    {
      'icon': Icons.shopping_cart_outlined,
      'title': 'landing_page.point_of_sale',
      'description': 'landing_page.point_of_sale_desc',
    },
    {
      'icon': Icons.assessment_outlined,
      'title': 'landing_page.analytics_reports',
      'description': 'landing_page.analytics_reports_desc',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxxl,
      ),
      child: Column(
        children: [
          Text(
            'landing_page.powerful_features'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'landing_page.features_description'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.gray600,
                ),
          ),
          SizedBox(height: AppSpacing.xxxl),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: AppSpacing.lg,
              mainAxisSpacing: AppSpacing.lg,
              childAspectRatio: isMobile ? 1 : 1.2,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return _FeatureCard(
                icon: feature['icon'] as IconData,
                titleKey: feature['title'] as String,
                descriptionKey: feature['description'] as String,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Individual Feature Card
class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String titleKey;
  final String descriptionKey;

  const _FeatureCard({
    Key? key,
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
  }) : super(key: key);

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.primary.withValues(alpha: 0.1)
              : (isDark
                  ? AppColors.gray800
                  : AppColors.gray100),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.gray200,
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.2),
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              widget.titleKey.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              widget.descriptionKey.tr(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.gray400
                        : AppColors.gray600,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Roles Section
class _RolesSection extends StatelessWidget {
  final roles = const [
    {
      'icon': '👨‍💼',
      'role': 'landing_page.salon_owner',
      'benefits': [
        'Real-time analytics',
        'Staff management',
        'Revenue tracking',
        'Inventory control',
      ]
    },
    {
      'icon': '💇',
      'role': 'landing_page.stylist',
      'benefits': [
        'Schedule overview',
        'Client information',
        'Time tracking',
        'Portfolio showcase',
      ]
    },
    {
      'icon': '👨‍💻',
      'role': 'landing_page.client',
      'benefits': [
        'Easy booking',
        'Service details',
        'Staff selection',
        'Appointment history',
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxxl,
      ),
      child: Column(
        children: [
          Text(
            'landing_page.built_for_everyone'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppSpacing.xl),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: AppSpacing.lg,
              mainAxisSpacing: AppSpacing.lg,
            ),
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              return _RoleCard(
                icon: role['icon'] as String,
                roleKey: role['role'] as String,
                benefits: role['benefits'] as List<String>,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Role Card
class _RoleCard extends StatelessWidget {
  final String icon;
  final String roleKey;
  final List<String> benefits;

  const _RoleCard({
    Key? key,
    required this.icon,
    required this.roleKey,
    required this.benefits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 48),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            roleKey.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppSpacing.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: benefits
                .map((benefit) => Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              benefit,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isDark
                                        ? AppColors.gray400
                                        : AppColors.gray600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// Pricing Section
class _PricingSection extends StatelessWidget {
  final plans = const [
    {
      'name': 'Starter',
      'price': '\$29',
      'features': [
        'Up to 3 stylists',
        'Basic bookings',
        'Customer database',
        'Mobile app access',
      ]
    },
    {
      'name': 'Professional',
      'price': '\$79',
      'features': [
        'Up to 10 stylists',
        'Advanced bookings',
        'Inventory management',
        'Analytics',
        'POS system',
      ],
      'highlighted': true,
    },
    {
      'name': 'Enterprise',
      'price': 'Custom',
      'features': [
        'Unlimited users',
        'Multi-location',
        'Advanced analytics',
        'API access',
        'Priority support',
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxxl,
      ),
      child: Column(
        children: [
          Text(
            'simple_pricing'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppSpacing.xl),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: AppSpacing.lg,
              mainAxisSpacing: AppSpacing.lg,
            ),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return _PricingCard(
                name: plan['name'] as String,
                price: plan['price'] as String,
                features: plan['features'] as List<String>,
                highlighted: plan['highlighted'] as bool? ?? false,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Pricing Card
class _PricingCard extends StatelessWidget {
  final String name;
  final String price;
  final List<String> features;
  final bool highlighted;

  const _PricingCard({
    Key? key,
    required this.name,
    required this.price,
    required this.features,
    required this.highlighted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.primary
            : (isDark
                ? AppColors.gray800
                : AppColors.gray100),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted
              ? AppColors.primary
              : AppColors.gray200,
          width: highlighted ? 2 : 1,
        ),
        boxShadow: highlighted
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                )
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (highlighted)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Most Popular',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          SizedBox(height: AppSpacing.lg),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: highlighted ? Colors.white : null,
                ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            price,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: highlighted ? Colors.white : AppColors.primary,
                ),
          ),
          Text(
            '/month',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: highlighted
                      ? Colors.white.withOpacity(0.8)
                      : AppColors.gray600,
                ),
          ),
          SizedBox(height: AppSpacing.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features
                .map((feature) => Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: highlighted
                                ? Colors.white
                                : AppColors.primary,
                            size: 18,
                          ),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              feature,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: highlighted
                                        ? Colors.white.withOpacity(0.9)
                                        : null,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: highlighted
                      ? Colors.white
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: highlighted
                      ? null
                      : Border.all(color: AppColors.primary),
                ),
                child: Center(
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: highlighted ? AppColors.primary : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// CTA Section
class _CTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.xl),
      padding: EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'ready_to_get_started'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'join_hundreds_of_salons'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/signup'),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'start_free_trial'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
