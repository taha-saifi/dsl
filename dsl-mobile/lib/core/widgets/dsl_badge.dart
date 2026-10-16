import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum DslBadgeTone { cyan, amber, success, error, muted, violet }

enum DslBadgeStyle {
  /// Solid fill, e.g. "+125 XP".
  filled,

  /// Coloured outline on a faint tint, e.g. status chips ("Completed").
  outlined,

  /// Faint tint, no outline, e.g. level badges ("Beginner").
  soft,
}

/// Figma "DS · Badges" (`52:186`): pill chips for XP, status and level.
class DslBadge extends StatelessWidget {
  const DslBadge({
    required this.label,
    super.key,
    this.tone = DslBadgeTone.cyan,
    this.style = DslBadgeStyle.outlined,
    this.icon,
  });

  final String label;
  final DslBadgeTone tone;
  final DslBadgeStyle style;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = switch (tone) {
      DslBadgeTone.cyan => colors.cyan,
      DslBadgeTone.amber => colors.amber,
      DslBadgeTone.success => colors.success,
      DslBadgeTone.error => colors.error,
      DslBadgeTone.muted => colors.muted,
      DslBadgeTone.violet => colors.violet,
    };

    final (Color background, Color foreground, Color? border) = switch (style) {
      DslBadgeStyle.filled => (accent, colors.ink, null),
      DslBadgeStyle.outlined => (
        accent.withValues(alpha: 0.12),
        accent,
        accent,
      ),
      DslBadgeStyle.soft => (accent.withValues(alpha: 0.18), accent, null),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
          style == DslBadgeStyle.soft ? 8 : AppRadii.pill,
        ),
        border: border == null ? null : Border.all(color: border, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          // Long labels (unit and course names) ellipsize instead of
          // overflowing a narrow screen.
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.type.caption.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
