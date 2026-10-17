import 'dart:convert';

import 'package:dsl/app.dart';
import 'package:dsl/core/api/api_providers.dart';
import 'package:dsl/core/widgets/coming_soon.dart';
import 'package:dsl/core/widgets/dsl_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_api.dart';

Future<TestApi> _launch(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);
  final api = TestApi(
    routes({
      'GET /auth/me': respondWith('auth_me.json'),
      'GET /learn/me/courses': respondWith('learn_me_courses_empty.json'),
      'PATCH /auth/me': respondWith('auth_patch_me.json'),
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

Future<void> _tab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(
      of: find.byType(DslBottomNav),
      matching: find.bySemanticsLabel(label),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(text).first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('static screens open with no network calls and say Coming soon', (
    tester,
  ) async {
    final api = await _launch(tester);
    final atHome = api.adapter.requests.length;

    await _tab(tester, 'Certs');
    expect(find.text('My Certificates'), findsOneWidget);
    expect(find.byType(ComingSoonBanner), findsOneWidget);
    await _tap(tester, 'View sample certificate');
    expect(find.text('SAMPLE'), findsOneWidget);
    expect(find.text('Your name'), findsOneWidget);
    expect(find.byType(ComingSoonBanner), findsOneWidget);

    await _tab(tester, 'Profile');
    expect(find.text('Sara Lee'), findsOneWidget);
    expect(
      find.text('Daily Practice · Beginner · Learning French'),
      findsOneWidget,
    );
    expect(find.byType(ComingSoonBanner), findsOneWidget);
    await tester.ensureVisible(find.text('Scholar'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Scholar, locked'), findsOneWidget);

    await _tap(tester, 'Leaderboard');
    expect(find.byType(ComingSoonBanner), findsOneWidget);
    expect(find.text('Learner A'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await _tap(tester, 'Settings');
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.byType(SoonBadge), findsNWidgets(8));

    expect(
      api.adapter.requests.skip(atHome).map((r) => '${r.method} ${r.path}'),
      isEmpty,
      reason: 'static screens must not call the API',
    );
  });

  testWidgets('Settings edits daily target and level through PATCH /auth/me', (
    tester,
  ) async {
    final api = await _launch(tester);
    await _tab(tester, 'Profile');
    await _tap(tester, 'Settings');

    expect(find.text('10 min'), findsOneWidget);
    await _tap(tester, 'Daily Target');
    await _tap(tester, '20 min');
    expect(find.text('Saved.'), findsOneWidget);
    var patch = api.adapter.requests.lastWhere((r) => r.method == 'PATCH');
    expect(jsonDecode(jsonEncode(patch.data)), {
      'preferences': {'dailyTargetMinutes': 20},
    });

    await _tap(tester, 'Experience Level');
    expect(find.text('Experience level'), findsOneWidget, reason: 'sheet open');
    await _tap(tester, 'Advanced');
    patch = api.adapter.requests.lastWhere((r) => r.method == 'PATCH');
    expect(jsonDecode(jsonEncode(patch.data)), {
      'preferences': {'experienceLevel': 'advanced'},
    });
  });

  testWidgets('Profile logs out', (tester) async {
    final api = await _launch(tester);
    await _tab(tester, 'Profile');
    await _tap(tester, 'Log Out');

    expect(find.text('DOMAIN SPECIFIC LANGUAGE'), findsOneWidget);
    expect(api.storage.token, isNull);
  });
}
