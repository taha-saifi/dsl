import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dsl/core/api/api_client.dart';
import 'package:dsl/core/api/api_providers.dart';
import 'package:dsl/core/auth/auth_controller.dart';
import 'package:dsl/core/config/app_config.dart';
import 'package:dsl/core/storage/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'fake_adapter.dart';

const testConfig = AppConfig(
  apiBaseUrl: 'http://api.test/api',
  environment: 'dev',
);

/// JSON recorded from the real local API (`test/fixtures/`).
Object? fixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync());

ResponseBody fixtureResponse(String name, {int status = 200}) =>
    FakeAdapter.json(fixture(name), status: status);

Never networkDown(RequestOptions options) => throw DioException(
  requestOptions: options,
  type: DioExceptionType.connectionError,
);

/// The real [ApiClient] and interceptor over a [FakeAdapter], with an
/// in-memory token store: everything above the socket is the app's code.
class TestApi {
  TestApi(this.handler, {String? token}) : storage = MemoryTokenStorage(token);

  Future<ResponseBody> Function(RequestOptions options) handler;
  final MemoryTokenStorage storage;
  late final FakeAdapter adapter = FakeAdapter((o) => handler(o));

  List<Override> get overrides => [
    appConfigProvider.overrideWithValue(testConfig),
    tokenStorageProvider.overrideWithValue(storage),
    apiClientProvider.overrideWith((ref) {
      final dio = createDio(
        baseUrl: testConfig.apiBaseUrl,
        tokenStorage: storage,
        onUnauthorized: () =>
            ref.read(sessionExpiredEventsProvider.notifier).signal(),
      );
      dio.httpClientAdapter = adapter;
      return ApiClient(dio);
    }),
  ];

  ProviderContainer container() =>
      ProviderContainer(retry: noAutomaticRetry, overrides: overrides);
}

/// Waits for the controller to finish restoring the stored session.
Future<AuthState> restored(ProviderContainer container) async {
  container.read(authControllerProvider);
  for (var i = 0; i < 100; i++) {
    final state = container.read(authControllerProvider);
    if (state is! AuthRestoring) return state;
    await Future<void>.delayed(Duration.zero);
  }
  throw StateError('session restore never finished');
}
