import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/state_views.dart';
import '../../learn/data/language_names.dart';
import '../../learn/data/learn_models.dart';
import '../../learn/data/learn_repository.dart';
import '../data/onboarding_draft.dart';
import 'domain_step_screen.dart';
import 'onboarding_widgets.dart';

/// Figma 03-B "Language Select" (`57:73`): target languages of the published
/// courses in the chosen domain, with course counts.
class LanguageStepScreen extends ConsumerStatefulWidget {
  const LanguageStepScreen({super.key});

  @override
  ConsumerState<LanguageStepScreen> createState() => _LanguageStepScreenState();
}

class _LanguageStepScreenState extends ConsumerState<LanguageStepScreen> {
  String _query = '';

  bool _matches(LanguageSummary language) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final name = LanguageName.of(language.code);
    return [
      language.code,
      name.english,
      name.native,
    ].any((s) => s.toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(onboardingDraftProvider);
    final provider = languagesProvider(draft.specializationId);
    final languages = ref.watch(provider);
    final noneToPick = languages.value?.isEmpty ?? false;
    final colors = context.colors;
    final tones = tileTones(context);

    return OnboardingScaffold(
      step: 2,
      stepLabel: 'Step 2 of 3',
      titleLine1: 'Which Language Do You',
      titleLine2: 'Want to Learn?',
      subtitle: 'Choose the language for all your course content',
      onBack: () => context.go(Routes.onboardingDomain),
      buttonLabel: 'Continue',
      onContinue: draft.targetLanguage != null || noneToPick
          ? () => context.go(Routes.onboardingProfile)
          : null,
      footnote: 'You can change this anytime in settings',
      body: languages.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          title: "Couldn't load languages",
          onRetry: () => ref.invalidate(provider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyView(
              title: 'No languages yet',
              message:
                  'No course is published in this domain yet. You can finish '
                  'setting up and pick a language later.',
            );
          }
          final visible = items.where(_matches).toList();
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenMargin,
            ),
            children: [
              TextField(
                onChanged: (value) => setState(() => _query = value),
                style: context.type.body.copyWith(color: colors.white),
                decoration: InputDecoration(
                  hintText: 'Search language...',
                  prefixIcon: Icon(Icons.search_rounded, color: colors.muted),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (visible.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Text(
                    'No language matches "$_query".',
                    textAlign: TextAlign.center,
                    style: context.type.body.copyWith(color: colors.muted),
                  ),
                ),
              for (final (i, language) in visible.indexed) ...[
                ChoiceCard(
                  badge: language.code.toUpperCase(),
                  tone: tones[i % tones.length],
                  title: LanguageName.of(language.code).english,
                  subtitle:
                      '${LanguageName.of(language.code).native} · '
                      '${courseCount(language.publishedCourseCount)}',
                  selected: draft.targetLanguage == language.code,
                  onTap: () => ref
                      .read(onboardingDraftProvider.notifier)
                      .selectLanguage(language.code),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        },
      ),
    );
  }
}
