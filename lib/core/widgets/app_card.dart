import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_shadows.dart';
import '../constants/app_dimensions.dart';
import 'design_system_widgets.dart';

/// AppCard - Base card component with Glass effect
/// Used throughout the app for cards, containers, and elevated surfaces
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool glass;
  final bool elevate;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? shadows;

  const AppCard({
    Key? key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.onTap,
    this.glass = false,
    this.elevate = false,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.shadows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (glass) {
      return GlassContainer(
        width: width,
        height: height,
        padding: padding ?? EdgeInsets.all(AppSpacing.lg),
        borderRadius: borderRadius ?? AppRadius.borderMd,
        shadows: shadows ?? AppShadows.md,
        child: GestureDetector(
          onTap: onTap,
          child: child,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding ?? EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: borderRadius ?? AppRadius.borderMd,
          border: border ?? Border.all(
            color: AppColors.border,
            width: 1,
          ),
          boxShadow: shadows ?? (elevate ? AppShadows.md : null),
        ),
        child: child,
      ),
    );
  }
}

/// HoverCard - Card that responds to hover with lift effect
class HoverCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool glass;

  const HoverCard({
    Key? key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.onTap,
    this.glass = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoverLiftCard(
      onTap: onTap,
      child: AppCard(
        width: width,
        height: height,
        padding: padding,
        glass: glass,
        child: child,
      ),
    );
  }
}

/// ActionCard - Card with icon and text, often used for quick actions
class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool glass;

  const ActionCard({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.onTap,
    this.glass = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      onTap: onTap,
      glass: glass,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primary).withOpacity(0.1),
              borderRadius: AppRadius.borderMd,
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: 28,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// SectionCard - Card for grouping content in sections
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onHeaderTap;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const SectionCard({
    Key? key,
    required this.title,
    required this.child,
    this.onHeaderTap,
    this.trailing,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onHeaderTap,
            child: Padding(
              padding: padding ?? EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.border,
            indent: AppSpacing.lg,
            endIndent: AppSpacing.lg,
          ),
          Padding(
            padding: padding ?? EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ],
      ),
    );
  }
}
