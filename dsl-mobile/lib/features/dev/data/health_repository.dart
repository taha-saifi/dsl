import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';

/// `GET /health` → `{data: {status: "ok"}}`. Used by the debug System check screen to
/// prove the app reaches the API through the real client.
class HealthRepository {
  const HealthRepository(this._client);

  final ApiClient _client;

  Future<String> status() => _client.get(
    '/health',
    decode: (json) {
      if (json is Map<String, Object?> && json['status'] is String) {
        return json['status']! as String;
      }
      throw const ApiException(
        failure: ApiFailure.badResponse,
        message: 'Unexpected /health response.',
      );
    },
  );
}

final healthRepositoryProvider = Provider<HealthRepository>(
  (ref) => HealthRepository(ref.watch(apiClientProvider)),
);

final healthStatusProvider = FutureProvider.autoDispose<String>(
  (ref) => ref.watch(healthRepositoryProvider).status(),
);
