import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum DslProgressSize {
  large(8),
  medium(6),
  small(4);

  const DslProgressSize(this.height);
  final double height;
}

enum DslProgressTone { progress, complete, warning, error }

/// Figma "DS · Progress Bar" (`52:241`): rounded track + fill, 3 sizes,
/// tone by state. [value] is clamped to 0..1.
class DslProgressBar extends StatelessWidget {
  const DslProgressBar({
    required this.value,
    super.key,
    this.size = DslProgressSize.medium,
    this.tone = DslProgressTone.progress,
    this.trackColor,
    this.semanticsLabel,
  });

  final double value;
  final DslProgressSize size;
  final DslProgressTone tone;

  /// Defaults to the ink track; lesson screens pass a light track.
  final Color? trackColor;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fill = switch (tone) {
      DslProgressTone.progress => colors.cyan,
      DslProgressTone.complete => colors.success,
      DslProgressTone.warning => colors.amber,
      DslProgressTone.error => colors.error,
    };
    final clamped = value.clamp(0.0, 1.0);

    return Semantics(
      label: semanticsLabel,
      value: '${(clamped * 100).round()}%',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: SizedBox(
          height: size.height,
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: size.height,
            color: fill,
            backgroundColor: trackColor ?? colors.inkTrack,
          ),
        ),
      ),
    );
  }
}
