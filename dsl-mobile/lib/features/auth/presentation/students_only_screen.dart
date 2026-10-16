import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import 'auth_widgets.dart';

/// A teacher or admin signed in. Mirrors the dashboard's
/// `RequireTeacherRole` screen the other way round.
class StudentsOnlyScreen extends ConsumerWidget {
  const StudentsOnlyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final type = context.type;
    final auth = ref.watch(authControllerProvider);
    final user = auth is SignedIn ? auth.user : null;

    return Scaffold(
      body: AuthScrollBody(
        children: [
          const Center(child: AuthLogo()),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'This app is for students',
            textAlign: TextAlign.center,
            style: type.h2.copyWith(color: colors.white),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '${user?.email ?? 'This account'} is a ${user?.role.name ?? 'staff'} '
            'account. Teachers and admins manage content in the DSL web '
            'dashboard.',
            textAlign: TextAlign.center,
            style: type.body.copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          DslButton(
            label: 'Log out',
            variant: DslButtonVariant.secondary,
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}
