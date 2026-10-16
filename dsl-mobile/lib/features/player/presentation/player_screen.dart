import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dsl_button.dart';
import '../../../core/widgets/dsl_progress_bar.dart';
import '../../../core/widgets/state_views.dart';
import '../../learn/data/question_type.dart';
import '../data/play_models.dart';
import '../data/player_answer.dart';
import '../data/player_controller.dart';
import 'lesson_widgets.dart';
import 'renderers/arrange_renderer.dart';
import 'renderers/choice_renderers.dart';
import 'renderers/matching_renderer.dart';
import 'renderers/text_renderers.dart';

/// Plays an exercise's questions in order (feat-exercise-player). Full screen,
/// outside the tab shell. Close or Back opens Pause. Checking answers and
/// the results screen arrive in slice 7; here "Next" moves on.
class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({required this.exerciseId, super.key});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payload = ref.watch(playPayloadProvider(exerciseId));
    // Dark status-bar icons on the light lesson surface.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: LessonTheme(
        child: Scaffold(
          body: SafeArea(
            child: payload.when(
              loading: () => const _OnInk(
                child: LoadingView(message: 'Loading exercise…'),
              ),
              error: (error, _) => _OnInk(
                child: Column(
                  children: [
                    Expanded(
                      child: ErrorView(
                        error: error,
                        title: "Couldn't open this exercise",
                        onRetry: () =>
                            ref.invalidate(playPayloadProvider(exerciseId)),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Back'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
              data: (data) => data.questions.isEmpty
                  ? _OnInk(
                      child: EmptyView(
                        title: 'Nothing to play yet',
                        message: 'This exercise has no questions right now.',
                        actionLabel: 'Back',
                        onAction: () => context.pop(),
                      ),
                    )
                  : _Player(exerciseId: exerciseId, payload: data),
            ),
          ),
        ),
      ),
    );
  }
}

/// The app's state views are designed for the Ink background.
class _OnInk extends StatelessWidget {
  const _OnInk({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: context.colors.ink, child: child);
}

class _Player extends ConsumerWidget {
  const _Player({required this.exerciseId, required this.payload});

  final String exerciseId;
  final PlayPayload payload;

  Future<void> _pause(BuildContext context) async {
    final quit = await showDialog<bool>(
      context: context,
      builder: (context) => const _PauseDialog(),
    );
    if ((quit ?? false) && context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = playerControllerProvider(exerciseId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final total = payload.questions.length;

    if (state.finished) {
      return _Finished(exercise: payload.exercise, total: total);
    }

    final question = payload.questions[state.index];
    final answer = state.answers[question.id];
    final complete = answer?.isComplete(question) ?? false;
    final last = state.index == total - 1;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _pause(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopBar(
            index: state.index,
            total: total,
            onClose: () => _pause(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: ValueKey('scroll-${question.id}'),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                AppSpacing.md,
                AppSpacing.screenMargin,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _TypeBadge(question: question),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    question.displayText,
                    textAlign: TextAlign.center,
                    style: context.type.h3.copyWith(color: context.colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  KeyedSubtree(
                    key: ValueKey(question.id),
                    child: _renderer(
                      question,
                      answer,
                      (a) => controller.answer(question.id, a),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: DslButton(
              onLight: true,
              label: complete
                  ? (last ? 'Finish' : 'Next')
                  : 'Answer to continue',
              onPressed: complete ? () => controller.next(total) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderer(
    PlayQuestion question,
    PlayerAnswer? answer,
    ValueChanged<PlayerAnswer> onAnswer,
  ) => switch (question) {
    ChoosePictureQuestion() => ChoosePictureRenderer(
      question: question,
      answer: answer,
      onAnswer: onAnswer,
    ),
    MultipleChoiceQuestion() => MultipleChoiceRenderer(
      question: question,
      answer: answer,
      onAnswer: onAnswer,
    ),
    ListeningSelectQuestion() => ListeningSelectRenderer(
      question: question,
      answer: answer,
      onAnswer: onAnswer,
    ),
    TypingQuestion() => TypingRenderer(
      question: question,
      answer: answer,
      onAnswer: onAnswer,
    ),
    ListeningTranscribeQuestion() => ListeningTranscribeRenderer(
      question: question,
      answer: answer,
      onAnswer: onAnswer,
    ),
    FillBlankQuestion() => FillBlankRenderer(
      question: question,
      answer: answer,
      onAnswer: onAnswer,
    ),
    ArrangeSentenceQuestion() => ArrangeSentenceRenderer(
      question: question,
      answer: answer,
      onAnswer: onAnswer,
    ),
    MatchingQuestion() => MatchingRenderer(
      question: question,
      answer: answer,
      onAnswer: onAnswer,
    ),
    UnknownQuestion() => const _UnsupportedQuestion(),
  };
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.index,
    required this.total,
    required this.onClose,
  });

  final int index;
  final int total;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Pause',
            icon: Icon(Icons.close_rounded, color: colors.ink),
            onPressed: onClose,
          ),
          Expanded(
            child: DslProgressBar(
              value: (index + 1) / total,
              trackColor: colors.muted.withValues(alpha: 0.25),
              semanticsLabel: 'Question ${index + 1} of $total',
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '${index + 1}/$total',
            style: context.type.caption.copyWith(
              color: colors.cyan,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// "MULTIPLE CHOICE" pill, coloured per type as in the Figma frames.
class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.question});

  final PlayQuestion question;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (QuestionType type, Color tone) = switch (question) {
      ChoosePictureQuestion() => (QuestionType.choosePicture, colors.amber),
      MultipleChoiceQuestion() => (QuestionType.multipleChoice, colors.violet),
      ListeningSelectQuestion() => (
        QuestionType.listeningSelect,
        colors.violet,
      ),
      TypingQuestion() => (QuestionType.typing, colors.cyan),
      ListeningTranscribeQuestion() => (
        QuestionType.listeningTranscribe,
        colors.violet,
      ),
      FillBlankQuestion() => (QuestionType.fillBlank, colors.success),
      ArrangeSentenceQuestion() => (QuestionType.arrangeSentence, colors.amber),
      MatchingQuestion() => (QuestionType.matching, colors.cyan),
      UnknownQuestion() => (QuestionType.unknown, colors.muted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        type.label.toUpperCase(),
        style: context.type.label.copyWith(color: tone),
      ),
    );
  }
}

class _UnsupportedQuestion extends StatelessWidget {
  const _UnsupportedQuestion();

  @override
  Widget build(BuildContext context) => LessonCard(
    child: Text(
      'This question type needs a newer version of the app. Update DSL to '
      'answer it.',
      style: context.type.body.copyWith(color: context.colors.ink),
    ),
  );
}

class _PauseDialog extends StatelessWidget {
  const _PauseDialog();

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Paused'),
    content: const Text("If you quit now, this exercise won't be saved."),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('Quit'),
      ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Keep going'),
      ),
    ],
  );
}

/// End of the questions. The score screen (Exercise Complete) is slice 7.
class _Finished extends StatelessWidget {
  const _Finished({required this.exercise, required this.total});

  final PlayExercise exercise;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag_rounded, size: 64, color: colors.cyan),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'End of ${exercise.name}',
            textAlign: TextAlign.center,
            style: type.h2.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'You answered all $total questions.',
            textAlign: TextAlign.center,
            style: type.body.copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.xxl),
          DslButton(label: 'Back to the unit', onPressed: () => context.pop()),
        ],
      ),
    );
  }
}
