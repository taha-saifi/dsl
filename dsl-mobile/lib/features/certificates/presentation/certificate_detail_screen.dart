import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/coming_soon.dart';
import '../../../core/widgets/dsl_button.dart';

/// Figma 10b "Certificate Detail" (`111:163`), as a clearly marked sample:
/// placeholder name, no verification number, Download/Share disabled.
class CertificateDetailScreen extends StatelessWidget {
  const CertificateDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return Scaffold(
      appBar: AppBar(title: const Text('Certificate')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          const ComingSoonBanner(
            message:
                'A sample of the certificate you get for finishing a course.',
          ),
          const SizedBox(height: AppSpacing.xl),
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: colors.softGray,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  border: Border.all(color: colors.amber, width: 3),
                ),
                child: Column(
                  children: [
                    Text(
                      'DOMAIN SPECIFIC LANGUAGE',
                      style: type.label.copyWith(
                        color: colors.cyan,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Certificate of Completion',
                      textAlign: TextAlign.center,
                      style: type.h2.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'This is to certify that',
                      style: type.body.copyWith(color: colors.muted),
                    ),
                    Text(
                      'Your name',
                      style: type.h1.copyWith(color: colors.ink),
                    ),
                    Text(
                      'has successfully completed',
                      style: type.body.copyWith(color: colors.muted),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Medical English',
                      style: type.h3.copyWith(color: colors.ink),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Transform.rotate(
                      angle: -0.35,
                      child: Text(
                        'SAMPLE',
                        style: type.display.copyWith(
                          fontSize: 56,
                          color: colors.amber.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const DslButton(label: 'Download Certificate', onPressed: null),
          const SizedBox(height: AppSpacing.md),
          const DslButton(
            label: 'Share / Copy Link',
            variant: DslButtonVariant.ghost,
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
