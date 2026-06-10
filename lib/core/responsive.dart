import 'package:flutter/material.dart';

/// Breakpoints
/// - Mobile  : width < 600
/// - Tablet  : 600 <= width < 1024
/// - Desktop : width >= 1024
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= 600 && w < 1024;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  /// Returns the right value based on current breakpoint.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  /// Responsive horizontal content padding.
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return w * 0.1;   // desktop: 10% each side
    if (w >= 600) return w * 0.06;   // tablet : 6% each side
    return 24.0;                      // mobile : 24px
  }

  /// Max content width to avoid stretching on very wide screens.
  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1100;
    if (isTablet(context)) return 840;
    return double.infinity;
  }

  /// Grid cross-axis count for product grids.
  static int gridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }

  /// Width of the permanent side navigation on desktop.
  static const double sideNavWidth = 240.0;
}

/// Wraps [child] in a centered, max-width constrained box.
/// Use on large screens to avoid ultra-wide content.
class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({
    super.key,
    required this.child,
    this.maxWidth = 1100,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final double maxWidth;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
