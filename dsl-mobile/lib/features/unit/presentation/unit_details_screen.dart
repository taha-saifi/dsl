import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_badge.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/progress_line.dart';
import '../../../core/widgets/state_views.dart';
import '../../catalog/presentation/course_card.dart';
import '../../learn/data/learn_models.dart';
import '../../learn/data/question_type.dart';
import '../data/unit_providers.dart';

/// Figma 07 "Unit Details" (`87:104`): progress, then the unit's playable
/// exercises in order with Done and best score. "Start Next Exercise" opens
/// the first one not done. Locked, difficulty, minutes and XP arrive with
/// their features.
class UnitDetailsScreen extends ConsumerWidget {
  const UnitDetailsScreen({
    required this.courseId,
    required this.unitId,
    super.key,
  });

  final String courseId;
  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(unitDetailProvider(unitId));
    return Scaffold(
      appBar: AppBar(title: const Text('Unit Details')),
      body: unit.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          title: "Couldn't load this unit",
          onRetry: () => ref.invalidate(unitDetailProvider(unitId)),
        ),
        data: (data) => _Body(courseId: courseId, unit: data),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.courseId, required this.unit});

  final String courseId;
  final UnitDetail unit;

  void _open(BuildContext context, ExerciseSummary exercise) =>
      context.go(Routes.exerciseIntro(courseId, unit.id, exercise.id));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenMargin,
              0,
              AppSpacing.screenMargin,
              AppSpacing.lg,
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: DslBadge(
                  label: unit.courseName,
                  style: DslBadgeStyle.soft,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(unit.name, style: type.h1.copyWith(color: colors.white)),
              if (unit.progress != null) ...[
                const SizedBox(height: AppSpacing.md),
                ProgressLine(
                  percent: unit.progress!.percent,
                  caption: progressCaption(unit.progress!),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Exercises',
                      style: type.h3.copyWith(color: colors.white),
                    ),
                  ),
                  Text(
                    countLabel(unit.exercises.length, 'exercise'),
                    style: type.caption.copyWith(color: colors.muted),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              for (final (i, exercise) in unit.exercises.indexed) ...[
                _ExerciseRow(
                  number: i + 1,
                  exercise: exercise,
                  onTap: () => _open(context, exercise),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
        ),
        if (unit.exercises.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenMargin,
              0,
              AppSpacing.screenMargin,
              AppSpacing.lg,
            ),
            child: DslButton(
              label: unit.progress?.isComplete ?? false
                  ? 'Practice again'
                  : 'Start Next Exercise',
              onPressed: () => _open(
                context,
                unit.exercises.firstWhere(
                  (e) => e.id == unit.nextExerciseId,
                  orElse: () => unit.exercises.first,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Figma "Exercise Card" (`52:337`) without status, difficulty and XP.
class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.number,
    required this.exercise,
    required this.onTap,
  });

  final int number;
  final ExerciseSummary exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return Material(
      color: colors.inkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
        side: BorderSide(color: colors.inkBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.inkTrack,
                  borderRadius: BorderRadius.circular(AppRadii.input),
                ),
                child: Text(
                  '$number',
                  style: type.button.copyWith(color: colors.cyan),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: type.body.copyWith(
                        color: colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      summarizeTypes(exercise.questionTypes),
                      style: type.caption.copyWith(color: colors.cyan),
                    ),
                    Text(
                      countLabel(exercise.questionCount, 'question'),
                      style: type.caption.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              if (exercise.status == ExerciseStatus.completed)
                DslBadge(
                  label: 'Done · ${exercise.bestPercent ?? 0}%',
                  tone: DslBadgeTone.success,
                  style: DslBadgeStyle.soft,
                  icon: Icons.check_rounded,
                )
              else
                Icon(Icons.chevron_right_rounded, color: colors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
