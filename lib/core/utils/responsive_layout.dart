import 'package:flutter/material.dart';
import 'package:product_catalog_application/core/theme/app_spacing.dart';

abstract final class ResponsiveLayout {
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 900;
  static const double maxContentWidth = 1100;

  static bool isTablet(double width) => width >= tabletBreakpoint;

  static bool isDesktop(double width) => width >= desktopBreakpoint;

  static int gridColumnCount(double width) {
    if (width >= desktopBreakpoint) {
      return 3;
    }
    if (width >= tabletBreakpoint) {
      return 2;
    }
    return 1;
  }
}

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = ResponsiveLayout.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

class ResponsiveScrollableEmpty extends StatelessWidget {
  const ResponsiveScrollableEmpty({
    super.key,
    required this.onRefresh,
    required this.child,
    this.minHeight = 280,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: constraints.maxHeight < minHeight
                    ? minHeight
                    : constraints.maxHeight,
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }
}

EdgeInsets responsiveScreenPadding(double width) {
  final horizontal = width >= ResponsiveLayout.desktopBreakpoint
      ? AppSpacing.xl
      : AppSpacing.screenPadding;
  return EdgeInsets.fromLTRB(horizontal, 0, horizontal, AppSpacing.screenPadding);
}
