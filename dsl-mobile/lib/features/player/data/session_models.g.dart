// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionSummary _$SessionSummaryFromJson(Map<String, dynamic> json) =>
    _SessionSummary(
      id: json['_id'] as String,
      exerciseId: json['exerciseId'] as String,
      unitId: json['unitId'] as String,
      courseId: json['courseId'] as String,
      status: json['status'] as String,
      questionCount: (json['questionCount'] as num).toInt(),
    );

Map<String, dynamic> _$SessionSummaryToJson(_SessionSummary instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'exerciseId': instance.exerciseId,
      'unitId': instance.unitId,
      'courseId': instance.courseId,
      'status': instance.status,
      'questionCount': instance.questionCount,
    };

_StartedSession _$StartedSessionFromJson(Map<String, dynamic> json) =>
    _StartedSession(
      session: SessionSummary.fromJson(json['session'] as Map<String, dynamic>),
      play: PlayPayload.fromJson(json['play'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StartedSessionToJson(_StartedSession instance) =>
    <String, dynamic>{'session': instance.session, 'play': instance.play};

_AnswerResult _$AnswerResultFromJson(Map<String, dynamic> json) =>
    _AnswerResult(
      verdict: $enumDecode(_$VerdictEnumMap, json['verdict']),
      isCorrect: json['isCorrect'] as bool,
      attemptNumber: (json['attemptNumber'] as num).toInt(),
      firstAttempt: json['firstAttempt'] as bool,
      correctAnswer: json['correctAnswer'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AnswerResultToJson(_AnswerResult instance) =>
    <String, dynamic>{
      'verdict': _$VerdictEnumMap[instance.verdict]!,
      'isCorrect': instance.isCorrect,
      'attemptNumber': instance.attemptNumber,
      'firstAttempt': instance.firstAttempt,
      'correctAnswer': instance.correctAnswer,
    };

const _$VerdictEnumMap = {
  Verdict.correct: 'correct',
  Verdict.almost: 'almost',
  Verdict.wrong: 'wrong',
};

_SessionResult _$SessionResultFromJson(Map<String, dynamic> json) =>
    _SessionResult(
      score: (json['score'] as num).toInt(),
      maxScore: (json['maxScore'] as num).toInt(),
      accuracy: (json['accuracy'] as num).toInt(),
      correctCount: (json['correctCount'] as num).toInt(),
      questionCount: (json['questionCount'] as num).toInt(),
      durationMs: (json['durationMs'] as num).toInt(),
    );

Map<String, dynamic> _$SessionResultToJson(_SessionResult instance) =>
    <String, dynamic>{
      'score': instance.score,
      'maxScore': instance.maxScore,
      'accuracy': instance.accuracy,
      'correctCount': instance.correctCount,
      'questionCount': instance.questionCount,
      'durationMs': instance.durationMs,
    };
