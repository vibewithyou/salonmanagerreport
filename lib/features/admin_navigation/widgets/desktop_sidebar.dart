import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_providers.dart';
import '../models/navigation_item.dart';
import '../../../core/constants/app_colors.dart';

/// Desktop Sidebar - Persistente Navigation für Desktop & Tablet
class DesktopSidebar extends ConsumerWidget {
  final bool isExpanded;
  
  const DesktopSidebar({
    super.key,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navItems = ref.watch(navigationItemsProvider);
    final navState = ref.watch(navigationStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isExpanded ? 250 : 70,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo & Toggle Button
          _buildHeader(context, ref, isDark),
          
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
                  ref,
                  navItems[index],
                  navState,
                  isDark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Header mit Logo und Toggle Button
  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isDark) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Logo/Icon
          Container(
            width: 38,
            height: 38,
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
          
          if (isExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'SalonManager',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          
          // Toggle Button
          IconButton(
            icon: Icon(
              isExpanded
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              size: 20,
            ),
            onPressed: () {
              ref.read(navigationStateProvider.notifier).toggleDesktopSidebar();
            },
            tooltip: isExpanded ? 'Sidebar einklappen' : 'Sidebar ausklappen',
          ),
        ],
      ),
    );
  }

  /// Navigation Item (mit Submenü-Support)
  Widget _buildNavigationItem(
    BuildContext context,
    WidgetRef ref,
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
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                
                if (this.isExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isActive
                            ? AppColors.primary
                            : (isDark ? Colors.grey[300] : Colors.grey[800]),
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
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
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
        
        // Submenü (wenn erweitert)
        if (hasChildren && isExpanded && this.isExpanded)
          ...item.children.map((child) {
            final isChildActive = navState.currentPage == child.page;
            return InkWell(
              onTap: () {
                ref.read(navigationStateProvider.notifier).navigateToPage(child.page);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 8, top: 2, bottom: 2),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      size: 18,
                      color: isChildActive
                          ? AppColors.primary
                          : (isDark ? Colors.grey[500] : Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        child.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isChildActive
                              ? AppColors.primary
                              : (isDark ? Colors.grey[400] : Colors.grey[700]),
                          fontWeight:
                              isChildActive ? FontWeight.w600 : FontWeight.normal,
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
}
