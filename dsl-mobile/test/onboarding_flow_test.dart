import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dsl/app.dart';
import 'package:dsl/core/api/api_providers.dart';
import 'package:dsl/core/widgets/dsl_bottom_nav.dart';
import 'package:dsl/core/widgets/dsl_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/test_api.dart';

/// A signed-in student with no preferences, over the real router and client.
/// [routes] maps "METHOD /path" to a response; anything else fails the test.
Future<TestApi> _launchNewStudent(
  WidgetTester tester,
  Map<String, ResponseBody Function(RequestOptions)> routes,
) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);

  final api = TestApi((o) async {
    final handler = routes['${o.method} ${o.path}'];
    if (handler == null) fail('unexpected ${o.method} ${o.path}');
    return handler(o);
  }, token: 'stored');
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

DslButton _button(WidgetTester tester, String label) => tester.widget(
  find.ancestor(of: find.text(label), matching: find.byType(DslButton)),
);

/// Scrolls [text] into view first: the step lists are taller than the screen.
Future<void> _tap(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text));
  await tester.pumpAndSettle();
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

ResponseBody Function(RequestOptions) _fixture(String name) =>
    (_) => fixtureResponse(name);

void main() {
  testWidgets('a new student picks domain, language and profile, then Home', (
    tester,
  ) async {
    final api = await _launchNewStudent(tester, {
      'GET /auth/me': _fixture('auth_me_new_student.json'),
      'GET /learn/specializations': _fixture('learn_specializations.json'),
      'GET /learn/languages': _fixture('learn_languages.json'),
      'PATCH /auth/me': _fixture('auth_patch_me.json'),
      'GET /learn/me/courses': _fixture('learn_me_courses_empty.json'),
    });

    // Step 1: domain. Continue waits for a choice.
    expect(find.text('Step 1 of 3'), findsOneWidget);
    expect(find.byType(DslBottomNav), findsNothing);
    expect(_button(tester, 'Continue').onPressed, isNull);
    await tester.tap(find.text('E2E Languages'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 2: languages of that domain.
    expect(find.text('Step 2 of 3'), findsOneWidget);
    final languagesCall = api.adapter.requests.last;
    expect(languagesCall.path, '/learn/languages');
    expect(languagesCall.queryParameters, {
      'specializationId': '6aa872d4a40b68f11a965014',
    });
    expect(find.text('Français · 1 course'), findsOneWidget);
    await tester.tap(find.text('French'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 3: every choice is needed before saving.
    expect(find.text('Step 3 of 3 — Final Step'), findsOneWidget);
    expect(_button(tester, 'Get Started').onPressed, isNull);
    await _tap(tester, 'Daily Practice');
    await _tap(tester, '10 min');
    await _tap(tester, 'Beginner');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    final patch = api.adapter.requests.singleWhere((r) => r.method == 'PATCH');
    expect(jsonDecode(jsonEncode(patch.data)), {
      'preferences': {
        'specializationId': '6aa872d4a40b68f11a965014',
        'targetLanguage': 'fr',
        'goal': 'daily_practice',
        'dailyTargetMinutes': 10,
        'experienceLevel': 'beginner',
      },
    });
    expect(find.text('Hello, Sara'), findsOneWidget);
    expect(find.byType(DslBottomNav), findsOneWidget);
  });

  testWidgets('Back returns to the domain step and keeps the choice', (
    tester,
  ) async {
    await _launchNewStudent(tester, {
      'GET /auth/me': _fixture('auth_me_new_student.json'),
      'GET /learn/specializations': _fixture('learn_specializations.json'),
      'GET /learn/languages': _fixture('learn_languages.json'),
    });
    await tester.tap(find.text('E2E Languages'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 3'), findsOneWidget);
    expect(_button(tester, 'Continue').onPressed, isNotNull);
  });

  testWidgets('no published courses: steps 1 and 2 can be skipped', (
    tester,
  ) async {
    ResponseBody empty(RequestOptions _) =>
        FakeAdapter.json({'data': <Object>[]});
    final api = await _launchNewStudent(tester, {
      'GET /auth/me': _fixture('auth_me_new_student.json'),
      'GET /learn/specializations': empty,
      'GET /learn/languages': empty,
      'PATCH /auth/me': _fixture('auth_patch_me.json'),
      'GET /learn/me/courses': _fixture('learn_me_courses_empty.json'),
    });

    expect(find.text('No courses yet'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('No languages yet'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await _tap(tester, 'Academic Study');
    await _tap(tester, '5 min');
    await _tap(tester, 'Advanced');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    final patch = api.adapter.requests.singleWhere((r) => r.method == 'PATCH');
    expect(jsonDecode(jsonEncode(patch.data)), {
      'preferences': {
        'goal': 'academic',
        'dailyTargetMinutes': 5,
        'experienceLevel': 'advanced',
      },
    });
  });

  testWidgets('domains failing to load show a retry', (tester) async {
    var calls = 0;
    await _launchNewStudent(tester, {
      'GET /auth/me': _fixture('auth_me_new_student.json'),
      'GET /learn/specializations': (o) {
        calls++;
        if (calls == 1) networkDown(o);
        return fixtureResponse('learn_specializations.json');
      },
    });

    expect(find.text("Couldn't load domains"), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('E2E Languages'), findsOneWidget);
  });

  testWidgets('a failed save shows the error and stays on step 3', (
    tester,
  ) async {
    await _launchNewStudent(tester, {
      'GET /auth/me': _fixture('auth_me_new_student.json'),
      'GET /learn/specializations': _fixture('learn_specializations.json'),
      'GET /learn/languages': _fixture('learn_languages.json'),
      'PATCH /auth/me': (_) => FakeAdapter.json({
        'error': {
          'message': 'Specialization not found.',
          'code': 'SPECIALIZATION_NOT_FOUND',
        },
      }, status: 404),
    });
    await tester.tap(find.text('E2E Languages'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('French'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await _tap(tester, 'Certification');
    await _tap(tester, '20 min');
    await _tap(tester, 'Intermediate');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Specialization not found.'), findsOneWidget);
    expect(find.text('Step 3 of 3 — Final Step'), findsOneWidget);
  });
}
