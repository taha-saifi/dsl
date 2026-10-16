import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/play_models.dart';
import '../../data/player_answer.dart';
import '../lesson_widgets.dart';
import 'text_renderers.dart';

/// arrange_sentence (Figma `5:237`): tap words in the bank to build the
/// sentence; tap a placed word to send it back. The bank includes
/// distractor words, so not every word belongs in the sentence.
class ArrangeSentenceRenderer extends StatelessWidget {
  const ArrangeSentenceRenderer({
    required this.question,
    required this.answer,
    required this.onAnswer,
    super.key,
  });

  final ArrangeSentenceQuestion question;
  final PlayerAnswer? answer;
  final ValueChanged<PlayerAnswer> onAnswer;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final placed = answer is OrderAnswer
        ? (answer! as OrderAnswer).blockIds
        : const <String>[];
    final byId = {for (final b in question.bank) b.id: b};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (question.hint != null) ...[
          HintCard(label: 'Translate:', text: question.hint!),
          const SizedBox(height: AppSpacing.lg),
        ],
        const LessonLabel('Your sentence:'),
        Container(
          constraints: const BoxConstraints(minHeight: 112),
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: colors.muted.withValues(alpha: 0.3)),
          ),
          child: placed.isEmpty
              ? Center(
                  child: Text(
                    'Tap words below to add them',
                    style: context.type.body.copyWith(color: colors.muted),
                  ),
                )
              : Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final (i, id) in placed.indexed)
                      _WordChip(
                        text: byId[id]?.text ?? '',
                        placed: true,
                        semanticsHint: 'Remove',
                        onTap: () =>
                            onAnswer(OrderAnswer([...placed]..removeAt(i))),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final block in question.bank)
              placed.contains(block.id)
                  ? _WordSlot(text: block.text ?? '')
                  : _WordChip(
                      text: block.text ?? '',
                      placed: false,
                      semanticsHint: 'Add',
                      onTap: () => onAnswer(OrderAnswer([...placed, block.id])),
                    ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          '${placed.length} of ${question.bank.length} words placed',
          textAlign: TextAlign.center,
          style: context.type.caption.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}

class _WordChip extends StatelessWidget {
  const _WordChip({
    required this.text,
    required this.placed,
    required this.onTap,
    required this.semanticsHint,
  });

  final String text;
  final bool placed;
  final VoidCallback onTap;
  final String semanticsHint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: '$semanticsHint $text',
      excludeSemantics: true,
      child: Material(
        color: placed ? colors.lessonSelected : colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          side: BorderSide(
            color: placed
                ? colors.lessonSelectedBorder
                : colors.muted.withValues(alpha: 0.3),
            width: placed ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Text(
              text,
              style: context.type.bodyLarge.copyWith(
                color: placed ? colors.cyan : colors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Where a placed word sat in the bank, kept so the bank doesn't reflow.
class _WordSlot extends StatelessWidget {
  const _WordSlot({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.muted.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.input),
      ),
      child: Text(
        text,
        style: context.type.bodyLarge.copyWith(color: Colors.transparent),
      ),
    ),
  );
}
