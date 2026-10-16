// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'play_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayPayload {

 PlayExercise get exercise; List<PlayQuestion> get questions;
/// Create a copy of PlayPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayPayloadCopyWith<PlayPayload> get copyWith => _$PlayPayloadCopyWithImpl<PlayPayload>(this as PlayPayload, _$identity);

  /// Serializes this PlayPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayPayload&&(identical(other.exercise, exercise) || other.exercise == exercise)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exercise,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'PlayPayload(exercise: $exercise, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $PlayPayloadCopyWith<$Res>  {
  factory $PlayPayloadCopyWith(PlayPayload value, $Res Function(PlayPayload) _then) = _$PlayPayloadCopyWithImpl;
@useResult
$Res call({
 PlayExercise exercise, List<PlayQuestion> questions
});


$PlayExerciseCopyWith<$Res> get exercise;

}
/// @nodoc
class _$PlayPayloadCopyWithImpl<$Res>
    implements $PlayPayloadCopyWith<$Res> {
  _$PlayPayloadCopyWithImpl(this._self, this._then);

  final PlayPayload _self;
  final $Res Function(PlayPayload) _then;

/// Create a copy of PlayPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exercise = null,Object? questions = null,}) {
  return _then(_self.copyWith(
exercise: null == exercise ? _self.exercise : exercise // ignore: cast_nullable_to_non_nullable
as PlayExercise,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<PlayQuestion>,
  ));
}
/// Create a copy of PlayPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayExerciseCopyWith<$Res> get exercise {
  
  return $PlayExerciseCopyWith<$Res>(_self.exercise, (value) {
    return _then(_self.copyWith(exercise: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayPayload].
extension PlayPayloadPatterns on PlayPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayPayload value)  $default,){
final _that = this;
switch (_that) {
case _PlayPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayPayload value)?  $default,){
final _that = this;
switch (_that) {
case _PlayPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlayExercise exercise,  List<PlayQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayPayload() when $default != null:
return $default(_that.exercise,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlayExercise exercise,  List<PlayQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _PlayPayload():
return $default(_that.exercise,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlayExercise exercise,  List<PlayQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _PlayPayload() when $default != null:
return $default(_that.exercise,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayPayload implements PlayPayload {
  const _PlayPayload({required this.exercise, required final  List<PlayQuestion> questions}): _questions = questions;
  factory _PlayPayload.fromJson(Map<String, dynamic> json) => _$PlayPayloadFromJson(json);

@override final  PlayExercise exercise;
 final  List<PlayQuestion> _questions;
@override List<PlayQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of PlayPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayPayloadCopyWith<_PlayPayload> get copyWith => __$PlayPayloadCopyWithImpl<_PlayPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayPayload&&(identical(other.exercise, exercise) || other.exercise == exercise)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exercise,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'PlayPayload(exercise: $exercise, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$PlayPayloadCopyWith<$Res> implements $PlayPayloadCopyWith<$Res> {
  factory _$PlayPayloadCopyWith(_PlayPayload value, $Res Function(_PlayPayload) _then) = __$PlayPayloadCopyWithImpl;
@override @useResult
$Res call({
 PlayExercise exercise, List<PlayQuestion> questions
});


@override $PlayExerciseCopyWith<$Res> get exercise;

}
/// @nodoc
class __$PlayPayloadCopyWithImpl<$Res>
    implements _$PlayPayloadCopyWith<$Res> {
  __$PlayPayloadCopyWithImpl(this._self, this._then);

  final _PlayPayload _self;
  final $Res Function(_PlayPayload) _then;

/// Create a copy of PlayPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exercise = null,Object? questions = null,}) {
  return _then(_PlayPayload(
exercise: null == exercise ? _self.exercise : exercise // ignore: cast_nullable_to_non_nullable
as PlayExercise,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<PlayQuestion>,
  ));
}

/// Create a copy of PlayPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayExerciseCopyWith<$Res> get exercise {
  
  return $PlayExerciseCopyWith<$Res>(_self.exercise, (value) {
    return _then(_self.copyWith(exercise: value));
  });
}
}


/// @nodoc
mixin _$PlayExercise {

@JsonKey(name: '_id') String get id; String get name; String get unitId; String get unitName; String get courseId; String get courseName; int get questionCount;
/// Create a copy of PlayExercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayExerciseCopyWith<PlayExercise> get copyWith => _$PlayExerciseCopyWithImpl<PlayExercise>(this as PlayExercise, _$identity);

  /// Serializes this PlayExercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,unitId,unitName,courseId,courseName,questionCount);

@override
String toString() {
  return 'PlayExercise(id: $id, name: $name, unitId: $unitId, unitName: $unitName, courseId: $courseId, courseName: $courseName, questionCount: $questionCount)';
}


}

/// @nodoc
abstract mixin class $PlayExerciseCopyWith<$Res>  {
  factory $PlayExerciseCopyWith(PlayExercise value, $Res Function(PlayExercise) _then) = _$PlayExerciseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String name, String unitId, String unitName, String courseId, String courseName, int questionCount
});




}
/// @nodoc
class _$PlayExerciseCopyWithImpl<$Res>
    implements $PlayExerciseCopyWith<$Res> {
  _$PlayExerciseCopyWithImpl(this._self, this._then);

  final PlayExercise _self;
  final $Res Function(PlayExercise) _then;

/// Create a copy of PlayExercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? unitId = null,Object? unitName = null,Object? courseId = null,Object? courseName = null,Object? questionCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayExercise].
extension PlayExercisePatterns on PlayExercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayExercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayExercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayExercise value)  $default,){
final _that = this;
switch (_that) {
case _PlayExercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayExercise value)?  $default,){
final _that = this;
switch (_that) {
case _PlayExercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String name,  String unitId,  String unitName,  String courseId,  String courseName,  int questionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayExercise() when $default != null:
return $default(_that.id,_that.name,_that.unitId,_that.unitName,_that.courseId,_that.courseName,_that.questionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String name,  String unitId,  String unitName,  String courseId,  String courseName,  int questionCount)  $default,) {final _that = this;
switch (_that) {
case _PlayExercise():
return $default(_that.id,_that.name,_that.unitId,_that.unitName,_that.courseId,_that.courseName,_that.questionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String name,  String unitId,  String unitName,  String courseId,  String courseName,  int questionCount)?  $default,) {final _that = this;
switch (_that) {
case _PlayExercise() when $default != null:
return $default(_that.id,_that.name,_that.unitId,_that.unitName,_that.courseId,_that.courseName,_that.questionCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayExercise implements PlayExercise {
  const _PlayExercise({@JsonKey(name: '_id') required this.id, required this.name, required this.unitId, required this.unitName, required this.courseId, required this.courseName, required this.questionCount});
  factory _PlayExercise.fromJson(Map<String, dynamic> json) => _$PlayExerciseFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String name;
@override final  String unitId;
@override final  String unitName;
@override final  String courseId;
@override final  String courseName;
@override final  int questionCount;

/// Create a copy of PlayExercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayExerciseCopyWith<_PlayExercise> get copyWith => __$PlayExerciseCopyWithImpl<_PlayExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,unitId,unitName,courseId,courseName,questionCount);

@override
String toString() {
  return 'PlayExercise(id: $id, name: $name, unitId: $unitId, unitName: $unitName, courseId: $courseId, courseName: $courseName, questionCount: $questionCount)';
}


}

/// @nodoc
abstract mixin class _$PlayExerciseCopyWith<$Res> implements $PlayExerciseCopyWith<$Res> {
  factory _$PlayExerciseCopyWith(_PlayExercise value, $Res Function(_PlayExercise) _then) = __$PlayExerciseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String name, String unitId, String unitName, String courseId, String courseName, int questionCount
});




}
/// @nodoc
class __$PlayExerciseCopyWithImpl<$Res>
    implements _$PlayExerciseCopyWith<$Res> {
  __$PlayExerciseCopyWithImpl(this._self, this._then);

  final _PlayExercise _self;
  final $Res Function(_PlayExercise) _then;

/// Create a copy of PlayExercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? unitId = null,Object? unitName = null,Object? courseId = null,Object? courseName = null,Object? questionCount = null,}) {
  return _then(_PlayExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PlayChoice {

 String get id; String? get text; String? get imageUrl;
/// Create a copy of PlayChoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayChoiceCopyWith<PlayChoice> get copyWith => _$PlayChoiceCopyWithImpl<PlayChoice>(this as PlayChoice, _$identity);

  /// Serializes this PlayChoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayChoice&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,imageUrl);

@override
String toString() {
  return 'PlayChoice(id: $id, text: $text, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $PlayChoiceCopyWith<$Res>  {
  factory $PlayChoiceCopyWith(PlayChoice value, $Res Function(PlayChoice) _then) = _$PlayChoiceCopyWithImpl;
@useResult
$Res call({
 String id, String? text, String? imageUrl
});




}
/// @nodoc
class _$PlayChoiceCopyWithImpl<$Res>
    implements $PlayChoiceCopyWith<$Res> {
  _$PlayChoiceCopyWithImpl(this._self, this._then);

  final PlayChoice _self;
  final $Res Function(PlayChoice) _then;

/// Create a copy of PlayChoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = freezed,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayChoice].
extension PlayChoicePatterns on PlayChoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayChoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayChoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayChoice value)  $default,){
final _that = this;
switch (_that) {
case _PlayChoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayChoice value)?  $default,){
final _that = this;
switch (_that) {
case _PlayChoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? text,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayChoice() when $default != null:
return $default(_that.id,_that.text,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? text,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _PlayChoice():
return $default(_that.id,_that.text,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? text,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _PlayChoice() when $default != null:
return $default(_that.id,_that.text,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayChoice implements PlayChoice {
  const _PlayChoice({required this.id, this.text, this.imageUrl});
  factory _PlayChoice.fromJson(Map<String, dynamic> json) => _$PlayChoiceFromJson(json);

@override final  String id;
@override final  String? text;
@override final  String? imageUrl;

/// Create a copy of PlayChoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayChoiceCopyWith<_PlayChoice> get copyWith => __$PlayChoiceCopyWithImpl<_PlayChoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayChoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayChoice&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,imageUrl);

@override
String toString() {
  return 'PlayChoice(id: $id, text: $text, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$PlayChoiceCopyWith<$Res> implements $PlayChoiceCopyWith<$Res> {
  factory _$PlayChoiceCopyWith(_PlayChoice value, $Res Function(_PlayChoice) _then) = __$PlayChoiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String? text, String? imageUrl
});




}
/// @nodoc
class __$PlayChoiceCopyWithImpl<$Res>
    implements _$PlayChoiceCopyWith<$Res> {
  __$PlayChoiceCopyWithImpl(this._self, this._then);

  final _PlayChoice _self;
  final $Res Function(_PlayChoice) _then;

/// Create a copy of PlayChoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = freezed,Object? imageUrl = freezed,}) {
  return _then(_PlayChoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

PlayQuestion _$PlayQuestionFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'choose_picture':
          return ChoosePictureQuestion.fromJson(
            json
          );
                case 'multiple_choice':
          return MultipleChoiceQuestion.fromJson(
            json
          );
                case 'listening_select':
          return ListeningSelectQuestion.fromJson(
            json
          );
                case 'typing':
          return TypingQuestion.fromJson(
            json
          );
                case 'listening_transcribe':
          return ListeningTranscribeQuestion.fromJson(
            json
          );
                case 'fill_blank':
          return FillBlankQuestion.fromJson(
            json
          );
                case 'arrange_sentence':
          return ArrangeSentenceQuestion.fromJson(
            json
          );
                case 'matching':
          return MatchingQuestion.fromJson(
            json
          );
        
          default:
            return UnknownQuestion.fromJson(
  json
);
        }
      
}

/// @nodoc
mixin _$PlayQuestion {

 String get id; String get displayText; int get points;
/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayQuestionCopyWith<PlayQuestion> get copyWith => _$PlayQuestionCopyWithImpl<PlayQuestion>(this as PlayQuestion, _$identity);

  /// Serializes this PlayQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.points, points) || other.points == points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayText,points);

@override
String toString() {
  return 'PlayQuestion(id: $id, displayText: $displayText, points: $points)';
}


}

/// @nodoc
abstract mixin class $PlayQuestionCopyWith<$Res>  {
  factory $PlayQuestionCopyWith(PlayQuestion value, $Res Function(PlayQuestion) _then) = _$PlayQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String displayText, int points
});




}
/// @nodoc
class _$PlayQuestionCopyWithImpl<$Res>
    implements $PlayQuestionCopyWith<$Res> {
  _$PlayQuestionCopyWithImpl(this._self, this._then);

  final PlayQuestion _self;
  final $Res Function(PlayQuestion) _then;

/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayText = null,Object? points = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayQuestion].
extension PlayQuestionPatterns on PlayQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChoosePictureQuestion value)?  choosePicture,TResult Function( MultipleChoiceQuestion value)?  multipleChoice,TResult Function( ListeningSelectQuestion value)?  listeningSelect,TResult Function( TypingQuestion value)?  typing,TResult Function( ListeningTranscribeQuestion value)?  listeningTranscribe,TResult Function( FillBlankQuestion value)?  fillBlank,TResult Function( ArrangeSentenceQuestion value)?  arrangeSentence,TResult Function( MatchingQuestion value)?  matching,TResult Function( UnknownQuestion value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChoosePictureQuestion() when choosePicture != null:
return choosePicture(_that);case MultipleChoiceQuestion() when multipleChoice != null:
return multipleChoice(_that);case ListeningSelectQuestion() when listeningSelect != null:
return listeningSelect(_that);case TypingQuestion() when typing != null:
return typing(_that);case ListeningTranscribeQuestion() when listeningTranscribe != null:
return listeningTranscribe(_that);case FillBlankQuestion() when fillBlank != null:
return fillBlank(_that);case ArrangeSentenceQuestion() when arrangeSentence != null:
return arrangeSentence(_that);case MatchingQuestion() when matching != null:
return matching(_that);case UnknownQuestion() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChoosePictureQuestion value)  choosePicture,required TResult Function( MultipleChoiceQuestion value)  multipleChoice,required TResult Function( ListeningSelectQuestion value)  listeningSelect,required TResult Function( TypingQuestion value)  typing,required TResult Function( ListeningTranscribeQuestion value)  listeningTranscribe,required TResult Function( FillBlankQuestion value)  fillBlank,required TResult Function( ArrangeSentenceQuestion value)  arrangeSentence,required TResult Function( MatchingQuestion value)  matching,required TResult Function( UnknownQuestion value)  unknown,}){
final _that = this;
switch (_that) {
case ChoosePictureQuestion():
return choosePicture(_that);case MultipleChoiceQuestion():
return multipleChoice(_that);case ListeningSelectQuestion():
return listeningSelect(_that);case TypingQuestion():
return typing(_that);case ListeningTranscribeQuestion():
return listeningTranscribe(_that);case FillBlankQuestion():
return fillBlank(_that);case ArrangeSentenceQuestion():
return arrangeSentence(_that);case MatchingQuestion():
return matching(_that);case UnknownQuestion():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChoosePictureQuestion value)?  choosePicture,TResult? Function( MultipleChoiceQuestion value)?  multipleChoice,TResult? Function( ListeningSelectQuestion value)?  listeningSelect,TResult? Function( TypingQuestion value)?  typing,TResult? Function( ListeningTranscribeQuestion value)?  listeningTranscribe,TResult? Function( FillBlankQuestion value)?  fillBlank,TResult? Function( ArrangeSentenceQuestion value)?  arrangeSentence,TResult? Function( MatchingQuestion value)?  matching,TResult? Function( UnknownQuestion value)?  unknown,}){
final _that = this;
switch (_that) {
case ChoosePictureQuestion() when choosePicture != null:
return choosePicture(_that);case MultipleChoiceQuestion() when multipleChoice != null:
return multipleChoice(_that);case ListeningSelectQuestion() when listeningSelect != null:
return listeningSelect(_that);case TypingQuestion() when typing != null:
return typing(_that);case ListeningTranscribeQuestion() when listeningTranscribe != null:
return listeningTranscribe(_that);case FillBlankQuestion() when fillBlank != null:
return fillBlank(_that);case ArrangeSentenceQuestion() when arrangeSentence != null:
return arrangeSentence(_that);case MatchingQuestion() when matching != null:
return matching(_that);case UnknownQuestion() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  String displayText,  int points,  String prompt,  List<PlayChoice> options)?  choosePicture,TResult Function( String id,  String displayText,  int points,  String prompt,  String promptLanguage,  String answerLanguage,  List<PlayChoice> options,  String? imageUrl)?  multipleChoice,TResult Function( String id,  String displayText,  int points,  String audioUrl,  String answerLanguage,  List<PlayChoice> options)?  listeningSelect,TResult Function( String id,  String displayText,  int points,  String prompt,  String promptLanguage,  String answerLanguage,  String? imageUrl)?  typing,TResult Function( String id,  String displayText,  int points,  String audioUrl,  String answerLanguage)?  listeningTranscribe,TResult Function( String id,  String displayText,  int points,  String sentenceLanguage,  String before,  String after,  String? hint)?  fillBlank,TResult Function( String id,  String displayText,  int points,  String sentenceLanguage,  List<PlayChoice> bank,  String? hint)?  arrangeSentence,TResult Function( String id,  String displayText,  int points,  String sourceLanguage,  String targetLanguage,  List<PlayChoice> left,  List<PlayChoice> right)?  matching,TResult Function( String id,  String displayText,  int points)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChoosePictureQuestion() when choosePicture != null:
return choosePicture(_that.id,_that.displayText,_that.points,_that.prompt,_that.options);case MultipleChoiceQuestion() when multipleChoice != null:
return multipleChoice(_that.id,_that.displayText,_that.points,_that.prompt,_that.promptLanguage,_that.answerLanguage,_that.options,_that.imageUrl);case ListeningSelectQuestion() when listeningSelect != null:
return listeningSelect(_that.id,_that.displayText,_that.points,_that.audioUrl,_that.answerLanguage,_that.options);case TypingQuestion() when typing != null:
return typing(_that.id,_that.displayText,_that.points,_that.prompt,_that.promptLanguage,_that.answerLanguage,_that.imageUrl);case ListeningTranscribeQuestion() when listeningTranscribe != null:
return listeningTranscribe(_that.id,_that.displayText,_that.points,_that.audioUrl,_that.answerLanguage);case FillBlankQuestion() when fillBlank != null:
return fillBlank(_that.id,_that.displayText,_that.points,_that.sentenceLanguage,_that.before,_that.after,_that.hint);case ArrangeSentenceQuestion() when arrangeSentence != null:
return arrangeSentence(_that.id,_that.displayText,_that.points,_that.sentenceLanguage,_that.bank,_that.hint);case MatchingQuestion() when matching != null:
return matching(_that.id,_that.displayText,_that.points,_that.sourceLanguage,_that.targetLanguage,_that.left,_that.right);case UnknownQuestion() when unknown != null:
return unknown(_that.id,_that.displayText,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  String displayText,  int points,  String prompt,  List<PlayChoice> options)  choosePicture,required TResult Function( String id,  String displayText,  int points,  String prompt,  String promptLanguage,  String answerLanguage,  List<PlayChoice> options,  String? imageUrl)  multipleChoice,required TResult Function( String id,  String displayText,  int points,  String audioUrl,  String answerLanguage,  List<PlayChoice> options)  listeningSelect,required TResult Function( String id,  String displayText,  int points,  String prompt,  String promptLanguage,  String answerLanguage,  String? imageUrl)  typing,required TResult Function( String id,  String displayText,  int points,  String audioUrl,  String answerLanguage)  listeningTranscribe,required TResult Function( String id,  String displayText,  int points,  String sentenceLanguage,  String before,  String after,  String? hint)  fillBlank,required TResult Function( String id,  String displayText,  int points,  String sentenceLanguage,  List<PlayChoice> bank,  String? hint)  arrangeSentence,required TResult Function( String id,  String displayText,  int points,  String sourceLanguage,  String targetLanguage,  List<PlayChoice> left,  List<PlayChoice> right)  matching,required TResult Function( String id,  String displayText,  int points)  unknown,}) {final _that = this;
switch (_that) {
case ChoosePictureQuestion():
return choosePicture(_that.id,_that.displayText,_that.points,_that.prompt,_that.options);case MultipleChoiceQuestion():
return multipleChoice(_that.id,_that.displayText,_that.points,_that.prompt,_that.promptLanguage,_that.answerLanguage,_that.options,_that.imageUrl);case ListeningSelectQuestion():
return listeningSelect(_that.id,_that.displayText,_that.points,_that.audioUrl,_that.answerLanguage,_that.options);case TypingQuestion():
return typing(_that.id,_that.displayText,_that.points,_that.prompt,_that.promptLanguage,_that.answerLanguage,_that.imageUrl);case ListeningTranscribeQuestion():
return listeningTranscribe(_that.id,_that.displayText,_that.points,_that.audioUrl,_that.answerLanguage);case FillBlankQuestion():
return fillBlank(_that.id,_that.displayText,_that.points,_that.sentenceLanguage,_that.before,_that.after,_that.hint);case ArrangeSentenceQuestion():
return arrangeSentence(_that.id,_that.displayText,_that.points,_that.sentenceLanguage,_that.bank,_that.hint);case MatchingQuestion():
return matching(_that.id,_that.displayText,_that.points,_that.sourceLanguage,_that.targetLanguage,_that.left,_that.right);case UnknownQuestion():
return unknown(_that.id,_that.displayText,_that.points);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  String displayText,  int points,  String prompt,  List<PlayChoice> options)?  choosePicture,TResult? Function( String id,  String displayText,  int points,  String prompt,  String promptLanguage,  String answerLanguage,  List<PlayChoice> options,  String? imageUrl)?  multipleChoice,TResult? Function( String id,  String displayText,  int points,  String audioUrl,  String answerLanguage,  List<PlayChoice> options)?  listeningSelect,TResult? Function( String id,  String displayText,  int points,  String prompt,  String promptLanguage,  String answerLanguage,  String? imageUrl)?  typing,TResult? Function( String id,  String displayText,  int points,  String audioUrl,  String answerLanguage)?  listeningTranscribe,TResult? Function( String id,  String displayText,  int points,  String sentenceLanguage,  String before,  String after,  String? hint)?  fillBlank,TResult? Function( String id,  String displayText,  int points,  String sentenceLanguage,  List<PlayChoice> bank,  String? hint)?  arrangeSentence,TResult? Function( String id,  String displayText,  int points,  String sourceLanguage,  String targetLanguage,  List<PlayChoice> left,  List<PlayChoice> right)?  matching,TResult? Function( String id,  String displayText,  int points)?  unknown,}) {final _that = this;
switch (_that) {
case ChoosePictureQuestion() when choosePicture != null:
return choosePicture(_that.id,_that.displayText,_that.points,_that.prompt,_that.options);case MultipleChoiceQuestion() when multipleChoice != null:
return multipleChoice(_that.id,_that.displayText,_that.points,_that.prompt,_that.promptLanguage,_that.answerLanguage,_that.options,_that.imageUrl);case ListeningSelectQuestion() when listeningSelect != null:
return listeningSelect(_that.id,_that.displayText,_that.points,_that.audioUrl,_that.answerLanguage,_that.options);case TypingQuestion() when typing != null:
return typing(_that.id,_that.displayText,_that.points,_that.prompt,_that.promptLanguage,_that.answerLanguage,_that.imageUrl);case ListeningTranscribeQuestion() when listeningTranscribe != null:
return listeningTranscribe(_that.id,_that.displayText,_that.points,_that.audioUrl,_that.answerLanguage);case FillBlankQuestion() when fillBlank != null:
return fillBlank(_that.id,_that.displayText,_that.points,_that.sentenceLanguage,_that.before,_that.after,_that.hint);case ArrangeSentenceQuestion() when arrangeSentence != null:
return arrangeSentence(_that.id,_that.displayText,_that.points,_that.sentenceLanguage,_that.bank,_that.hint);case MatchingQuestion() when matching != null:
return matching(_that.id,_that.displayText,_that.points,_that.sourceLanguage,_that.targetLanguage,_that.left,_that.right);case UnknownQuestion() when unknown != null:
return unknown(_that.id,_that.displayText,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ChoosePictureQuestion implements PlayQuestion {
  const ChoosePictureQuestion({required this.id, required this.displayText, required this.points, required this.prompt, required final  List<PlayChoice> options, final  String? $type}): _options = options,$type = $type ?? 'choose_picture';
  factory ChoosePictureQuestion.fromJson(Map<String, dynamic> json) => _$ChoosePictureQuestionFromJson(json);

@override final  String id;
@override final  String displayText;
@override final  int points;
 final  String prompt;
 final  List<PlayChoice> _options;
 List<PlayChoice> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChoosePictureQuestionCopyWith<ChoosePictureQuestion> get copyWith => _$ChoosePictureQuestionCopyWithImpl<ChoosePictureQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChoosePictureQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChoosePictureQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.points, points) || other.points == points)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayText,points,prompt,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'PlayQuestion.choosePicture(id: $id, displayText: $displayText, points: $points, prompt: $prompt, options: $options)';
}


}

/// @nodoc
abstract mixin class $ChoosePictureQuestionCopyWith<$Res> implements $PlayQuestionCopyWith<$Res> {
  factory $ChoosePictureQuestionCopyWith(ChoosePictureQuestion value, $Res Function(ChoosePictureQuestion) _then) = _$ChoosePictureQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayText, int points, String prompt, List<PlayChoice> options
});




}
/// @nodoc
class _$ChoosePictureQuestionCopyWithImpl<$Res>
    implements $ChoosePictureQuestionCopyWith<$Res> {
  _$ChoosePictureQuestionCopyWithImpl(this._self, this._then);

  final ChoosePictureQuestion _self;
  final $Res Function(ChoosePictureQuestion) _then;

/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayText = null,Object? points = null,Object? prompt = null,Object? options = null,}) {
  return _then(ChoosePictureQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<PlayChoice>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MultipleChoiceQuestion implements PlayQuestion {
  const MultipleChoiceQuestion({required this.id, required this.displayText, required this.points, required this.prompt, required this.promptLanguage, required this.answerLanguage, required final  List<PlayChoice> options, this.imageUrl, final  String? $type}): _options = options,$type = $type ?? 'multiple_choice';
  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) => _$MultipleChoiceQuestionFromJson(json);

@override final  String id;
@override final  String displayText;
@override final  int points;
 final  String prompt;
 final  String promptLanguage;
 final  String answerLanguage;
 final  List<PlayChoice> _options;
 List<PlayChoice> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  String? imageUrl;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultipleChoiceQuestionCopyWith<MultipleChoiceQuestion> get copyWith => _$MultipleChoiceQuestionCopyWithImpl<MultipleChoiceQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MultipleChoiceQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultipleChoiceQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.points, points) || other.points == points)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.promptLanguage, promptLanguage) || other.promptLanguage == promptLanguage)&&(identical(other.answerLanguage, answerLanguage) || other.answerLanguage == answerLanguage)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayText,points,prompt,promptLanguage,answerLanguage,const DeepCollectionEquality().hash(_options),imageUrl);

