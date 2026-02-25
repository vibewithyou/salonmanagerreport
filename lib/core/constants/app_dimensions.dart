import 'package:flutter/material.dart';

/// Spacing System for Salon Manager App
/// Following TailwindCSS scale
class AppSpacing {
  // Extra small
  static const double xs = 4.0;

  // Small
  static const double sm = 8.0;

  // Medium
  static const double md = 16.0;

  // Large
  static const double lg = 24.0;

  // Extra large
  static const double xl = 32.0;

  // Double extra large
  static const double xxl = 48.0;

  // Triple extra large
  static const double xxxl = 64.0;

  // Padding combinations
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);

  // Vertical padding
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
}

/// Border Radius System
class AppRadius {
  // Small
  static const double sm = 8.0;

  // Medium
  static const double md = 12.0;

  // Large
  static const double lg = 16.0;

  // Extra large
  static const double xl = 20.0;

  // Double extra large
  static const double xxl = 24.0;

  // Full / Circular
  static const double full = 9999.0;

  // BorderRadius objects
  static BorderRadius borderSm = BorderRadius.circular(sm);
  static BorderRadius borderMd = BorderRadius.circular(md);
  static BorderRadius borderLg = BorderRadius.circular(lg);
  static BorderRadius borderXl = BorderRadius.circular(xl);
  static BorderRadius borderXxl = BorderRadius.circular(xxl);
  static BorderRadius borderFull = BorderRadius.circular(full);

  // Individual corners
  static BorderRadius borderTopSm = BorderRadius.only(
    topLeft: Radius.circular(sm),
    topRight: Radius.circular(sm),
  );
  static BorderRadius borderTopMd = BorderRadius.only(
    topLeft: Radius.circular(md),
    topRight: Radius.circular(md),
  );
  static BorderRadius borderTopLg = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );
}

/// Border Width System
class AppBorder {
  static const double thin = 1.0;
  static const double default_ = 2.0;
  static const double thick = 3.0;
}
