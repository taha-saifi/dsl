import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/coming_soon.dart';
import '../../../core/widgets/dsl_badge.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/dsl_card.dart';

/// Figma 10a "Certificates" (`111:98`), static: a sample certificate so the
/// tab shows what's coming. No network calls (feat-static-screens); the
/// real list arrives with feat-certificates.
class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return Scaffold(
      appBar: AppBar(title: const Text('My Certificates')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          const ComingSoonBanner(
            message:
                'Finish a course to earn its certificate. This is what one '
                'will look like.',
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('SAMPLE', style: type.label.copyWith(color: colors.muted)),
          const SizedBox(height: AppSpacing.sm),
          DslCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.amber.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(AppRadii.input),
                      ),
                      child: Icon(
                        Icons.workspace_premium_rounded,
                        color: colors.amber,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medical English',
                            style: type.h3.copyWith(color: colors.white),
                          ),
                          Text(
                            'Certificate of Completion',
                            style: type.caption.copyWith(color: colors.muted),
                          ),
                        ],
                      ),
                    ),
                    const DslBadge(
                      label: 'Sample',
                      tone: DslBadgeTone.amber,
                      style: DslBadgeStyle.soft,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                DslButton(
                  label: 'View sample certificate',
                  variant: DslButtonVariant.secondary,
                  size: DslButtonSize.medium,
                  onPressed: () => context.go(Routes.sampleCertificate),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          DslButton(
            label: 'Explore All Courses',
            variant: DslButtonVariant.ghost,
            onPressed: () => context.go(Routes.courses),
          ),
        ],
      ),
    );
  }
}