@override
String toString() {
  return 'PlayQuestion.multipleChoice(id: $id, displayText: $displayText, points: $points, prompt: $prompt, promptLanguage: $promptLanguage, answerLanguage: $answerLanguage, options: $options, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $MultipleChoiceQuestionCopyWith<$Res> implements $PlayQuestionCopyWith<$Res> {
  factory $MultipleChoiceQuestionCopyWith(MultipleChoiceQuestion value, $Res Function(MultipleChoiceQuestion) _then) = _$MultipleChoiceQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayText, int points, String prompt, String promptLanguage, String answerLanguage, List<PlayChoice> options, String? imageUrl
});




}
/// @nodoc
class _$MultipleChoiceQuestionCopyWithImpl<$Res>
    implements $MultipleChoiceQuestionCopyWith<$Res> {
  _$MultipleChoiceQuestionCopyWithImpl(this._self, this._then);

  final MultipleChoiceQuestion _self;
  final $Res Function(MultipleChoiceQuestion) _then;

/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayText = null,Object? points = null,Object? prompt = null,Object? promptLanguage = null,Object? answerLanguage = null,Object? options = null,Object? imageUrl = freezed,}) {
  return _then(MultipleChoiceQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,promptLanguage: null == promptLanguage ? _self.promptLanguage : promptLanguage // ignore: cast_nullable_to_non_nullable
as String,answerLanguage: null == answerLanguage ? _self.answerLanguage : answerLanguage // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<PlayChoice>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ListeningSelectQuestion implements PlayQuestion {
  const ListeningSelectQuestion({required this.id, required this.displayText, required this.points, required this.audioUrl, required this.answerLanguage, required final  List<PlayChoice> options, final  String? $type}): _options = options,$type = $type ?? 'listening_select';
  factory ListeningSelectQuestion.fromJson(Map<String, dynamic> json) => _$ListeningSelectQuestionFromJson(json);

@override final  String id;
@override final  String displayText;
@override final  int points;
 final  String audioUrl;
 final  String answerLanguage;
 final  List<PlayChoice> _options;
 List<PlayChoice> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListeningSelectQuestionCopyWith<ListeningSelectQuestion> get copyWith => _$ListeningSelectQuestionCopyWithImpl<ListeningSelectQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListeningSelectQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListeningSelectQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.points, points) || other.points == points)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.answerLanguage, answerLanguage) || other.answerLanguage == answerLanguage)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayText,points,audioUrl,answerLanguage,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'PlayQuestion.listeningSelect(id: $id, displayText: $displayText, points: $points, audioUrl: $audioUrl, answerLanguage: $answerLanguage, options: $options)';
}


}

