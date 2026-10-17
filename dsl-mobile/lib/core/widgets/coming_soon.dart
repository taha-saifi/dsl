import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Marks screens and sections that show sample content until their feature
/// ships (feat-static-screens), so nothing is mistaken for real data.
class ComingSoonBanner extends StatelessWidget {
  const ComingSoonBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.input),
        border: Border.all(color: colors.amber.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.schedule_rounded, color: colors.amber, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Coming soon. ',
                    style: TextStyle(
                      color: colors.amber,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: message),
                ],
              ),
              style: context.type.body.copyWith(color: colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// A small "Soon" pill for rows and tiles that don't work yet.
class SoonBadge extends StatelessWidget {
  const SoonBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        'Soon',
        style: context.type.label.copyWith(color: colors.amber),
      ),
    );
  }
}
