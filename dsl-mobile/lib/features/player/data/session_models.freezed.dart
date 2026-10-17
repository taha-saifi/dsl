// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionSummary {

@JsonKey(name: '_id') String get id; String get exerciseId; String get unitId; String get courseId; String get status; int get questionCount;
/// Create a copy of SessionSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionSummaryCopyWith<SessionSummary> get copyWith => _$SessionSummaryCopyWithImpl<SessionSummary>(this as SessionSummary, _$identity);

  /// Serializes this SessionSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.status, status) || other.status == status)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,exerciseId,unitId,courseId,status,questionCount);

@override
String toString() {
  return 'SessionSummary(id: $id, exerciseId: $exerciseId, unitId: $unitId, courseId: $courseId, status: $status, questionCount: $questionCount)';
}


}

/// @nodoc
abstract mixin class $SessionSummaryCopyWith<$Res>  {
  factory $SessionSummaryCopyWith(SessionSummary value, $Res Function(SessionSummary) _then) = _$SessionSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String exerciseId, String unitId, String courseId, String status, int questionCount
});




}
/// @nodoc
class _$SessionSummaryCopyWithImpl<$Res>
    implements $SessionSummaryCopyWith<$Res> {
  _$SessionSummaryCopyWithImpl(this._self, this._then);

  final SessionSummary _self;
  final $Res Function(SessionSummary) _then;

/// Create a copy of SessionSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? exerciseId = null,Object? unitId = null,Object? courseId = null,Object? status = null,Object? questionCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionSummary].
extension SessionSummaryPatterns on SessionSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionSummary value)  $default,){
final _that = this;
switch (_that) {
case _SessionSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SessionSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String exerciseId,  String unitId,  String courseId,  String status,  int questionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionSummary() when $default != null:
return $default(_that.id,_that.exerciseId,_that.unitId,_that.courseId,_that.status,_that.questionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String exerciseId,  String unitId,  String courseId,  String status,  int questionCount)  $default,) {final _that = this;
switch (_that) {
case _SessionSummary():
return $default(_that.id,_that.exerciseId,_that.unitId,_that.courseId,_that.status,_that.questionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String exerciseId,  String unitId,  String courseId,  String status,  int questionCount)?  $default,) {final _that = this;
switch (_that) {
case _SessionSummary() when $default != null:
return $default(_that.id,_that.exerciseId,_that.unitId,_that.courseId,_that.status,_that.questionCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionSummary implements SessionSummary {
  const _SessionSummary({@JsonKey(name: '_id') required this.id, required this.exerciseId, required this.unitId, required this.courseId, required this.status, required this.questionCount});
  factory _SessionSummary.fromJson(Map<String, dynamic> json) => _$SessionSummaryFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String exerciseId;
@override final  String unitId;
@override final  String courseId;
@override final  String status;
@override final  int questionCount;

/// Create a copy of SessionSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionSummaryCopyWith<_SessionSummary> get copyWith => __$SessionSummaryCopyWithImpl<_SessionSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.status, status) || other.status == status)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,exerciseId,unitId,courseId,status,questionCount);

@override
String toString() {
  return 'SessionSummary(id: $id, exerciseId: $exerciseId, unitId: $unitId, courseId: $courseId, status: $status, questionCount: $questionCount)';
}


}

/// @nodoc
abstract mixin class _$SessionSummaryCopyWith<$Res> implements $SessionSummaryCopyWith<$Res> {
  factory _$SessionSummaryCopyWith(_SessionSummary value, $Res Function(_SessionSummary) _then) = __$SessionSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String exerciseId, String unitId, String courseId, String status, int questionCount
});




}
/// @nodoc
class __$SessionSummaryCopyWithImpl<$Res>
    implements _$SessionSummaryCopyWith<$Res> {
  __$SessionSummaryCopyWithImpl(this._self, this._then);

  final _SessionSummary _self;
  final $Res Function(_SessionSummary) _then;

/// Create a copy of SessionSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? exerciseId = null,Object? unitId = null,Object? courseId = null,Object? status = null,Object? questionCount = null,}) {
  return _then(_SessionSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StartedSession {

 SessionSummary get session; PlayPayload get play;
/// Create a copy of StartedSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartedSessionCopyWith<StartedSession> get copyWith => _$StartedSessionCopyWithImpl<StartedSession>(this as StartedSession, _$identity);

  /// Serializes this StartedSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartedSession&&(identical(other.session, session) || other.session == session)&&(identical(other.play, play) || other.play == play));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,play);

@override
String toString() {
  return 'StartedSession(session: $session, play: $play)';
}


}

/// @nodoc
abstract mixin class $StartedSessionCopyWith<$Res>  {
  factory $StartedSessionCopyWith(StartedSession value, $Res Function(StartedSession) _then) = _$StartedSessionCopyWithImpl;
@useResult
$Res call({
 SessionSummary session, PlayPayload play
});


$SessionSummaryCopyWith<$Res> get session;$PlayPayloadCopyWith<$Res> get play;

}
/// @nodoc
class _$StartedSessionCopyWithImpl<$Res>
    implements $StartedSessionCopyWith<$Res> {
  _$StartedSessionCopyWithImpl(this._self, this._then);

  final StartedSession _self;
  final $Res Function(StartedSession) _then;

/// Create a copy of StartedSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? play = null,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as SessionSummary,play: null == play ? _self.play : play // ignore: cast_nullable_to_non_nullable
as PlayPayload,
  ));
}
/// Create a copy of StartedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionSummaryCopyWith<$Res> get session {
  
  return $SessionSummaryCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of StartedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayPayloadCopyWith<$Res> get play {
  
  return $PlayPayloadCopyWith<$Res>(_self.play, (value) {
    return _then(_self.copyWith(play: value));
  });
}
}


/// Adds pattern-matching-related methods to [StartedSession].
extension StartedSessionPatterns on StartedSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StartedSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StartedSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StartedSession value)  $default,){
final _that = this;
switch (_that) {
case _StartedSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StartedSession value)?  $default,){
final _that = this;
switch (_that) {
case _StartedSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SessionSummary session,  PlayPayload play)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StartedSession() when $default != null:
return $default(_that.session,_that.play);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SessionSummary session,  PlayPayload play)  $default,) {final _that = this;
switch (_that) {
case _StartedSession():
return $default(_that.session,_that.play);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SessionSummary session,  PlayPayload play)?  $default,) {final _that = this;
switch (_that) {
case _StartedSession() when $default != null:
return $default(_that.session,_that.play);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StartedSession implements StartedSession {
  const _StartedSession({required this.session, required this.play});
  factory _StartedSession.fromJson(Map<String, dynamic> json) => _$StartedSessionFromJson(json);

@override final  SessionSummary session;
@override final  PlayPayload play;

/// Create a copy of StartedSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedSessionCopyWith<_StartedSession> get copyWith => __$StartedSessionCopyWithImpl<_StartedSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartedSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartedSession&&(identical(other.session, session) || other.session == session)&&(identical(other.play, play) || other.play == play));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,play);

@override
String toString() {
  return 'StartedSession(session: $session, play: $play)';
}


}

/// @nodoc
abstract mixin class _$StartedSessionCopyWith<$Res> implements $StartedSessionCopyWith<$Res> {
  factory _$StartedSessionCopyWith(_StartedSession value, $Res Function(_StartedSession) _then) = __$StartedSessionCopyWithImpl;
@override @useResult
$Res call({
 SessionSummary session, PlayPayload play
});


@override $SessionSummaryCopyWith<$Res> get session;@override $PlayPayloadCopyWith<$Res> get play;

}
/// @nodoc
class __$StartedSessionCopyWithImpl<$Res>
    implements _$StartedSessionCopyWith<$Res> {
  __$StartedSessionCopyWithImpl(this._self, this._then);

  final _StartedSession _self;
  final $Res Function(_StartedSession) _then;

/// Create a copy of StartedSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? play = null,}) {
  return _then(_StartedSession(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as SessionSummary,play: null == play ? _self.play : play // ignore: cast_nullable_to_non_nullable
as PlayPayload,
  ));
}

/// Create a copy of StartedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionSummaryCopyWith<$Res> get session {
  
  return $SessionSummaryCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of StartedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayPayloadCopyWith<$Res> get play {
  
  return $PlayPayloadCopyWith<$Res>(_self.play, (value) {
    return _then(_self.copyWith(play: value));
  });
}
}


/// @nodoc
mixin _$AnswerResult {

 Verdict get verdict; bool get isCorrect; int get attemptNumber; bool get firstAttempt;/// `{optionId, text?}`, `{text}` or `{pairs: [{leftId, rightId, left, right}]}`.
 Map<String, dynamic> get correctAnswer;
/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnswerResultCopyWith<AnswerResult> get copyWith => _$AnswerResultCopyWithImpl<AnswerResult>(this as AnswerResult, _$identity);

  /// Serializes this AnswerResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnswerResult&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.attemptNumber, attemptNumber) || other.attemptNumber == attemptNumber)&&(identical(other.firstAttempt, firstAttempt) || other.firstAttempt == firstAttempt)&&const DeepCollectionEquality().equals(other.correctAnswer, correctAnswer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,verdict,isCorrect,attemptNumber,firstAttempt,const DeepCollectionEquality().hash(correctAnswer));

@override
String toString() {
  return 'AnswerResult(verdict: $verdict, isCorrect: $isCorrect, attemptNumber: $attemptNumber, firstAttempt: $firstAttempt, correctAnswer: $correctAnswer)';
}


}

/// @nodoc
abstract mixin class $AnswerResultCopyWith<$Res>  {
  factory $AnswerResultCopyWith(AnswerResult value, $Res Function(AnswerResult) _then) = _$AnswerResultCopyWithImpl;
@useResult
$Res call({
 Verdict verdict, bool isCorrect, int attemptNumber, bool firstAttempt, Map<String, dynamic> correctAnswer
});




}
/// @nodoc
class _$AnswerResultCopyWithImpl<$Res>
    implements $AnswerResultCopyWith<$Res> {
  _$AnswerResultCopyWithImpl(this._self, this._then);

  final AnswerResult _self;
  final $Res Function(AnswerResult) _then;

/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verdict = null,Object? isCorrect = null,Object? attemptNumber = null,Object? firstAttempt = null,Object? correctAnswer = null,}) {
  return _then(_self.copyWith(
verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,attemptNumber: null == attemptNumber ? _self.attemptNumber : attemptNumber // ignore: cast_nullable_to_non_nullable
as int,firstAttempt: null == firstAttempt ? _self.firstAttempt : firstAttempt // ignore: cast_nullable_to_non_nullable
as bool,correctAnswer: null == correctAnswer ? _self.correctAnswer : correctAnswer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnswerResult].
extension AnswerResultPatterns on AnswerResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnswerResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnswerResult value)  $default,){
final _that = this;
switch (_that) {
case _AnswerResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnswerResult value)?  $default,){
final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Verdict verdict,  bool isCorrect,  int attemptNumber,  bool firstAttempt,  Map<String, dynamic> correctAnswer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
return $default(_that.verdict,_that.isCorrect,_that.attemptNumber,_that.firstAttempt,_that.correctAnswer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Verdict verdict,  bool isCorrect,  int attemptNumber,  bool firstAttempt,  Map<String, dynamic> correctAnswer)  $default,) {final _that = this;
switch (_that) {
case _AnswerResult():
return $default(_that.verdict,_that.isCorrect,_that.attemptNumber,_that.firstAttempt,_that.correctAnswer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Verdict verdict,  bool isCorrect,  int attemptNumber,  bool firstAttempt,  Map<String, dynamic> correctAnswer)?  $default,) {final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
return $default(_that.verdict,_that.isCorrect,_that.attemptNumber,_that.firstAttempt,_that.correctAnswer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnswerResult extends AnswerResult {
  const _AnswerResult({required this.verdict, required this.isCorrect, required this.attemptNumber, required this.firstAttempt, required final  Map<String, dynamic> correctAnswer}): _correctAnswer = correctAnswer,super._();
  factory _AnswerResult.fromJson(Map<String, dynamic> json) => _$AnswerResultFromJson(json);

@override final  Verdict verdict;
@override final  bool isCorrect;
@override final  int attemptNumber;
@override final  bool firstAttempt;
/// `{optionId, text?}`, `{text}` or `{pairs: [{leftId, rightId, left, right}]}`.
 final  Map<String, dynamic> _correctAnswer;
/// `{optionId, text?}`, `{text}` or `{pairs: [{leftId, rightId, left, right}]}`.
@override Map<String, dynamic> get correctAnswer {
  if (_correctAnswer is EqualUnmodifiableMapView) return _correctAnswer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_correctAnswer);
}


/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnswerResultCopyWith<_AnswerResult> get copyWith => __$AnswerResultCopyWithImpl<_AnswerResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnswerResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnswerResult&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.attemptNumber, attemptNumber) || other.attemptNumber == attemptNumber)&&(identical(other.firstAttempt, firstAttempt) || other.firstAttempt == firstAttempt)&&const DeepCollectionEquality().equals(other._correctAnswer, _correctAnswer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,verdict,isCorrect,attemptNumber,firstAttempt,const DeepCollectionEquality().hash(_correctAnswer));

@override
String toString() {
  return 'AnswerResult(verdict: $verdict, isCorrect: $isCorrect, attemptNumber: $attemptNumber, firstAttempt: $firstAttempt, correctAnswer: $correctAnswer)';
}


}

