import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_providers.dart';
import '../models/navigation_item.dart';
import 'desktop_sidebar.dart';
import 'mobile_bottom_nav.dart';
import 'mobile_hamburger_menu.dart';

/// Navigation Layout Wrapper - Responsives Hauptlayout
/// 
/// Verwaltet das Layout basierend auf Bildschirmgröße:
/// - Desktop (>1024px): Persistente Sidebar links
/// - Tablet (768-1024px): Collapsible Icon-Sidebar
/// - Mobile (<768px): Hamburger Menu + Bottom Navigation
class NavigationLayout extends ConsumerWidget {
  final NavigationPage page;
  final Widget child;
  
  const NavigationLayout({
    super.key,
    required this.page,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationStateProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Bestimme Layout-Typ basierend auf Bildschirmbreite
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth >= 768 && screenWidth <= 1024;
    final isMobile = screenWidth < 768;

    // Setze aktuelle Seite
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navState.currentPage != page) {
        ref.read(navigationStateProvider.notifier).navigateToPage(page);
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildLayout(
        context,
        ref,
        isDesktop: isDesktop,
        isTablet: isTablet,
        isMobile: isMobile,
      ),
    );
  }

  Widget _buildLayout(
    BuildContext context,
    WidgetRef ref, {
    required bool isDesktop,
    required bool isTablet,
    required bool isMobile,
  }) {
    if (isDesktop) {
      return _buildDesktopLayout(context, ref);
    } else if (isTablet) {
      return _buildTabletLayout(context, ref);
    } else {
      return _buildMobileLayout(context, ref);
    }
  }

  /// Desktop Layout: Persistente Sidebar + Content
  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationStateProvider);

    return Row(
      children: [
        // Desktop Sidebar (immer sichtbar)
        DesktopSidebar(
          isExpanded: navState.isDesktopSidebarExpanded,
        ),
        
        // Main Content
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              children: [
                // Header mit Breadcrumb (optional)
                _buildHeader(context, ref),
                
                // Scrollbarer Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Tablet Layout: Collapsible Icon-Sidebar + Content
  Widget _buildTabletLayout(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Tablet Sidebar (nur Icons)
        DesktopSidebar(
          isExpanded: false, // Immer collapsed auf Tablet
        ),
        
        // Main Content
        Expanded(
          child: Column(
            children: [
              _buildHeader(context, ref),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Mobile Layout: Hamburger + Bottom Nav + Content
  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationStateProvider);

    return Stack(
      children: [
        // Main Content mit Bottom Padding für Bottom Nav
        Column(
          children: [
            // Mobile Header mit Hamburger
            _buildMobileHeader(context, ref),
            
            // Scrollbarer Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 80, // Platz für Bottom Navigation
                ),
                child: child,
              ),
            ),
          ],
        ),
        
        // Bottom Navigation (Sticky Footer)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: MobileBottomNavigation(),
        ),
        
        // Hamburger Menu Overlay
        if (navState.isMobileSidebarOpen)
          MobileHamburgerMenu(),
      ],
    );
  }

  /// Header für Desktop/Tablet mit Breadcrumb
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final currentNavItem = ref.watch(currentNavigationItemProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Breadcrumb
          Expanded(
            child: _buildBreadcrumb(context, ref, currentNavItem),
          ),
          
          // Header Actions (z.B. Notifications, User Menu)
          _buildHeaderActions(context, ref),
        ],
      ),
    );
  }

  /// Mobile Header mit Hamburger Icon
  Widget _buildMobileHeader(BuildContext context, WidgetRef ref) {
    final currentNavItem = ref.watch(currentNavigationItemProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Hamburger Menu Button
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              ref.read(navigationStateProvider.notifier).toggleMobileSidebar();
            },
          ),
          
          const SizedBox(width: 8),
          
          // Aktueller Seitentitel
          Expanded(
            child: Text(
              currentNavItem?.label ?? 'Dashboard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Header Actions
          _buildHeaderActions(context, ref),
        ],
      ),
    );
  }

  /// Breadcrumb Navigation
  Widget _buildBreadcrumb(
    BuildContext context,
    WidgetRef ref,
    NavigationItem? currentItem,
  ) {
    if (currentItem == null) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(
          currentItem.icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          currentItem.label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Header Actions (Notifications, User Menu, etc.)
  Widget _buildHeaderActions(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Notifications
        IconButton(
          icon: Badge(
            label: const Text('3'),
            child: const Icon(Icons.notifications_rounded),
          ),
          onPressed: () {
            // TODO: Zeige Benachrichtigungen
          },
        ),
        
        const SizedBox(width: 8),
        
        // User Menu
        PopupMenuButton<String>(
          icon: CircleAvatar(
            radius: 16,
            child: const Icon(Icons.person_rounded, size: 20),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Text('Profil'),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Text('Einstellungen'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Text('Abmelden'),
            ),
          ],
          onSelected: (value) {
            if (value == 'logout') {
              // TODO: Logout
            } else if (value == 'profile') {
              ref.read(navigationStateProvider.notifier)
                  .navigateToPage(NavigationPage.profileAccount);
            } else if (value == 'settings') {
              ref.read(navigationStateProvider.notifier)
                  .navigateToPage(NavigationPage.profileSettings);
            }
          },
        ),
      ],
    );
  }
}
