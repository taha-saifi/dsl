import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import 'auth_widgets.dart';

/// Figma 02-A "Splash Screen" (`55:5`): the first screen when signed out.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _domains = [
    'Medical',
    'Legal',
    'Engineering',
    'Finance',
    'Aviation',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned(left: -80, top: -80, child: _Glow(size: 340)),
          const Positioned(right: -70, bottom: -30, child: _Glow(size: 280)),
          AuthScrollBody(
            children: [
              const SizedBox(height: AppSpacing.xxl),
              const Center(child: AuthLogo(size: 104)),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'DOMAIN SPECIFIC LANGUAGE',
                textAlign: TextAlign.center,
                style: type.label.copyWith(
                  color: colors.cyan,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.cyan,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Master the Language\n'),
                    TextSpan(
                      text: 'of Your Domain',
                      style: TextStyle(color: colors.cyan),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: type.h1.copyWith(color: colors.white),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Professional vocabulary & terminology across Medical, '
                'Legal, Engineering and more domains.',
                textAlign: TextAlign.center,
                style: type.body.copyWith(color: colors.muted),
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [for (final d in _domains) _DomainChip(d)],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              DslButton(
                label: 'Get Started',
                onPressed: () => context.go(Routes.signUp),
              ),
              const SizedBox(height: AppSpacing.md),
              DslButton(
                label: 'Sign In',
                variant: DslButtonVariant.secondary,
                onPressed: () => context.go(Routes.signIn),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Already a member? Use Sign In above.',
                textAlign: TextAlign.center,
                style: type.caption.copyWith(color: colors.muted),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    border: Border.all(color: colors.inkBorder),
                  ),
                  child: Text(
                    'MEDEA UNIVERSITY INCUBATOR',
                    style: type.label.copyWith(
                      color: colors.muted,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ],
      ),
    );
  }
}

class _DomainChip extends StatelessWidget {
  const _DomainChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 1,
      ),
      decoration: BoxDecoration(
        color: colors.inkSurface,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: colors.inkBorder),
      ),
      child: Text(
        label,
        style: context.type.caption.copyWith(color: colors.muted),
      ),
    );
  }
}

/// The soft background circles from the Figma frame.
class _Glow extends StatelessWidget {
  const _Glow({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.inkSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
