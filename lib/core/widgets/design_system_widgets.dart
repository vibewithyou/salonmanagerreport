import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_shadows.dart';
import '../constants/app_gradients.dart';
import '../constants/app_dimensions.dart';

/// GlassContainer - Glassmorphism widget with blur effect
/// Creates a liquid-glass aesthetic matching React design
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final List<BoxShadow>? shadows;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final bool dark;

  const GlassContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.blur = 20.0,
    this.opacity = 0.9,
    this.shadows,
    this.borderColor,
    this.borderWidth = 1.0,
    this.gradient,
    this.dark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? AppRadius.borderMd;
    final effectiveGradient = gradient ??
        (dark ? AppGradients.glassDark : AppGradients.glass);
    final effectiveBorderColor =
        borderColor ?? Colors.white.withOpacity(0.2);

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            gradient: effectiveGradient,
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: effectiveBorderColor,
              width: borderWidth,
            ),
            boxShadow: shadows,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// HoverLiftCard - Card that lifts on hover/press
/// Provides interactive feedback with smooth animation
class HoverLiftCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double liftDistance;
  final Duration duration;
  final Curve curve;

  const HoverLiftCard({
    Key? key,
    required this.child,
    this.onTap,
    this.liftDistance = 4.0,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
  }) : super(key: key);

  @override
  State<HoverLiftCard> createState() => _HoverLiftCardState();
}

class _HoverLiftCardState extends State<HoverLiftCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _liftAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _liftAnimation = Tween<double>(begin: 0, end: -widget.liftDistance)
        .animate(
          CurvedAnimation(parent: _controller, curve: widget.curve),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _liftAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _liftAnimation.value),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: _isHovered ? AppShadows.lg : AppShadows.md,
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// FadeInAnimation - Widget that fades in with slide animation
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final bool slideUp;

  const FadeInAnimation({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
    this.slideUp = true,
  }) : super(key: key);

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    final slideDistance = widget.slideUp ? 20.0 : 0.0;
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, slideDistance / 100),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// ScaleUpAnimation - Widget that scales up while fading in
class ScaleUpAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double initialScale;

  const ScaleUpAnimation({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.initialScale = 0.8,
  }) : super(key: key);

  @override
  State<ScaleUpAnimation> createState() => _ScaleUpAnimationState();
}

class _ScaleUpAnimationState extends State<ScaleUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.initialScale,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// SlideInAnimation - Widget that slides in from direction
enum SlideDirection { left, right, up, down }

class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration delay;
  final Duration duration;
  final double distance;

  const SlideInAnimation({
    Key? key,
    required this.child,
    this.direction = SlideDirection.up,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.distance = 50.0,
  }) : super(key: key);

  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final offset = _getStartOffset();
    _slideAnimation = Tween<Offset>(
      begin: offset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  Offset _getStartOffset() {
    switch (widget.direction) {
      case SlideDirection.left:
        return Offset(-widget.distance / 100, 0);
      case SlideDirection.right:
        return Offset(widget.distance / 100, 0);
      case SlideDirection.up:
        return Offset(0, widget.distance / 100);
      case SlideDirection.down:
        return Offset(0, -widget.distance / 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
