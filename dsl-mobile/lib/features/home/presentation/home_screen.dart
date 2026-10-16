import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/placeholder_screen.dart';

/// Placeholder with the student's name. The real Home (My Courses,
/// Continue) arrives in slice 4. In debug builds it links to the developer
/// screens.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final firstName = auth is SignedIn ? auth.user.firstName : null;

    return PlaceholderScreen(
      title: firstName == null ? 'Home' : 'Hi, $firstName',
      message: 'Your courses and progress will show up here.',
      actions: [
        if (kDebugMode)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenMargin,
              0,
              AppSpacing.screenMargin,
              AppSpacing.xxl,
            ),
            child: Column(
              children: [
                DslButton(
                  label: 'System check',
                  icon: Icons.wifi_tethering_rounded,
                  variant: DslButtonVariant.secondary,
                  onPressed: () => context.push(Routes.systemCheck),
                ),
                const SizedBox(height: AppSpacing.md),
                DslButton(
                  label: 'Design system',
                  icon: Icons.palette_outlined,
                  variant: DslButtonVariant.ghost,
                  onPressed: () => context.push(Routes.designSystem),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