/// @nodoc
abstract mixin class _$AnswerResultCopyWith<$Res> implements $AnswerResultCopyWith<$Res> {
  factory _$AnswerResultCopyWith(_AnswerResult value, $Res Function(_AnswerResult) _then) = __$AnswerResultCopyWithImpl;
@override @useResult
$Res call({
 Verdict verdict, bool isCorrect, int attemptNumber, bool firstAttempt, Map<String, dynamic> correctAnswer
});




}
/// @nodoc
class __$AnswerResultCopyWithImpl<$Res>
    implements _$AnswerResultCopyWith<$Res> {
  __$AnswerResultCopyWithImpl(this._self, this._then);

  final _AnswerResult _self;
  final $Res Function(_AnswerResult) _then;

/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verdict = null,Object? isCorrect = null,Object? attemptNumber = null,Object? firstAttempt = null,Object? correctAnswer = null,}) {
  return _then(_AnswerResult(
verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,attemptNumber: null == attemptNumber ? _self.attemptNumber : attemptNumber // ignore: cast_nullable_to_non_nullable
as int,firstAttempt: null == firstAttempt ? _self.firstAttempt : firstAttempt // ignore: cast_nullable_to_non_nullable
as bool,correctAnswer: null == correctAnswer ? _self._correctAnswer : correctAnswer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$SessionResult {

 int get score; int get maxScore; int get accuracy; int get correctCount; int get questionCount; int get durationMs;
/// Create a copy of SessionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionResultCopyWith<SessionResult> get copyWith => _$SessionResultCopyWithImpl<SessionResult>(this as SessionResult, _$identity);

  /// Serializes this SessionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionResult&&(identical(other.score, score) || other.score == score)&&(identical(other.maxScore, maxScore) || other.maxScore == maxScore)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,maxScore,accuracy,correctCount,questionCount,durationMs);

@override
String toString() {
  return 'SessionResult(score: $score, maxScore: $maxScore, accuracy: $accuracy, correctCount: $correctCount, questionCount: $questionCount, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class $SessionResultCopyWith<$Res>  {
  factory $SessionResultCopyWith(SessionResult value, $Res Function(SessionResult) _then) = _$SessionResultCopyWithImpl;
@useResult
$Res call({
 int score, int maxScore, int accuracy, int correctCount, int questionCount, int durationMs
});




}
/// @nodoc
class _$SessionResultCopyWithImpl<$Res>
    implements $SessionResultCopyWith<$Res> {
  _$SessionResultCopyWithImpl(this._self, this._then);

  final SessionResult _self;
  final $Res Function(SessionResult) _then;

/// Create a copy of SessionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? maxScore = null,Object? accuracy = null,Object? correctCount = null,Object? questionCount = null,Object? durationMs = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,maxScore: null == maxScore ? _self.maxScore : maxScore // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionResult].
extension SessionResultPatterns on SessionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionResult value)  $default,){
final _that = this;
switch (_that) {
case _SessionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionResult value)?  $default,){
final _that = this;
switch (_that) {
case _SessionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int score,  int maxScore,  int accuracy,  int correctCount,  int questionCount,  int durationMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionResult() when $default != null:
return $default(_that.score,_that.maxScore,_that.accuracy,_that.correctCount,_that.questionCount,_that.durationMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int score,  int maxScore,  int accuracy,  int correctCount,  int questionCount,  int durationMs)  $default,) {final _that = this;
switch (_that) {
case _SessionResult():
return $default(_that.score,_that.maxScore,_that.accuracy,_that.correctCount,_that.questionCount,_that.durationMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int score,  int maxScore,  int accuracy,  int correctCount,  int questionCount,  int durationMs)?  $default,) {final _that = this;
switch (_that) {
case _SessionResult() when $default != null:
return $default(_that.score,_that.maxScore,_that.accuracy,_that.correctCount,_that.questionCount,_that.durationMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionResult implements SessionResult {
  const _SessionResult({required this.score, required this.maxScore, required this.accuracy, required this.correctCount, required this.questionCount, required this.durationMs});
  factory _SessionResult.fromJson(Map<String, dynamic> json) => _$SessionResultFromJson(json);

@override final  int score;
@override final  int maxScore;
@override final  int accuracy;
@override final  int correctCount;
@override final  int questionCount;
@override final  int durationMs;

/// Create a copy of SessionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionResultCopyWith<_SessionResult> get copyWith => __$SessionResultCopyWithImpl<_SessionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionResult&&(identical(other.score, score) || other.score == score)&&(identical(other.maxScore, maxScore) || other.maxScore == maxScore)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,maxScore,accuracy,correctCount,questionCount,durationMs);

@override
String toString() {
  return 'SessionResult(score: $score, maxScore: $maxScore, accuracy: $accuracy, correctCount: $correctCount, questionCount: $questionCount, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class _$SessionResultCopyWith<$Res> implements $SessionResultCopyWith<$Res> {
  factory _$SessionResultCopyWith(_SessionResult value, $Res Function(_SessionResult) _then) = __$SessionResultCopyWithImpl;
@override @useResult
$Res call({
 int score, int maxScore, int accuracy, int correctCount, int questionCount, int durationMs
});




}
/// @nodoc
class __$SessionResultCopyWithImpl<$Res>
    implements _$SessionResultCopyWith<$Res> {
  __$SessionResultCopyWithImpl(this._self, this._then);

  final _SessionResult _self;
  final $Res Function(_SessionResult) _then;

/// Create a copy of SessionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? maxScore = null,Object? accuracy = null,Object? correctCount = null,Object? questionCount = null,Object? durationMs = null,}) {
  return _then(_SessionResult(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,maxScore: null == maxScore ? _self.maxScore : maxScore // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
