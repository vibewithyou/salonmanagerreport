import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_providers.dart';
import '../models/navigation_item.dart';
import '../../../core/constants/app_colors.dart';

/// Mobile Hamburger Menu - Full-Screen Overlay mit Slide-In Animation
class MobileHamburgerMenu extends ConsumerStatefulWidget {
  const MobileHamburgerMenu({super.key});

  @override
  ConsumerState<MobileHamburgerMenu> createState() => _MobileHamburgerMenuState();
}

class _MobileHamburgerMenuState extends ConsumerState<MobileHamburgerMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeMenu() {
    _animationController.reverse().then((_) {
      if (mounted) {
        ref.read(navigationStateProvider.notifier).closeMobileSidebar();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final navItems = ref.watch(navigationItemsProvider);
    final navState = ref.watch(navigationStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Backdrop (dunkler Hintergrund)
        FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: _closeMenu,
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),

        // Slide-In Menu
        SlideTransition(
          position: _slideAnimation,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header mit Logo und Close Button
                    _buildHeader(context, isDark),

                    // Separator
                    Divider(
                      height: 1,
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                    ),

                    // Navigation Items
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: navItems.length,
                        itemBuilder: (context, index) {
                          return _buildNavigationItem(
                            context,
                            navItems[index],
                            navState,
                            isDark,
                          );
                        },
                      ),
                    ),

                    // Footer (optional - User Info)
                    _buildFooter(context, isDark),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Header mit Logo und Close Button
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.content_cut_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'SalonManager',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          // Close Button
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 24),
            onPressed: _closeMenu,
            tooltip: 'Menü schließen',
          ),
        ],
      ),
    );
  }

  /// Navigation Item (mit Submenü-Support)
  Widget _buildNavigationItem(
    BuildContext context,
    NavigationItem item,
    NavigationState navState,
    bool isDark,
  ) {
    final isActive = navState.currentPage == item.page;
    final isExpanded = navState.expandedMenuIds.contains(item.id);
    final hasChildren = item.children.isNotEmpty;

    return Column(
      children: [
        // Haupteintrag
        InkWell(
          onTap: () {
            if (hasChildren) {
              ref.read(navigationStateProvider.notifier).toggleMenu(item.id);
            } else {
              ref.read(navigationStateProvider.notifier).navigateToPage(item.page);
              _closeMenu();
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Icon
                Icon(
                  item.icon,
                  size: 24,
                  color: isActive
                      ? AppColors.primary
                      : (isDark ? Colors.grey[400] : Colors.grey[700]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isActive
                              ? AppColors.primary
                              : (isDark ? Colors.grey[300] : Colors.grey[800]),
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                  ),
                ),
                // Expand/Collapse Icon bei Submenüs
                if (hasChildren)
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    size: 20,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                // Badge (optional)
                if (item.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Submenü (wenn erweitert)
        if (hasChildren && isExpanded)
          ...item.children.map((child) {
            final isChildActive = navState.currentPage == child.page;
            return InkWell(
              onTap: () {
                ref
                    .read(navigationStateProvider.notifier)
                    .navigateToPage(child.page);
                _closeMenu();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 24, right: 8, top: 2, bottom: 2),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isChildActive
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      child.icon,
                      size: 20,
                      color: isChildActive
                          ? AppColors.primary
                          : (isDark ? Colors.grey[500] : Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        child.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isChildActive
                                  ? AppColors.primary
                                  : (isDark ? Colors.grey[400] : Colors.grey[700]),
                              fontWeight: isChildActive
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  /// Footer mit User Info (optional)
  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Admin User',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'admin@salon.de',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 20),
            onPressed: () {
              // TODO: Logout Funktion
            },
            tooltip: 'Abmelden',
          ),
        ],
      ),
    );
  }
}
