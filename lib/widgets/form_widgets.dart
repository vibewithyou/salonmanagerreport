import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

class AppTextFormField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final bool enabled;
  final VoidCallback? onEditingComplete;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final InputDecoration? decoration;
  final VoidCallback? onTap;
  final bool readOnly;

  const AppTextFormField({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
    this.onEditingComplete,
    this.onChanged,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.decoration,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSizes.sm),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          obscureText: _obscureText,
          textCapitalization: widget.textCapitalization,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration:
              widget.decoration ??
              InputDecoration(
                hintText: widget.hintText,
                helperText: widget.helperText,
                errorText: widget.errorText,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscureText = !_obscureText);
                        },
                      )
                    : widget.suffixIcon,
              ),
        ),
      ],
    );
  }
}

/// Custom button with various styles
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final ButtonStyle? style;
  final AppButtonType type;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.icon,
    this.style,
    this.type = AppButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();

    if (type == AppButtonType.text) {
      return TextButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: buttonStyle,
        child: _buildButtonChild(),
      );
    }

    if (type == AppButtonType.outlined) {
      return OutlinedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: buttonStyle,
        child: _buildButtonChild(),
      );
    }

    return ElevatedButton(
      onPressed: enabled && !isLoading ? onPressed : null,
      style: buttonStyle,
      child: _buildButtonChild(),
    );
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: AppSizes.sm),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  ButtonStyle _getButtonStyle() {
    if (style != null) return style!;

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? AppColors.white,
          minimumSize: Size(
            width ?? double.infinity,
            height ?? AppSizes.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        );
      case AppButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.secondary,
          foregroundColor: foregroundColor ?? AppColors.white,
          minimumSize: Size(
            width ?? double.infinity,
            height ?? AppSizes.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        );
      case AppButtonType.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? AppColors.primary,
          minimumSize: Size(
            width ?? double.infinity,
            height ?? AppSizes.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          side: BorderSide(color: backgroundColor ?? AppColors.primary),
        );
      case AppButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: foregroundColor ?? AppColors.primary,
          minimumSize: Size(
            width ?? double.infinity,
            height ?? AppSizes.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        );
      case AppButtonType.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.error,
          foregroundColor: foregroundColor ?? AppColors.white,
          minimumSize: Size(
            width ?? double.infinity,
            height ?? AppSizes.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        );
    }
  }
}

enum AppButtonType { primary, secondary, outlined, text, danger }
