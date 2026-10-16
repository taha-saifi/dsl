import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/state_views.dart';
import '../../learn/data/learn_repository.dart';
import '../data/onboarding_draft.dart';
import 'onboarding_widgets.dart';

String courseCount(int n) => n == 1 ? '1 course' : '$n courses';

/// Figma 03-A "Choose Domain" (`57:5`). Domains come from
/// `GET /learn/specializations`, so only ones with published courses show.
/// The model has no domain description, so the card shows its course count.
class DomainStepScreen extends ConsumerWidget {
  const DomainStepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final domains = ref.watch(specializationsProvider);
    final draft = ref.watch(onboardingDraftProvider);
    final tones = tileTones(context);
    final noneToPick = domains.value?.isEmpty ?? false;

    return OnboardingScaffold(
      step: 1,
      stepLabel: 'Step 1 of 3',
      titleLine1: 'Choose Your',
      titleLine2: 'Professional Domain',
      subtitle: 'Select the field you want to master',
      trailing: TextButton(
        onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
        child: Text(
          'Log out',
          style: context.type.body.copyWith(color: context.colors.muted),
        ),
      ),
      buttonLabel: 'Continue',
      onContinue: draft.specializationId != null || noneToPick
          ? () => context.go(Routes.onboardingLanguage)
          : null,
      footnote: 'You can explore all domains anytime',
      body: domains.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          title: "Couldn't load domains",
          onRetry: () => ref.invalidate(specializationsProvider),
        ),
        data: (items) => items.isEmpty
            ? const EmptyView(
                title: 'No courses yet',
                message:
                    "Teachers haven't published a course yet. You can finish "
                    'setting up now and pick a domain later.',
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenMargin,
                ),
                child: TwoColumnCards(
                  children: [
                    for (final (i, domain) in items.indexed)
                      ChoiceCard(
                        compact: true,
                        badge: domain.name.characters.first.toUpperCase(),
                        tone: tones[i % tones.length],
                        title: domain.name,
                        subtitle: courseCount(domain.publishedCourseCount),
                        selected: draft.specializationId == domain.id,
                        onTap: () => ref
                            .read(onboardingDraftProvider.notifier)
                            .selectDomain(domain.id),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
