import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final VoidCallback? onDrawerToggle;
  final bool showDrawer;
  final Widget? drawer;
  final bool showBottomNav;
  final int? selectedBottomNavIndex;
  final List<BottomNavigationBarItem>? bottomNavItems;
  final Function(int)? onBottomNavChanged;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.onDrawerToggle,
    this.showDrawer = true,
    this.drawer,
    this.showBottomNav = false,
    this.selectedBottomNavIndex,
    this.bottomNavItems,
    this.onBottomNavChanged,
    this.backgroundColor,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget.backgroundColor ?? AppColors.white,
      appBar: widget.title != null || widget.actions != null
          ? AppBar(
              title: widget.title != null
                  ? Text(
                      widget.title!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  : null,
              actions: widget.actions,
              leading: widget.showDrawer
                  ? IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    )
                  : null,
            )
          : null,
      drawer: widget.showDrawer ? widget.drawer : null,
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.showBottomNav
          ? BottomNavigationBar(
              items: widget.bottomNavItems ?? [],
              currentIndex: widget.selectedBottomNavIndex ?? 0,
              onTap: widget.onBottomNavChanged,
              type: BottomNavigationBarType.fixed,
            )
          : null,
    );
  }
}

/// Responsive container that adapts to screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? maxWidth;
  final MainAxisAlignment mainAxisAlignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width:
              maxWidth ??
              (isMobile ? double.infinity : AppSizes.maxWidthTablet),
          child: Padding(
            padding:
                padding ?? EdgeInsets.all(isMobile ? AppSizes.md : AppSizes.lg),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Custom elevated card
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final double? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: elevation ?? 1,
        color: backgroundColor ?? AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppSizes.radiusLg,
          ),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSizes.lg),
          child: child,
        ),
      ),
    );
  }
}

/// Custom loading widget
class AppLoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;

  const AppLoadingWidget({super.key, this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSizes.md),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Custom error widget
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryText;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: AppSizes.iconXl,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSizes.lg),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(retryText ?? 'Retry'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state widget
class AppEmptyWidget extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;

  const AppEmptyWidget({
    super.key,
    required this.message,
    this.subMessage,
    this.icon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox,
            size: AppSizes.iconXl,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (subMessage != null) ...[
            const SizedBox(height: AppSizes.sm),
            Text(
              subMessage!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
          if (onAction != null && actionText != null) ...[
            const SizedBox(height: AppSizes.lg),
            ElevatedButton(onPressed: onAction, child: Text(actionText!)),
          ],
        ],
      ),
    );
  }
}
