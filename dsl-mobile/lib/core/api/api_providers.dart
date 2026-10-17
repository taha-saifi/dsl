import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'api_client.dart';

/// Riverpod 3 retries failing providers automatically. The app turns that
/// off: failures show an error state with "Try again", so the student decides
/// when to retry and errors aren't hidden behind silent back-off.
Duration? noAutomaticRetry(int retryCount, Object error) => null;

/// Bumped every time the API rejects our token with a 401. The auth
/// controller (slice 1) listens to it and routes to sign-in.
class SessionExpiredEvents extends Notifier<int> {
  @override
  int build() => 0;

  void signal() => state++;
}

final sessionExpiredEventsProvider =
    NotifierProvider<SessionExpiredEvents, int>(SessionExpiredEvents.new);

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = createDio(
    baseUrl: ref.watch(appConfigProvider).apiBaseUrl,
    tokenStorage: ref.watch(tokenStorageProvider),
    onUnauthorized: () =>
        ref.read(sessionExpiredEventsProvider.notifier).signal(),
    // Debug builds log each request's method and path (logcat "flutter").
    logRequest: kDebugMode ? debugPrint : null,
  );
  ref.onDispose(dio.close);
  return ApiClient(dio);
});
