import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DslNavItem {
  const DslNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// Figma "DS · Bottom Nav" (`52:266`): h80, active tab in cyan with a 3px
/// indicator on top. The Practice tab has no screen yet, so the shell passes
/// four items (docs/mobile/features/00-feature-catalog.md, Q34).
class DslBottomNav extends StatelessWidget {
  const DslBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<DslNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.ink,
        border: Border(top: BorderSide(color: colors.inkBorder)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavTab(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                    activeColor: colors.cyan,
                    inactiveColor: colors.muted,
                    labelStyle: type.caption,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.labelStyle,
  });

  final DslNavItem item;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;
    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        highlightShape: BoxShape.rectangle,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3,
              width: 44,
              decoration: BoxDecoration(
                color: selected ? activeColor : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(3),
                ),
              ),
            ),
            const Spacer(),
            Icon(
              selected ? item.activeIcon : item.icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.label,
              style: labelStyle.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
