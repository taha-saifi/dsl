import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'play_models.dart';
import 'player_answer.dart';
import 'session_models.dart';
import 'session_repository.dart';

/// One play of an exercise: the session, where the student is, what they've
/// entered, and the server's verdict on the current question.
class PlayerState {
  const PlayerState({
    required this.session,
    required this.payload,
    this.index = 0,
    this.answers = const {},
    this.feedback,
    this.checking = false,
    this.result,
    this.error,
  });

  final SessionSummary session;
  final PlayPayload payload;
  final int index;

  /// By question id.
  final Map<String, PlayerAnswer> answers;

  /// The verdict on the current question, until Continue / Try Again / Skip.
  final AnswerResult? feedback;
  final bool checking;

  /// Set once the session is completed (Exercise Complete).
  final SessionResult? result;

  /// The last failed request (check or complete), shown above the button
  /// until the next try.
  final Object? error;

  PlayQuestion get question => payload.questions[index];
  bool get isLast => index == payload.questions.length - 1;

  PlayerState copyWith({
    int? index,
    Map<String, PlayerAnswer>? answers,
    AnswerResult? feedback,
    bool clearFeedback = false,
    bool? checking,
    SessionResult? result,
    Object? error,
    bool clearError = false,
  }) => PlayerState(
    session: session,
    payload: payload,
    index: index ?? this.index,
    answers: answers ?? this.answers,
    feedback: clearFeedback ? null : (feedback ?? this.feedback),
    checking: checking ?? this.checking,
    result: result ?? this.result,
    error: clearError ? null : (error ?? this.error),
  );
}

class PlayerController extends AsyncNotifier<PlayerState> {
  PlayerController(this.exerciseId);

  final String exerciseId;
  DateTime _shownAt = DateTime.now();

  SessionRepository get _repo => ref.read(sessionRepositoryProvider);

  @override
  Future<PlayerState> build() async {
    final started = await _repo.start(exerciseId);
    _shownAt = DateTime.now();
    return PlayerState(session: started.session, payload: started.play);
  }

  PlayerState get _current => state.requireValue;

  void answer(PlayerAnswer answer) {
    final s = _current;
    if (s.feedback != null || s.checking) return; // locked once checked
    state = AsyncData(
      s.copyWith(answers: {...s.answers, s.question.id: answer}),
    );
  }

  /// Sends the answer to the server. On failure the answer is kept and the
  /// error shown, so the student can press Check again.
  Future<void> check() async {
    final s = _current;
    final answer = s.answers[s.question.id];
    if (answer == null || s.checking || s.feedback != null) return;
    state = AsyncData(s.copyWith(checking: true, clearError: true));
    try {
      final result = await _repo.answer(
        sessionId: s.session.id,
        questionId: s.question.id,
        answer: answer,
        timeTakenMs: DateTime.now().difference(_shownAt).inMilliseconds,
      );
      state = AsyncData(_current.copyWith(feedback: result, checking: false));
    } on Object catch (error) {
      state = AsyncData(_current.copyWith(checking: false, error: error));
    }
  }

  /// After a wrong answer: same question, fresh input. Only the first
  /// attempt counts toward the score.
  void tryAgain() {
    final s = _current;
    _shownAt = DateTime.now();
    state = AsyncData(
      s.copyWith(
        answers: {...s.answers}..remove(s.question.id),
        clearFeedback: true,
      ),
    );
  }

  /// Continue (after any verdict) or Skip & Continue. After the last
  /// question this completes the session (errors shown like check's).
  Future<void> next() async {
    final s = _current;
    if (!s.isLast) {
      _shownAt = DateTime.now();
      state = AsyncData(s.copyWith(index: s.index + 1, clearFeedback: true));
      return;
    }
    state = AsyncData(s.copyWith(checking: true, clearError: true));
    try {
      final result = await _repo.complete(s.session.id);
      state = AsyncData(_current.copyWith(result: result, checking: false));
    } on Object catch (error) {
      state = AsyncData(_current.copyWith(checking: false, error: error));
    }
  }

  /// Quit from Pause. Best effort: an unreachable server leaves the session
  /// active, and the next start abandons it anyway.
  void abandon() {
    final session = state.value?.session;
    if (session == null || state.value?.result != null) return;
    unawaited(_repo.abandon(session.id).catchError((Object _) {}));
  }
}

final playerControllerProvider = AsyncNotifierProvider.autoDispose
    .family<PlayerController, PlayerState, String>(PlayerController.new);
