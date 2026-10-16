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

enum LearningGoal {
  professional,
  academic,
  certification,
  @JsonValue('daily_practice')
  dailyPractice,
}

enum ExperienceLevel { beginner, intermediate, advanced }

/// Daily targets the API accepts, in minutes.
const dailyTargetOptions = [5, 10, 15, 20, 30];

/// `User.preferences`, set by onboarding (`PATCH /auth/me`). Goal and level
/// are informational in the MVP.
@freezed
abstract class LearningPreferences with _$LearningPreferences {
  const factory LearningPreferences({
    String? specializationId,
    String? targetLanguage,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    LearningGoal? goal,
    int? dailyTargetMinutes,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    ExperienceLevel? experienceLevel,
  }) = _LearningPreferences;

  factory LearningPreferences.fromJson(Map<String, dynamic> json) =>
      _$LearningPreferencesFromJson(json);
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
    LearningPreferences? preferences,
  }) = _AppUser;

  const AppUser._();

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  bool get isStudent => role == UserRole.student;

  /// Onboarding runs until the student has saved preferences once.
  bool get needsOnboarding => isStudent && preferences == null;

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
