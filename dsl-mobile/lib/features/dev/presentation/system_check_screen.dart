import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_badge.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/dsl_card.dart';
import '../../../core/widgets/state_views.dart';
import '../data/health_repository.dart';

/// Debug-only: shows which API the build points at and whether `/health`
/// answers through the real [ApiClient] (slice 0 gate).
class SystemCheckScreen extends ConsumerWidget {
  const SystemCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final health = ref.watch(healthStatusProvider);
    final colors = context.colors;
    final type = context.type;

    return Scaffold(
      appBar: AppBar(title: const Text('System check')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenMargin),
            child: DslCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('API', style: type.label.copyWith(color: colors.muted)),
                  const SizedBox(height: AppSpacing.xs),
                  SelectableText(
                    config.apiBaseUrl,
                    style: type.body.copyWith(color: colors.white),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'ENVIRONMENT',
                    style: type.label.copyWith(color: colors.muted),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    config.environment,
                    style: type.body.copyWith(color: colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: health.when(
              loading: () => const LoadingView(message: 'Calling /health…'),
              error: (error, _) => ErrorView(
                error: error,
                title: "The API didn't answer",
                onRetry: () => ref.invalidate(healthStatusProvider),
              ),
              data: (status) => Padding(
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: colors.success,
                      size: 56,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'API is reachable',
                      style: type.h2.copyWith(color: colors.white),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DslBadge(
                      label: 'status: $status',
                      tone: DslBadgeTone.success,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    DslButton(
                      label: 'Check again',
                      variant: DslButtonVariant.ghost,
                      onPressed: () => ref.invalidate(healthStatusProvider),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
