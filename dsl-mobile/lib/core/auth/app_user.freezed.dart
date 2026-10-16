// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LearningPreferences {

 String? get specializationId; String? get targetLanguage;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) LearningGoal? get goal; int? get dailyTargetMinutes;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) ExperienceLevel? get experienceLevel;
/// Create a copy of LearningPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearningPreferencesCopyWith<LearningPreferences> get copyWith => _$LearningPreferencesCopyWithImpl<LearningPreferences>(this as LearningPreferences, _$identity);

  /// Serializes this LearningPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningPreferences&&(identical(other.specializationId, specializationId) || other.specializationId == specializationId)&&(identical(other.targetLanguage, targetLanguage) || other.targetLanguage == targetLanguage)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.dailyTargetMinutes, dailyTargetMinutes) || other.dailyTargetMinutes == dailyTargetMinutes)&&(identical(other.experienceLevel, experienceLevel) || other.experienceLevel == experienceLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,specializationId,targetLanguage,goal,dailyTargetMinutes,experienceLevel);

@override
String toString() {
  return 'LearningPreferences(specializationId: $specializationId, targetLanguage: $targetLanguage, goal: $goal, dailyTargetMinutes: $dailyTargetMinutes, experienceLevel: $experienceLevel)';
}


}

/// @nodoc
abstract mixin class $LearningPreferencesCopyWith<$Res>  {
  factory $LearningPreferencesCopyWith(LearningPreferences value, $Res Function(LearningPreferences) _then) = _$LearningPreferencesCopyWithImpl;
@useResult
$Res call({
 String? specializationId, String? targetLanguage,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) LearningGoal? goal, int? dailyTargetMinutes,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) ExperienceLevel? experienceLevel
});




}
/// @nodoc
class _$LearningPreferencesCopyWithImpl<$Res>
    implements $LearningPreferencesCopyWith<$Res> {
  _$LearningPreferencesCopyWithImpl(this._self, this._then);

  final LearningPreferences _self;
  final $Res Function(LearningPreferences) _then;

/// Create a copy of LearningPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? specializationId = freezed,Object? targetLanguage = freezed,Object? goal = freezed,Object? dailyTargetMinutes = freezed,Object? experienceLevel = freezed,}) {
  return _then(_self.copyWith(
specializationId: freezed == specializationId ? _self.specializationId : specializationId // ignore: cast_nullable_to_non_nullable
as String?,targetLanguage: freezed == targetLanguage ? _self.targetLanguage : targetLanguage // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as LearningGoal?,dailyTargetMinutes: freezed == dailyTargetMinutes ? _self.dailyTargetMinutes : dailyTargetMinutes // ignore: cast_nullable_to_non_nullable
as int?,experienceLevel: freezed == experienceLevel ? _self.experienceLevel : experienceLevel // ignore: cast_nullable_to_non_nullable
as ExperienceLevel?,
  ));
}

}


