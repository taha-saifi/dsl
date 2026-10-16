import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_badge.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/dsl_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../catalog/presentation/course_card.dart';
import '../../learn/data/learn_models.dart';
import '../../learn/data/question_type.dart';
import '../data/unit_providers.dart';

/// Figma P2 "Exercise Intro" (`112:370`). Exercises are mixed-type, so the
/// intro shows every type as a chip instead of one type label. XP, time and
/// difficulty arrive with their features; Start is wired to the player in
/// slice 6.
class ExerciseIntroScreen extends ConsumerWidget {
  const ExerciseIntroScreen({
    required this.courseId,
    required this.unitId,
    required this.exerciseId,
    super.key,
  });

  final String courseId;
  final String unitId;
  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(unitDetailProvider(unitId));
    return Scaffold(
      appBar: AppBar(),
      body: unit.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          title: "Couldn't load this exercise",
          onRetry: () => ref.invalidate(unitDetailProvider(unitId)),
        ),
        data: (data) {
          final index = data.exercises.indexWhere((e) => e.id == exerciseId);
          // Unpublished since the unit list was shown.
          if (index == -1) {
            return EmptyView(
              title: 'Exercise not available',
              message: 'This exercise is no longer published.',
              actionLabel: 'Back to the unit',
              onAction: () => context.go(Routes.unit(courseId, unitId)),
            );
          }
          return _Body(
            unit: data,
            exercise: data.exercises[index],
            number: index + 1,
            onLater: () => context.go(Routes.unit(courseId, unitId)),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.unit,
    required this.exercise,
    required this.number,
    required this.onLater,
  });

  final UnitDetail unit;
  final ExerciseSummary exercise;
  final int number;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final types = exercise.questionTypes;
    final kinds = types.length == 1 ? '1 kind' : '${types.length} kinds';

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        0,
        AppSpacing.screenMargin,
        AppSpacing.xxl,
      ),
      children: [
        Center(
          child: DslBadge(
            label: '${unit.name} · Exercise $number',
            style: DslBadgeStyle.soft,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: colors.cyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadii.card),
              border: Border.all(color: colors.cyan.withValues(alpha: 0.5)),
            ),
            child: Icon(
              types.length == 1 ? types.first.icon : Icons.auto_awesome_mosaic,
              size: 44,
              color: colors.cyan,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          types.length == 1
              ? types.first.label.toUpperCase()
              : 'MIXED PRACTICE',
          textAlign: TextAlign.center,
          style: type.label.copyWith(color: colors.cyan, letterSpacing: 1),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          exercise.name,
          textAlign: TextAlign.center,
          style: type.h1.copyWith(color: colors.white),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            _Stat(value: '${exercise.questionCount}', label: 'Questions'),
            const SizedBox(width: AppSpacing.md),
            _Stat(
              value: '${types.length}',
              label: types.length == 1 ? 'Question type' : 'Question types',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        DslCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What to expect',
                style: type.h3.copyWith(color: colors.white),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "You'll answer ${countLabel(exercise.questionCount, 'question')} "
                'of $kinds:',
                style: type.body.copyWith(color: colors.muted),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [for (final t in types) _TypeChip(type: t)],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        // Wired to the exercise player in slice 6.
        const DslButton(label: 'Start Exercise', onPressed: null),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: onLater,
          child: Text(
            "I'll do this later",
            style: type.body.copyWith(color: colors.muted),
          ),
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
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: DslCard(
        child: Column(
          children: [
            Text(value, style: context.type.h2.copyWith(color: colors.white)),
            Text(
              label,
              style: context.type.caption.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});

  final QuestionType type;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: colors.inkTrack,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: colors.inkBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 16, color: colors.cyan),
          const SizedBox(width: AppSpacing.xs),
          Text(
            type.label,
            style: context.type.caption.copyWith(color: colors.white),
          ),
        ],
      ),
    );
  }
}
