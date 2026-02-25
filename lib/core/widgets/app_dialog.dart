import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_shadows.dart';
import 'design_system_widgets.dart';

enum ToastPosition { top, bottom }

/// AppDialog - Custom dialog with design system styling
class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final EdgeInsetsGeometry? contentPadding;

  const AppDialog({
    Key? key,
    required this.title,
    required this.content,
    this.actions,
    this.barrierDismissible = true,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadius.borderLg,
          boxShadow: AppShadows.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: AppColors.border,
            ),
            // Content
            Padding(
              padding: contentPadding ?? EdgeInsets.all(AppSpacing.lg),
              child: content,
            ),
            // Actions
            if (actions != null && actions!.isNotEmpty) ...[
              Divider(height: 1, color: AppColors.border),
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < actions!.length; i++) ...[
                      Expanded(child: actions![i]),
                      if (i < actions!.length - 1)
                        SizedBox(width: AppSpacing.md),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AppDialog(
        title: title,
        content: content,
        actions: actions,
        barrierDismissible: barrierDismissible,
      ),
    );
  }
}

/// AppAlertDialog - Alert dialog with confirm/cancel buttons
class AppAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;

  const AppAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Bestätigen',
    this.cancelText = 'Abbrechen',
    this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onCancel?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gray200,
            foregroundColor: AppColors.foreground,
          ),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDangerous ? AppColors.error : AppColors.primary,
            foregroundColor: AppColors.white,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Bestätigen',
    String cancelText = 'Abbrechen',
    bool isDangerous = false,
  }) {
    return showDialog<bool?>(
      context: context,
      builder: (context) => AppAlertDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDangerous: isDangerous,
        onConfirm: () {},
      ),
    );
  }
}

/// AppBottomSheet - Custom bottom sheet with design system styling
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final double maxHeight;
  final bool isDragable;
  final EdgeInsetsGeometry? padding;

  const AppBottomSheet({
    Key? key,
    this.title,
    required this.child,
    this.actions,
    this.maxHeight = 0.9,
    this.isDragable = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * maxHeight,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: AppShadows.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          if (isDragable)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.md),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          // Title
          if (title != null) ...[
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
            ),
          ],
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: padding ?? EdgeInsets.all(AppSpacing.lg),
              child: child,
            ),
          ),
          // Actions
          if (actions != null && actions!.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  for (int i = 0; i < actions!.length; i++) ...[
                    Expanded(child: actions![i]),
                    if (i < actions!.length - 1)
                      SizedBox(width: AppSpacing.md),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    List<Widget>? actions,
    double maxHeight = 0.9,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => AppBottomSheet(
        title: title,
        child: child,
        actions: actions,
        maxHeight: maxHeight,
      ),
    );
  }
}

/// AppToast - Toast notification
class AppToast extends StatelessWidget {
  final String message;
  final Duration duration;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final ToastPosition position;

  const AppToast({
    Key? key,
    required this.message,
    this.duration = const Duration(seconds: 4),
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.position = ToastPosition.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position == ToastPosition.bottom ? 20 : null,
      top: position == ToastPosition.top ? 20 : null,
      left: 20,
      right: 20,
      child: ScaleUpAnimation(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.foreground,
            borderRadius: AppRadius.borderMd,
            boxShadow: AppShadows.lg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor ?? AppColors.white),
                SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor ?? AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    IconData? icon,
  }) async {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => AppToast(
        message: message,
        duration: duration,
        backgroundColor: backgroundColor,
        icon: icon,
      ),
    );

    overlay.insert(entry);
    await Future.delayed(duration);
    entry.remove();
  }
}
