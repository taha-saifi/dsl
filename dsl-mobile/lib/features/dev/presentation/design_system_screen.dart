import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_badge.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/dsl_card.dart';
import '../../../core/widgets/dsl_progress_bar.dart';
import '../../../core/widgets/dsl_text_field.dart';

/// Debug-only catalogue of tokens and shared widgets, for comparing against
/// the Figma DS boards cached in docs/assets/mobile-screens/_ds-*.png.
class DesignSystemScreen extends StatelessWidget {
  const DesignSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    Widget section(String title, List<Widget> children) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: type.h3.copyWith(color: colors.white)),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );

    final swatches = <(String, Color)>[
      ('Midnight Ink', colors.ink),
      ('Ink surface', colors.inkSurface),
      ('Ink border', colors.inkBorder),
      ('Electric Cyan', colors.cyan),
      ('Gold Amber', colors.amber),
      ('Violet', colors.violet),
      ('Soft Gray', colors.softGray),
      ('Success', colors.success),
      ('Error', colors.error),
      ('Muted', colors.muted),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Design system')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          section('Colour tokens', [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final (name, color) in swatches)
                  _Swatch(name: name, color: color),
              ],
            ),
          ]),
          section('Typography · Inter', [
            Text(
              'Domain Mastery',
              style: type.display.copyWith(color: colors.white),
            ),
            Text(
              'Medical English',
              style: type.h1.copyWith(color: colors.white),
            ),
            Text(
              'Cardiovascular Unit',
              style: type.h2.copyWith(color: colors.white),
            ),
            Text('Unit Progress', style: type.h3.copyWith(color: colors.white)),
            Text(
              'Body large: the myocardium pumps blood.',
              style: type.bodyLarge.copyWith(color: colors.white),
            ),
            Text(
              'Body: anatomy, pharmacology, clinical terms.',
              style: type.body.copyWith(color: colors.white),
            ),
            Text(
              'Caption: 18 units · 4h 30m',
              style: type.caption.copyWith(color: colors.muted),
            ),
            Text(
              'LABEL · EMAIL ADDRESS',
              style: type.label.copyWith(color: colors.muted),
            ),
          ]),
          section('Buttons', [
            DslButton(label: 'Primary', onPressed: () {}),
            const SizedBox(height: AppSpacing.md),
            DslButton(
              label: 'Secondary',
              variant: DslButtonVariant.secondary,
              onPressed: () {},
            ),
            const SizedBox(height: AppSpacing.md),
            DslButton(
              label: 'Ghost',
              variant: DslButtonVariant.ghost,
              onPressed: () {},
            ),
            const SizedBox(height: AppSpacing.md),
            const DslButton(label: 'Disabled', onPressed: null),
            const SizedBox(height: AppSpacing.md),
            DslButton(label: 'Loading', loading: true, onPressed: () {}),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                DslButton(
                  label: 'Medium',
                  size: DslButtonSize.medium,
                  expand: false,
                  onPressed: () {},
                ),
                const SizedBox(width: AppSpacing.md),
                DslButton(
                  label: 'Small',
                  size: DslButtonSize.small,
                  expand: false,
                  onPressed: () {},
                ),
              ],
            ),
          ]),
          section('Inputs', [
            const DslTextField(label: 'Email address', hint: 'your@email.com'),
            const SizedBox(height: AppSpacing.lg),
            const DslTextField(
              label: 'Email address',
              hint: 'invalid-email',
              errorText: 'Enter a valid email address.',
            ),
          ]),
          section('Badges', [
            const Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                DslBadge(
                  label: '+125 XP',
                  tone: DslBadgeTone.amber,
                  style: DslBadgeStyle.filled,
                ),
                DslBadge(label: '5 / 5 HP', tone: DslBadgeTone.error),
                DslBadge(label: 'Completed', tone: DslBadgeTone.success),
                DslBadge(label: 'In progress'),
                DslBadge(label: 'Locked', tone: DslBadgeTone.muted),
                DslBadge(label: 'New', tone: DslBadgeTone.amber),
                DslBadge(
                  label: 'Beginner',
                  tone: DslBadgeTone.success,
                  style: DslBadgeStyle.soft,
                ),
                DslBadge(label: 'Intermediate', style: DslBadgeStyle.soft),
                DslBadge(
                  label: 'Advanced',
                  tone: DslBadgeTone.amber,
                  style: DslBadgeStyle.soft,
                ),
              ],
            ),
          ]),
          section('Progress', const [
            DslProgressBar(value: 0.72, size: DslProgressSize.large),
            SizedBox(height: AppSpacing.md),
            DslProgressBar(value: 0.45),
            SizedBox(height: AppSpacing.md),
            DslProgressBar(
              value: 1,
              size: DslProgressSize.small,
              tone: DslProgressTone.complete,
            ),
            SizedBox(height: AppSpacing.md),
            DslProgressBar(value: 0.3, tone: DslProgressTone.warning),
            SizedBox(height: AppSpacing.md),
            DslProgressBar(value: 0.15, tone: DslProgressTone.error),
          ]),
          section('Card', [
            DslCard(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DslBadge(label: 'MEDICAL', style: DslBadgeStyle.soft),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Medical English',
                    style: type.h3.copyWith(color: colors.white),
                  ),
                  Text(
                    'Advanced terminology',
                    style: type.body.copyWith(color: colors.muted),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const DslProgressBar(value: 0.72),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 104,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.inkBorder),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(name, style: context.type.caption.copyWith(color: colors.white)),
          Text(
            _hex(color),
            style: context.type.caption.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }

  static String _hex(Color c) =>
      '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}