/// @nodoc
abstract mixin class $ListeningSelectQuestionCopyWith<$Res> implements $PlayQuestionCopyWith<$Res> {
  factory $ListeningSelectQuestionCopyWith(ListeningSelectQuestion value, $Res Function(ListeningSelectQuestion) _then) = _$ListeningSelectQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayText, int points, String audioUrl, String answerLanguage, List<PlayChoice> options
});




}
/// @nodoc
class _$ListeningSelectQuestionCopyWithImpl<$Res>
    implements $ListeningSelectQuestionCopyWith<$Res> {
  _$ListeningSelectQuestionCopyWithImpl(this._self, this._then);

  final ListeningSelectQuestion _self;
  final $Res Function(ListeningSelectQuestion) _then;

/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayText = null,Object? points = null,Object? audioUrl = null,Object? answerLanguage = null,Object? options = null,}) {
  return _then(ListeningSelectQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,answerLanguage: null == answerLanguage ? _self.answerLanguage : answerLanguage // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<PlayChoice>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TypingQuestion implements PlayQuestion {
  const TypingQuestion({required this.id, required this.displayText, required this.points, required this.prompt, required this.promptLanguage, required this.answerLanguage, this.imageUrl, final  String? $type}): $type = $type ?? 'typing';
  factory TypingQuestion.fromJson(Map<String, dynamic> json) => _$TypingQuestionFromJson(json);

@override final  String id;
@override final  String displayText;
@override final  int points;
 final  String prompt;
 final  String promptLanguage;
 final  String answerLanguage;
 final  String? imageUrl;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TypingQuestionCopyWith<TypingQuestion> get copyWith => _$TypingQuestionCopyWithImpl<TypingQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TypingQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypingQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.points, points) || other.points == points)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.promptLanguage, promptLanguage) || other.promptLanguage == promptLanguage)&&(identical(other.answerLanguage, answerLanguage) || other.answerLanguage == answerLanguage)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayText,points,prompt,promptLanguage,answerLanguage,imageUrl);

