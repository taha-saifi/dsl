import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/launch_screen.dart';
import '../../features/auth/presentation/reconnect_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/sign_up_screen.dart';
import '../../features/auth/presentation/students_only_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/dev/presentation/design_system_screen.dart';
import '../../features/dev/presentation/system_check_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../auth/auth_controller.dart';
import '../widgets/dsl_bottom_nav.dart';
import '../widgets/placeholder_screen.dart';
import 'auth_redirect.dart';
import 'routes.dart';

/// Tabs in bottom-nav order. Practice is omitted until it's designed (Q34).
const _tabs = [
  DslNavItem(
    label: 'Home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
  ),
  DslNavItem(
    label: 'Courses',
    icon: Icons.menu_book_outlined,
    activeIcon: Icons.menu_book_rounded,
  ),
  DslNavItem(
    label: 'Certs',
    icon: Icons.workspace_premium_outlined,
    activeIcon: Icons.workspace_premium_rounded,
  ),
  DslNavItem(
    label: 'Profile',
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
  ),
];

/// One router for the app. The session guard is [authRedirect]; the
/// onboarding guard joins it in slice 2 (docs/decisions/mobile-architecture.md).
final appRouterProvider = Provider<GoRouter>((ref) {
  // The router is built once; auth changes re-run `redirect` through this.
  final auth = ValueNotifier<AuthState>(ref.read(authControllerProvider));
  ref.listen(authControllerProvider, (_, next) => auth.value = next);

  final router = GoRouter(
    initialLocation: Routes.launch,
    refreshListenable: auth,
    redirect: (_, state) => authRedirect(auth.value, state.matchedLocation),
    routes: [
      GoRoute(path: Routes.launch, builder: (_, _) => const LaunchScreen()),
      GoRoute(
        path: Routes.reconnect,
        builder: (_, _) => const ReconnectScreen(),
      ),
      GoRoute(
        path: Routes.studentsOnly,
        builder: (_, _) => const StudentsOnlyScreen(),
      ),
      GoRoute(path: Routes.welcome, builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: Routes.signIn, builder: (_, _) => const SignInScreen()),
      GoRoute(path: Routes.signUp, builder: (_, _) => const SignUpScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.courses,
                builder: (_, _) => const PlaceholderScreen(
                  title: 'Courses',
                  message: 'Browse published courses and enroll here.',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.certificates,
                builder: (_, _) => const PlaceholderScreen(
                  title: 'Certificates',
                  message: 'Certificates you earn will be listed here.',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      if (kDebugMode) ...[
        GoRoute(
          path: Routes.systemCheck,
          builder: (_, _) => const SystemCheckScreen(),
        ),
        GoRoute(
          path: Routes.designSystem,
          builder: (_, _) => const DesignSystemScreen(),
        ),
      ],
    ],
  );
  ref.onDispose(() {
    router.dispose();
    auth.dispose();
  });
  return router;
});

class _AppShell extends StatelessWidget {
  const _AppShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: DslBottomNav(
        items: _tabs,
        currentIndex: shell.currentIndex,
        // Re-tapping the active tab returns it to its first page.
        onTap: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
      ),
    );
  }
}
