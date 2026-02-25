import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// AppInput - Custom text input with design system styling
class AppInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final int? maxLines;
  final int minLines;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool readOnly;
  final bool enabled;

  const AppInput({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.maxLines = 1,
    this.minLines = 1,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        Container(
          decoration: BoxDecoration(
            color: widget.readOnly || !widget.enabled
                ? AppColors.gray100
                : AppColors.surface,
            borderRadius: AppRadius.borderMd,
            border: Border.all(
              color: _isFocused ? AppColors.primary : AppColors.border,
              width: _isFocused ? 2 : 1,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: AppColors.textSecondary)
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? GestureDetector(
                      onTap: widget.onSuffixIconPressed,
                      child: Icon(
                        widget.suffixIcon,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : null,
            ),
            style: const TextStyle(
              color: AppColors.foreground,
              fontSize: 14,
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }
}

/// AppTextArea - Multi-line text input
class AppTextArea extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final int maxLines;
  final int minLines;
  final Function(String)? onChanged;

  const AppTextArea({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.maxLines = 5,
    this.minLines = 3,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppInput(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      errorText: errorText,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
    );
  }
}

/// AppPasswordInput - Password input with show/hide toggle
class AppPasswordInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const AppPasswordInput({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<AppPasswordInput> createState() => _AppPasswordInputState();
}

class _AppPasswordInputState extends State<AppPasswordInput> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return AppInput(
      controller: widget.controller,
      hintText: widget.hintText,
      labelText: widget.labelText,
      errorText: widget.errorText,
      obscureText: !_showPassword,
      keyboardType: TextInputType.visiblePassword,
      suffixIcon: _showPassword ? Icons.visibility_off : Icons.visibility,
      onSuffixIconPressed: () {
        setState(() => _showPassword = !_showPassword);
      },
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
