import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum DslButtonVariant { primary, secondary, ghost }

enum DslButtonSize {
  large(52, 16),
  medium(44, 15),
  small(36, 13);

  const DslButtonSize(this.height, this.fontSize);
  final double height;
  final double fontSize;
}

/// Figma "DS · Buttons" (`52:129`): h52, radius 14, SemiBold 16.
/// `onPressed: null` renders the Disabled variant; [loading] shows a spinner
/// and blocks taps without changing the button's size.
class DslButton extends StatelessWidget {
  const DslButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = DslButtonVariant.primary,
    this.size = DslButtonSize.large,
    this.loading = false,
    this.expand = true,
    this.icon,
    this.onLight = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final DslButtonVariant variant;
  final DslButtonSize size;
  final bool loading;
  final bool expand;
  final IconData? icon;

  /// On the light lesson surface the Disabled state is white with muted
  /// text (Figma "Select an answer first"), not Ink.
  final bool onLight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null && !loading;
    final disabled = onPressed == null;

    final (
      Color background,
      Color foreground,
      Color? outline,
    ) = switch (variant) {
      _ when disabled && onLight => (colors.white, colors.muted, null),
      _ when disabled => (colors.inkDisabled, colors.muted, null),
      DslButtonVariant.primary => (colors.cyan, colors.white, null),
      DslButtonVariant.secondary => (
        Colors.transparent,
        colors.cyan,
        colors.cyan,
      ),
      DslButtonVariant.ghost => (
        Colors.transparent,
        colors.white,
        colors.inkBorder,
      ),
    };

    final textStyle = context.type.button.copyWith(
      fontSize: size.fontSize,
      color: foreground,
    );

    final content = loading
        ? SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: foreground,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size.fontSize + 4, color: foreground),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Text(
                  label,
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.button),
      side: outline == null
          ? BorderSide.none
          : BorderSide(color: outline, width: 1.5),
    );

    // Its own accessibility node, so a button inside a card or panel is
    // focused and announced separately instead of merging into it.
    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: loading ? '$label, loading' : null,
      excludeSemantics: loading,
      child: SizedBox(
        height: size.height,
        width: expand ? double.infinity : null,
        child: Material(
          color: background,
          shape: shape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Center(child: content),
            ),
          ),
        ),
      ),
    );
  }
}
