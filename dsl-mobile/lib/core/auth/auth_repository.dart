import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/api_providers.dart';
import 'app_user.dart';

/// `/auth/*` calls. Students register themselves; teachers and admins are
/// created by an admin in the dashboard.
class AuthRepository {
  const AuthRepository(this._client);

  final ApiClient _client;

  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) => _client.post(
    '/auth/login',
    decode: _session,
    body: {'email': email, 'password': password},
  );

  Future<AuthSession> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) => _client.post(
    '/auth/register',
    decode: _session,
    body: {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'acceptedTerms': true,
    },
  );

  Future<AppUser> me() => _client.get(
    '/auth/me',
    decode: (data) => AppUser.fromJson(data! as Map<String, dynamic>),
  );

  /// `PATCH /auth/me` (students only). [preferences] is the raw body object:
  /// a key set to null clears that preference.
  Future<AppUser> updateMe({Map<String, Object?>? preferences}) =>
      _client.patch(
        '/auth/me',
        decode: (data) => AppUser.fromJson(data! as Map<String, dynamic>),
        body: {'preferences': ?preferences},
      );

  static AuthSession _session(Object? data) =>
      AuthSession.fromJson(data! as Map<String, dynamic>);
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(apiClientProvider)),
);
