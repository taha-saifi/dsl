import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Build-time configuration, read from `--dart-define-from-file=env/<target>.json`.
class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.environment});

  /// Base URL including `/api`, e.g. `http://10.0.2.2:5000/api` on the emulator.
  final String apiBaseUrl;

  /// `dev` or `prod`.
  final String environment;

  bool get isDev => environment != 'prod';

  /// Throws a [StateError] naming the missing define, so a misconfigured
  /// build fails at startup instead of on the first request.
  static AppConfig fromEnvironment() {
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    const environment = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
    if (apiBaseUrl.isEmpty) {
      throw StateError(
        'API_BASE_URL is not set. Run with '
        '--dart-define-from-file=env/emulator.json (see dsl-mobile/CLAUDE.md).',
      );
    }
    return const AppConfig(apiBaseUrl: apiBaseUrl, environment: environment);
  }
}

/// Overridden in `main()` with [AppConfig.fromEnvironment].
final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('appConfigProvider must be overridden'),
);
