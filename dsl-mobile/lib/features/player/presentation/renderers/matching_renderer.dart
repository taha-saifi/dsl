import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../learn/data/language_names.dart';
import '../../data/play_models.dart';
import '../../data/player_answer.dart';
import '../../data/session_models.dart';
import '../lesson_widgets.dart';

/// matching (Figma `5:3`): tap a left card, then a right card to pair them;
/// tap a paired card to undo. Pairs share a colour and number; only after
/// checking does each pair turn green (right) or red (wrong).
class MatchingRenderer extends StatefulWidget {
  const MatchingRenderer({
    required this.question,
    required this.answer,
    required this.onAnswer,
    super.key,
    this.feedback,
  });

  final MatchingQuestion question;
  final PlayerAnswer? answer;
  final ValueChanged<PlayerAnswer> onAnswer;

  /// The verdict, once checked; input is locked while it is shown.
  final AnswerResult? feedback;

  @override
  State<MatchingRenderer> createState() => _MatchingRendererState();
}

class _MatchingRendererState extends State<MatchingRenderer> {
  String? _pendingLeft;

  Map<String, String> get _pairs => widget.answer is PairsAnswer
      ? (widget.answer! as PairsAnswer).pairs
      : const {};

  void _tapLeft(String id) {
    if (widget.feedback != null) return;
    if (_pairs.containsKey(id)) {
      widget.onAnswer(PairsAnswer({..._pairs}..remove(id)));
      return;
    }
    setState(() => _pendingLeft = _pendingLeft == id ? null : id);
  }

  void _tapRight(String id) {
    if (widget.feedback != null) return;
    final pairedLeft = _pairs.entries
        .where((e) => e.value == id)
        .map((e) => e.key)
        .firstOrNull;
    if (pairedLeft != null) {
      widget.onAnswer(PairsAnswer({..._pairs}..remove(pairedLeft)));
      return;
    }
    if (_pendingLeft == null) return;
    widget.onAnswer(PairsAnswer({..._pairs, _pendingLeft!: id}));
    setState(() => _pendingLeft = null);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final q = widget.question;
    final pairs = _pairs;
    // Pair number follows the left column's order.
    final pairNumber = <String, int>{};
    var n = 0;
    for (final left in q.left) {
      final right = pairs[left.id];
      if (right != null) {
        n++;
        pairNumber[left.id] = n;
        pairNumber[right] = n;
      }
    }
    // No green or red: those will mean right and wrong once answers are
    // checked.
    final tones = [
      colors.cyan,
      colors.violet,
      colors.amber,
      colors.ink,
      colors.muted,
    ];
    // After checking: each pair the student made is green if right, red if
    // wrong.
    final rightPairs =
        widget.feedback?.correctPairs ?? const <String, String>{};
    final leftOfRight = {for (final e in pairs.entries) e.value: e.key};
    Color? verdictOf(String id) {
      if (widget.feedback == null) return null;
      final left = pairs.containsKey(id) ? id : leftOfRight[id];
      if (left == null) return null;
      return rightPairs[left] == pairs[left] ? colors.success : colors.error;
    }

    Color? toneOf(String id) =>
        verdictOf(id) ??
        (pairNumber[id] == null
            ? null
            : tones[(pairNumber[id]! - 1) % tones.length]);

    Widget card(PlayChoice choice, {required bool left}) {
      final tone = toneOf(choice.id);
      final pending = left && _pendingLeft == choice.id;
      return SelectableLessonCard(
        selected: pending,
        onTap: () => left ? _tapLeft(choice.id) : _tapRight(choice.id),
        semanticsLabel: [
          choice.text ?? '',
          if (pairNumber[choice.id] != null) 'pair ${pairNumber[choice.id]}',
        ].join(', '),
        borderColor: tone,
        fillColor: tone?.withValues(alpha: 0.12),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        child: Row(
          children: [
            if (pairNumber[choice.id] != null) ...[
              CircleAvatar(
                radius: 10,
                backgroundColor: tone,
                child: Text(
                  '${pairNumber[choice.id]}',
                  style: type.label.copyWith(color: colors.white),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                choice.text ?? '',
                textAlign: TextAlign.center,
                style: type.body.copyWith(
                  color: colors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                LanguageName.of(q.sourceLanguage).english.toUpperCase(),
                style: type.label.copyWith(color: colors.muted),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                LanguageName.of(q.targetLanguage).english.toUpperCase(),
                style: type.label.copyWith(color: colors.muted),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (var i = 0; i < q.left.length; i++) ...[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: card(q.left[i], left: true)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: i < q.right.length
                      ? card(q.right[i], left: false)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        LessonCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            'Paired: ${pairs.length} of ${q.left.length}',
            style: type.body.copyWith(color: colors.ink),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _pendingLeft == null
              ? 'Tap a word, then tap its translation'
              : 'Now tap its translation',
          textAlign: TextAlign.center,
          style: type.caption.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
