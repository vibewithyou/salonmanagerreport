/// Navigation Component Integration Examples
/// 
/// This file demonstrates how to use NavigationTokens in actual Flutter widgets
/// to build the left-side collapsible navigation component.
///
/// Reference: navigation_tokens.dart, app_theme.dart, app_colors.dart

import 'package:flutter/material.dart';
import '../constants/navigation_tokens.dart';
import '../constants/app_colors.dart';

// ============================================================================
// 1. COLLAPSIBLE NAVIGATION CONTAINER WIDGET
// ============================================================================

/// Main navigation sidebar widget with collapse/expand functionality
class CollapsibleNavigationSidebar extends StatefulWidget {
  final bool isDarkMode;
  final String currentRoute;
  final Function(String) onMenuItemTapped;
  final String userRole; // customer, employee, stylist, manager, admin, owner

  const CollapsibleNavigationSidebar({
    Key? key,
    required this.isDarkMode,
    required this.currentRoute,
    required this.onMenuItemTapped,
    required this.userRole,
  }) : super(key: key);

  @override
  State<CollapsibleNavigationSidebar> createState() =>
      _CollapsibleNavigationSidebarState();
}

class _CollapsibleNavigationSidebarState
    extends State<CollapsibleNavigationSidebar>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _collapseButtonController;

  @override
  void initState() {
    super.initState();
    _isExpanded = true; // Default to expanded on desktop
    _collapseButtonController = AnimationController(
      duration: NavigationTokens.collapseButtonAnimationDuration,
      vsync: this,
    );
  }

  void _toggleNavigation() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _collapseButtonController.forward();
    } else {
      _collapseButtonController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return AnimatedContainer(
      width: _isExpanded
          ? NavigationTokens.expandedWidth
          : NavigationTokens.collapsedWidth,
      duration: NavigationTokens.expandCollapseDuration,
      curve: NavigationTokens.expandCollapseCurve,
      decoration: BoxDecoration(
        color: isDark
            ? NavigationTokens.containerBgDark
            : NavigationTokens.containerBgLight,
        border: Border(
          right: BorderSide(
            color: isDark
                ? NavigationTokens.containerBorderDark
                : NavigationTokens.containerBorderLight,
            width: NavigationTokens.containerBorderWidth,
          ),
        ),
        boxShadow: isDark
            ? NavigationTokens.containerShadowDark
            : NavigationTokens.containerShadowLight,
      ),
      child: Column(
        children: [
          // Header with Logo
          _buildHeaderSection(isDark),

          // Navigation Items
          Expanded(
            child: _buildMenuItems(isDark),
          ),

          // Collapse/Expand Button
          _buildCollapseButton(isDark),
        ],
      ),
    );
  }

  // ============================================================================
  // 2. HEADER SECTION WITH LOGO
  // ============================================================================

  Widget _buildHeaderSection(bool isDark) {
    return Container(
      height: NavigationTokens.headerHeight,
      padding: _isExpanded
          ? NavigationTokens.headerPaddingExpanded
          : NavigationTokens.headerPaddingCollapsed,
      decoration: BoxDecoration(
        color: isDark
            ? NavigationTokens.headerBgDark
            : NavigationTokens.headerBgLight,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? NavigationTokens.headerBorderDark
                : NavigationTokens.headerBorderLight,
            width: NavigationTokens.headerBorderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            height: NavigationTokens.logoSizeExpanded,
            width: NavigationTokens.logoSizeExpanded,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            child: const Text(
              'S',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Brand Name (shown when expanded)
          if (_isExpanded) ...[
            SizedBox(width: NavigationTokens.headerLogoTextSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SalonManager',
                  style: TextStyle(
                    fontSize: NavigationTokens.headerTextFontSize,
                    fontWeight: NavigationTokens.headerTextFontWeight,
                    color: isDark
                        ? NavigationTokens.headerTextDark
                        : NavigationTokens.headerTextLight,
                  ),
                ),
                Text(
                  'Premium',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? NavigationTokens.headerTextSecondaryDark
                        : NavigationTokens.headerTextSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================================
  // 3. MENU ITEMS SECTION
  // ============================================================================

  Widget _buildMenuItems(bool isDark) {
    final menuItems =
        NavigationTokens.roleMenuItems[widget.userRole] ?? [];

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSection('MENU', menuItems.sublist(0, 4), isDark),
          SizedBox(height: NavigationTokens.sectionSpacing),
          if (widget.userRole != 'customer')
            _buildSection('MANAGEMENT', menuItems.sublist(4), isDark),
          SizedBox(height: NavigationTokens.sectionSpacing),
          if (widget.userRole == 'admin' || widget.userRole == 'owner')
            _buildSection('SETTINGS', ['system_settings'], isDark),
        ],
      ),
    );
  }

  Widget _buildSection(
      String title, List<String> items, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: NavigationTokens.sectionHeaderPadding,
          child: Text(
            title,
            style: TextStyle(
              fontSize: NavigationTokens.sectionHeaderFontSize,
              fontWeight: NavigationTokens.sectionHeaderFontWeight,
              letterSpacing: NavigationTokens.sectionHeaderLetterSpacing,
              color: isDark
                  ? NavigationTokens.sectionHeaderTextDark
                  : NavigationTokens.sectionHeaderTextLight,
            ),
          ),
        ),

        // Menu Items
        ...items.map((item) => _buildMenuItem(item, isDark)),
      ],
    );
  }

  // ============================================================================
  // 4. INDIVIDUAL MENU ITEM
  // ============================================================================

  Widget _buildMenuItem(String itemKey, bool isDark) {
    final isActive = widget.currentRoute == '/$itemKey';
    final label = _getMenuItemLabel(itemKey);
    final icon = _getMenuItemIcon(itemKey);

    return MouseRegion(
      onEnter: (_) {},
      onExit: (_) {},
      child: GestureDetector(
        onTap: () => widget.onMenuItemTapped(itemKey),
        child: AnimatedContainer(
          duration: NavigationTokens.itemAnimationDuration,
          curve: NavigationTokens.itemAnimationCurve,
          height: NavigationTokens.itemHeight,
          margin: EdgeInsets.symmetric(
            horizontal: _isExpanded ? 12.0 : 6.0,
            vertical: 4.0,
          ),
          padding: _isExpanded
              ? NavigationTokens.itemPaddingExpanded
              : NavigationTokens.itemPaddingCollapsed,
          decoration: BoxDecoration(
            color: isActive
                ? (isDark
                    ? NavigationTokens.itemActiveBgDark
                    : NavigationTokens.itemActiveBgLight)
                : (isDark
                    ? NavigationTokens.itemDefaultBgDark
                    : NavigationTokens.itemDefaultBgLight),
            border: isActive
                ? Border(
                    left: BorderSide(
                      color: NavigationTokens.itemActiveBorderLight,
                      width: NavigationTokens.itemActiveBorderWidth,
                    ),
                  )
                : null,
            borderRadius: BorderRadius.circular(
              NavigationTokens.itemActiveBorderRadius,
            ),
            boxShadow: isActive ? NavigationTokens.itemActiveShadow : [],
          ),
          child: Row(
            children: [
              // Icon
              Icon(
                icon,
                size: NavigationTokens.iconSizeExpanded,
                color: isActive
                    ? (isDark
                        ? NavigationTokens.iconColorActiveDark
                        : NavigationTokens.iconColorActiveLight)
                    : (isDark
                        ? NavigationTokens.iconColorDefaultDark
                        : NavigationTokens.iconColorDefaultLight),
              ),

              // Label (shown when expanded)
              if (_isExpanded) ...[
                SizedBox(width: NavigationTokens.iconTextSpacing),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: NavigationTokens.itemTextFontSize,
                      fontWeight: NavigationTokens.itemTextFontWeight,
                      fontFamily: NavigationTokens.itemTextFontFamily,
                      color: isActive
                          ? (isDark
                              ? NavigationTokens.itemActiveTextDark
                              : NavigationTokens.itemActiveTextLight)
                          : (isDark
                              ? NavigationTokens.itemTextDark
                              : NavigationTokens.itemTextLight),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Badge (if applicable)
                if (itemKey == 'messages')
                  _buildNotificationBadge('3', isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // 5. NOTIFICATION BADGE
  // ============================================================================

  Widget _buildNotificationBadge(String count, bool isDark) {
    return Container(
      height: NavigationTokens.badgeSize,
      width: NavigationTokens.badgeSize,
      decoration: BoxDecoration(
        color: NavigationTokens.badgeBgNotification,
        borderRadius:
            BorderRadius.circular(NavigationTokens.badgeBorderRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        count,
        style: const TextStyle(
          fontSize: NavigationTokens.badgeFontSize,
          fontWeight: NavigationTokens.badgeFontWeight,
          color: NavigationTokens.badgeTextColor,
        ),
      ),
    );
  }

  // ============================================================================
  // 6. COLLAPSE/EXPAND BUTTON
  // ============================================================================

  Widget _buildCollapseButton(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: _toggleNavigation,
        child: AnimatedContainer(
          duration: NavigationTokens.collapseButtonAnimationDuration,
          curve: NavigationTokens.collapseButtonAnimationCurve,
          height: NavigationTokens.collapseButtonHeight,
          width: NavigationTokens.collapseButtonWidth,
          decoration: BoxDecoration(
            color: isDark
                ? NavigationTokens.collapseButtonBgDark
                : NavigationTokens.collapseButtonBgLight,
            borderRadius: BorderRadius.circular(
              NavigationTokens.collapseButtonBorderRadius,
            ),
          ),
          alignment: Alignment.center,
          child: AnimatedRotation(
            turns: _isExpanded ? 0 : 0.5,
            duration: NavigationTokens.collapseButtonAnimationDuration,
            curve: NavigationTokens.collapseButtonAnimationCurve,
            child: Icon(
              Icons.chevron_left,
              size: NavigationTokens.collapseButtonIconSize,
              color: isDark
                  ? NavigationTokens.collapseButtonIconDark
                  : NavigationTokens.collapseButtonIconLight,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // 7. HELPER METHODS
  // ============================================================================

  String _getMenuItemLabel(String key) {
    final labels = {
      'dashboard': 'Dashboard',
      'bookings': 'Bookings',
      'appointments': 'Appointments',
      'messages': 'Messages',
      'profile': 'Profile',
      'settings': 'Settings',
      'schedule': 'Schedule',
      'clients': 'Clients',
      'gallery': 'Gallery',
      'services': 'Services',
      'team': 'Team',
      'reports': 'Reports',
      'inventory': 'Inventory',
      'chat': 'Chat',
      'users': 'Users',
      'overview': 'Overview',
      'salon_settings': 'Salon Settings',
      'system_settings': 'System Settings',
      'billing': 'Billing',
    };
    return labels[key] ?? key;
  }

  IconData _getMenuItemIcon(String key) {
    final icons = {
      'dashboard': Icons.dashboard,
      'bookings': Icons.calendar_today,
      'appointments': Icons.event,
      'messages': Icons.message,
      'profile': Icons.person,
      'settings': Icons.settings,
      'schedule': Icons.schedule,
      'clients': Icons.people,
      'gallery': Icons.image,
      'services': Icons.store,
      'team': Icons.group,
      'reports': Icons.assessment,
      'inventory': Icons.warehouse,
      'chat': Icons.chat,
      'users': Icons.supervised_user_circle,
      'overview': Icons.trending_up,
      'salon_settings': Icons.business,
      'system_settings': Icons.construction,
      'billing': Icons.payment,
    };
    return icons[key] ?? Icons.circle;
  }

  @override
  void dispose() {
    _collapseButtonController.dispose();
    super.dispose();
  }
}

// ============================================================================
// 8. EXAMPLE USAGE IN DASHBOARD
// ============================================================================

class DashboardScaffold extends StatefulWidget {
  final String userRole;

  const DashboardScaffold({Key? key, required this.userRole}) : super(key: key);

  @override
  State<DashboardScaffold> createState() => _DashboardScaffoldState();
}

class _DashboardScaffoldState extends State<DashboardScaffold> {
  late String _currentRoute;
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _currentRoute = '/dashboard';
    _isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  void _handleMenuItemTap(String route) {
    setState(() => _currentRoute = route);
    // Navigate to route
    // context.go('/$route');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Navigation Sidebar
          CollapsibleNavigationSidebar(
            isDarkMode: _isDarkMode,
            currentRoute: _currentRoute,
            onMenuItemTapped: _handleMenuItemTap,
            userRole: widget.userRole,
          ),

          // Main Content Area
          Expanded(
            child: Container(
              color: _isDarkMode
                  ? NavigationTokens.containerBgDark
                  : NavigationTokens.containerBgLight,
              child: Center(
                child: Text(
                  'Content for: $_currentRoute',
                  style: TextStyle(
                    color: _isDarkMode
                        ? AppColors.foregroundDark
                        : AppColors.foreground,
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

// ============================================================================
// 9. THEME INTEGRATION TIPS
// ============================================================================

/*
To fully integrate NavigationTokens into your theme system:

1. Import in your app_theme.dart:
   import '../constants/navigation_tokens.dart';

2. Create a ThemeProvider to track dark mode:
   class ThemeProvider extends ChangeNotifier {
     bool _isDarkMode = false;
     
     bool get isDarkMode => _isDarkMode;
     
     void toggleTheme() {
       _isDarkMode = !_isDarkMode;
       notifyListeners();
     }
   }

3. Use in your MaterialApp:
   Consumer<ThemeProvider>(
     builder: (context, themeProvider, _) {
       return MaterialApp(
         theme: AppTheme.lightTheme,
         darkTheme: AppTheme.darkTheme,
         themeMode: themeProvider.isDarkMode 
           ? ThemeMode.dark 
           : ThemeMode.light,
       );
     },
   )

4. Access NavigationTokens from anywhere:
   final isDark = Theme.of(context).brightness == Brightness.dark;
   final containerBg = isDark 
     ? NavigationTokens.containerBgDark
     : NavigationTokens.containerBgLight;

5. For responsive behavior, check screen width:
   bool shouldCollapse = MediaQuery.of(context).size.width < 
     NavigationTokens.autoCollapseWidth;
*/