@override
String toString() {
  return 'PlayQuestion.typing(id: $id, displayText: $displayText, points: $points, prompt: $prompt, promptLanguage: $promptLanguage, answerLanguage: $answerLanguage, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $TypingQuestionCopyWith<$Res> implements $PlayQuestionCopyWith<$Res> {
  factory $TypingQuestionCopyWith(TypingQuestion value, $Res Function(TypingQuestion) _then) = _$TypingQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayText, int points, String prompt, String promptLanguage, String answerLanguage, String? imageUrl
});




}
/// @nodoc
class _$TypingQuestionCopyWithImpl<$Res>
    implements $TypingQuestionCopyWith<$Res> {
  _$TypingQuestionCopyWithImpl(this._self, this._then);

  final TypingQuestion _self;
  final $Res Function(TypingQuestion) _then;

/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayText = null,Object? points = null,Object? prompt = null,Object? promptLanguage = null,Object? answerLanguage = null,Object? imageUrl = freezed,}) {
  return _then(TypingQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,promptLanguage: null == promptLanguage ? _self.promptLanguage : promptLanguage // ignore: cast_nullable_to_non_nullable
as String,answerLanguage: null == answerLanguage ? _self.answerLanguage : answerLanguage // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ListeningTranscribeQuestion implements PlayQuestion {
  const ListeningTranscribeQuestion({required this.id, required this.displayText, required this.points, required this.audioUrl, required this.answerLanguage, final  String? $type}): $type = $type ?? 'listening_transcribe';
  factory ListeningTranscribeQuestion.fromJson(Map<String, dynamic> json) => _$ListeningTranscribeQuestionFromJson(json);

@override final  String id;
@override final  String displayText;
@override final  int points;
 final  String audioUrl;
 final  String answerLanguage;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListeningTranscribeQuestionCopyWith<ListeningTranscribeQuestion> get copyWith => _$ListeningTranscribeQuestionCopyWithImpl<ListeningTranscribeQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListeningTranscribeQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListeningTranscribeQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.points, points) || other.points == points)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.answerLanguage, answerLanguage) || other.answerLanguage == answerLanguage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayText,points,audioUrl,answerLanguage);

