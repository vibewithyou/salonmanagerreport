import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import 'design_system_widgets.dart';

/// Main app shell wrapper providing navigation structure
class AppShell extends StatefulWidget {
  final Widget child;
  final String? currentRoute;
  final Function(String)? onRouteChanged;

  const AppShell({
    Key? key,
    required this.child,
    this.currentRoute,
    this.onRouteChanged,
  }) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with SingleTickerProviderStateMixin {
  late AnimationController _sidebarController;
  bool _sidebarExpanded = true;
  bool _showMobileMenu = false;

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    if (_sidebarExpanded) {
      _sidebarController.forward();
    }
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _sidebarExpanded = !_sidebarExpanded;
    });
    if (_sidebarExpanded) {
      _sidebarController.forward();
    } else {
      _sidebarController.reverse();
    }
  }

  void _toggleMobileMenu() {
    setState(() {
      _showMobileMenu = !_showMobileMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gray900 : AppColors.gray50,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              _showMobileMenu ? Icons.close : Icons.menu,
              color: isDark ? AppColors.gray50 : AppColors.gray900,
            ),
            onPressed: _toggleMobileMenu,
          ),
          title: Text(
            'Salon Manager',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color:
                      isDark ? AppColors.gray50 : AppColors.gray900,
                ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: isDark ? AppColors.gray50 : AppColors.gray900,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle_outlined,
                color: isDark ? AppColors.gray50 : AppColors.gray900,
              ),
              onPressed: () {},
            ),
          ],
        ),
        drawer: _showMobileMenu ? _buildMobileDrawer(context) : null,
        body: widget.child,
      );
    }

    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          AnimatedBuilder(
            animation: _sidebarController,
            builder: (context, child) {
              return SidebarNavigation(
                expanded: _sidebarExpanded,
                onToggle: _toggleSidebar,
                currentRoute: widget.currentRoute,
                onRouteChanged: widget.onRouteChanged,
              );
            },
          ),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Navigation Bar
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.gray900 : AppColors.gray50,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? AppColors.gray800
                            : AppColors.gray200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _SearchBar(),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      UserControlsHeader(),
                    ],
                  ),
                ),
                // Main Content
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Salon Manager',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Divider(),
            Expanded(
              child: _MobileMenuItems(
                currentRoute: widget.currentRoute,
                onRouteChanged: (route) {
                  Navigator.pop(context);
                  widget.onRouteChanged?.call(route);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Responsive Sidebar Navigation
class SidebarNavigation extends StatefulWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final String? currentRoute;
  final Function(String)? onRouteChanged;

  const SidebarNavigation({
    Key? key,
    required this.expanded,
    required this.onToggle,
    this.currentRoute,
    this.onRouteChanged,
  }) : super(key: key);

  @override
  State<SidebarNavigation> createState() => _SidebarNavigationState();
}

class _SidebarNavigationState extends State<SidebarNavigation> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = widget.expanded ? 280.0 : 80.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      color: isDark ? AppColors.gray900 : AppColors.gray50,
      child: Column(
        children: [
          // Logo/Brand Area
          Container(
            height: 70,
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
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
                      'S',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                if (widget.expanded) ...[
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Salon',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Manager',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppColors.gray400
                                    : AppColors.gray600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.md,
              ),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  isActive: widget.currentRoute == '/dashboard',
                  expanded: widget.expanded,
                  onTap: () {
                    widget.onRouteChanged?.call('/dashboard');
                  },
                ),
                _SidebarItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Bookings',
                  isActive: widget.currentRoute == '/bookings',
                  expanded: widget.expanded,
                  onTap: () {
                    widget.onRouteChanged?.call('/bookings');
                  },
                ),
                _SidebarItem(
                  icon: Icons.people_outlined,
                  label: 'Customers',
                  isActive: widget.currentRoute == '/customers',
                  expanded: widget.expanded,
                  onTap: () {
                    widget.onRouteChanged?.call('/customers');
                  },
                ),
                _SidebarItem(
                  icon: Icons.person_outline,
                  label: 'Employees',
                  isActive: widget.currentRoute == '/employees',
                  expanded: widget.expanded,
                  onTap: () {
                    widget.onRouteChanged?.call('/employees');
                  },
                ),
                _SidebarItem(
                  icon: Icons.store_outlined,
                  label: 'Salons',
                  isActive: widget.currentRoute == '/salons',
                  expanded: widget.expanded,
                  onTap: () {
                    widget.onRouteChanged?.call('/salons');
                  },
                ),
                _SidebarItem(
                  icon: Icons.inventory_outlined,
                  label: 'Inventory',
                  isActive: widget.currentRoute == '/inventory',
                  expanded: widget.expanded,
                  onTap: () {
                    widget.onRouteChanged?.call('/inventory');
                  },
                ),
                _SidebarItem(
                  icon: Icons.shopping_cart_outlined,
                  label: 'POS',
                  isActive: widget.currentRoute == '/pos',
                  expanded: widget.expanded,
                  onTap: () {
                    widget.onRouteChanged?.call('/pos');
                  },
                ),
                _SidebarItem(
                  icon: Icons.image_search_outlined,
                  label: 'Gallery',
                  isActive: widget.currentRoute == '/gallery',
                  expanded: widget.expanded,
                  onTap: () {
                    widget.onRouteChanged?.call('/gallery');
                  },
                ),
                _SidebarItem(
                  icon: Icons.chat_outlined,
                  label: 'Chat',
                  isActive: widget.currentRoute == '/chat',
                  expanded: widget.expanded,
                  onTap: () {
                    widget.onRouteChanged?.call('/chat');
                  },
                ),
                _SidebarItem(
                  icon: Icons.assessment_outlined,
                  label: 'Reports',
                  isActive: widget.currentRoute == '/reports',
                  expanded: widget.expanded,
                  onTap: () {
                    widget.onRouteChanged?.call('/reports');
                  },
                ),
              ],
            ),
          ),

          // Collapse Button
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: GestureDetector(
              onTap: widget.onToggle,
              child: HoverLiftCard(
                onTap: widget.onToggle,
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.gray800
                        : AppColors.gray100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.expanded
                        ? Icons.chevron_left
                        : Icons.chevron_right,
                    color: isDark
                        ? AppColors.gray400
                        : AppColors.gray600,
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

/// Individual Sidebar Menu Item
class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool expanded;
  final VoidCallback onTap;

  const _SidebarItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.expanded,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? (isDark ? AppColors.gray800 : AppColors.gray100)
                : (_isHovered
                    ? (isDark ? AppColors.gray800 : AppColors.gray100)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            border: widget.isActive
                ? Border(
                    left: BorderSide(
                      color: AppColors.primary,
                      width: 3,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: widget.isActive
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.gray400
                        : AppColors.gray600),
                size: 20,
              ),
              if (widget.expanded) ...[
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    widget.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: widget.isActive
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.gray400
                                  : AppColors.gray600),
                          fontWeight: widget.isActive
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Mobile Menu Items
class _MobileMenuItems extends StatelessWidget {
  final String? currentRoute;
  final Function(String) onRouteChanged;

  const _MobileMenuItems({
    Key? key,
    required this.currentRoute,
    required this.onRouteChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Dashboard', '/dashboard', Icons.dashboard_outlined),
      ('Bookings', '/bookings', Icons.calendar_today_outlined),
      ('Customers', '/customers', Icons.people_outlined),
      ('Employees', '/employees', Icons.person_outline),
      ('Salons', '/salons', Icons.store_outlined),
      ('Inventory', '/inventory', Icons.inventory_outlined),
      ('POS', '/pos', Icons.shopping_cart_outlined),
      ('Gallery', '/gallery', Icons.image_search_outlined),
      ('Chat', '/chat', Icons.chat_outlined),
      ('Reports', '/reports', Icons.assessment_outlined),
    ];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final (label, route, icon) = items[index];
        final isActive = currentRoute == route;

        return ListTile(
          leading: Icon(icon),
          title: Text(label),
          selected: isActive,
          onTap: () => onRouteChanged(route),
        );
      },
    );
  }
}

/// Search Bar Widget
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search...',
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? AppColors.gray400 : AppColors.gray600,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
      ),
    );
  }
}

