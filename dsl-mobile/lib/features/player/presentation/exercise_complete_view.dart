import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../unit/data/unit_providers.dart';
import '../data/player_controller.dart';
import 'lesson_widgets.dart';

/// Figma P "Exercise Complete" (`6:107`), MVP subset: score, accuracy and
/// time. XP and level wait for feat-xp-and-levels. Any score completes the
/// exercise; replaying keeps the best score (Q13).
class ExerciseCompleteView extends ConsumerWidget {
  const ExerciseCompleteView({required this.state, super.key});

  final PlayerState state;

  static String duration(int ms) {
    final seconds = (ms / 1000).round();
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m == 0 ? '${s}s' : '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final type = context.type;
    final result = state.result!;
    final session = state.session;
    final percent = result.maxScore == 0
        ? 0
        : (result.score * 100 / result.maxScore).round();

    // The next playable exercise in this unit, if any.
    final unit = ref.watch(unitDetailProvider(session.unitId)).value;
    final exercises = unit?.exercises ?? const [];
    final here = exercises.indexWhere((e) => e.id == session.exerciseId);
    final next = here >= 0 && here + 1 < exercises.length
        ? exercises[here + 1]
        : null;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        const SizedBox(height: AppSpacing.xl),
        Icon(Icons.emoji_events_rounded, size: 72, color: colors.amber),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Exercise Complete!',
          textAlign: TextAlign.center,
          style: type.h1.copyWith(color: colors.ink),
        ),
        Text(
          state.payload.exercise.name,
          textAlign: TextAlign.center,
          style: type.body.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.xl),
        LessonCard(
          child: Column(
            children: [
              Text(
                '$percent%',
                style: type.display.copyWith(color: colors.cyan),
              ),
              Text(
                'Score ${result.score} / ${result.maxScore}',
                style: type.body.copyWith(color: colors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _Stat(value: '${result.accuracy}%', label: 'Accuracy'),
            const SizedBox(width: AppSpacing.md),
            _Stat(
              value: '${result.correctCount}/${result.questionCount}',
              label: 'Right first try',
            ),
            const SizedBox(width: AppSpacing.md),
            _Stat(value: duration(result.durationMs), label: 'Time'),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        if (next != null) ...[
          DslButton(
            label: 'Next: ${next.name}',
            onPressed: () => context.go(
              Routes.exerciseIntro(session.courseId, session.unitId, next.id),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        DslButton(
          label: 'Back to the unit',
          variant: next == null
              ? DslButtonVariant.primary
              : DslButtonVariant.secondary,
          onPressed: () =>
              context.go(Routes.unit(session.courseId, session.unitId)),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: LessonCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: context.type.h3.copyWith(color: context.colors.ink),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: context.type.caption.copyWith(color: context.colors.muted),
          ),
        ],
      ),
    ),
  );
}