@override
String toString() {
  return 'PlayQuestion.listeningTranscribe(id: $id, displayText: $displayText, points: $points, audioUrl: $audioUrl, answerLanguage: $answerLanguage)';
}


}

/// @nodoc
abstract mixin class $ListeningTranscribeQuestionCopyWith<$Res> implements $PlayQuestionCopyWith<$Res> {
  factory $ListeningTranscribeQuestionCopyWith(ListeningTranscribeQuestion value, $Res Function(ListeningTranscribeQuestion) _then) = _$ListeningTranscribeQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayText, int points, String audioUrl, String answerLanguage
});




}
/// @nodoc
class _$ListeningTranscribeQuestionCopyWithImpl<$Res>
    implements $ListeningTranscribeQuestionCopyWith<$Res> {
  _$ListeningTranscribeQuestionCopyWithImpl(this._self, this._then);

  final ListeningTranscribeQuestion _self;
  final $Res Function(ListeningTranscribeQuestion) _then;

/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayText = null,Object? points = null,Object? audioUrl = null,Object? answerLanguage = null,}) {
  return _then(ListeningTranscribeQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,answerLanguage: null == answerLanguage ? _self.answerLanguage : answerLanguage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class FillBlankQuestion implements PlayQuestion {
  const FillBlankQuestion({required this.id, required this.displayText, required this.points, required this.sentenceLanguage, required this.before, required this.after, this.hint, final  String? $type}): $type = $type ?? 'fill_blank';
  factory FillBlankQuestion.fromJson(Map<String, dynamic> json) => _$FillBlankQuestionFromJson(json);

@override final  String id;
@override final  String displayText;
@override final  int points;
 final  String sentenceLanguage;
 final  String before;
 final  String after;
 final  String? hint;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FillBlankQuestionCopyWith<FillBlankQuestion> get copyWith => _$FillBlankQuestionCopyWithImpl<FillBlankQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FillBlankQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FillBlankQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.points, points) || other.points == points)&&(identical(other.sentenceLanguage, sentenceLanguage) || other.sentenceLanguage == sentenceLanguage)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after)&&(identical(other.hint, hint) || other.hint == hint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayText,points,sentenceLanguage,before,after,hint);

