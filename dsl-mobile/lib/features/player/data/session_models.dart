import 'package:freezed_annotation/freezed_annotation.dart';

import 'play_models.dart';

part 'session_models.freezed.dart';
part 'session_models.g.dart';

/// `session` in the session responses (docs/contracts/api-contract.md).
@freezed
abstract class SessionSummary with _$SessionSummary {
  const factory SessionSummary({
    @JsonKey(name: '_id') required String id,
    required String exerciseId,
    required String unitId,
    required String courseId,
    required String status,
    required int questionCount,
  }) = _SessionSummary;

  factory SessionSummary.fromJson(Map<String, dynamic> json) =>
      _$SessionSummaryFromJson(json);
}

/// `POST /learn/exercises/:id/sessions`.
@freezed
abstract class StartedSession with _$StartedSession {
  const factory StartedSession({
    required SessionSummary session,
    required PlayPayload play,
  }) = _StartedSession;

  factory StartedSession.fromJson(Map<String, dynamic> json) =>
      _$StartedSessionFromJson(json);
}

/// `correct` and `almost` both count as right; `almost` means only accents
/// differ, so the app shows the exact spelling.
enum Verdict { correct, almost, wrong }

/// `POST /learn/sessions/:id/answers`.
@freezed
abstract class AnswerResult with _$AnswerResult {
  const factory AnswerResult({
    required Verdict verdict,
    required bool isCorrect,
    required int attemptNumber,
    required bool firstAttempt,

    /// `{optionId, text?}`, `{text}` or `{pairs: [{leftId, rightId, left, right}]}`.
    required Map<String, dynamic> correctAnswer,
  }) = _AnswerResult;

  const AnswerResult._();

  factory AnswerResult.fromJson(Map<String, dynamic> json) =>
      _$AnswerResultFromJson(json);

  String? get correctOptionId => correctAnswer['optionId'] as String?;
  String? get correctText => correctAnswer['text'] as String?;

  /// leftId → rightId of the right pairs (matching).
  Map<String, String> get correctPairs => {
    for (final p in (correctAnswer['pairs'] as List<Object?>? ?? const []))
      (p! as Map<String, dynamic>)['leftId'] as String:
          (p as Map<String, dynamic>)['rightId'] as String,
  };

  /// "os → bone" lines for matching.
  List<String> get pairLines => [
    for (final p in (correctAnswer['pairs'] as List<Object?>? ?? const []))
      '${(p! as Map<String, dynamic>)['left']} → '
          '${(p as Map<String, dynamic>)['right']}',
  ];
}

/// `POST /learn/sessions/:id/complete`.
@freezed
abstract class SessionResult with _$SessionResult {
  const factory SessionResult({
    required int score,
    required int maxScore,
    required int accuracy,
    required int correctCount,
    required int questionCount,
    required int durationMs,
  }) = _SessionResult;

  factory SessionResult.fromJson(Map<String, dynamic> json) =>
      _$SessionResultFromJson(json);
}
