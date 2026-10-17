import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'dsl_progress_bar.dart';

/// A progress bar with "42%" beside it and an optional caption below
/// ("2 of 5 exercises"). Turns green when complete.
class ProgressLine extends StatelessWidget {
  const ProgressLine({
    required this.percent,
    super.key,
    this.caption,
    this.size = DslProgressSize.medium,
  });

  final int percent;
  final String? caption;
  final DslProgressSize size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final done = percent >= 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: DslProgressBar(
                value: percent / 100,
                size: size,
                tone: done
                    ? DslProgressTone.complete
                    : DslProgressTone.progress,
                semanticsLabel: '$percent% complete',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // The bar already announces "N% complete".
            ExcludeSemantics(
              child: Text(
                '$percent%',
                style: context.type.caption.copyWith(
                  color: done ? colors.success : colors.cyan,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        if (caption != null) ...[
          const SizedBox(height: 2),
          Text(
            caption!,
            style: context.type.caption.copyWith(color: colors.muted),
          ),
        ],
      ],
    );
  }
}
