import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/state_views.dart';

/// A token is stored but the API couldn't confirm it (offline, timeout,
/// 5xx). The student stays signed in and can try again.
class ReconnectScreen extends ConsumerWidget {
  const ReconnectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ErrorView(
                error: auth is SessionUnverified ? auth.error : Object(),
                title: "Can't open DSL right now",
                onRetry: controller.retry,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxxl,
                0,
                AppSpacing.xxxl,
                AppSpacing.xxl,
              ),
              child: DslButton(
                label: 'Log out',
                variant: DslButtonVariant.ghost,
                size: DslButtonSize.medium,
                onPressed: controller.signOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
