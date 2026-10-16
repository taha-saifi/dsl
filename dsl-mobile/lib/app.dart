import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class DslApp extends ConsumerWidget {
  const DslApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'DSL',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dsl(),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
