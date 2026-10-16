import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/auth/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/dsl_card.dart';
import '../../onboarding/data/language_names.dart';
import '../../onboarding/data/learn_repository.dart';
import '../../onboarding/presentation/preference_labels.dart';

/// Who is signed in, their learning preferences (read-only for now), and
/// Log out. The full Profile (stats, achievements, settings) is slice 9.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final type = context.type;
    final auth = ref.watch(authControllerProvider);
    final user = auth is SignedIn ? auth.user : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          if (user != null) ...[
            DslCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.cyan,
                    child: Text(
                      user.displayName.characters.first.toUpperCase(),
                      style: type.h2.copyWith(color: colors.ink),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName,
                          style: type.h3.copyWith(color: colors.white),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          user.email,
                          style: type.body.copyWith(color: colors.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (user.preferences != null) ...[
              const SizedBox(height: AppSpacing.lg),
              _PreferencesCard(preferences: user.preferences!),
            ],
          ],
          const SizedBox(height: AppSpacing.xxl),
          DslButton(
            label: 'Log out',
            icon: Icons.logout_rounded,
            variant: DslButtonVariant.ghost,
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}

class _PreferencesCard extends ConsumerWidget {
  const _PreferencesCard({required this.preferences});

  final LearningPreferences preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final domainId = preferences.specializationId;
    // Name lookup only; while it loads (or if it fails) the row is omitted.
    final domainName = domainId == null
        ? null
        : ref
              .watch(specializationsProvider)
              .value
              ?.where((d) => d.id == domainId)
              .firstOrNull
              ?.name;
    final language = preferences.targetLanguage;

    final rows = <(String, String)>[
      if (domainName != null) ('Domain', domainName),
      if (language != null) ('Learning', LanguageName.of(language).english),
      if (preferences.goal != null) ('Goal', preferences.goal!.label),
      if (preferences.dailyTargetMinutes != null)
        ('Daily target', dailyTargetLabel(preferences.dailyTargetMinutes!)),
      if (preferences.experienceLevel != null)
        ('Level', preferences.experienceLevel!.label),
    ];

    final colors = context.colors;
    final type = context.type;
    return DslCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LEARNING PREFERENCES',
            style: type.label.copyWith(color: colors.muted),
          ),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: type.body.copyWith(color: colors.muted),
                    ),
                  ),
                  Text(
                    value,
                    style: type.body.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
