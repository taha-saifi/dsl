import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/error_messages.dart';
import '../../../core/auth/app_user.dart';
import '../../../core/auth/auth_controller.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../data/onboarding_draft.dart';
import 'onboarding_widgets.dart';
import 'preference_labels.dart';

/// Figma 03-C "Profile Setup" (`57:132`). "Get Started" saves every choice
/// with one `PATCH /auth/me`; the router then leaves onboarding.
class ProfileStepScreen extends ConsumerStatefulWidget {
  const ProfileStepScreen({super.key});

  @override
  ConsumerState<ProfileStepScreen> createState() => _ProfileStepScreenState();
}

class _ProfileStepScreenState extends ConsumerState<ProfileStepScreen> {
  bool _saving = false;
  String? _error;

  Future<void> _save(OnboardingDraft draft) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .savePreferences(draft.toPreferences());
    } on Object catch (error) {
      if (mounted) setState(() => _error = describeError(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(onboardingDraftProvider);
    final notifier = ref.read(onboardingDraftProvider.notifier);
    final tones = tileTones(context);

    return OnboardingScaffold(
      step: 3,
      stepLabel: 'Step 3 of 3 — Final Step',
      titleLine1: 'Personalize',
      titleLine2: 'Your Learning',
      subtitle: 'Help us customize the perfect experience for you',
      onBack: () => context.go(Routes.onboardingLanguage),
      buttonLabel: 'Get Started',
      loading: _saving,
      error: _error,
      onContinue: draft.profileComplete ? () => _save(draft) : null,
      footnote: 'You can update these preferences anytime',
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenMargin,
        ),
        children: [
          const SectionLabel('Learning goal'),
          TwoColumnCards(
            children: [
              for (final goal in LearningGoal.values)
                ChoiceCard(
                  compact: true,
                  title: goal.label,
                  subtitle: goal.description,
                  selected: draft.goal == goal,
                  onTap: () => notifier.selectGoal(goal),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionLabel('Daily target'),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final minutes in dailyTargetOptions)
                _TargetChip(
                  minutes: minutes,
                  selected: draft.dailyTargetMinutes == minutes,
                  onTap: () => notifier.selectDailyTarget(minutes),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionLabel('Experience level'),
          for (final (i, level) in ExperienceLevel.values.indexed) ...[
            ChoiceCard(
              badge: level.label.characters.first,
              tone: tones[i % tones.length],
              title: level.label,
              subtitle: level.description,
              selected: draft.experienceLevel == level,
              onTap: () => notifier.selectLevel(level),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _TargetChip extends StatelessWidget {
  const _TargetChip({
    required this.minutes,
    required this.selected,
    required this.onTap,
  });

  final int minutes;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? colors.cyan : colors.inkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          side: BorderSide(color: selected ? colors.cyan : colors.inkBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm + 2,
            ),
            child: Text(
              dailyTargetLabel(minutes),
              style: context.type.body.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? colors.ink : colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
