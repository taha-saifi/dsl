import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/error_messages.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_badge.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/dsl_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../learn/data/language_names.dart';
import '../../learn/data/learn_models.dart';
import '../data/catalog_providers.dart';
import 'course_card.dart';

/// Figma 06 "Course Details" (`87:5`): about, counts, the unit list, and
/// Enroll Now, or Continue Learning and Leave course. Until progress exists
/// (slice 8), Continue Learning opens the first unit. XP and locks arrive
/// with their slices.
class CourseDetailsScreen extends ConsumerStatefulWidget {
  const CourseDetailsScreen({required this.courseId, super.key});

  final String courseId;

  @override
  ConsumerState<CourseDetailsScreen> createState() =>
      _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends ConsumerState<CourseDetailsScreen> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action, String done) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) _snack(done);
    } on Object catch (error) {
      if (mounted) _snack(describeError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  Future<void> _confirmLeave(CourseSummary course) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave this course?'),
        content: Text(
          '${course.name} will be removed from My Courses. You can enroll '
          'again at any time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave course'),
          ),
        ],
      ),
    );
    if (leave ?? false) {
      await _run(
        () => ref.read(enrollmentActionsProvider).unenroll(course.id),
        'You left ${course.name}.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(courseDetailProvider(widget.courseId));
    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: detail.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          title: "Couldn't load this course",
          onRetry: () => ref.invalidate(courseDetailProvider(widget.courseId)),
        ),
        data: (data) => _Body(
          detail: data,
          busy: _busy,
          onEnroll: () => _run(
            () => ref.read(enrollmentActionsProvider).enroll(data.course.id),
            'Enrolled in ${data.course.name}.',
          ),
          onLeave: () => _confirmLeave(data.course),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.detail,
    required this.busy,
    required this.onEnroll,
    required this.onLeave,
  });

  final CourseDetail detail;
  final bool busy;
  final VoidCallback onEnroll;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final course = detail.course;
    final tone = domainTone(context, course.specializationId);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        0,
        AppSpacing.screenMargin,
        AppSpacing.xxl,
      ),
      children: [
        Row(
          children: [
            DslBadge(
              label: course.specializationName.toUpperCase(),
              tone: DslBadgeTone.cyan,
              style: DslBadgeStyle.soft,
            ),
            if (course.isEnrolled) ...[
              const SizedBox(width: AppSpacing.sm),
              const DslBadge(
                label: 'Enrolled',
                tone: DslBadgeTone.success,
                style: DslBadgeStyle.soft,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(course.name, style: type.h1.copyWith(color: colors.white)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${LanguageName.of(course.sourceLanguage).english} → '
          '${LanguageName.of(course.targetLanguage).english}',
          style: type.body.copyWith(color: tone),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            _Stat(
              value: '${course.unitCount}',
              label: course.unitCount == 1 ? 'Unit' : 'Units',
            ),
            const SizedBox(width: AppSpacing.md),
            _Stat(
              value: '${course.exerciseCount}',
              label: course.exerciseCount == 1 ? 'Exercise' : 'Exercises',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (course.isEnrolled) ...[
          if (detail.units.isNotEmpty)
            DslButton(
              label: 'Continue Learning',
              onPressed: () =>
                  context.go(Routes.unit(course.id, detail.units.first.id)),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: busy ? null : onLeave,
              icon: Icon(Icons.logout_rounded, color: colors.muted, size: 18),
              label: Text(
                'Leave course',
                style: type.body.copyWith(color: colors.muted),
              ),
            ),
          ),
        ] else
          DslButton(label: 'Enroll Now', loading: busy, onPressed: onEnroll),
        if (course.description != null) ...[
          const SizedBox(height: AppSpacing.xl),
          Text(
            'About This Course',
            style: type.h3.copyWith(color: colors.white),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            course.description!,
            style: type.body.copyWith(color: colors.muted),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: Text(
                'Course Units',
                style: type.h3.copyWith(color: colors.white),
              ),
            ),
            Text(
              countLabel(detail.units.length, 'unit'),
              style: type.caption.copyWith(color: colors.muted),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        for (final (i, unit) in detail.units.indexed) ...[
          _UnitRow(
            number: i + 1,
            unit: unit,
            onTap: () => context.go(Routes.unit(course.id, unit.id)),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
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

/// Figma "Unit Card" (`52:310`) without progress and locks (later slices).
class _UnitRow extends StatelessWidget {
  const _UnitRow({
    required this.number,
    required this.unit,
    required this.onTap,
  });

  final int number;
  final UnitSummary unit;
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
          padding: const EdgeInsets.all(AppSpacing.lg),
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
                      'UNIT ${number.toString().padLeft(2, '0')}',
                      style: type.label.copyWith(color: colors.muted),
                    ),
                    Text(
                      unit.name,
                      style: type.body.copyWith(
                        color: colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      countLabel(unit.exerciseCount, 'exercise'),
                      style: type.caption.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
