import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Level-1 surface from "DS · Elevation" (`52:101`): a slightly lighter ink
/// panel with a hairline outline. Tappable when [onTap] is set.
class DslCard extends StatelessWidget {
  const DslCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.card),
      side: BorderSide(color: borderColor ?? colors.inkBorder),
    );
    return Material(
      color: colors.inkSurface,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
