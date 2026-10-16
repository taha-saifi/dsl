import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/dsl_card.dart';

/// Slice 1: who is signed in, and Log out. The full Profile (stats,
/// achievements, settings rows) comes with slice 9.
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
          if (user != null)
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
