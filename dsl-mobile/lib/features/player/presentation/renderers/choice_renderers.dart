import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../learn/data/language_names.dart';
import '../../data/play_models.dart';
import '../../data/player_answer.dart';
import '../../data/session_models.dart';
import '../lesson_widgets.dart';

/// multiple_choice (Figma `6:54`): the prompt, then lettered options.
class MultipleChoiceRenderer extends StatelessWidget {
  const MultipleChoiceRenderer({
    required this.question,
    required this.answer,
    required this.onAnswer,
    super.key,
    this.feedback,
  });

  final MultipleChoiceQuestion question;
  final PlayerAnswer? answer;
  final ValueChanged<PlayerAnswer> onAnswer;

  /// The verdict, once checked; input is locked while it is shown.
  final AnswerResult? feedback;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
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
                style: type.h2.copyWith(color: colors.ink),
              ),
              Text(
                'Pick the ${LanguageName.of(question.answerLanguage).english} '
                'translation',
                style: type.caption.copyWith(color: colors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ChoiceList(
          options: question.options,
          answer: answer,
          onAnswer: onAnswer,
          feedback: feedback,
        ),
      ],
    );
  }
}

/// listening_select: audio, then the options.
class ListeningSelectRenderer extends StatelessWidget {
  const ListeningSelectRenderer({
    required this.question,
    required this.answer,
    required this.onAnswer,
    super.key,
    this.feedback,
  });

  final ListeningSelectQuestion question;
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
        'What did you hear? (${LanguageName.of(question.answerLanguage).english})',
      ),
      ChoiceList(
        options: question.options,
        answer: answer,
        onAnswer: onAnswer,
        feedback: feedback,
      ),
    ],
  );
}

/// Lettered, radio-style option rows shared by the text-choice types.
class ChoiceList extends StatelessWidget {
  const ChoiceList({
    required this.options,
    required this.answer,
    required this.onAnswer,
    super.key,
    this.feedback,
  });

  final List<PlayChoice> options;
  final PlayerAnswer? answer;
  final ValueChanged<PlayerAnswer> onAnswer;

  /// The verdict, once checked; input is locked while it is shown.
  final AnswerResult? feedback;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final selectedId = answer is ChoiceAnswer
        ? (answer! as ChoiceAnswer).optionId
        : null;
    return Column(
      children: [
        for (final (i, option) in options.indexed) ...[
          SelectableLessonCard(
            selected: option.id == selectedId,
            onTap: feedback == null
                ? () => onAnswer(ChoiceAnswer(option.id))
                : null,
            semanticsLabel: option.text,
            borderColor: revealColors(
              context,
              feedback: feedback,
              choiceId: option.id,
              picked: option.id == selectedId,
            )?.border,
            fillColor: revealColors(
              context,
              feedback: feedback,
              choiceId: option.id,
              picked: option.id == selectedId,
            )?.fill,
            child: Row(
              children: [
                _Letter(
                  letter: String.fromCharCode(65 + i),
                  selected: option.id == selectedId,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    option.text ?? '',
                    style: type.bodyLarge.copyWith(
                      color: colors.ink,
                      fontWeight: option.id == selectedId
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
                RadioDot(selected: option.id == selectedId),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _Letter extends StatelessWidget {
  const _Letter({required this.letter, required this.selected});

  final String letter;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected
            ? colors.lessonSelectedBorder.withValues(alpha: 0.3)
            : null,
        border: Border.all(
          color: selected ? colors.lessonSelectedBorder : colors.softGray,
          width: 2,
        ),
      ),
      child: Text(
        letter,
        style: context.type.button.copyWith(
          fontSize: 14,
          color: selected ? colors.cyan : colors.muted,
        ),
      ),
    );
  }
}

class RadioDot extends StatelessWidget {
  const RadioDot({required this.selected, super.key});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.white,
        border: Border.all(
          color: selected ? colors.cyan : colors.muted.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: selected
          ? DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.cyan,
              ),
            )
          : null,
    );
  }
}

/// choose_picture (Figma `5:62`): the word, then a 2×2 grid of images. Tiles
/// carry no labels: a label would give the answer away.
class ChoosePictureRenderer extends StatelessWidget {
  const ChoosePictureRenderer({
    required this.question,
    required this.answer,
    required this.onAnswer,
    super.key,
    this.feedback,
  });

  final ChoosePictureQuestion question;
  final PlayerAnswer? answer;
  final ValueChanged<PlayerAnswer> onAnswer;

  /// The verdict, once checked; input is locked while it is shown.
  final AnswerResult? feedback;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedId = answer is ChoiceAnswer
        ? (answer! as ChoiceAnswer).optionId
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question.prompt,
          textAlign: TextAlign.center,
          style: context.type.h2.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.lg),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          children: [
            for (final (i, option) in question.options.indexed)
              SelectableLessonCard(
                selected: option.id == selectedId,
                onTap: feedback == null
                    ? () => onAnswer(ChoiceAnswer(option.id))
                    : null,
                semanticsLabel: [
                  'Picture ${i + 1}',
                  if (feedback != null &&
                      option.id == feedback!.correctOptionId)
                    'correct answer',
                ].join(', '),
                borderColor: revealColors(
                  context,
                  feedback: feedback,
                  choiceId: option.id,
                  picked: option.id == selectedId,
                )?.border,
                fillColor: revealColors(
                  context,
                  feedback: feedback,
                  choiceId: option.id,
                  picked: option.id == selectedId,
                )?.fill,
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadii.input),
                        child: LessonImage(url: option.imageUrl ?? ''),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: RadioDot(selected: option.id == selectedId),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
