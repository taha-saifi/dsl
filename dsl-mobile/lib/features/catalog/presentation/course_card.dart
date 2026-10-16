import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_badge.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../learn/data/learn_models.dart';

/// Accent for a domain, stable across screens (Figma `62:5` colours each
/// domain differently).
Color domainTone(BuildContext context, String specializationId) {
  final c = context.colors;
  final tones = [c.cyan, c.violet, c.amber, c.success, c.error];
  return tones[specializationId.hashCode.abs() % tones.length];
}

String countLabel(int n, String noun) => n == 1 ? '1 $noun' : '$n ${noun}s';

/// Figma "Course Card" (`52:289`) as used in the catalog (`62:5`). Level,
/// duration and the progress bar arrive with their features.
class CourseCard extends StatelessWidget {
  const CourseCard({
    required this.course,
    required this.onOpen,
    required this.onEnroll,
    super.key,
    this.enrolling = false,
  });

  final CourseSummary course;
  final VoidCallback onOpen;
  final VoidCallback onEnroll;
  final bool enrolling;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final tone = domainTone(context, course.specializationId);

    return Material(
      color: colors.inkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
        side: BorderSide(
          color: course.isEnrolled ? colors.cyan : colors.inkBorder,
          width: course.isEnrolled ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CourseArt(course: course, width: 72),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: _DomainLabel(
                              name: course.specializationName,
                              tone: tone,
                            ),
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
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        course.name,
                        style: type.h3.copyWith(color: colors.white),
                      ),
                      if (course.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          course.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: type.caption.copyWith(color: colors.muted),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${countLabel(course.unitCount, 'unit')} · '
                        '${countLabel(course.exerciseCount, 'exercise')}',
                        style: type.caption.copyWith(color: colors.muted),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DslButton(
                        label: course.isEnrolled ? 'Continue' : 'Enroll Now',
                        size: DslButtonSize.small,
                        variant: course.isEnrolled
                            ? DslButtonVariant.primary
                            : DslButtonVariant.secondary,
                        loading: enrolling,
                        onPressed: course.isEnrolled ? onOpen : onEnroll,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Domain name as an uppercase pill ("MEDICAL").
class _DomainLabel extends StatelessWidget {
  const _DomainLabel({required this.name, required this.tone});

  final String name;
  final Color tone;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
    decoration: BoxDecoration(
      color: tone.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(AppRadii.pill),
    ),
    child: Text(
      name.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.type.label.copyWith(color: tone, fontSize: 10),
    ),
  );
}

/// The coloured strip on the left of a course card: the thumbnail when the
/// course has one, otherwise the course's first letter in a circle.
class CourseArt extends StatelessWidget {
  const CourseArt({required this.course, required this.width, super.key});

  final CourseSummary course;
  final double width;

  @override
  Widget build(BuildContext context) {
    final tone = domainTone(context, course.specializationId);
    final letter = Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tone.withValues(alpha: 0.35),
      ),
      child: Text(
        course.name.characters.first.toUpperCase(),
        style: context.type.h3.copyWith(color: tone),
      ),
    );

    return ExcludeSemantics(
      child: Container(
        width: width,
        color: tone.withValues(alpha: 0.18),
        alignment: Alignment.center,
        // The letter sizes the strip; a thumbnail covers it once it loads
        // (and leaves the letter showing if it can't).
        child: Stack(
          alignment: Alignment.center,
          children: [
            letter,
            if (course.thumbnailUrl != null)
              Positioned.fill(
                child: Image.network(
                  course.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
