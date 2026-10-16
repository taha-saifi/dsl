// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LearningPreferences _$LearningPreferencesFromJson(Map<String, dynamic> json) =>
    _LearningPreferences(
      specializationId: json['specializationId'] as String?,
      targetLanguage: json['targetLanguage'] as String?,
      goal: $enumDecodeNullable(
        _$LearningGoalEnumMap,
        json['goal'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      dailyTargetMinutes: (json['dailyTargetMinutes'] as num?)?.toInt(),
      experienceLevel: $enumDecodeNullable(
        _$ExperienceLevelEnumMap,
        json['experienceLevel'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
    );

Map<String, dynamic> _$LearningPreferencesToJson(
  _LearningPreferences instance,
) => <String, dynamic>{
  'specializationId': instance.specializationId,
  'targetLanguage': instance.targetLanguage,
  'goal': _$LearningGoalEnumMap[instance.goal],
  'dailyTargetMinutes': instance.dailyTargetMinutes,
  'experienceLevel': _$ExperienceLevelEnumMap[instance.experienceLevel],
};

const _$LearningGoalEnumMap = {
  LearningGoal.professional: 'professional',
  LearningGoal.academic: 'academic',
  LearningGoal.certification: 'certification',
  LearningGoal.dailyPractice: 'daily_practice',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'beginner',
  ExperienceLevel.intermediate: 'intermediate',
  ExperienceLevel.advanced: 'advanced',
};

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['_id'] as String,
  email: json['email'] as String,
  role: $enumDecode(
    _$UserRoleEnumMap,
    json['role'],
    unknownValue: UserRole.unknown,
  ),
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  preferences: json['preferences'] == null
      ? null
      : LearningPreferences.fromJson(
          json['preferences'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  '_id': instance.id,
  'email': instance.email,
  'role': _$UserRoleEnumMap[instance.role]!,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'preferences': instance.preferences,
};

const _$UserRoleEnumMap = {
  UserRole.student: 'student',
  UserRole.teacher: 'teacher',
  UserRole.admin: 'admin',
  UserRole.unknown: 'unknown',
};

_AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => _AuthSession(
  token: json['token'] as String,
  user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthSessionToJson(_AuthSession instance) =>
    <String, dynamic>{'token': instance.token, 'user': instance.user};
