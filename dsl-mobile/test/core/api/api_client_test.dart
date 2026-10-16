import 'package:dio/dio.dart';
import 'package:dsl/core/api/api_client.dart';
import 'package:dsl/core/api/api_exception.dart';
import 'package:dsl/core/api/error_messages.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_adapter.dart';

void main() {
  late MemoryTokenStorage storage;
  late int unauthorizedCalls;

  (ApiClient, FakeAdapter) build(
    Future<ResponseBody> Function(RequestOptions) handler,
  ) {
    final dio = createDio(
      baseUrl: 'http://api.test/api',
      tokenStorage: storage,
      onUnauthorized: () => unauthorizedCalls++,
    );
    final adapter = FakeAdapter(handler);
    dio.httpClientAdapter = adapter;
    return (ApiClient(dio), adapter);
  }

  Future<ApiException> failureOf(Future<Object?> call) async {
    try {
      await call;
    } on ApiException catch (error) {
      return error;
    }
    fail('expected an ApiException');
  }

  setUp(() {
    storage = MemoryTokenStorage();
    unauthorizedCalls = 0;
  });

  group('envelope', () {
    test('requests are made against the base URL', () async {
      final (client, adapter) = build(
        (_) async => FakeAdapter.json({
          'data': {'status': 'ok'},
        }),
      );

      await client.get('/health', decode: (json) => json);

      expect(
        adapter.requests.single.uri.toString(),
        'http://api.test/api/health',
      );
    });

    test('unwraps {data}', () async {
      final (client, _) = build(
        (_) async => FakeAdapter.json({
          'data': {'name': 'Medical French'},
        }),
      );

      final name = await client.get(
        '/courses/1',
        decode: (json) => (json! as Map<String, Object?>)['name']! as String,
      );

      expect(name, 'Medical French');
    });

    test('a 2xx body without data is a badResponse', () async {
      final (client, _) = build((_) async => FakeAdapter.json({'oops': true}));

      final error = await failureOf(client.get('/x', decode: (json) => json));

      expect(error.failure, ApiFailure.badResponse);
    });
  });

  group('errors', () {
    test('maps {error:{code,message}} with the status', () async {
      final (client, _) = build(
        (_) async => FakeAdapter.json({
          'error': {
            'code': 'VALIDATION_ERROR',
            'message': 'Email is required.',
          },
        }, status: 400),
      );

      final error = await failureOf(
        client.post('/auth/login', decode: (json) => json),
      );

      expect(error.failure, ApiFailure.http);
      expect(error.status, 400);
      expect(error.code, 'VALIDATION_ERROR');
      expect(error.message, 'Email is required.');
      expect(error.isRetryable, isFalse);
      expect(describeError(error), 'Email is required.');
    });

    test('a non-JSON error body still yields a message', () async {
      final (client, _) = build(
        (_) async => ResponseBody.fromString('<html>Bad gateway</html>', 502),
      );

      final error = await failureOf(client.get('/x', decode: (json) => json));

      expect(error.status, 502);
      expect(error.code, isNull);
      expect(error.isRetryable, isTrue);
    });

    test('connection failures are network errors and retryable', () async {
      final (client, _) = build(
        (options) => throw DioException.connectionError(
          requestOptions: options,
          reason: 'Connection refused',
        ),
      );

      final error = await failureOf(client.get('/x', decode: (json) => json));

      expect(error.failure, ApiFailure.network);
      expect(error.isRetryable, isTrue);
      expect(describeError(error), contains("Can't reach the server"));
    });

    test('timeouts are retryable', () async {
      final (client, _) = build(
        (options) => throw DioException.receiveTimeout(
          requestOptions: options,
          timeout: const Duration(seconds: 1),
        ),
      );

      final error = await failureOf(client.get('/x', decode: (json) => json));

      expect(error.failure, ApiFailure.timeout);
      expect(error.isRetryable, isTrue);
    });
  });

  group('session rule: only a genuine 401 ends the session', () {
    test('attaches the bearer token', () async {
      storage.token = 'abc';
      final (client, adapter) = build(
        (_) async => FakeAdapter.json({'data': null}),
      );

      await client.get('/auth/me', decode: (json) => json);

      expect(adapter.requests.single.headers['Authorization'], 'Bearer abc');
    });

    test(
      '401 on an authenticated request clears the token and signals',
      () async {
        storage.token = 'expired';
        final (client, _) = build(
          (_) async => FakeAdapter.json({
            'error': {'code': 'UNAUTHORIZED', 'message': 'Invalid token.'},
          }, status: 401),
        );

        final error = await failureOf(
          client.get('/auth/me', decode: (json) => json),
        );

        expect(error.isUnauthorized, isTrue);
        expect(storage.token, isNull);
        expect(unauthorizedCalls, 1);
      },
    );

    test(
      '401 without a token (wrong password on login) keeps everything',
      () async {
        final (client, _) = build(
          (_) async => FakeAdapter.json({
            'error': {
              'code': 'INVALID_CREDENTIALS',
              'message': 'Wrong email or password.',
            },
          }, status: 401),
        );

        final error = await failureOf(
          client.post('/auth/login', decode: (json) => json),
        );

        expect(error.code, 'INVALID_CREDENTIALS');
        expect(unauthorizedCalls, 0);
      },
    );

    for (final (label, Future<ResponseBody> Function(RequestOptions) handler)
        in [
          (
            'a 403',
            (_) async => FakeAdapter.json({
              'error': {'message': 'No.'},
            }, status: 403),
          ),
          (
            'a 500',
            (_) async => FakeAdapter.json({
              'error': {'message': 'Boom.'},
            }, status: 500),
          ),
          (
            'a network failure',
            (options) => throw DioException.connectionError(
              requestOptions: options,
              reason: 'x',
            ),
          ),
        ]) {
      test('$label keeps the token', () async {
        storage.token = 'valid';
        final (client, _) = build(handler);

        await failureOf(client.get('/x', decode: (json) => json));

        expect(storage.token, 'valid');
        expect(unauthorizedCalls, 0);
      });
    }
  });
}