/// Adds pattern-matching-related methods to [LearningPreferences].
extension LearningPreferencesPatterns on LearningPreferences {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearningPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearningPreferences() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearningPreferences value)  $default,){
final _that = this;
switch (_that) {
case _LearningPreferences():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearningPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _LearningPreferences() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? specializationId,  String? targetLanguage, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  LearningGoal? goal,  int? dailyTargetMinutes, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  ExperienceLevel? experienceLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearningPreferences() when $default != null:
return $default(_that.specializationId,_that.targetLanguage,_that.goal,_that.dailyTargetMinutes,_that.experienceLevel);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? specializationId,  String? targetLanguage, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  LearningGoal? goal,  int? dailyTargetMinutes, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  ExperienceLevel? experienceLevel)  $default,) {final _that = this;
switch (_that) {
case _LearningPreferences():
return $default(_that.specializationId,_that.targetLanguage,_that.goal,_that.dailyTargetMinutes,_that.experienceLevel);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? specializationId,  String? targetLanguage, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  LearningGoal? goal,  int? dailyTargetMinutes, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  ExperienceLevel? experienceLevel)?  $default,) {final _that = this;
switch (_that) {
case _LearningPreferences() when $default != null:
return $default(_that.specializationId,_that.targetLanguage,_that.goal,_that.dailyTargetMinutes,_that.experienceLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LearningPreferences implements LearningPreferences {
  const _LearningPreferences({this.specializationId, this.targetLanguage, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.goal, this.dailyTargetMinutes, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.experienceLevel});
  factory _LearningPreferences.fromJson(Map<String, dynamic> json) => _$LearningPreferencesFromJson(json);

@override final  String? specializationId;
@override final  String? targetLanguage;
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  LearningGoal? goal;
@override final  int? dailyTargetMinutes;
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  ExperienceLevel? experienceLevel;

/// Create a copy of LearningPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningPreferencesCopyWith<_LearningPreferences> get copyWith => __$LearningPreferencesCopyWithImpl<_LearningPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearningPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningPreferences&&(identical(other.specializationId, specializationId) || other.specializationId == specializationId)&&(identical(other.targetLanguage, targetLanguage) || other.targetLanguage == targetLanguage)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.dailyTargetMinutes, dailyTargetMinutes) || other.dailyTargetMinutes == dailyTargetMinutes)&&(identical(other.experienceLevel, experienceLevel) || other.experienceLevel == experienceLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,specializationId,targetLanguage,goal,dailyTargetMinutes,experienceLevel);

@override
String toString() {
  return 'LearningPreferences(specializationId: $specializationId, targetLanguage: $targetLanguage, goal: $goal, dailyTargetMinutes: $dailyTargetMinutes, experienceLevel: $experienceLevel)';
}


}

/// @nodoc
abstract mixin class _$LearningPreferencesCopyWith<$Res> implements $LearningPreferencesCopyWith<$Res> {
  factory _$LearningPreferencesCopyWith(_LearningPreferences value, $Res Function(_LearningPreferences) _then) = __$LearningPreferencesCopyWithImpl;
@override @useResult
$Res call({
 String? specializationId, String? targetLanguage,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) LearningGoal? goal, int? dailyTargetMinutes,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) ExperienceLevel? experienceLevel
});




}
/// @nodoc
class __$LearningPreferencesCopyWithImpl<$Res>
    implements _$LearningPreferencesCopyWith<$Res> {
  __$LearningPreferencesCopyWithImpl(this._self, this._then);

  final _LearningPreferences _self;
  final $Res Function(_LearningPreferences) _then;

/// Create a copy of LearningPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? specializationId = freezed,Object? targetLanguage = freezed,Object? goal = freezed,Object? dailyTargetMinutes = freezed,Object? experienceLevel = freezed,}) {
  return _then(_LearningPreferences(
specializationId: freezed == specializationId ? _self.specializationId : specializationId // ignore: cast_nullable_to_non_nullable
as String?,targetLanguage: freezed == targetLanguage ? _self.targetLanguage : targetLanguage // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as LearningGoal?,dailyTargetMinutes: freezed == dailyTargetMinutes ? _self.dailyTargetMinutes : dailyTargetMinutes // ignore: cast_nullable_to_non_nullable
as int?,experienceLevel: freezed == experienceLevel ? _self.experienceLevel : experienceLevel // ignore: cast_nullable_to_non_nullable
as ExperienceLevel?,
  ));
}


}


/// @nodoc
mixin _$AppUser {

@JsonKey(name: '_id') String get id; String get email;@JsonKey(unknownEnumValue: UserRole.unknown) UserRole get role; String? get firstName; String? get lastName; LearningPreferences? get preferences;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.preferences, preferences) || other.preferences == preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,role,firstName,lastName,preferences);

@override
String toString() {
  return 'AppUser(id: $id, email: $email, role: $role, firstName: $firstName, lastName: $lastName, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String email,@JsonKey(unknownEnumValue: UserRole.unknown) UserRole role, String? firstName, String? lastName, LearningPreferences? preferences
});


