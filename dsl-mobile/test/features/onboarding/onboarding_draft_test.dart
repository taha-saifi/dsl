import 'package:dsl/core/auth/app_user.dart';
import 'package:dsl/features/onboarding/data/onboarding_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('builds the PATCH body with API enum values', () {
    const draft = OnboardingDraft(
      specializationId: 'spec',
      targetLanguage: 'fr',
      goal: LearningGoal.dailyPractice,
      dailyTargetMinutes: 30,
      experienceLevel: ExperienceLevel.advanced,
    );
    expect(draft.toPreferences(), {
      'specializationId': 'spec',
      'targetLanguage': 'fr',
      'goal': 'daily_practice',
      'dailyTargetMinutes': 30,
      'experienceLevel': 'advanced',
    });
  });

  test('leaves out a domain and language nobody could pick', () {
    const draft = OnboardingDraft(
      goal: LearningGoal.academic,
      dailyTargetMinutes: 5,
      experienceLevel: ExperienceLevel.beginner,
    );
    expect(draft.toPreferences().keys, [
      'goal',
      'dailyTargetMinutes',
      'experienceLevel',
    ]);
  });

  test('changing domain clears the language picked for the old one', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final sub = container.listen(onboardingDraftProvider, (_, _) {});
    addTearDown(sub.close);
    final notifier = container.read(onboardingDraftProvider.notifier)
      ..selectDomain('a')
      ..selectLanguage('fr')
      ..selectDomain('a');
    expect(container.read(onboardingDraftProvider).targetLanguage, 'fr');

    notifier.selectDomain('b');
    expect(container.read(onboardingDraftProvider).targetLanguage, isNull);
  });
}