@override
String toString() {
  return 'PlayQuestion.fillBlank(id: $id, displayText: $displayText, points: $points, sentenceLanguage: $sentenceLanguage, before: $before, after: $after, hint: $hint)';
}


}

/// @nodoc
abstract mixin class $FillBlankQuestionCopyWith<$Res> implements $PlayQuestionCopyWith<$Res> {
  factory $FillBlankQuestionCopyWith(FillBlankQuestion value, $Res Function(FillBlankQuestion) _then) = _$FillBlankQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayText, int points, String sentenceLanguage, String before, String after, String? hint
});




}
/// @nodoc
class _$FillBlankQuestionCopyWithImpl<$Res>
    implements $FillBlankQuestionCopyWith<$Res> {
  _$FillBlankQuestionCopyWithImpl(this._self, this._then);

  final FillBlankQuestion _self;
  final $Res Function(FillBlankQuestion) _then;

/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayText = null,Object? points = null,Object? sentenceLanguage = null,Object? before = null,Object? after = null,Object? hint = freezed,}) {
  return _then(FillBlankQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,sentenceLanguage: null == sentenceLanguage ? _self.sentenceLanguage : sentenceLanguage // ignore: cast_nullable_to_non_nullable
as String,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ArrangeSentenceQuestion implements PlayQuestion {
  const ArrangeSentenceQuestion({required this.id, required this.displayText, required this.points, required this.sentenceLanguage, required final  List<PlayChoice> bank, this.hint, final  String? $type}): _bank = bank,$type = $type ?? 'arrange_sentence';
  factory ArrangeSentenceQuestion.fromJson(Map<String, dynamic> json) => _$ArrangeSentenceQuestionFromJson(json);

@override final  String id;
@override final  String displayText;
@override final  int points;
 final  String sentenceLanguage;
 final  List<PlayChoice> _bank;
 List<PlayChoice> get bank {
  if (_bank is EqualUnmodifiableListView) return _bank;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bank);
}

 final  String? hint;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArrangeSentenceQuestionCopyWith<ArrangeSentenceQuestion> get copyWith => _$ArrangeSentenceQuestionCopyWithImpl<ArrangeSentenceQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArrangeSentenceQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArrangeSentenceQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.points, points) || other.points == points)&&(identical(other.sentenceLanguage, sentenceLanguage) || other.sentenceLanguage == sentenceLanguage)&&const DeepCollectionEquality().equals(other._bank, _bank)&&(identical(other.hint, hint) || other.hint == hint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayText,points,sentenceLanguage,const DeepCollectionEquality().hash(_bank),hint);

