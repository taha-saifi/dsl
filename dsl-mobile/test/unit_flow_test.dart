import 'package:dsl/app.dart';
import 'package:dsl/core/api/api_providers.dart';
import 'package:dsl/core/router/app_router.dart';
import 'package:dsl/core/router/routes.dart';
import 'package:dsl/core/widgets/dsl_bottom_nav.dart';
import 'package:dsl/core/widgets/dsl_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/test_api.dart';

const _course = '6ad28f21dcbfbc7ecf3f1a95';
const _unit = '6ad28f21dcbfbc7ecf3f1a96';

Future<TestApi> _launch(WidgetTester tester, {Responder? unit}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);
  final api = TestApi(
    routes({
      'GET /auth/me': respondWith('auth_me.json'),
      'GET /learn/me/courses': respondWith('learn_me_courses.json'),
      'GET /learn/specializations': respondWith('learn_specializations.json'),
      'GET /learn/courses/$_course': respondWith('learn_course_enrolled.json'),
      'GET /learn/units/$_unit': unit ?? respondWith('learn_unit.json'),
    }),
    token: 'stored',
  );
  await tester.pumpWidget(
    ProviderScope(
      retry: noAutomaticRetry,
      overrides: api.overrides,
      child: const DslApp(),
    ),
  );
  await tester.pumpAndSettle();
  return api;
}

/// Courses tab → course → its unit row.
Future<void> _openUnit(WidgetTester tester) async {
  final container = ProviderScope.containerOf(
    tester.element(find.byType(DslApp)),
  );
  container.read(appRouterProvider).go(Routes.course(_course));
  await tester.pumpAndSettle();
  expect(find.text('Course Details'), findsOneWidget);
  await tester.tap(find.text('A1 Published unit'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('unit lists exercises with their type mix, in order', (
    tester,
  ) async {
    await _launch(tester);
    await _openUnit(tester);

    expect(find.text('Unit Details'), findsOneWidget);
    expect(find.text('A1 Published unit'), findsOneWidget);
    expect(find.text('3 exercises'), findsOneWidget);
    final names = tester
        .widgetList<Text>(find.textContaining(RegExp(r'^(A1 ex|Organs)')))
        .map((t) => t.data);
    expect(names, [
      'A1 ex 1 (published)',
      'A1 ex 2 (published)',
      'Organs: mixed practice',
    ]);
    expect(find.text('Choose picture · Multiple choice · +6'), findsOneWidget);
    expect(find.text('8 questions'), findsOneWidget);
    expect(find.byType(DslBottomNav), findsOneWidget);
  });

  testWidgets('intro of a mixed exercise shows every type', (tester) async {
    await _launch(tester);
    await _openUnit(tester);
    await tester.tap(find.text('Organs: mixed practice'));
    await tester.pumpAndSettle();

    expect(find.text('A1 Published unit · Exercise 3'), findsOneWidget);
    expect(find.text('MIXED PRACTICE'), findsOneWidget);
    expect(find.text("You'll answer 8 questions of 8 kinds:"), findsOneWidget);
    for (final label in [
      'Choose picture',
      'Multiple choice',
      'Listen and type',
      'Listen and select',
      'Typing',
      'Fill in the blank',
      'Arrange sentence',
      'Matching pairs',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    // Start opens the player (covered in player_flow_test).
    await tester.scrollUntilVisible(find.text('Start Exercise'), 200);
    final start = tester.widget<DslButton>(
      find.ancestor(
        of: find.text('Start Exercise'),
        matching: find.byType(DslButton),
      ),
    );
    expect(start.onPressed, isNotNull);

    await tester.ensureVisible(find.text("I'll do this later"));
    await tester.tap(find.text("I'll do this later"));
    await tester.pumpAndSettle();
    expect(find.text('Unit Details'), findsOneWidget);
  });

  testWidgets('progress, Done badge, and Start Next opens the first not done', (
    tester,
  ) async {
    await _launch(tester);
    await _openUnit(tester);

    // Recorded: the mixed exercise was completed at 29%.
    expect(find.text('1 of 3 exercises done'), findsOneWidget);
    expect(find.text('Done · 29%'), findsOneWidget);
    await tester.tap(find.text('Start Next Exercise'));
    await tester.pumpAndSettle();

    expect(find.text('TYPING'), findsOneWidget);
    expect(find.text('A1 Published unit · Exercise 1'), findsOneWidget);
    expect(find.text("You'll answer 2 questions of 1 kind:"), findsOneWidget);
  });

  testWidgets('a unit that disappeared shows not found with retry', (
    tester,
  ) async {
    var calls = 0;
    await _launch(
      tester,
      unit: (_) {
        calls++;
        return calls == 1
            ? FakeAdapter.json({
                'error': {
                  'message': 'Unit not found.',
                  'code': 'UNIT_NOT_FOUND',
                },
              }, status: 404)
            : fixtureResponse('learn_unit.json');
      },
    );
    await _openUnit(tester);

    expect(find.text("Couldn't load this unit"), findsOneWidget);
    expect(find.text('Unit not found.'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('A1 Published unit'), findsOneWidget);
  });
}
