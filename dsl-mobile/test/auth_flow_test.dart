import 'package:dio/dio.dart';
import 'package:dsl/app.dart';
import 'package:dsl/core/api/api_providers.dart';
import 'package:dsl/core/widgets/dsl_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/test_api.dart';

/// The whole app (real router, controller, ApiClient) over a fake socket.
Future<TestApi> _launch(
  WidgetTester tester,
  Future<ResponseBody> Function(RequestOptions) handler, {
  String? token,
}) async {
  // Tall enough that every form field is on screen without scrolling.
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);

  final api = TestApi(handler, token: token);
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

Finder _field(String label) => find
    .ancestor(of: find.text(label.toUpperCase()), matching: find.byType(Column))
    .first;

Future<void> _type(WidgetTester tester, String label, String text) =>
    tester.enterText(
      find.descendant(of: _field(label), matching: find.byType(TextField)),
      text,
    );

ResponseBody _unauthorized() => FakeAdapter.json({
  'error': {'message': 'Unauthorized.', 'code': 'UNAUTHORIZED'},
}, status: 401);

void main() {
  testWidgets('signed out: welcome → sign up validates, then onboarding', (
    tester,
  ) async {
    final api = await _launch(
      tester,
      (_) async => fixtureResponse('auth_register.json', status: 201),
    );
    expect(find.text('DOMAIN SPECIFIC LANGUAGE'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Create Account'), findsWidgets);

    await _type(tester, 'First name', 'Sara');
    await _type(tester, 'Last name', 'Lee');
    await _type(tester, 'Email address', 'sara@dsl.local');
    await _type(tester, 'Password', 'short');
    await _type(tester, 'Confirm password', 'other');
    await tester.tap(find.widgetWithText(InkWell, 'Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Use at least 8 characters.'), findsOneWidget);
    expect(find.text("The passwords don't match."), findsOneWidget);
    expect(
      find.text('Accept the terms to create your account.'),
      findsOneWidget,
    );
    expect(api.adapter.requests, isEmpty);

    await _type(tester, 'Password', 'Student123');
    await _type(tester, 'Confirm password', 'Student123');
    await tester.tap(find.byType(Checkbox));
    await tester.tap(find.widgetWithText(InkWell, 'Create Account'));
    await tester.pumpAndSettle();

    expect(api.adapter.requests.first.path, '/auth/register');
    expect(api.storage.token, 'fixture-token');
    // A new student has no preferences yet.
    expect(find.text('Step 1 of 3'), findsOneWidget);
    expect(find.byType(DslBottomNav), findsNothing);
  });

  testWidgets('sign up shows the server error (email in use)', (tester) async {
    await _launch(
      tester,
      (_) async =>
          fixtureResponse('auth_register_email_in_use.json', status: 409),
    );
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    await _type(tester, 'First name', 'Sara');
    await _type(tester, 'Last name', 'Lee');
    await _type(tester, 'Email address', 'sara@dsl.local');
    await _type(tester, 'Password', 'Student123');
    await _type(tester, 'Confirm password', 'Student123');
    await tester.tap(find.byType(Checkbox));
    await tester.tap(find.widgetWithText(InkWell, 'Create Account'));
    await tester.pumpAndSettle();

    expect(
      find.text('An account with that email already exists.'),
      findsOneWidget,
    );
  });

  testWidgets('sign in with a wrong password shows the server message', (
    tester,
  ) async {
    final api = await _launch(
      tester,
      (_) async => fixtureResponse('auth_login_invalid.json', status: 401),
    );
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    await _type(tester, 'Email address', 'sara@dsl.local');
    await _type(tester, 'Password', 'wrongpass1');
    await tester.tap(find.widgetWithText(InkWell, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid credentials.'), findsOneWidget);
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(api.storage.token, isNull);
  });

  testWidgets('a tampered token goes to Sign In with an explanation', (
    tester,
  ) async {
    final api = await _launch(
      tester,
      (_) async => _unauthorized(),
      token: 'tampered',
    );

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Your session has ended. Sign in again.'), findsOneWidget);
    expect(api.storage.token, isNull);
  });

  testWidgets('API down on launch: retry screen, still signed in, recovers', (
    tester,
  ) async {
    final api = await _launch(
      tester,
      (o) async => networkDown(o),
      token: 'stored',
    );

    expect(find.text("Can't open DSL right now"), findsOneWidget);
    expect(find.textContaining("Can't reach the server"), findsOneWidget);
    expect(api.storage.token, 'stored');

    api.handler = (_) async => fixtureResponse('auth_me.json');
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Hello, Sara'), findsOneWidget);
  });

  testWidgets('a teacher sees "students only" and can log out', (tester) async {
    final teacher = fixture('auth_me.json')! as Map<String, dynamic>;
    (teacher['data']! as Map<String, dynamic>)['role'] = 'teacher';
    final api = await _launch(
      tester,
      (_) async => FakeAdapter.json(teacher),
      token: 'stored',
    );

    expect(find.text('This app is for students'), findsOneWidget);
    expect(find.byType(DslBottomNav), findsNothing);

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('DOMAIN SPECIFIC LANGUAGE'), findsOneWidget);
    expect(api.storage.token, isNull);
  });

  testWidgets('Profile shows the student and logs out', (tester) async {
    final api = await _launch(
      tester,
      (_) async => fixtureResponse('auth_me.json'),
      token: 'stored',
    );
    await tester.tap(
      find.descendant(
        of: find.byType(DslBottomNav),
        matching: find.bySemanticsLabel('Profile'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sara Lee'), findsOneWidget);
    await tester.ensureVisible(find.text('Log Out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();

    expect(find.text('DOMAIN SPECIFIC LANGUAGE'), findsOneWidget);
    expect(api.storage.token, isNull);
  });
}