@override
String toString() {
  return 'PlayQuestion.arrangeSentence(id: $id, displayText: $displayText, points: $points, sentenceLanguage: $sentenceLanguage, bank: $bank, hint: $hint)';
}


}

/// @nodoc
abstract mixin class $ArrangeSentenceQuestionCopyWith<$Res> implements $PlayQuestionCopyWith<$Res> {
  factory $ArrangeSentenceQuestionCopyWith(ArrangeSentenceQuestion value, $Res Function(ArrangeSentenceQuestion) _then) = _$ArrangeSentenceQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayText, int points, String sentenceLanguage, List<PlayChoice> bank, String? hint
});




}
/// @nodoc
class _$ArrangeSentenceQuestionCopyWithImpl<$Res>
    implements $ArrangeSentenceQuestionCopyWith<$Res> {
  _$ArrangeSentenceQuestionCopyWithImpl(this._self, this._then);

  final ArrangeSentenceQuestion _self;
  final $Res Function(ArrangeSentenceQuestion) _then;

/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayText = null,Object? points = null,Object? sentenceLanguage = null,Object? bank = null,Object? hint = freezed,}) {
  return _then(ArrangeSentenceQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,sentenceLanguage: null == sentenceLanguage ? _self.sentenceLanguage : sentenceLanguage // ignore: cast_nullable_to_non_nullable
as String,bank: null == bank ? _self._bank : bank // ignore: cast_nullable_to_non_nullable
as List<PlayChoice>,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MatchingQuestion implements PlayQuestion {
  const MatchingQuestion({required this.id, required this.displayText, required this.points, required this.sourceLanguage, required this.targetLanguage, required final  List<PlayChoice> left, required final  List<PlayChoice> right, final  String? $type}): _left = left,_right = right,$type = $type ?? 'matching';
  factory MatchingQuestion.fromJson(Map<String, dynamic> json) => _$MatchingQuestionFromJson(json);

@override final  String id;
@override final  String displayText;
@override final  int points;
 final  String sourceLanguage;
 final  String targetLanguage;
 final  List<PlayChoice> _left;
 List<PlayChoice> get left {
  if (_left is EqualUnmodifiableListView) return _left;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_left);
}

 final  List<PlayChoice> _right;
 List<PlayChoice> get right {
  if (_right is EqualUnmodifiableListView) return _right;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_right);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchingQuestionCopyWith<MatchingQuestion> get copyWith => _$MatchingQuestionCopyWithImpl<MatchingQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchingQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchingQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.points, points) || other.points == points)&&(identical(other.sourceLanguage, sourceLanguage) || other.sourceLanguage == sourceLanguage)&&(identical(other.targetLanguage, targetLanguage) || other.targetLanguage == targetLanguage)&&const DeepCollectionEquality().equals(other._left, _left)&&const DeepCollectionEquality().equals(other._right, _right));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayText,points,sourceLanguage,targetLanguage,const DeepCollectionEquality().hash(_left),const DeepCollectionEquality().hash(_right));

