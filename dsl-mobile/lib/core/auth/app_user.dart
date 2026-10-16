import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

enum UserRole {
  student,
  teacher,
  admin,

  /// A role this build doesn't know. Treated like any non-student role.
  unknown,
}

/// The `User` entity from `docs/contracts/api-contract.md`
/// (`GET /auth/me`, and `user` in the login/register response).
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    @JsonKey(name: '_id') required String id,
    required String email,
    @JsonKey(unknownEnumValue: UserRole.unknown) required UserRole role,
    String? firstName,
    String? lastName,
  }) = _AppUser;

  const AppUser._();

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  bool get isStudent => role == UserRole.student;

  String get displayName {
    final name = [firstName, lastName].whereType<String>().join(' ').trim();
    return name.isEmpty ? email : name;
  }
}

/// `{token, user}` from `POST /auth/login` and `POST /auth/register`.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({required String token, required AppUser user}) =
      _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}
