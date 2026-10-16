import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/api/api_providers.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final config = AppConfig.fromEnvironment();

  runApp(
    ProviderScope(
      retry: noAutomaticRetry,
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const DslApp(),
    ),
  );
}
