import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where the JWT lives. Only the token goes here; everything else that's
/// persisted is non-secret (docs/decisions/mobile-architecture.md, "Secure storage").
abstract interface class TokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  const SecureTokenStorage(this._storage);

  static const _key = 'dsl_token';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String token) => _storage.write(key: _key, value: token);

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => const SecureTokenStorage(FlutterSecureStorage()),
);