@override
String toString() {
  return 'PlayQuestion.matching(id: $id, displayText: $displayText, points: $points, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, left: $left, right: $right)';
}


}

/// @nodoc
abstract mixin class $MatchingQuestionCopyWith<$Res> implements $PlayQuestionCopyWith<$Res> {
  factory $MatchingQuestionCopyWith(MatchingQuestion value, $Res Function(MatchingQuestion) _then) = _$MatchingQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayText, int points, String sourceLanguage, String targetLanguage, List<PlayChoice> left, List<PlayChoice> right
});




}
/// @nodoc
class _$MatchingQuestionCopyWithImpl<$Res>
    implements $MatchingQuestionCopyWith<$Res> {
  _$MatchingQuestionCopyWithImpl(this._self, this._then);

  final MatchingQuestion _self;
  final $Res Function(MatchingQuestion) _then;

/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayText = null,Object? points = null,Object? sourceLanguage = null,Object? targetLanguage = null,Object? left = null,Object? right = null,}) {
  return _then(MatchingQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,sourceLanguage: null == sourceLanguage ? _self.sourceLanguage : sourceLanguage // ignore: cast_nullable_to_non_nullable
as String,targetLanguage: null == targetLanguage ? _self.targetLanguage : targetLanguage // ignore: cast_nullable_to_non_nullable
as String,left: null == left ? _self._left : left // ignore: cast_nullable_to_non_nullable
as List<PlayChoice>,right: null == right ? _self._right : right // ignore: cast_nullable_to_non_nullable
as List<PlayChoice>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class UnknownQuestion implements PlayQuestion {
  const UnknownQuestion({required this.id, required this.displayText, this.points = 0, final  String? $type}): $type = $type ?? 'unknown';
  factory UnknownQuestion.fromJson(Map<String, dynamic> json) => _$UnknownQuestionFromJson(json);

@override final  String id;
@override final  String displayText;
@override@JsonKey() final  int points;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownQuestionCopyWith<UnknownQuestion> get copyWith => _$UnknownQuestionCopyWithImpl<UnknownQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnknownQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.points, points) || other.points == points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayText,points);

@override
String toString() {
  return 'PlayQuestion.unknown(id: $id, displayText: $displayText, points: $points)';
}


}

/// @nodoc
abstract mixin class $UnknownQuestionCopyWith<$Res> implements $PlayQuestionCopyWith<$Res> {
  factory $UnknownQuestionCopyWith(UnknownQuestion value, $Res Function(UnknownQuestion) _then) = _$UnknownQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayText, int points
});




}
/// @nodoc
class _$UnknownQuestionCopyWithImpl<$Res>
    implements $UnknownQuestionCopyWith<$Res> {
  _$UnknownQuestionCopyWithImpl(this._self, this._then);

  final UnknownQuestion _self;
  final $Res Function(UnknownQuestion) _then;

/// Create a copy of PlayQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayText = null,Object? points = null,}) {
  return _then(UnknownQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
