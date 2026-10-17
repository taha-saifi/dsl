import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import '../data/play_models.dart';
import '../data/session_models.dart';

/// The server's verdict under the question (Figma Correct `87:218`, Wrong
/// `87:262`). Correct and almost → Continue; wrong → Try Again or Skip &
/// Continue. Only the first attempt counts toward the score.
class FeedbackPanel extends StatelessWidget {
  const FeedbackPanel({
    required this.question,
    required this.result,
    required this.isLast,
    required this.busy,
    required this.onContinue,
    required this.onTryAgain,
    super.key,
  });

  final PlayQuestion question;
  final AnswerResult result;
  final bool isLast;
  final bool busy;
  final VoidCallback onContinue;
  final VoidCallback onTryAgain;

  /// How to state the right answer for this type.
  String _correctAnswer() => switch (question) {
    ChoosePictureQuestion() => 'The right picture is marked in green.',
    MatchingQuestion() => 'The pairs are:\n${result.pairLines.join('\n')}',
    _ => 'The correct answer is “${result.correctText ?? ''}”.',
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final (
      Color tone,
      IconData icon,
      String title,
      String? body,
    ) = switch (result.verdict) {
      Verdict.correct => (
        colors.success,
        Icons.check_rounded,
        'Correct!',
        null,
      ),
      Verdict.almost => (
        colors.amber,
        Icons.spellcheck_rounded,
        'Almost!',
        'Watch the accents: “${result.correctText ?? ''}”. '
            'This still counts as right.',
      ),
      Verdict.wrong => (
        colors.error,
        Icons.close_rounded,
        'Incorrect',
        _correctAnswer(),
      ),
    };
    final continueLabel = isLast ? 'See results' : 'Continue';

    return Semantics(
      liveRegion: true,
      child: Container(
        decoration: BoxDecoration(
          color: tone.withValues(alpha: 0.12),
          border: Border(top: BorderSide(color: tone, width: 2)),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: tone.withValues(alpha: 0.25),
                  child: Icon(icon, color: tone),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: type.h2.copyWith(color: tone)),
                      if (body != null)
                        Text(
                          body,
                          style: type.body.copyWith(color: colors.ink),
                        ),
                      if (!result.firstAttempt && result.isCorrect)
                        Text(
                          'Only first tries count toward your score.',
                          style: type.caption.copyWith(color: colors.muted),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (result.isCorrect)
              DslButton(
                label: continueLabel,
                loading: busy,
                onPressed: onContinue,
              )
            else ...[
              DslButton(
                label: 'Try Again',
                variant: DslButtonVariant.secondary,
                onPressed: busy ? null : onTryAgain,
                onLight: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: busy ? null : onContinue,
                child: Text(
                  isLast ? 'Skip & see results' : 'Skip & Continue',
                  style: type.body.copyWith(color: colors.muted),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
