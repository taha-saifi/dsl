import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/error_messages.dart';
import '../../../core/auth/app_user.dart';
import '../../../core/auth/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/coming_soon.dart';
import '../../../core/widgets/state_views.dart';
import '../../learn/data/language_names.dart';
import '../../learn/data/learn_repository.dart';
import '../../onboarding/presentation/preference_labels.dart';

/// Figma 12b "Settings" (`89:4`). Language, Daily Target and Experience
/// Level edit the onboarding preferences (`PATCH /auth/me`); every other
/// row is marked "Soon" (feat-profile-and-settings).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    Map<String, Object?> preferences,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .savePreferences(preferences);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Saved.')));
    } on Object catch (error) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(describeError(error))));
    }
  }

  Future<T?> _pick<T>(
    BuildContext context, {
    required String title,
    required List<(T, String)> options,
    required T? current,
  }) {
    // A "Saved." snackbar would cover the bottom of the sheet.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: context.colors.inkSurface,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(
                title,
                style: context.type.h3.copyWith(color: context.colors.white),
              ),
            ),
            for (final (value, label) in options)
              ListTile(
                title: Text(
                  label,
                  style: context.type.bodyLarge.copyWith(
                    color: context.colors.white,
                  ),
                ),
                trailing: value == current
                    ? Icon(Icons.check_rounded, color: context.colors.cyan)
                    : null,
                onTap: () => Navigator.of(context).pop(value),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLanguage(
    BuildContext context,
    WidgetRef ref,
    LearningPreferences? prefs,
  ) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.colors.inkSurface,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final provider = languagesProvider(prefs?.specializationId);
          return SafeArea(
            child: ref
                .watch(provider)
                .when(
                  loading: () =>
                      const SizedBox(height: 160, child: LoadingView()),
                  error: (error, _) => SizedBox(
                    height: 280,
                    child: ErrorView(
                      error: error,
                      title: "Couldn't load languages",
                      onRetry: () => ref.invalidate(provider),
                    ),
                  ),
                  data: (languages) => ListView(
                    shrinkWrap: true,
                    children: [
                      for (final l in languages)
                        ListTile(
                          title: Text(
                            LanguageName.of(l.code).english,
                            style: context.type.bodyLarge.copyWith(
                              color: context.colors.white,
                            ),
                          ),
                          trailing: l.code == prefs?.targetLanguage
                              ? Icon(
                                  Icons.check_rounded,
                                  color: context.colors.cyan,
                                )
                              : null,
                          onTap: () => Navigator.of(context).pop(l.code),
                        ),
                    ],
                  ),
                ),
          );
        },
      ),
    );
    if (picked != null && picked != prefs?.targetLanguage && context.mounted) {
      await _save(context, ref, {'targetLanguage': picked});
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final prefs = auth is SignedIn ? auth.user.preferences : null;
    final language = prefs?.targetLanguage;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          const _Section('Learning'),
          _Row(
            label: 'Language',
            value: language == null
                ? 'Not set'
                : LanguageName.of(language).english,
            onTap: () => _pickLanguage(context, ref, prefs),
          ),
          _Row(
            label: 'Daily Target',
            value: prefs?.dailyTargetMinutes == null
                ? 'Not set'
                : dailyTargetLabel(prefs!.dailyTargetMinutes!),
            onTap: () async {
              final picked = await _pick<int>(
                context,
                title: 'Daily target',
                options: [
                  for (final m in dailyTargetOptions) (m, dailyTargetLabel(m)),
                ],
                current: prefs?.dailyTargetMinutes,
              );
              if (picked != null && context.mounted) {
                await _save(context, ref, {'dailyTargetMinutes': picked});
              }
            },
          ),
          _Row(
            label: 'Experience Level',
            value: prefs?.experienceLevel?.label ?? 'Not set',
            onTap: () async {
              final picked = await _pick<ExperienceLevel>(
                context,
                title: 'Experience level',
                options: [for (final l in ExperienceLevel.values) (l, l.label)],
                current: prefs?.experienceLevel,
              );
              if (picked != null && context.mounted) {
                await _save(context, ref, {'experienceLevel': picked.name});
              }
            },
          ),
          const _Row(label: 'Notifications'),
          const _Section('Account'),
          const _Row(label: 'Edit Profile'),
          const _Row(label: 'Privacy & Data'),
          const _Row(label: 'Linked Accounts'),
          const _Row(label: 'Subscription'),
          const _Section('Support'),
          const _Row(label: 'Help Center'),
          const _Row(label: 'Send Feedback'),
          const _Row(label: 'Rate the App'),
          _Row(
            label: 'About DSL',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'DSL',
              applicationVersion: '0.1.0',
              applicationLegalese:
                  'Domain Specific Language: professional vocabulary, '
                  'one domain at a time.',
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, AppSpacing.lg, 0, AppSpacing.sm),
    child: Text(
      title.toUpperCase(),
      style: context.type.label.copyWith(color: context.colors.muted),
    ),
  );
}

/// A settings row. Without [onTap] it's disabled and marked "Soon".
class _Row extends StatelessWidget {
  const _Row({required this.label, this.value, this.onTap});

  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      enabled: onTap != null,
      title: Text(
        label,
        style: type.bodyLarge.copyWith(
          color: onTap == null ? colors.muted : colors.white,
        ),
      ),
      subtitle: value == null
          ? null
          : Text(value!, style: type.body.copyWith(color: colors.cyan)),
      trailing: onTap == null
          ? const SoonBadge()
          : Icon(Icons.chevron_right_rounded, color: colors.muted),
    );
  }
}
