import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Layout for public pages (landing, auth pages)
class PublicLayout extends StatelessWidget {
  final Widget child;
  final bool showNavbar;
  final bool showFooter;

  const PublicLayout({
    Key? key,
    required this.child,
    this.showNavbar = true,
    this.showFooter = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (showNavbar) _PublicNavbar(),
            child,
            if (showFooter) _PublicFooter(),
          ],
        ),
      ),
    );
  }
}

/// Public Navigation Bar
class _PublicNavbar extends StatefulWidget {
  @override
  State<_PublicNavbar> createState() => _PublicNavbarState();
}

class _PublicNavbarState extends State<_PublicNavbar> {
  bool _showMobileMenu = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : AppColors.gray50,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.gray800 : AppColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/'),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'SM',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                if (!isMobile) ...[
                  SizedBox(width: AppSpacing.md),
                  Text(
                    'Salon Manager',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ],
            ),
          ),

          // Desktop Navigation
          if (!isMobile) ...[
            Row(
              children: [
                _NavLink('Features', onTap: () {}),
                SizedBox(width: AppSpacing.lg),
                _NavLink('Pricing', onTap: () {}),
                SizedBox(width: AppSpacing.lg),
                _NavLink('About', onTap: () {}),
                SizedBox(width: AppSpacing.lg),
                _NavLink('Contact', onTap: () {}),
              ],
            ),
            SizedBox(width: AppSpacing.lg),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signup'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            IconButton(
              icon: Icon(
                _showMobileMenu ? Icons.close : Icons.menu,
                color: isDark ? AppColors.gray50 : AppColors.gray900,
              ),
              onPressed: () {
                setState(() => _showMobileMenu = !_showMobileMenu);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink(
    this.label, {
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _isHovered ? AppColors.primary : null,
                fontWeight:
                    _isHovered ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
      ),
    );
  }
}

/// Public Footer
class _PublicFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xxl),
      color: isDark ? AppColors.gray900 : AppColors.gray50,
      child: Column(
        children: [
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salon Manager',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'Professional salon management system for modern businesses.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.gray400
                                  : AppColors.gray600,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      _FooterLink('Features'),
                      _FooterLink('Pricing'),
                      _FooterLink('Security'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      _FooterLink('About'),
                      _FooterLink('Blog'),
                      _FooterLink('Contact'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Legal',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      _FooterLink('Privacy'),
                      _FooterLink('Terms'),
                      _FooterLink('Cookies'),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Salon Manager',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: AppSpacing.lg),
                _FooterLink('Features'),
                _FooterLink('Pricing'),
                _FooterLink('About'),
                _FooterLink('Contact'),
                SizedBox(height: AppSpacing.lg),
                _FooterLink('Privacy'),
                _FooterLink('Terms'),
              ],
            ),
          SizedBox(height: AppSpacing.xxl),
          Divider(
            color: isDark ? AppColors.gray800 : AppColors.gray200,
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2024 Salon Manager. All rights reserved.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.gray400
                          : AppColors.gray600,
                    ),
              ),
              Row(
                children: [
                  Icon(Icons.facebook_outlined,
                      size: 20,
                      color: isDark
                          ? AppColors.gray400
                          : AppColors.gray600),
                  SizedBox(width: AppSpacing.md),
                  Icon(Icons.diamond_outlined,
                      size: 20,
                      color: isDark
                          ? AppColors.gray400
                          : AppColors.gray600),
                  SizedBox(width: AppSpacing.md),
                  Icon(Icons.link,
                      size: 20,
                      color: isDark
                          ? AppColors.gray400
                          : AppColors.gray600),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;

  const _FooterLink(this.label);

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Text(
          widget.label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _isHovered
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.gray400
                        : AppColors.gray600),
              ),
        ),
      ),
    );
  }
}
