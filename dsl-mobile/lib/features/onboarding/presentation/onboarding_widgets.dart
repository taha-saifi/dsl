import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../auth/presentation/auth_widgets.dart';

/// Shared frame of the three onboarding steps (Figma `57:5`, `57:73`,
/// `57:132`): step bar, two-line title with the second line in cyan,
/// scrolling body, and a bottom button with a footnote.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    required this.step,
    required this.stepLabel,
    required this.titleLine1,
    required this.titleLine2,
    required this.subtitle,
    required this.body,
    required this.buttonLabel,
    required this.onContinue,
    required this.footnote,
    super.key,
    this.onBack,
    this.trailing,
    this.loading = false,
    this.error,
  });

  static const stepCount = 3;

  final int step;
  final String stepLabel;
  final String titleLine1;
  final String titleLine2;
  final String subtitle;
  final Widget body;
  final String buttonLabel;
  final VoidCallback? onContinue;
  final String footnote;
  final VoidCallback? onBack;
  final Widget? trailing;
  final bool loading;

  /// Shown above the button, outside the scrolling body, so it's always seen.
  final String? error;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: onBack == null
                        ? null
                        : IconButton(
                            tooltip: 'Back',
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: colors.white,
                            onPressed: onBack,
                          ),
                  ),
                  Expanded(child: _StepBar(step: step)),
                  SizedBox(width: 88, child: trailing),
                ],
              ),
            ),
            Text(
              stepLabel,
              textAlign: TextAlign.center,
              style: type.caption.copyWith(color: colors.muted),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenMargin,
              ),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '$titleLine1\n'),
                        TextSpan(
                          text: titleLine2,
                          style: TextStyle(color: colors.cyan),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: type.h1.copyWith(color: colors.white),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: type.body.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(child: body),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                AppSpacing.md,
                AppSpacing.screenMargin,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  if (error != null) ...[
                    FormErrorBanner(message: error!),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  DslButton(
                    label: buttonLabel,
                    loading: loading,
                    onPressed: onContinue,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    footnote,
                    textAlign: TextAlign.center,
                    style: type.caption.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBar extends StatelessWidget {
  const _StepBar({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: 'Step $step of ${OnboardingScaffold.stepCount}',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 1; i <= OnboardingScaffold.stepCount; i++) ...[
            if (i > 1) const SizedBox(width: AppSpacing.sm),
            Container(
              width: 48,
              height: 3,
              decoration: BoxDecoration(
                color: i <= step ? colors.cyan : colors.inkBorder,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A selectable card: letter tile, title, subtitle and a radio circle
/// (Figma "Domain Card" `52:431` / "Language Card" `52:410`).
class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    required this.title,
    required this.selected,
    required this.onTap,
    super.key,
    this.subtitle,
    this.badge,
    this.tone,
    this.compact = false,
  });

  final String title;
  final String? subtitle;

  /// Letters in the tile ("M", "FR"). No tile when null.
  final String? badge;
  final Color? tone;
  final bool selected;
  final VoidCallback onTap;

  /// Tighter padding, for the 2-column grids.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final accent = tone ?? colors.cyan;

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected
            ? colors.cyan.withValues(alpha: 0.10)
            : colors.inkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(
            color: selected ? colors.cyan : colors.inkBorder,
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
            child: Row(
              children: [
                if (badge != null) ...[
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(AppRadii.input),
                    ),
                    child: Text(
                      badge!,
                      style: type.button.copyWith(color: accent, fontSize: 14),
                    ),
                  ),
                  SizedBox(width: compact ? AppSpacing.sm : AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: type.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: selected ? colors.cyan : colors.white,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: type.caption.copyWith(color: colors.muted),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _RadioDot(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colors.cyan : Colors.transparent,
        border: Border.all(
          color: selected ? colors.cyan : colors.inkBorder,
          width: 1.5,
        ),
      ),
      child: selected
          ? Icon(Icons.check_rounded, size: 14, color: colors.ink)
          : null,
    );
  }
}

/// Uppercase section label ("LEARNING GOAL").
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(
      text.toUpperCase(),
      style: context.type.label.copyWith(color: context.colors.muted),
    ),
  );
}

/// Letter-tile colours, cycled so neighbouring cards differ (Figma `57:5`).
List<Color> tileTones(BuildContext context) {
  final c = context.colors;
  return [
    c.cyan,
    c.amber,
    c.violet,
    c.success,
    c.error,
    c.lessonSelectedBorder,
  ];
}

/// Two cards per row, each row as tall as its tallest card, so large system
/// text grows the cards instead of overflowing a fixed grid cell.
class TwoColumnCards extends StatelessWidget {
  const TwoColumnCards({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < children.length; i += 2) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: children[i]),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: i + 1 < children.length
                      ? children[i + 1]
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
