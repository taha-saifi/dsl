import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../learn/data/language_names.dart';
import '../../data/play_models.dart';
import '../../data/player_answer.dart';
import '../../data/session_models.dart';
import '../lesson_widgets.dart';

String _typed(PlayerAnswer? answer) => answer is TextAnswer ? answer.text : '';

/// typing (no Figma frame): the prompt word, then a text field.
class TypingRenderer extends StatelessWidget {
  const TypingRenderer({
    required this.question,
    required this.answer,
    required this.onAnswer,
    super.key,
    this.feedback,
  });

  final TypingQuestion question;
  final PlayerAnswer? answer;
  final ValueChanged<PlayerAnswer> onAnswer;

  /// The verdict, once checked; input is locked while it is shown.
  final AnswerResult? feedback;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final from = LanguageName.of(question.promptLanguage).english;
    final to = LanguageName.of(question.answerLanguage).english;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LessonCard(
          child: Column(
            children: [
              if (question.imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadii.input),
                  child: SizedBox(
                    height: 120,
                    width: 160,
                    child: LessonImage(url: question.imageUrl!),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              Text(
                question.prompt,
                textAlign: TextAlign.center,
                style: context.type.h2.copyWith(color: colors.ink),
              ),
              Text(
                '$from → $to',
                style: context.type.caption.copyWith(color: colors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        LessonLabel('Type it in $to:'),
        AnswerField(
          questionId: question.id,
          hint: 'Your answer',
          initial: _typed(answer),
          onChanged: (text) => onAnswer(TextAnswer(text)),
          feedback: feedback,
        ),
      ],
    );
  }
}

/// listening_transcribe (Figma `5:121`): audio, then a text field.
class ListeningTranscribeRenderer extends StatelessWidget {
  const ListeningTranscribeRenderer({
    required this.question,
    required this.answer,
    required this.onAnswer,
    super.key,
    this.feedback,
  });

  final ListeningTranscribeQuestion question;
  final PlayerAnswer? answer;
  final ValueChanged<PlayerAnswer> onAnswer;

  /// The verdict, once checked; input is locked while it is shown.
  final AnswerResult? feedback;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AudioPromptCard(url: question.audioUrl),
      const SizedBox(height: AppSpacing.lg),
      LessonLabel(
        'Type what you heard '
        '(${LanguageName.of(question.answerLanguage).english}):',
      ),
      AnswerField(
        questionId: question.id,
        hint: 'What you heard',
        initial: _typed(answer),
        onChanged: (text) => onAnswer(TextAnswer(text)),
        feedback: feedback,
      ),
    ],
  );
}

/// fill_blank (Figma `6:3`, with a text field instead of word options:
/// decision Q9). The sentence shows what's typed in the gap as you type.
class FillBlankRenderer extends StatelessWidget {
  const FillBlankRenderer({
    required this.question,
    required this.answer,
    required this.onAnswer,
    super.key,
    this.feedback,
  });

  final FillBlankQuestion question;
  final PlayerAnswer? answer;
  final ValueChanged<PlayerAnswer> onAnswer;

  /// The verdict, once checked; input is locked while it is shown.
  final AnswerResult? feedback;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final typed = _typed(answer).trim();
    final sentenceStyle = type.bodyLarge.copyWith(
      color: colors.ink,
      height: 1.8,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LessonCard(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: question.before),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 72),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.lessonSelected,
                      borderRadius: BorderRadius.circular(AppRadii.input),
                      border: Border.all(
                        color: colors.lessonSelectedBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      typed.isEmpty ? ' ' : typed,
                      textAlign: TextAlign.center,
                      style: type.bodyLarge.copyWith(
                        color: colors.cyan,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                TextSpan(text: question.after),
              ],
            ),
            style: sentenceStyle,
          ),
        ),
        if (question.hint != null) ...[
          const SizedBox(height: AppSpacing.md),
          HintCard(label: 'Meaning', text: question.hint!),
        ],
        const SizedBox(height: AppSpacing.lg),
        LessonLabel(
          'Missing word '
          '(${LanguageName.of(question.sentenceLanguage).english}):',
        ),
        AnswerField(
          questionId: question.id,
          hint: 'Type the missing word',
          initial: _typed(answer),
          onChanged: (text) => onAnswer(TextAnswer(text)),
          feedback: feedback,
        ),
      ],
    );
  }
}

/// Amber-edged hint (Figma "Translate:" / "Medical context" cards).
class HintCard extends StatelessWidget {
  const HintCard({required this.label, required this.text, super.key});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(AppRadii.input),
        border: Border.all(color: colors.amber.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.type.caption.copyWith(color: colors.amber),
          ),
          Text(text, style: context.type.body.copyWith(color: colors.ink)),
        ],
      ),
    );
  }
}
