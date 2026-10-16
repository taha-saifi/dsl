import 'package:dsl/core/api/api_exception.dart';
import 'package:dsl/core/api/api_providers.dart';
import 'package:dsl/core/auth/app_user.dart';
import 'package:dsl/core/auth/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_adapter.dart';
import '../../helpers/test_api.dart';

void main() {
  group('restoring the session on launch', () {
    test('no stored token → signed out, no request', () async {
      final api = TestApi((_) async => fail('no request expected'));
      final state = await restored(api.container());

      expect(state, isA<SignedOut>());
      expect((state as SignedOut).sessionEnded, isFalse);
      expect(api.adapter.requests, isEmpty);
    });

    test('valid token → signed in with /auth/me', () async {
      final api = TestApi(
        (_) async => fixtureResponse('auth_me.json'),
        token: 'stored',
      );
      final state = await restored(api.container());

      expect(state, isA<SignedIn>());
      final user = (state as SignedIn).user;
      expect(user.role, UserRole.student);
      expect(user.displayName, 'Sara Lee');
      expect(api.adapter.requests.single.path, '/auth/me');
      expect(
        api.adapter.requests.single.headers['Authorization'],
        'Bearer stored',
      );
    });

    test('rejected token (401) → signed out, token cleared', () async {
      final api = TestApi(
        (_) async => FakeAdapter.json({
          'error': {'message': 'Unauthorized.', 'code': 'UNAUTHORIZED'},
        }, status: 401),
        token: 'tampered',
      );
      final state = await restored(api.container());

      expect(state, isA<SignedOut>());
      expect((state as SignedOut).sessionEnded, isTrue);
      expect(api.storage.token, isNull);
    });

    test('API unreachable → unverified, token kept; retry recovers', () async {
      final api = TestApi((o) async => networkDown(o), token: 'stored');
      final container = api.container();
      final state = await restored(container);

      expect(state, isA<SessionUnverified>());
      expect(
        ((state as SessionUnverified).error as ApiException).failure,
        ApiFailure.network,
      );
      expect(api.storage.token, 'stored');

      api.handler = (_) async => fixtureResponse('auth_me.json');
      await container.read(authControllerProvider.notifier).retry();
      expect(container.read(authControllerProvider), isA<SignedIn>());
    });

    test('server error (500) → unverified, token kept', () async {
      final api = TestApi(
        (_) async => FakeAdapter.json({
          'error': {'message': 'Internal server error.'},
        }, status: 500),
        token: 'stored',
      );
      expect(await restored(api.container()), isA<SessionUnverified>());
      expect(api.storage.token, 'stored');
    });
  });

  group('signing in and out', () {
    test('register stores the token and signs in', () async {
      final api = TestApi((_) async => fixtureResponse('auth_register.json'));
      final container = api.container();
      await restored(container);

      await container
          .read(authControllerProvider.notifier)
          .register(
            firstName: 'Sara',
            lastName: 'Lee',
            email: 'sara@dsl.local',
            password: 'Student123',
          );

      expect(api.storage.token, 'fixture-token');
      expect(container.read(authControllerProvider), isA<SignedIn>());
      final request = api.adapter.requests.single;
      expect(request.path, '/auth/register');
      expect(request.data, {
        'firstName': 'Sara',
        'lastName': 'Lee',
        'email': 'sara@dsl.local',
        'password': 'Student123',
        'acceptedTerms': true,
      });
    });

    test(
      'wrong password throws the server message, stays signed out',
      () async {
        final api = TestApi(
          (_) async => fixtureResponse('auth_login_invalid.json', status: 401),
        );
        final container = api.container();
        await restored(container);

        final call = container
            .read(authControllerProvider.notifier)
            .signIn(email: 'a@b.co', password: 'wrongpass1');
        await expectLater(
          call,
          throwsA(
            isA<ApiException>()
                .having((e) => e.code, 'code', 'INVALID_CREDENTIALS')
                .having((e) => e.message, 'message', 'Invalid credentials.'),
          ),
        );
        final state = container.read(authControllerProvider);
        expect(state, isA<SignedOut>());
        // No token was sent, so this 401 isn't a "session ended".
        expect((state as SignedOut).sessionEnded, isFalse);
      },
    );

    test('sign out clears the token', () async {
      final api = TestApi(
        (_) async => fixtureResponse('auth_me.json'),
        token: 'stored',
      );
      final container = api.container();
      await restored(container);

      await container.read(authControllerProvider.notifier).signOut();

      expect(container.read(authControllerProvider), isA<SignedOut>());
      expect(api.storage.token, isNull);
    });

    test('a 401 on any later call ends the session', () async {
      final api = TestApi(
        (_) async => fixtureResponse('auth_me.json'),
        token: 'stored',
      );
      final container = api.container();
      expect(await restored(container), isA<SignedIn>());

      api.handler = (_) async => FakeAdapter.json({
        'error': {'message': 'Unauthorized.', 'code': 'UNAUTHORIZED'},
      }, status: 401);
      await expectLater(
        container.read(apiClientProvider).get('/courses', decode: (j) => j),
        throwsA(isA<ApiException>()),
      );

      final state = container.read(authControllerProvider);
      expect(state, isA<SignedOut>());
      expect((state as SignedOut).sessionEnded, isTrue);
      expect(api.storage.token, isNull);
    });
  });
}
