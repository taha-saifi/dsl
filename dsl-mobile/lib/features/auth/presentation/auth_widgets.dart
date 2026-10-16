import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// The logo tile at the top of the auth screens (Figma `122:335`).
class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.size = 100});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.1),
      decoration: BoxDecoration(
        color: colors.inkSurface,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(color: colors.cyan.withValues(alpha: 0.45)),
      ),
      child: Image.asset(
        'assets/branding/logo.png',
        semanticLabel: 'DSL',
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Title and subtitle under the logo ("Welcome Back!").
class AuthHeading extends StatelessWidget {
  const AuthHeading({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: type.h1.copyWith(color: colors.white),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: type.body.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}

/// A server or connection error above a form's submit button.
class FormErrorBanner extends StatelessWidget {
  const FormErrorBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: colors.error.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadii.input),
          border: Border.all(color: colors.error.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline_rounded, size: 18, color: colors.error),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: context.type.body.copyWith(color: colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Don't have an account? Sign Up".
class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({
    required this.prompt,
    required this.action,
    required this.onTap,
    super.key,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    // Wraps rather than overflows with large system text sizes.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(prompt, style: type.body.copyWith(color: colors.muted)),
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: type.body.copyWith(
              color: colors.cyan,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Scrollable, centred column with the screen margin, so forms stay usable
/// with the keyboard open on small phones.
class AuthScrollBody extends StatelessWidget {
  const AuthScrollBody({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
