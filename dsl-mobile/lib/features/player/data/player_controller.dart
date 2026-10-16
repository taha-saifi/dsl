import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_providers.dart';
import 'play_models.dart';
import 'player_answer.dart';

/// `GET /learn/exercises/:id/play`.
final playPayloadProvider = FutureProvider.autoDispose
    .family<PlayPayload, String>(
      (ref, exerciseId) => ref
          .watch(apiClientProvider)
          .get(
            '/learn/exercises/$exerciseId/play',
            decode: (data) =>
                PlayPayload.fromJson(data! as Map<String, dynamic>),
          ),
    );

/// Where the student is in an exercise and what they've entered. Checking
/// answers (and the feedback sheet) arrives in slice 7; for now "Next"
/// just moves on.
class PlayerState {
  const PlayerState({
    this.index = 0,
    this.answers = const {},
    this.finished = false,
  });

  final int index;

  /// By question id.
  final Map<String, PlayerAnswer> answers;
  final bool finished;

  PlayerState copyWith({
    int? index,
    Map<String, PlayerAnswer>? answers,
    bool? finished,
  }) => PlayerState(
    index: index ?? this.index,
    answers: answers ?? this.answers,
    finished: finished ?? this.finished,
  );
}

class PlayerController extends Notifier<PlayerState> {
  PlayerController(this.exerciseId);

  final String exerciseId;

  @override
  PlayerState build() => const PlayerState();

  void answer(String questionId, PlayerAnswer answer) =>
      state = state.copyWith(answers: {...state.answers, questionId: answer});

  /// To the next question, or finished after the last of [total].
  void next(int total) => state = state.index + 1 >= total
      ? state.copyWith(finished: true)
      : state.copyWith(index: state.index + 1);
}

final playerControllerProvider = NotifierProvider.autoDispose
    .family<PlayerController, PlayerState, String>(PlayerController.new);
