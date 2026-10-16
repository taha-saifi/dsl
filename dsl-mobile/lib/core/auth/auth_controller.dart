import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exception.dart';
import '../api/api_providers.dart';
import '../storage/token_storage.dart';
import 'app_user.dart';
import 'auth_repository.dart';

/// Where the session stands. The router redirects on every change.
sealed class AuthState {
  const AuthState();
}

/// Reading the stored token and checking it with `GET /auth/me`.
final class AuthRestoring extends AuthState {
  const AuthRestoring();
}

final class SignedOut extends AuthState {
  const SignedOut({this.sessionEnded = false});

  /// True when the API rejected a stored token (401), so sign-in can say why.
  final bool sessionEnded;
}

final class SignedIn extends AuthState {
  const SignedIn(this.user);

  final AppUser user;
}

/// A token is stored but couldn't be checked (no network, timeout, 5xx).
/// The token is kept: only a real 401 ends a session.
final class SessionUnverified extends AuthState {
  const SessionUnverified(this.error);

  final Object error;
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    ref.listen(sessionExpiredEventsProvider, (_, _) {
      state = const SignedOut(sessionEnded: true);
    });
    Future.microtask(_restore);
    return const AuthRestoring();
  }

  TokenStorage get _storage => ref.read(tokenStorageProvider);
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> _restore() async {
    final String? token;
    try {
      token = await _storage.read();
    } on Object {
      // An unreadable keystore entry can't be recovered; start clean.
      await _clearQuietly();
      state = const SignedOut();
      return;
    }
    if (token == null) {
      state = const SignedOut();
      return;
    }
    try {
      state = SignedIn(await _repository.me());
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        // The interceptor already cleared the token.
        state = const SignedOut(sessionEnded: true);
      } else {
        state = SessionUnverified(error);
      }
    } on Object catch (error) {
      state = SessionUnverified(error);
    }
  }

  /// From [SessionUnverified]: check the stored token again.
  Future<void> retry() async {
    state = const AuthRestoring();
    await _restore();
  }

  /// Throws [ApiException] on failure; the screen shows it.
  Future<void> signIn({required String email, required String password}) =>
      _start(_repository.signIn(email: email, password: password));

  /// Creates a student account. Throws [ApiException] on failure.
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) => _start(
    _repository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    ),
  );

  /// Saves learning preferences; the router leaves onboarding on success.
  /// Throws [ApiException] on failure.
  Future<void> savePreferences(Map<String, Object?> preferences) async {
    final user = await _repository.updateMe(preferences: preferences);
    state = SignedIn(user);
  }

  Future<void> signOut() async {
    await _clearQuietly();
    state = const SignedOut();
  }

  Future<void> _start(Future<AuthSession> request) async {
    final session = await request;
    await _storage.write(session.token);
    state = SignedIn(session.user);
  }

  Future<void> _clearQuietly() async {
    try {
      await _storage.clear();
    } on Object {
      // Nothing more to do: the session is over either way.
    }
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
