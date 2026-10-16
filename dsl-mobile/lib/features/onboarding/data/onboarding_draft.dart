import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';

/// Choices made across the three onboarding steps, saved together at the
/// end with one `PATCH /auth/me`.
class OnboardingDraft {
  const OnboardingDraft({
    this.specializationId,
    this.targetLanguage,
    this.goal,
    this.dailyTargetMinutes,
    this.experienceLevel,
  });

  final String? specializationId;
  final String? targetLanguage;
  final LearningGoal? goal;
  final int? dailyTargetMinutes;
  final ExperienceLevel? experienceLevel;

  bool get profileComplete =>
      goal != null && dailyTargetMinutes != null && experienceLevel != null;

  /// Body for `preferences`. Domain and language are left out when no
  /// published course offered one to pick.
  Map<String, Object?> toPreferences() => {
    'specializationId': ?specializationId,
    'targetLanguage': ?targetLanguage,
    'goal': ?goal?.apiValue,
    'dailyTargetMinutes': ?dailyTargetMinutes,
    'experienceLevel': ?experienceLevel?.name,
  };

  OnboardingDraft copyWith({
    String? specializationId,
    String? targetLanguage,
    LearningGoal? goal,
    int? dailyTargetMinutes,
    ExperienceLevel? experienceLevel,
    bool clearLanguage = false,
  }) => OnboardingDraft(
    specializationId: specializationId ?? this.specializationId,
    targetLanguage: clearLanguage
        ? null
        : (targetLanguage ?? this.targetLanguage),
    goal: goal ?? this.goal,
    dailyTargetMinutes: dailyTargetMinutes ?? this.dailyTargetMinutes,
    experienceLevel: experienceLevel ?? this.experienceLevel,
  );
}

extension LearningGoalApi on LearningGoal {
  /// Matches the `@JsonValue`s on [LearningGoal].
  String get apiValue =>
      this == LearningGoal.dailyPractice ? 'daily_practice' : name;
}

class OnboardingDraftNotifier extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  /// A new domain may not offer the language picked before.
  void selectDomain(String id) => state = id == state.specializationId
      ? state
      : state.copyWith(specializationId: id, clearLanguage: true);

  void selectLanguage(String code) =>
      state = state.copyWith(targetLanguage: code);

  void selectGoal(LearningGoal goal) => state = state.copyWith(goal: goal);

  void selectDailyTarget(int minutes) =>
      state = state.copyWith(dailyTargetMinutes: minutes);

  void selectLevel(ExperienceLevel level) =>
      state = state.copyWith(experienceLevel: level);
}

final onboardingDraftProvider =
    NotifierProvider.autoDispose<OnboardingDraftNotifier, OnboardingDraft>(
      OnboardingDraftNotifier.new,
    );