/// Header User Controls (Theme, Language, Profile)
class UserControlsHeader extends StatefulWidget {
  @override
  State<UserControlsHeader> createState() => _UserControlsHeaderState();
}

class _UserControlsHeaderState extends State<UserControlsHeader> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Language Selector
        PopupMenuButton<String>(
          onSelected: (lang) {
            if (lang == 'de') {
              context.setLocale(const Locale('de'));
            } else if (lang == 'en') {
              context.setLocale(const Locale('en'));
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'de',
              child: Row(
                children: [
                  Text('🇩🇪 Deutsch'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'en',
              child: Row(
                children: [
                  Text('🇬🇧 English'),
                ],
              ),
            ),
          ],
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray800 : AppColors.gray100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Text('🌐'),
                SizedBox(width: AppSpacing.sm),
                Text(
                  context.locale.languageCode.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Icon(
                  Icons.expand_more,
                  size: 18,
                  color: isDark
                      ? AppColors.gray400
                      : AppColors.gray600,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md),

        // Theme Toggle
        Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isDark ? AppColors.gray800 : AppColors.gray100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: GestureDetector(
            onTap: () {
              // Theme toggle logic
            },
            child: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 20,
              color: isDark ? AppColors.gold : AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md),

        // Profile Dropdown
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'logout') {
              // Handle logout
            } else if (value == 'settings') {
              // Navigate to settings
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 18),
                  SizedBox(width: 8),
                  Text('Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
          ],
          child: Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray800 : AppColors.gray100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: Text(
                'U',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
