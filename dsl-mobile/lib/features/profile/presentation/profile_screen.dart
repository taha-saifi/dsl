import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/coming_soon.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/dsl_card.dart';
import '../../learn/data/language_names.dart';
import '../../onboarding/presentation/preference_labels.dart';

/// Figma 12a "Profile" (`111:296`). The header (name, email, goal, level,
/// language) is real and comes from the signed-in user, so the screen
/// makes no network calls. Stats and achievements are static until
/// feat-xp-and-levels / feat-achievements (feat-static-screens).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final type = context.type;
    final auth = ref.watch(authControllerProvider);
    final user = auth is SignedIn ? auth.user : null;
    final prefs = user?.preferences;
    final subtitle = [
      if (prefs?.goal != null) prefs!.goal!.label,
      if (prefs?.experienceLevel != null) prefs!.experienceLevel!.label,
      if (prefs?.targetLanguage != null)
        'Learning ${LanguageName.of(prefs!.targetLanguage!).english}',
    ].join(' · ');

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          if (user != null)
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: colors.cyan,
                  child: Text(
                    user.displayName.characters.first.toUpperCase(),
                    style: type.display.copyWith(color: colors.ink),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  user.displayName,
                  style: type.h2.copyWith(color: colors.white),
                ),
                Text(
                  user.email,
                  style: type.body.copyWith(color: colors.muted),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: type.caption.copyWith(color: colors.cyan),
                  ),
                ],
              ],
            ),
          const SizedBox(height: AppSpacing.xl),
          const ComingSoonBanner(
            message: 'XP, streaks, rank and achievements are on the way.',
          ),
          const SizedBox(height: AppSpacing.md),
          const Row(
            children: [
              _Stat(label: 'Total XP', icon: Icons.bolt_rounded),
              SizedBox(width: AppSpacing.sm),
              _Stat(label: 'Streak', icon: Icons.local_fire_department_rounded),
              SizedBox(width: AppSpacing.sm),
              _Stat(label: 'Rank', icon: Icons.leaderboard_rounded),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Achievements', style: type.h3.copyWith(color: colors.white)),
          const SizedBox(height: AppSpacing.sm),
          const Row(
            children: [
              _Achievement(label: 'First Milestone', icon: Icons.flag_rounded),
              SizedBox(width: AppSpacing.sm),
              _Achievement(
                label: 'Dedicated Learner',
                icon: Icons.school_rounded,
              ),
              SizedBox(width: AppSpacing.sm),
              _Achievement(
                label: 'Scholar',
                icon: Icons.workspace_premium_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _NavRow(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => context.go(Routes.settings),
          ),
          const SizedBox(height: AppSpacing.sm),
          _NavRow(
            icon: Icons.leaderboard_outlined,
            label: 'Leaderboard',
            onTap: () => context.go(Routes.leaderboard),
          ),
          const SizedBox(height: AppSpacing.xxl),
          DslButton(
            label: 'Log Out',
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

/// A stat with no value yet: "—" rather than a made-up number.
class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: DslCard(
        child: Column(
          children: [
            Icon(icon, color: colors.muted),
            Text('—', style: context.type.h2.copyWith(color: colors.muted)),
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

/// A locked achievement tile (Figma "Achievement Card" `52:396`).
class _Achievement extends StatelessWidget {
  const _Achievement({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Semantics(
        container: true,
        label: '$label, locked',
        excludeSemantics: true,
        child: DslCard(
          child: Column(
            children: [
              Icon(icon, color: colors.inkBorder, size: 32),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                textAlign: TextAlign.center,
                style: context.type.caption.copyWith(color: colors.muted),
              ),
              Icon(Icons.lock_outline_rounded, size: 14, color: colors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.inkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
        side: BorderSide(color: colors.inkBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: colors.cyan),
        title: Text(
          label,
          style: context.type.bodyLarge.copyWith(color: colors.white),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: colors.muted),
      ),
    );
  }
}
