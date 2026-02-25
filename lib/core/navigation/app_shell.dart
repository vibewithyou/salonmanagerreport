import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../auth/identity_provider.dart';
import '../auth/user_role_helpers.dart';
import 'navigation_items.dart';
import 'sidebar_state_provider.dart';

/// Main app shell with navigation
class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final identity = ref.watch(identityProvider);
    final user = authService.currentUser;
    final isSidebarCollapsed = ref.watch(sidebarCollapsedProvider);
    final isWideScreen = MediaQuery.of(context).size.width >= 768;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (identity.loading || identity.roleKey == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Get navigation items based on identity role if available
    final roleKey = _resolveRoleKey(user.role, identity.roleKey);
    final navItems = getNavigationItems(roleKey);

    if (!isWideScreen) {
      // Mobile: Use Drawer without AppBar
      return Scaffold(
        drawer: _buildDrawer(context, ref, navItems, user, roleKey),
        drawerEnableOpenDragGesture: true,
        body: child,
      );
    }

    // Desktop: Use NavigationRail
    return Scaffold(
      body: Row(
        children: [
          _buildNavigationRail(
            context,
            ref,
            navItems,
            user,
            isSidebarCollapsed,
            roleKey,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildNavigationRail(
    BuildContext context,
    WidgetRef ref,
    List<NavigationGroup> navGroups,
    dynamic user,
    bool isCollapsed,
    String roleKey,
  ) {
    final theme = Theme.of(context);
    final currentPath = GoRouterState.of(context).uri.toString();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isCollapsed ? 72 : 240,
      color: theme.brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with logo and collapse button
          Container(
            height: 64,
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 12 : 16,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment:
                  isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                if (!isCollapsed)
                  Icon(
                    LucideIcons.scissors,
                    color: const Color(0xFFcc9933),
                    size: 28,
                  ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'SalonManager',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                IconButton(
                  icon: Icon(
                    isCollapsed ? LucideIcons.chevronRight : LucideIcons.chevronLeft,
                    size: 20,
                  ),
                  constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    ref.read(sidebarCollapsedProvider.notifier).toggle();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Navigation groups
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final group in navGroups) ...[
                  if (!isCollapsed)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        group.label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  for (final item in group.items)
                    _buildNavItem(
                      context,
                      item,
                      currentPath,
                      isCollapsed,
                      theme,
                    ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),

          // User profile section
          const Divider(height: 1),
          _buildUserProfile(context, ref, user, isCollapsed, theme, roleKey),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    NavigationItem item,
    String currentPath,
    bool isCollapsed,
    ThemeData theme,
  ) {
    final isActive = currentPath == item.path;
    final activeColor = const Color(0xFFcc9933);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 12 : 8,
        vertical: 2,
      ),
      child: Tooltip(
        message: isCollapsed ? item.label : '',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.go(item.path),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 12 : 12,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? activeColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 20,
                    color: isActive
                        ? activeColor
                        : theme.iconTheme.color?.withValues(alpha: 0.7),
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isActive
                              ? activeColor
                              : theme.textTheme.bodyMedium?.color,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(
    BuildContext context,
    WidgetRef ref,
    dynamic user,
    bool isCollapsed,
    ThemeData theme,
    String roleKey,
  ) {
    return Padding(
      padding: EdgeInsets.all(isCollapsed ? 8 : 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFcc9933).withValues(alpha: 0.2),
            child: Text(
              (user.firstName ?? user.email)[0].toUpperCase(),
              style: const TextStyle(
                color: Color(0xFFcc9933),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.firstName ?? user.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _getRoleLabelFromKey(roleKey),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(LucideIcons.moreVertical, size: 18),
              onSelected: (value) {
                if (value == 'profile') {
                  context.go('/profile');
                } else if (value == 'settings') {
                  context.go('/settings');
                } else if (value == 'logout') {
                  ref.read(authServiceProvider).logout();
                  context.go('/auth');
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: Text('Settings'),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    WidgetRef ref,
    List<NavigationGroup> navGroups,
    dynamic user,
    String roleKey,
  ) {
    final theme = Theme.of(context);
    final currentPath = GoRouterState.of(context).uri.toString();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Text(
                    (user.firstName ?? user.email)[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.firstName ?? user.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getRoleLabelFromKey(roleKey),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (final group in navGroups) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      group.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  for (final item in group.items)
                    ListTile(
                      leading: Icon(item.icon),
                      title: Text(item.label),
                      selected: currentPath == item.path,
                      onTap: () {
                        context.go(item.path);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(LucideIcons.logOut),
            title: const Text('Logout'),
            onTap: () {
              ref.read(authServiceProvider).logout();
              context.go('/auth');
            },
          ),
        ],
      ),
    );
  }
}

/// Helper function to get role label without using extensions
String _getRoleLabelFromKey(String roleKey) {
  switch (normalizeRoleKey(roleKey)) {
    case 'owner':
      return 'Saloninhaber';
    case 'admin':
      return 'Admin';
    case 'manager':
      return 'Leitung';
    case 'stylist':
      return 'Stylist';
    case 'employee':
      return 'Mitarbeiter';
    default:
      return 'Kunde';
  }
}

String _resolveRoleKey(UserRole fallbackRole, String? roleKey) {
  if (roleKey == null || roleKey.isEmpty || roleKey == 'unknown') {
    return _roleToString(fallbackRole);
  }

  return normalizeRoleKey(roleKey);
}

/// Helper function to convert UserRole to string for navigation
String _roleToString(UserRole role) {
  switch (role) {
    case UserRole.owner:
      return 'owner';
    case UserRole.admin:
      return 'admin';
    case UserRole.manager:
      return 'manager';
    case UserRole.stylist:
      return 'stylist';
    case UserRole.employee:
      return 'employee';
    case UserRole.customer:
      return 'customer';
  }
}
