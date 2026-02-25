import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';
import '../constants/app_shadows.dart';
import '../constants/app_dimensions.dart';

/// AppButton - Primary, Secondary, Outlined, Text button variants
/// Matching React design with gradients, glow effects, and hover states
enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger,
  gold,
}

class AppButton extends StatefulWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool disabled;
  final ButtonVariant variant;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final bool showGlow;
  final IconData? icon;
  final bool isIconOnly;

  const AppButton({
    Key? key,
    this.text,
    this.child,
    this.onPressed,
    this.isLoading = false,
    this.disabled = false,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height = 48,
    this.padding,
    this.showGlow = false,
    this.icon,
    this.isIconOnly = false,
  })  : assert(text != null || child != null || icon != null),
        super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _onPressed() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onPressed?.call();
  }

  Color _getBackgroundColor() {
    if (widget.disabled) {
      return AppColors.gray300;
    }

    switch (widget.variant) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.secondary:
        return AppColors.secondary;
      case ButtonVariant.outline:
        return Colors.transparent;
      case ButtonVariant.ghost:
        return Colors.transparent;
      case ButtonVariant.danger:
        return AppColors.error;
      case ButtonVariant.gold:
        return AppColors.gold;
    }
  }

  Color _getForegroundColor() {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return AppColors.white;
      case ButtonVariant.secondary:
        return AppColors.foreground;
      case ButtonVariant.outline:
        return AppColors.primary;
      case ButtonVariant.ghost:
        return AppColors.foreground;
      case ButtonVariant.danger:
        return AppColors.white;
      case ButtonVariant.gold:
        return AppColors.white;
    }
  }

  Border? _getBorder() {
    if (widget.variant == ButtonVariant.outline) {
      return Border.all(
        color: widget.disabled ? AppColors.gray300 : AppColors.primary,
        width: 2,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!widget.disabled && !widget.isLoading) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: (widget.disabled || widget.isLoading) ? null : _onPressed,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: widget.isIconOnly ? widget.height : widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: widget.variant == ButtonVariant.primary && _isHovered
                  ? AppGradients.buttonHover
                  : (widget.variant == ButtonVariant.primary
                      ? AppGradients.primary
                      : null),
              color: widget.variant != ButtonVariant.primary
                  ? _getBackgroundColor()
                  : null,
              border: _getBorder(),
              borderRadius: AppRadius.borderMd,
              boxShadow: widget.showGlow && _isHovered && !widget.disabled
                  ? AppShadows.glow
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap:
                    (widget.disabled || widget.isLoading) ? null : _onPressed,
                borderRadius: AppRadius.borderMd,
                child: Padding(
                  padding: widget.padding ??
                      EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                  child: _buildContent(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_getForegroundColor()),
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (widget.isIconOnly) {
      return Center(
        child: Icon(widget.icon, color: _getForegroundColor()),
      );
    }

    if (widget.icon != null) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: _getForegroundColor()),
            SizedBox(width: AppSpacing.sm),
            if (widget.text != null)
              Flexible(
                child: Text(
                  widget.text!,
                  style: TextStyle(
                    color: _getForegroundColor(),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    if (widget.child != null) {
      return Center(child: widget.child!);
    }

    return Center(
      child: Text(
        widget.text ?? '',
        style: TextStyle(
          color: _getForegroundColor(),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// AppSecondaryButton - Convenience widget for secondary buttons
class AppSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;
  final double? width;

  const AppSecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.disabled = false,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      disabled: disabled,
      variant: ButtonVariant.secondary,
      width: width,
    );
  }
}

/// AppOutlineButton - Convenience widget for outline buttons
class AppOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;
  final double? width;
  final IconData? icon;

  const AppOutlineButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.disabled = false,
    this.width,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      disabled: disabled,
      variant: ButtonVariant.outline,
      width: width,
      icon: icon,
    );
  }
}
