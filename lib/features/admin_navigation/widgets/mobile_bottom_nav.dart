import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_providers.dart';
import '../models/navigation_item.dart';
import '../../../core/constants/app_colors.dart';

/// Mobile Bottom Navigation - Sticky Footer (bleibt immer sichtbar beim Scrollen)
class MobileBottomNavigation extends ConsumerWidget {
  const MobileBottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomItems = ref.watch(bottomNavigationItemsProvider);
    final navState = ref.watch(navigationStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bottomItems.map((item) {
              final isActive = navState.currentPage == item.page;
              
              return _buildBottomNavItem(
                context,
                ref,
                item,
                isActive,
                isDark,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Bottom Navigation Item
  Widget _buildBottomNavItem(
    BuildContext context,
    WidgetRef ref,
    NavigationItem item,
    bool isActive,
    bool isDark,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(navigationStateProvider.notifier).navigateToPage(item.page);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon mit Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    item.icon,
                    size: 26,
                    color: isActive
                        ? AppColors.primary
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  if (item.badge != null)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          item.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              // Label
              Text(
                item.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive
                      ? AppColors.primary
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