$LearningPreferencesCopyWith<$Res>? get preferences;

}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? role = null,Object? firstName = freezed,Object? lastName = freezed,Object? preferences = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as LearningPreferences?,
  ));
}
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LearningPreferencesCopyWith<$Res>? get preferences {
    if (_self.preferences == null) {
    return null;
  }

  return $LearningPreferencesCopyWith<$Res>(_self.preferences!, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String email, @JsonKey(unknownEnumValue: UserRole.unknown)  UserRole role,  String? firstName,  String? lastName,  LearningPreferences? preferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.email,_that.role,_that.firstName,_that.lastName,_that.preferences);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String email, @JsonKey(unknownEnumValue: UserRole.unknown)  UserRole role,  String? firstName,  String? lastName,  LearningPreferences? preferences)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.email,_that.role,_that.firstName,_that.lastName,_that.preferences);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String email, @JsonKey(unknownEnumValue: UserRole.unknown)  UserRole role,  String? firstName,  String? lastName,  LearningPreferences? preferences)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.email,_that.role,_that.firstName,_that.lastName,_that.preferences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser extends AppUser {
  const _AppUser({@JsonKey(name: '_id') required this.id, required this.email, @JsonKey(unknownEnumValue: UserRole.unknown) required this.role, this.firstName, this.lastName, this.preferences}): super._();
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String email;
@override@JsonKey(unknownEnumValue: UserRole.unknown) final  UserRole role;
@override final  String? firstName;
@override final  String? lastName;
@override final  LearningPreferences? preferences;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.preferences, preferences) || other.preferences == preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,role,firstName,lastName,preferences);

@override
String toString() {
  return 'AppUser(id: $id, email: $email, role: $role, firstName: $firstName, lastName: $lastName, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String email,@JsonKey(unknownEnumValue: UserRole.unknown) UserRole role, String? firstName, String? lastName, LearningPreferences? preferences
});


@override $LearningPreferencesCopyWith<$Res>? get preferences;

}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? role = null,Object? firstName = freezed,Object? lastName = freezed,Object? preferences = freezed,}) {
  return _then(_AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as LearningPreferences?,
  ));
}

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LearningPreferencesCopyWith<$Res>? get preferences {
    if (_self.preferences == null) {
    return null;
  }

  return $LearningPreferencesCopyWith<$Res>(_self.preferences!, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}


/// @nodoc
mixin _$AuthSession {

 String get token; AppUser get user;
/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSessionCopyWith<AuthSession> get copyWith => _$AuthSessionCopyWithImpl<AuthSession>(this as AuthSession, _$identity);

  /// Serializes this AuthSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSession&&(identical(other.token, token) || other.token == token)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,user);

@override
String toString() {
  return 'AuthSession(token: $token, user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthSessionCopyWith<$Res>  {
  factory $AuthSessionCopyWith(AuthSession value, $Res Function(AuthSession) _then) = _$AuthSessionCopyWithImpl;
@useResult
$Res call({
 String token, AppUser user
});


$AppUserCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthSessionCopyWithImpl<$Res>
    implements $AuthSessionCopyWith<$Res> {
  _$AuthSessionCopyWithImpl(this._self, this._then);

  final AuthSession _self;
  final $Res Function(AuthSession) _then;

/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? user = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,
  ));
}
/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthSession].
extension AuthSessionPatterns on AuthSession {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthSession value)  $default,){
final _that = this;
switch (_that) {
case _AuthSession():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthSession value)?  $default,){
final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  AppUser user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that.token,_that.user);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  AppUser user)  $default,) {final _that = this;
switch (_that) {
case _AuthSession():
return $default(_that.token,_that.user);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  AppUser user)?  $default,) {final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that.token,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthSession implements AuthSession {
  const _AuthSession({required this.token, required this.user});
  factory _AuthSession.fromJson(Map<String, dynamic> json) => _$AuthSessionFromJson(json);

@override final  String token;
@override final  AppUser user;

/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthSessionCopyWith<_AuthSession> get copyWith => __$AuthSessionCopyWithImpl<_AuthSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthSession&&(identical(other.token, token) || other.token == token)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,user);

@override
String toString() {
  return 'AuthSession(token: $token, user: $user)';
}


}

/// @nodoc
abstract mixin class _$AuthSessionCopyWith<$Res> implements $AuthSessionCopyWith<$Res> {
  factory _$AuthSessionCopyWith(_AuthSession value, $Res Function(_AuthSession) _then) = __$AuthSessionCopyWithImpl;
@override @useResult
$Res call({
 String token, AppUser user
});


@override $AppUserCopyWith<$Res> get user;

}
/// @nodoc
class __$AuthSessionCopyWithImpl<$Res>
    implements _$AuthSessionCopyWith<$Res> {
  __$AuthSessionCopyWithImpl(this._self, this._then);

  final _AuthSession _self;
  final $Res Function(_AuthSession) _then;

/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? user = null,}) {
  return _then(_AuthSession(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,
  ));
}

/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
