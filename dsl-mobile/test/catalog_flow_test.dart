import 'package:dio/dio.dart';
import 'package:dsl/app.dart';
import 'package:dsl/core/api/api_providers.dart';
import 'package:dsl/core/widgets/dsl_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/test_api.dart';

const _e2eDomain = '6aa872d4a40b68f11a965014'; // Sara's onboarding domain
const _s3Course = '6ad28f21dcbfbc7ecf3f1a95';
const _s3Unit = '6ad28f21dcbfbc7ecf3f1a96';

/// The real app, signed in as Sara (onboarded: E2E Languages, French). The
/// fake server remembers whether she's enrolled in the S3 course.
class _Server {
  bool enrolled = false;
  bool catalogDown = false;

  Future<ResponseBody> Function(RequestOptions) get handler => routes({
    'GET /auth/me': respondWith('auth_me.json'),
    'GET /learn/specializations': respondWith('learn_specializations.json'),
    'GET /learn/languages': respondWith('learn_languages.json'),
    'GET /learn/me/courses': (_) => fixtureResponse(
      enrolled ? 'learn_me_courses.json' : 'learn_me_courses_empty.json',
    ),
    'GET /learn/courses': (o) {
      if (catalogDown) networkDown(o);
      final body = fixture('learn_courses_all.json')! as Map<String, dynamic>;
      final list = (body['data']! as List<Object?>)
          .cast<Map<String, dynamic>>();
      for (final c in list) {
        if (c['_id'] == _s3Course) c['isEnrolled'] = enrolled;
      }
      final domain = o.queryParameters['specializationId'];
      return FakeAdapter.json({
        'data': domain == null
            ? list
            : list.where((c) => c['specializationId'] == domain).toList(),
      });
    },
    'GET /learn/courses/$_s3Course': (_) => fixtureResponse(
      enrolled ? 'learn_course_enrolled.json' : 'learn_course.json',
    ),
    'GET /learn/units/$_s3Unit': respondWith('learn_unit.json'),
    'POST /learn/courses/$_s3Course/enroll': (_) {
      enrolled = true;
      return fixtureResponse('learn_enroll.json', status: 201);
    },
    'DELETE /learn/courses/$_s3Course/enroll': (_) {
      enrolled = false;
      return FakeAdapter.json({
        'data': {'id': _s3Course},
      });
    },
  });
}

Future<(TestApi, _Server)> _launch(
  WidgetTester tester, {
  _Server? server,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);
  final s = server ?? _Server();
  final api = TestApi((o) => s.handler(o), token: 'stored');
  await tester.pumpWidget(
    ProviderScope(
      retry: noAutomaticRetry,
      overrides: api.overrides,
      child: const DslApp(),
    ),
  );
  await tester.pumpAndSettle();
  return (api, s);
}

Future<void> _openTab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(
      of: find.byType(DslBottomNav),
      matching: find.bySemanticsLabel(label),
    ),
  );
  await tester.pumpAndSettle();
}

Iterable<RequestOptions> _courseQueries(TestApi api) =>
    api.adapter.requests.where((r) => r.path == '/learn/courses');

void main() {
  testWidgets('catalog starts from the onboarding domain and language', (
    tester,
  ) async {
    final (api, _) = await _launch(tester);
    await _openTab(tester, 'Courses');

    expect(_courseQueries(api).last.queryParameters, {
      'specializationId': _e2eDomain,
      'targetLanguage': 'fr',
    });
    expect(find.text('E2E French Basics'), findsOneWidget);
    expect(find.text('S3 Full Course 4zjs'), findsNothing);
    expect(find.text('French'), findsOneWidget); // language filter button

    // "All" drops the domain and, with it, the language.
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(_courseQueries(api).last.queryParameters, isEmpty);
    expect(find.text('S3 Full Course 4zjs'), findsOneWidget);
    expect(find.text('2 courses found'), findsOneWidget);
  });

  testWidgets('search is sent after a pause, trimmed', (tester) async {
    final (api, _) = await _launch(tester);
    await _openTab(tester, 'Courses');
    final before = _courseQueries(api).length;

    await tester.enterText(find.byType(TextField), 'anat');
    await tester.enterText(find.byType(TextField), 'anatomy ');
    await tester.pump(const Duration(milliseconds: 100));
    expect(_courseQueries(api).length, before); // still typing
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(_courseQueries(api).length, before + 1);
    expect(_courseQueries(api).last.queryParameters['search'], 'anatomy');
  });

  testWidgets('Enroll Now from the catalog, then the course is on Home', (
    tester,
  ) async {
    final (api, server) = await _launch(tester);
    expect(find.text('Start your first course'), findsOneWidget);

    await tester.tap(find.text('Browse courses'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enroll Now').first);
    await tester.pumpAndSettle();

    expect(server.enrolled, isTrue);
    expect(
      api.adapter.requests.any(
        (r) =>
            r.method == 'POST' && r.path == '/learn/courses/$_s3Course/enroll',
      ),
      isTrue,
    );
    expect(find.text('Enrolled'), findsOneWidget);
    expect(find.text('Enrolled in S3 Full Course 4zjs.'), findsOneWidget);

    await _openTab(tester, 'Home');
    expect(find.text('CURRENT COURSE'), findsOneWidget);
    expect(find.text('S3 Full Course 4zjs'), findsWidgets);

    // Progress: 1 of 3 done (the mixed exercise); Continue opens the next.
    expect(find.text('1 of 3 exercises done'), findsOneWidget);
    expect(find.text('33%'), findsWidgets);
    await tester.tap(find.text('Continue Learning'));
    await tester.pumpAndSettle();
    expect(find.text('A1 Published unit · Exercise 1'), findsOneWidget);
  });

  testWidgets('course details: enroll, then leave with confirmation', (
    tester,
  ) async {
    final (_, server) = await _launch(tester);
    await _openTab(tester, 'Courses');
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S3 Full Course 4zjs'));
    await tester.pumpAndSettle();

    expect(find.text('Course Details'), findsOneWidget);
    expect(find.text('UNIT 01'), findsOneWidget);
    await tester.tap(find.text('Enroll Now'));
    await tester.pumpAndSettle();
    expect(server.enrolled, isTrue);
    expect(find.text('Leave course'), findsOneWidget);

    await tester.tap(find.text('Leave course'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(server.enrolled, isTrue);

    await tester.tap(find.text('Leave course'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave course').last);
    await tester.pumpAndSettle();
    expect(server.enrolled, isFalse);
    expect(find.text('Enroll Now'), findsOneWidget);
  });

  testWidgets('catalog failure shows a retry', (tester) async {
    final server = _Server()..catalogDown = true;
    await _launch(tester, server: server);
    await _openTab(tester, 'Courses');

    expect(find.text("Couldn't load courses"), findsOneWidget);
    server.catalogDown = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('E2E French Basics'), findsOneWidget);
  });
}
