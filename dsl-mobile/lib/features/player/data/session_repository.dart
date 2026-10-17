import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_providers.dart';
import 'player_answer.dart';
import 'session_models.dart';

/// Exercise sessions. The server checks every answer; the app never does.
class SessionRepository {
  const SessionRepository(this._client);

  final ApiClient _client;

  /// Abandons any active session for this exercise and starts a new one.
  Future<StartedSession> start(String exerciseId) => _client.post(
    '/learn/exercises/$exerciseId/sessions',
    decode: (data) => StartedSession.fromJson(data! as Map<String, dynamic>),
  );

  Future<AnswerResult> answer({
    required String sessionId,
    required String questionId,
    required PlayerAnswer answer,
    required int timeTakenMs,
  }) => _client.post(
    '/learn/sessions/$sessionId/answers',
    body: {
      'questionId': questionId,
      'answer': answer.toJson(),
      'timeTakenMs': timeTakenMs,
    },
    decode: (data) => AnswerResult.fromJson(data! as Map<String, dynamic>),
  );

  Future<SessionResult> complete(String sessionId) => _client.post(
    '/learn/sessions/$sessionId/complete',
    decode: (data) => SessionResult.fromJson(data! as Map<String, dynamic>),
  );

  Future<void> abandon(String sessionId) =>
      _client.post('/learn/sessions/$sessionId/abandon', decode: (_) {});
}

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(ref.watch(apiClientProvider)),
);
