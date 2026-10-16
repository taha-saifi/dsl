import 'package:flutter/material.dart';

import '../api/error_messages.dart';
import '../theme/app_theme.dart';
import 'dsl_button.dart';

/// "DS · Loading State" (`52:473`): centred spinner with an optional line.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox.square(
            dimension: 36,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: context.type.body.copyWith(color: context.colors.muted),
            ),
          ],
        ],
      ),
    );
  }
}

/// "DS · Empty State" (`52:460`): an invitation to act, not a dead end.
class EmptyView extends StatelessWidget {
  const EmptyView({
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _StateLayout(
      emblem: Image.asset(
        'assets/branding/logo.png',
        width: 72,
        height: 72,
        excludeFromSemantics: true,
      ),
      emblemColor: context.colors.cyan,
      title: title,
      message: message,
      actions: [
        if (actionLabel != null && onAction != null)
          DslButton(label: actionLabel!, onPressed: onAction),
      ],
    );
  }
}

/// "DS · Error State" (`52:495`): says what failed and how to fix it.
/// [error] is usually an `ApiException`; its message is chosen by
/// [describeError].
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.error,
    super.key,
    this.title = 'Something went wrong',
    this.onRetry,
  });

  final Object error;
  final String title;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _StateLayout(
      emblem: Icon(Icons.priority_high_rounded, size: 44, color: colors.error),
      emblemColor: colors.error,
      title: title,
      message: describeError(error),
      actions: [
        if (onRetry != null) DslButton(label: 'Try again', onPressed: onRetry),
      ],
    );
  }
}

class _StateLayout extends StatelessWidget {
  const _StateLayout({
    required this.emblem,
    required this.emblemColor,
    required this.title,
    required this.message,
    required this.actions,
  });

  final Widget emblem;
  final Color emblemColor;
  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: emblemColor.withValues(alpha: 0.12),
                ),
                alignment: Alignment.center,
                child: emblem,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                title,
                textAlign: TextAlign.center,
                style: type.h2.copyWith(color: colors.white),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: type.body.copyWith(color: colors.muted),
              ),
              for (final action in actions) ...[
                const SizedBox(height: AppSpacing.xxl),
                action,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
