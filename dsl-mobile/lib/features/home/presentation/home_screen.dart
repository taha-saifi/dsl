import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/state_views.dart';
import '../../catalog/data/catalog_providers.dart';
import '../../catalog/presentation/course_card.dart';
import '../../learn/data/learn_models.dart';

/// Figma 04 "Home Dashboard" (`60:5`), MVP subset: greeting, the current
/// course with Continue Learning, and My Courses. XP, hearts, streak,
/// achievements and leaderboard wait for their features.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final firstName = auth is SignedIn ? auth.user.firstName : null;
    final courses = ref.watch(myCoursesProvider);
    final colors = context.colors;
    final type = context.type;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(myCoursesProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenMargin),
            children: [
              Text(
                firstName == null ? 'Hello!' : 'Hello, $firstName',
                style: type.h1.copyWith(color: colors.white),
              ),
              Text(
                "Let's continue your journey",
                style: type.body.copyWith(color: colors.muted),
              ),
              const SizedBox(height: AppSpacing.xl),
              ...courses.when(
                loading: () => [
                  const SizedBox(height: 240, child: LoadingView()),
                ],
                error: (error, _) => [
                  SizedBox(
                    height: 360,
                    child: ErrorView(
                      error: error,
                      title: "Couldn't load your courses",
                      onRetry: () => ref.invalidate(myCoursesProvider),
                    ),
                  ),
                ],
                data: (items) => items.isEmpty
                    ? [
                        SizedBox(
                          height: 360,
                          child: EmptyView(
                            title: 'Start your first course',
                            message:
                                'Browse published courses and enroll to start '
                                'learning.',
                            actionLabel: 'Browse courses',
                            onAction: () => context.go(Routes.courses),
                          ),
                        ),
                      ]
                    : [
                        _CurrentCourseCard(course: items.first),
                        const SizedBox(height: AppSpacing.xl),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'My Courses',
                                style: type.h3.copyWith(color: colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go(Routes.courses),
                              child: Text(
                                'Browse all',
                                style: type.body.copyWith(color: colors.cyan),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        for (final course in items) ...[
                          _MyCourseRow(course: course),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ],
              ),
              if (kDebugMode) ...[
                const SizedBox(height: AppSpacing.xxl),
                DslButton(
                  label: 'System check',
                  icon: Icons.wifi_tethering_rounded,
                  variant: DslButtonVariant.ghost,
                  size: DslButtonSize.small,
                  onPressed: () => context.push(Routes.systemCheck),
                ),
                const SizedBox(height: AppSpacing.sm),
                DslButton(
                  label: 'Design system',
                  icon: Icons.palette_outlined,
                  variant: DslButtonVariant.ghost,
                  size: DslButtonSize.small,
                  onPressed: () => context.push(Routes.designSystem),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// "CURRENT COURSE": the most recently enrolled one until progress
/// (slice 8) can tell which was played last.
class _CurrentCourseCard extends StatelessWidget {
  const _CurrentCourseCard({required this.course});

  final CourseSummary course;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.card),
        gradient: LinearGradient(
          colors: [colors.cyan.withValues(alpha: 0.25), colors.inkSurface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: colors.cyan.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT COURSE',
            style: type.label.copyWith(color: colors.cyan),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(course.name, style: type.h2.copyWith(color: colors.white)),
          Text(
            '${course.specializationName} · '
            '${countLabel(course.unitCount, 'unit')} · '
            '${countLabel(course.exerciseCount, 'exercise')}',
            style: type.caption.copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.lg),
          DslButton(
            label: 'Continue Learning',
            onPressed: () => context.go(Routes.course(course.id)),
          ),
        ],
      ),
    );
  }
}

class _MyCourseRow extends StatelessWidget {
  const _MyCourseRow({required this.course});

  final CourseSummary course;

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
        onTap: () => context.go(Routes.course(course.id)),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CourseArt(course: course, width: 64),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        course.specializationName.toUpperCase(),
                        style: type.label.copyWith(
                          color: domainTone(context, course.specializationId),
                        ),
                      ),
                      Text(
                        course.name,
                        style: type.body.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        countLabel(course.unitCount, 'unit'),
                        style: type.caption.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: Icon(Icons.chevron_right_rounded, color: colors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
