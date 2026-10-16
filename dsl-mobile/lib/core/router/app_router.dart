import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/dev/presentation/design_system_screen.dart';
import '../../features/dev/presentation/system_check_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../widgets/dsl_bottom_nav.dart';
import '../widgets/placeholder_screen.dart';
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

/// One router for the app. Auth and onboarding guards are added to
/// `redirect` in slices 1 and 2 (docs/decisions/mobile-architecture.md).
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: Routes.home,
    routes: [
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
                builder: (_, _) => const PlaceholderScreen(
                  title: 'Profile',
                  message: 'Your account and learning preferences.',
                ),
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
  ref.onDispose(router.dispose);
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
