import 'package:dsl/app.dart';
import 'package:dsl/core/api/api_exception.dart';
import 'package:dsl/core/api/api_providers.dart';
import 'package:dsl/core/config/app_config.dart';
import 'package:dsl/core/theme/app_theme.dart';
import 'package:dsl/core/widgets/dsl_bottom_nav.dart';
import 'package:dsl/features/dev/data/health_repository.dart';
import 'package:dsl/features/dev/presentation/system_check_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_api.dart';

const _config = AppConfig(
  apiBaseUrl: 'http://api.test/api',
  environment: 'dev',
);

/// The app with a signed-in student (stored token, `/auth/me` fixture).
Widget _signedInApp() => ProviderScope(
  retry: noAutomaticRetry,
  overrides: TestApi(
    routes({
      'GET /auth/me': respondWith('auth_me.json'),
      'GET /learn/me/courses': respondWith('learn_me_courses_empty.json'),
      'GET /learn/specializations': respondWith('learn_specializations.json'),
      'GET /learn/courses': respondWith('learn_courses_all.json'),
    }),
    token: 'stored',
  ).overrides,
  child: const DslApp(),
);

Widget _screen(Widget child, {required List<Override> overrides}) =>
    ProviderScope(
      retry: noAutomaticRetry,
      overrides: [appConfigProvider.overrideWithValue(_config), ...overrides],
      child: MaterialApp(theme: AppTheme.dsl(), home: child),
    );

Finder _navTab(String label) => find.descendant(
  of: find.byType(DslBottomNav),
  matching: find.bySemanticsLabel(label),
);

void main() {
  testWidgets('shell shows four tabs, no Practice, and switches tabs', (
    tester,
  ) async {
    await tester.pumpWidget(_signedInApp());
    await tester.pumpAndSettle();

    expect(find.text('Hello, Sara'), findsOneWidget);

    for (final label in ['Home', 'Courses', 'Certs', 'Profile']) {
      expect(_navTab(label), findsOneWidget);
    }
    expect(find.text('Practice'), findsNothing);

    await tester.tap(_navTab('Courses'));
    await tester.pumpAndSettle();
    expect(find.text('Explore Courses'), findsOneWidget);
  });

  testWidgets('system check shows success when /health answers', (
    tester,
  ) async {
    await tester.pumpWidget(
      _screen(
        const SystemCheckScreen(),
        overrides: [healthStatusProvider.overrideWith((ref) async => 'ok')],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('API is reachable'), findsOneWidget);
    expect(find.text('status: ok'), findsOneWidget);
  });

  testWidgets('system check shows a retryable error when the API is down', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      _screen(
        const SystemCheckScreen(),
        overrides: [
          healthStatusProvider.overrideWith((ref) async {
            calls++;
            throw const ApiException(
              failure: ApiFailure.network,
              message: 'Could not reach the server.',
            );
          }),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("The API didn't answer"), findsOneWidget);
    expect(find.textContaining("Can't reach the server"), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(calls, 2);
  });
}
