// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learn_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpecializationSummary {

@JsonKey(name: '_id') String get id; String get name; int get publishedCourseCount; String? get iconUrl;
/// Create a copy of SpecializationSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecializationSummaryCopyWith<SpecializationSummary> get copyWith => _$SpecializationSummaryCopyWithImpl<SpecializationSummary>(this as SpecializationSummary, _$identity);

  /// Serializes this SpecializationSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecializationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.publishedCourseCount, publishedCourseCount) || other.publishedCourseCount == publishedCourseCount)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,publishedCourseCount,iconUrl);

@override
String toString() {
  return 'SpecializationSummary(id: $id, name: $name, publishedCourseCount: $publishedCourseCount, iconUrl: $iconUrl)';
}


}

/// @nodoc
abstract mixin class $SpecializationSummaryCopyWith<$Res>  {
  factory $SpecializationSummaryCopyWith(SpecializationSummary value, $Res Function(SpecializationSummary) _then) = _$SpecializationSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String name, int publishedCourseCount, String? iconUrl
});




}
/// @nodoc
class _$SpecializationSummaryCopyWithImpl<$Res>
    implements $SpecializationSummaryCopyWith<$Res> {
  _$SpecializationSummaryCopyWithImpl(this._self, this._then);

  final SpecializationSummary _self;
  final $Res Function(SpecializationSummary) _then;

/// Create a copy of SpecializationSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? publishedCourseCount = null,Object? iconUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,publishedCourseCount: null == publishedCourseCount ? _self.publishedCourseCount : publishedCourseCount // ignore: cast_nullable_to_non_nullable
as int,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpecializationSummary].
extension SpecializationSummaryPatterns on SpecializationSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpecializationSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpecializationSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpecializationSummary value)  $default,){
final _that = this;
switch (_that) {
case _SpecializationSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpecializationSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SpecializationSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String name,  int publishedCourseCount,  String? iconUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpecializationSummary() when $default != null:
return $default(_that.id,_that.name,_that.publishedCourseCount,_that.iconUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String name,  int publishedCourseCount,  String? iconUrl)  $default,) {final _that = this;
switch (_that) {
case _SpecializationSummary():
return $default(_that.id,_that.name,_that.publishedCourseCount,_that.iconUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String name,  int publishedCourseCount,  String? iconUrl)?  $default,) {final _that = this;
switch (_that) {
case _SpecializationSummary() when $default != null:
return $default(_that.id,_that.name,_that.publishedCourseCount,_that.iconUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpecializationSummary implements SpecializationSummary {
  const _SpecializationSummary({@JsonKey(name: '_id') required this.id, required this.name, required this.publishedCourseCount, this.iconUrl});
  factory _SpecializationSummary.fromJson(Map<String, dynamic> json) => _$SpecializationSummaryFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String name;
@override final  int publishedCourseCount;
@override final  String? iconUrl;

/// Create a copy of SpecializationSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpecializationSummaryCopyWith<_SpecializationSummary> get copyWith => __$SpecializationSummaryCopyWithImpl<_SpecializationSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpecializationSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpecializationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.publishedCourseCount, publishedCourseCount) || other.publishedCourseCount == publishedCourseCount)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,publishedCourseCount,iconUrl);

@override
String toString() {
  return 'SpecializationSummary(id: $id, name: $name, publishedCourseCount: $publishedCourseCount, iconUrl: $iconUrl)';
}


}

/// @nodoc
abstract mixin class _$SpecializationSummaryCopyWith<$Res> implements $SpecializationSummaryCopyWith<$Res> {
  factory _$SpecializationSummaryCopyWith(_SpecializationSummary value, $Res Function(_SpecializationSummary) _then) = __$SpecializationSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String name, int publishedCourseCount, String? iconUrl
});




}
/// @nodoc
class __$SpecializationSummaryCopyWithImpl<$Res>
    implements _$SpecializationSummaryCopyWith<$Res> {
  __$SpecializationSummaryCopyWithImpl(this._self, this._then);

  final _SpecializationSummary _self;
  final $Res Function(_SpecializationSummary) _then;

/// Create a copy of SpecializationSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? publishedCourseCount = null,Object? iconUrl = freezed,}) {
  return _then(_SpecializationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,publishedCourseCount: null == publishedCourseCount ? _self.publishedCourseCount : publishedCourseCount // ignore: cast_nullable_to_non_nullable
as int,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LanguageSummary {

 String get code; int get publishedCourseCount;
/// Create a copy of LanguageSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LanguageSummaryCopyWith<LanguageSummary> get copyWith => _$LanguageSummaryCopyWithImpl<LanguageSummary>(this as LanguageSummary, _$identity);

  /// Serializes this LanguageSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LanguageSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.publishedCourseCount, publishedCourseCount) || other.publishedCourseCount == publishedCourseCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,publishedCourseCount);

@override
String toString() {
  return 'LanguageSummary(code: $code, publishedCourseCount: $publishedCourseCount)';
}


}

/// @nodoc
abstract mixin class $LanguageSummaryCopyWith<$Res>  {
  factory $LanguageSummaryCopyWith(LanguageSummary value, $Res Function(LanguageSummary) _then) = _$LanguageSummaryCopyWithImpl;
@useResult
$Res call({
 String code, int publishedCourseCount
});




}
/// @nodoc
class _$LanguageSummaryCopyWithImpl<$Res>
    implements $LanguageSummaryCopyWith<$Res> {
  _$LanguageSummaryCopyWithImpl(this._self, this._then);

  final LanguageSummary _self;
  final $Res Function(LanguageSummary) _then;

/// Create a copy of LanguageSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? publishedCourseCount = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,publishedCourseCount: null == publishedCourseCount ? _self.publishedCourseCount : publishedCourseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LanguageSummary].
extension LanguageSummaryPatterns on LanguageSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LanguageSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LanguageSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LanguageSummary value)  $default,){
final _that = this;
switch (_that) {
case _LanguageSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LanguageSummary value)?  $default,){
final _that = this;
switch (_that) {
case _LanguageSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int publishedCourseCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LanguageSummary() when $default != null:
return $default(_that.code,_that.publishedCourseCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int publishedCourseCount)  $default,) {final _that = this;
switch (_that) {
case _LanguageSummary():
return $default(_that.code,_that.publishedCourseCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int publishedCourseCount)?  $default,) {final _that = this;
switch (_that) {
case _LanguageSummary() when $default != null:
return $default(_that.code,_that.publishedCourseCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LanguageSummary implements LanguageSummary {
  const _LanguageSummary({required this.code, required this.publishedCourseCount});
  factory _LanguageSummary.fromJson(Map<String, dynamic> json) => _$LanguageSummaryFromJson(json);

@override final  String code;
@override final  int publishedCourseCount;

/// Create a copy of LanguageSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LanguageSummaryCopyWith<_LanguageSummary> get copyWith => __$LanguageSummaryCopyWithImpl<_LanguageSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LanguageSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LanguageSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.publishedCourseCount, publishedCourseCount) || other.publishedCourseCount == publishedCourseCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,publishedCourseCount);

@override
String toString() {
  return 'LanguageSummary(code: $code, publishedCourseCount: $publishedCourseCount)';
}


}

/// @nodoc
abstract mixin class _$LanguageSummaryCopyWith<$Res> implements $LanguageSummaryCopyWith<$Res> {
  factory _$LanguageSummaryCopyWith(_LanguageSummary value, $Res Function(_LanguageSummary) _then) = __$LanguageSummaryCopyWithImpl;
@override @useResult
$Res call({
 String code, int publishedCourseCount
});




}
/// @nodoc
class __$LanguageSummaryCopyWithImpl<$Res>
    implements _$LanguageSummaryCopyWith<$Res> {
  __$LanguageSummaryCopyWithImpl(this._self, this._then);

  final _LanguageSummary _self;
  final $Res Function(_LanguageSummary) _then;

/// Create a copy of LanguageSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? publishedCourseCount = null,}) {
  return _then(_LanguageSummary(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,publishedCourseCount: null == publishedCourseCount ? _self.publishedCourseCount : publishedCourseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Progress {

 int get completedExercises; int get totalExercises; int get percent;
/// Create a copy of Progress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressCopyWith<Progress> get copyWith => _$ProgressCopyWithImpl<Progress>(this as Progress, _$identity);

  /// Serializes this Progress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Progress&&(identical(other.completedExercises, completedExercises) || other.completedExercises == completedExercises)&&(identical(other.totalExercises, totalExercises) || other.totalExercises == totalExercises)&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,completedExercises,totalExercises,percent);

@override
String toString() {
  return 'Progress(completedExercises: $completedExercises, totalExercises: $totalExercises, percent: $percent)';
}


}

/// @nodoc
abstract mixin class $ProgressCopyWith<$Res>  {
  factory $ProgressCopyWith(Progress value, $Res Function(Progress) _then) = _$ProgressCopyWithImpl;
@useResult
$Res call({
 int completedExercises, int totalExercises, int percent
});




}
/// @nodoc
class _$ProgressCopyWithImpl<$Res>
    implements $ProgressCopyWith<$Res> {
  _$ProgressCopyWithImpl(this._self, this._then);

  final Progress _self;
  final $Res Function(Progress) _then;

/// Create a copy of Progress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completedExercises = null,Object? totalExercises = null,Object? percent = null,}) {
  return _then(_self.copyWith(
completedExercises: null == completedExercises ? _self.completedExercises : completedExercises // ignore: cast_nullable_to_non_nullable
as int,totalExercises: null == totalExercises ? _self.totalExercises : totalExercises // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Progress].
extension ProgressPatterns on Progress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Progress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Progress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Progress value)  $default,){
final _that = this;
switch (_that) {
case _Progress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Progress value)?  $default,){
final _that = this;
switch (_that) {
case _Progress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int completedExercises,  int totalExercises,  int percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Progress() when $default != null:
return $default(_that.completedExercises,_that.totalExercises,_that.percent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int completedExercises,  int totalExercises,  int percent)  $default,) {final _that = this;
switch (_that) {
case _Progress():
return $default(_that.completedExercises,_that.totalExercises,_that.percent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int completedExercises,  int totalExercises,  int percent)?  $default,) {final _that = this;
switch (_that) {
case _Progress() when $default != null:
return $default(_that.completedExercises,_that.totalExercises,_that.percent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Progress extends Progress {
  const _Progress({required this.completedExercises, required this.totalExercises, required this.percent}): super._();
  factory _Progress.fromJson(Map<String, dynamic> json) => _$ProgressFromJson(json);

@override final  int completedExercises;
@override final  int totalExercises;
@override final  int percent;

/// Create a copy of Progress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressCopyWith<_Progress> get copyWith => __$ProgressCopyWithImpl<_Progress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Progress&&(identical(other.completedExercises, completedExercises) || other.completedExercises == completedExercises)&&(identical(other.totalExercises, totalExercises) || other.totalExercises == totalExercises)&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,completedExercises,totalExercises,percent);

@override
String toString() {
  return 'Progress(completedExercises: $completedExercises, totalExercises: $totalExercises, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$ProgressCopyWith<$Res> implements $ProgressCopyWith<$Res> {
  factory _$ProgressCopyWith(_Progress value, $Res Function(_Progress) _then) = __$ProgressCopyWithImpl;
@override @useResult
$Res call({
 int completedExercises, int totalExercises, int percent
});




}
/// @nodoc
class __$ProgressCopyWithImpl<$Res>
    implements _$ProgressCopyWith<$Res> {
  __$ProgressCopyWithImpl(this._self, this._then);

  final _Progress _self;
  final $Res Function(_Progress) _then;

/// Create a copy of Progress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completedExercises = null,Object? totalExercises = null,Object? percent = null,}) {
  return _then(_Progress(
completedExercises: null == completedExercises ? _self.completedExercises : completedExercises // ignore: cast_nullable_to_non_nullable
as int,totalExercises: null == totalExercises ? _self.totalExercises : totalExercises // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CourseSummary {

@JsonKey(name: '_id') String get id; String get specializationId; String get specializationName; String get name; String get sourceLanguage; String get targetLanguage; int get unitCount; int get exerciseCount; String? get description;/// Absolute MinIO URL built from the current `MINIO_PUBLIC_ENDPOINT`.
 String? get thumbnailUrl;/// Always false for teachers and admins.
 bool get isEnrolled; DateTime? get enrolledAt;/// Students only. Where Continue goes: the first exercise not completed
/// yet; both null once everything is done.
 Progress? get progress; String? get nextUnitId; String? get nextExerciseId; DateTime? get lastActivityAt;
/// Create a copy of CourseSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseSummaryCopyWith<CourseSummary> get copyWith => _$CourseSummaryCopyWithImpl<CourseSummary>(this as CourseSummary, _$identity);

  /// Serializes this CourseSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.specializationId, specializationId) || other.specializationId == specializationId)&&(identical(other.specializationName, specializationName) || other.specializationName == specializationName)&&(identical(other.name, name) || other.name == name)&&(identical(other.sourceLanguage, sourceLanguage) || other.sourceLanguage == sourceLanguage)&&(identical(other.targetLanguage, targetLanguage) || other.targetLanguage == targetLanguage)&&(identical(other.unitCount, unitCount) || other.unitCount == unitCount)&&(identical(other.exerciseCount, exerciseCount) || other.exerciseCount == exerciseCount)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isEnrolled, isEnrolled) || other.isEnrolled == isEnrolled)&&(identical(other.enrolledAt, enrolledAt) || other.enrolledAt == enrolledAt)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.nextUnitId, nextUnitId) || other.nextUnitId == nextUnitId)&&(identical(other.nextExerciseId, nextExerciseId) || other.nextExerciseId == nextExerciseId)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,specializationId,specializationName,name,sourceLanguage,targetLanguage,unitCount,exerciseCount,description,thumbnailUrl,isEnrolled,enrolledAt,progress,nextUnitId,nextExerciseId,lastActivityAt);

@override
String toString() {
  return 'CourseSummary(id: $id, specializationId: $specializationId, specializationName: $specializationName, name: $name, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, unitCount: $unitCount, exerciseCount: $exerciseCount, description: $description, thumbnailUrl: $thumbnailUrl, isEnrolled: $isEnrolled, enrolledAt: $enrolledAt, progress: $progress, nextUnitId: $nextUnitId, nextExerciseId: $nextExerciseId, lastActivityAt: $lastActivityAt)';
}


}

/// @nodoc
abstract mixin class $CourseSummaryCopyWith<$Res>  {
  factory $CourseSummaryCopyWith(CourseSummary value, $Res Function(CourseSummary) _then) = _$CourseSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String specializationId, String specializationName, String name, String sourceLanguage, String targetLanguage, int unitCount, int exerciseCount, String? description, String? thumbnailUrl, bool isEnrolled, DateTime? enrolledAt, Progress? progress, String? nextUnitId, String? nextExerciseId, DateTime? lastActivityAt
});


$ProgressCopyWith<$Res>? get progress;

}
/// @nodoc
class _$CourseSummaryCopyWithImpl<$Res>
    implements $CourseSummaryCopyWith<$Res> {
  _$CourseSummaryCopyWithImpl(this._self, this._then);

  final CourseSummary _self;
  final $Res Function(CourseSummary) _then;

/// Create a copy of CourseSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? specializationId = null,Object? specializationName = null,Object? name = null,Object? sourceLanguage = null,Object? targetLanguage = null,Object? unitCount = null,Object? exerciseCount = null,Object? description = freezed,Object? thumbnailUrl = freezed,Object? isEnrolled = null,Object? enrolledAt = freezed,Object? progress = freezed,Object? nextUnitId = freezed,Object? nextExerciseId = freezed,Object? lastActivityAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,specializationId: null == specializationId ? _self.specializationId : specializationId // ignore: cast_nullable_to_non_nullable
as String,specializationName: null == specializationName ? _self.specializationName : specializationName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sourceLanguage: null == sourceLanguage ? _self.sourceLanguage : sourceLanguage // ignore: cast_nullable_to_non_nullable
as String,targetLanguage: null == targetLanguage ? _self.targetLanguage : targetLanguage // ignore: cast_nullable_to_non_nullable
as String,unitCount: null == unitCount ? _self.unitCount : unitCount // ignore: cast_nullable_to_non_nullable
as int,exerciseCount: null == exerciseCount ? _self.exerciseCount : exerciseCount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isEnrolled: null == isEnrolled ? _self.isEnrolled : isEnrolled // ignore: cast_nullable_to_non_nullable
as bool,enrolledAt: freezed == enrolledAt ? _self.enrolledAt : enrolledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,nextUnitId: freezed == nextUnitId ? _self.nextUnitId : nextUnitId // ignore: cast_nullable_to_non_nullable
as String?,nextExerciseId: freezed == nextExerciseId ? _self.nextExerciseId : nextExerciseId // ignore: cast_nullable_to_non_nullable
as String?,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of CourseSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $ProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// Adds pattern-matching-related methods to [CourseSummary].
extension CourseSummaryPatterns on CourseSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseSummary value)  $default,){
final _that = this;
switch (_that) {
case _CourseSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CourseSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String specializationId,  String specializationName,  String name,  String sourceLanguage,  String targetLanguage,  int unitCount,  int exerciseCount,  String? description,  String? thumbnailUrl,  bool isEnrolled,  DateTime? enrolledAt,  Progress? progress,  String? nextUnitId,  String? nextExerciseId,  DateTime? lastActivityAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseSummary() when $default != null:
return $default(_that.id,_that.specializationId,_that.specializationName,_that.name,_that.sourceLanguage,_that.targetLanguage,_that.unitCount,_that.exerciseCount,_that.description,_that.thumbnailUrl,_that.isEnrolled,_that.enrolledAt,_that.progress,_that.nextUnitId,_that.nextExerciseId,_that.lastActivityAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String specializationId,  String specializationName,  String name,  String sourceLanguage,  String targetLanguage,  int unitCount,  int exerciseCount,  String? description,  String? thumbnailUrl,  bool isEnrolled,  DateTime? enrolledAt,  Progress? progress,  String? nextUnitId,  String? nextExerciseId,  DateTime? lastActivityAt)  $default,) {final _that = this;
switch (_that) {
case _CourseSummary():
return $default(_that.id,_that.specializationId,_that.specializationName,_that.name,_that.sourceLanguage,_that.targetLanguage,_that.unitCount,_that.exerciseCount,_that.description,_that.thumbnailUrl,_that.isEnrolled,_that.enrolledAt,_that.progress,_that.nextUnitId,_that.nextExerciseId,_that.lastActivityAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String specializationId,  String specializationName,  String name,  String sourceLanguage,  String targetLanguage,  int unitCount,  int exerciseCount,  String? description,  String? thumbnailUrl,  bool isEnrolled,  DateTime? enrolledAt,  Progress? progress,  String? nextUnitId,  String? nextExerciseId,  DateTime? lastActivityAt)?  $default,) {final _that = this;
switch (_that) {
case _CourseSummary() when $default != null:
return $default(_that.id,_that.specializationId,_that.specializationName,_that.name,_that.sourceLanguage,_that.targetLanguage,_that.unitCount,_that.exerciseCount,_that.description,_that.thumbnailUrl,_that.isEnrolled,_that.enrolledAt,_that.progress,_that.nextUnitId,_that.nextExerciseId,_that.lastActivityAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseSummary implements CourseSummary {
  const _CourseSummary({@JsonKey(name: '_id') required this.id, required this.specializationId, required this.specializationName, required this.name, required this.sourceLanguage, required this.targetLanguage, required this.unitCount, required this.exerciseCount, this.description, this.thumbnailUrl, this.isEnrolled = false, this.enrolledAt, this.progress, this.nextUnitId, this.nextExerciseId, this.lastActivityAt});
  factory _CourseSummary.fromJson(Map<String, dynamic> json) => _$CourseSummaryFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String specializationId;
@override final  String specializationName;
@override final  String name;
@override final  String sourceLanguage;
@override final  String targetLanguage;
@override final  int unitCount;
@override final  int exerciseCount;
@override final  String? description;
/// Absolute MinIO URL built from the current `MINIO_PUBLIC_ENDPOINT`.
@override final  String? thumbnailUrl;
/// Always false for teachers and admins.
@override@JsonKey() final  bool isEnrolled;
@override final  DateTime? enrolledAt;
/// Students only. Where Continue goes: the first exercise not completed
/// yet; both null once everything is done.
@override final  Progress? progress;
@override final  String? nextUnitId;
@override final  String? nextExerciseId;
@override final  DateTime? lastActivityAt;

/// Create a copy of CourseSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseSummaryCopyWith<_CourseSummary> get copyWith => __$CourseSummaryCopyWithImpl<_CourseSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.specializationId, specializationId) || other.specializationId == specializationId)&&(identical(other.specializationName, specializationName) || other.specializationName == specializationName)&&(identical(other.name, name) || other.name == name)&&(identical(other.sourceLanguage, sourceLanguage) || other.sourceLanguage == sourceLanguage)&&(identical(other.targetLanguage, targetLanguage) || other.targetLanguage == targetLanguage)&&(identical(other.unitCount, unitCount) || other.unitCount == unitCount)&&(identical(other.exerciseCount, exerciseCount) || other.exerciseCount == exerciseCount)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isEnrolled, isEnrolled) || other.isEnrolled == isEnrolled)&&(identical(other.enrolledAt, enrolledAt) || other.enrolledAt == enrolledAt)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.nextUnitId, nextUnitId) || other.nextUnitId == nextUnitId)&&(identical(other.nextExerciseId, nextExerciseId) || other.nextExerciseId == nextExerciseId)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,specializationId,specializationName,name,sourceLanguage,targetLanguage,unitCount,exerciseCount,description,thumbnailUrl,isEnrolled,enrolledAt,progress,nextUnitId,nextExerciseId,lastActivityAt);

@override
String toString() {
  return 'CourseSummary(id: $id, specializationId: $specializationId, specializationName: $specializationName, name: $name, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, unitCount: $unitCount, exerciseCount: $exerciseCount, description: $description, thumbnailUrl: $thumbnailUrl, isEnrolled: $isEnrolled, enrolledAt: $enrolledAt, progress: $progress, nextUnitId: $nextUnitId, nextExerciseId: $nextExerciseId, lastActivityAt: $lastActivityAt)';
}


}

/// @nodoc
abstract mixin class _$CourseSummaryCopyWith<$Res> implements $CourseSummaryCopyWith<$Res> {
  factory _$CourseSummaryCopyWith(_CourseSummary value, $Res Function(_CourseSummary) _then) = __$CourseSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String specializationId, String specializationName, String name, String sourceLanguage, String targetLanguage, int unitCount, int exerciseCount, String? description, String? thumbnailUrl, bool isEnrolled, DateTime? enrolledAt, Progress? progress, String? nextUnitId, String? nextExerciseId, DateTime? lastActivityAt
});


@override $ProgressCopyWith<$Res>? get progress;

}
/// @nodoc
class __$CourseSummaryCopyWithImpl<$Res>
    implements _$CourseSummaryCopyWith<$Res> {
  __$CourseSummaryCopyWithImpl(this._self, this._then);

  final _CourseSummary _self;
  final $Res Function(_CourseSummary) _then;

/// Create a copy of CourseSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? specializationId = null,Object? specializationName = null,Object? name = null,Object? sourceLanguage = null,Object? targetLanguage = null,Object? unitCount = null,Object? exerciseCount = null,Object? description = freezed,Object? thumbnailUrl = freezed,Object? isEnrolled = null,Object? enrolledAt = freezed,Object? progress = freezed,Object? nextUnitId = freezed,Object? nextExerciseId = freezed,Object? lastActivityAt = freezed,}) {
  return _then(_CourseSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,specializationId: null == specializationId ? _self.specializationId : specializationId // ignore: cast_nullable_to_non_nullable
as String,specializationName: null == specializationName ? _self.specializationName : specializationName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sourceLanguage: null == sourceLanguage ? _self.sourceLanguage : sourceLanguage // ignore: cast_nullable_to_non_nullable
as String,targetLanguage: null == targetLanguage ? _self.targetLanguage : targetLanguage // ignore: cast_nullable_to_non_nullable
as String,unitCount: null == unitCount ? _self.unitCount : unitCount // ignore: cast_nullable_to_non_nullable
as int,exerciseCount: null == exerciseCount ? _self.exerciseCount : exerciseCount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isEnrolled: null == isEnrolled ? _self.isEnrolled : isEnrolled // ignore: cast_nullable_to_non_nullable
as bool,enrolledAt: freezed == enrolledAt ? _self.enrolledAt : enrolledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,nextUnitId: freezed == nextUnitId ? _self.nextUnitId : nextUnitId // ignore: cast_nullable_to_non_nullable
as String?,nextExerciseId: freezed == nextExerciseId ? _self.nextExerciseId : nextExerciseId // ignore: cast_nullable_to_non_nullable
as String?,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of CourseSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $ProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// @nodoc
mixin _$UnitSummary {

@JsonKey(name: '_id') String get id; String get name; int get orderIndex; int get exerciseCount; Progress? get progress;
/// Create a copy of UnitSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitSummaryCopyWith<UnitSummary> get copyWith => _$UnitSummaryCopyWithImpl<UnitSummary>(this as UnitSummary, _$identity);

  /// Serializes this UnitSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.exerciseCount, exerciseCount) || other.exerciseCount == exerciseCount)&&(identical(other.progress, progress) || other.progress == progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,orderIndex,exerciseCount,progress);

@override
String toString() {
  return 'UnitSummary(id: $id, name: $name, orderIndex: $orderIndex, exerciseCount: $exerciseCount, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $UnitSummaryCopyWith<$Res>  {
  factory $UnitSummaryCopyWith(UnitSummary value, $Res Function(UnitSummary) _then) = _$UnitSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String name, int orderIndex, int exerciseCount, Progress? progress
});


$ProgressCopyWith<$Res>? get progress;

}
/// @nodoc
class _$UnitSummaryCopyWithImpl<$Res>
    implements $UnitSummaryCopyWith<$Res> {
  _$UnitSummaryCopyWithImpl(this._self, this._then);

  final UnitSummary _self;
  final $Res Function(UnitSummary) _then;

/// Create a copy of UnitSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? orderIndex = null,Object? exerciseCount = null,Object? progress = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,exerciseCount: null == exerciseCount ? _self.exerciseCount : exerciseCount // ignore: cast_nullable_to_non_nullable
as int,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,
  ));
}
/// Create a copy of UnitSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $ProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// Adds pattern-matching-related methods to [UnitSummary].
extension UnitSummaryPatterns on UnitSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnitSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnitSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnitSummary value)  $default,){
final _that = this;
switch (_that) {
case _UnitSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnitSummary value)?  $default,){
final _that = this;
switch (_that) {
case _UnitSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String name,  int orderIndex,  int exerciseCount,  Progress? progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnitSummary() when $default != null:
return $default(_that.id,_that.name,_that.orderIndex,_that.exerciseCount,_that.progress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String name,  int orderIndex,  int exerciseCount,  Progress? progress)  $default,) {final _that = this;
switch (_that) {
case _UnitSummary():
return $default(_that.id,_that.name,_that.orderIndex,_that.exerciseCount,_that.progress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String name,  int orderIndex,  int exerciseCount,  Progress? progress)?  $default,) {final _that = this;
switch (_that) {
case _UnitSummary() when $default != null:
return $default(_that.id,_that.name,_that.orderIndex,_that.exerciseCount,_that.progress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnitSummary implements UnitSummary {
  const _UnitSummary({@JsonKey(name: '_id') required this.id, required this.name, required this.orderIndex, required this.exerciseCount, this.progress});
  factory _UnitSummary.fromJson(Map<String, dynamic> json) => _$UnitSummaryFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String name;
@override final  int orderIndex;
@override final  int exerciseCount;
@override final  Progress? progress;

/// Create a copy of UnitSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitSummaryCopyWith<_UnitSummary> get copyWith => __$UnitSummaryCopyWithImpl<_UnitSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.exerciseCount, exerciseCount) || other.exerciseCount == exerciseCount)&&(identical(other.progress, progress) || other.progress == progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,orderIndex,exerciseCount,progress);

@override
String toString() {
  return 'UnitSummary(id: $id, name: $name, orderIndex: $orderIndex, exerciseCount: $exerciseCount, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$UnitSummaryCopyWith<$Res> implements $UnitSummaryCopyWith<$Res> {
  factory _$UnitSummaryCopyWith(_UnitSummary value, $Res Function(_UnitSummary) _then) = __$UnitSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String name, int orderIndex, int exerciseCount, Progress? progress
});


@override $ProgressCopyWith<$Res>? get progress;

}
/// @nodoc
class __$UnitSummaryCopyWithImpl<$Res>
    implements _$UnitSummaryCopyWith<$Res> {
  __$UnitSummaryCopyWithImpl(this._self, this._then);

  final _UnitSummary _self;
  final $Res Function(_UnitSummary) _then;

/// Create a copy of UnitSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? orderIndex = null,Object? exerciseCount = null,Object? progress = freezed,}) {
  return _then(_UnitSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,exerciseCount: null == exerciseCount ? _self.exerciseCount : exerciseCount // ignore: cast_nullable_to_non_nullable
as int,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,
  ));
}

/// Create a copy of UnitSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $ProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// @nodoc
mixin _$CourseDetail {

 CourseSummary get course; List<UnitSummary> get units;
/// Create a copy of CourseDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailCopyWith<CourseDetail> get copyWith => _$CourseDetailCopyWithImpl<CourseDetail>(this as CourseDetail, _$identity);

  /// Serializes this CourseDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetail&&(identical(other.course, course) || other.course == course)&&const DeepCollectionEquality().equals(other.units, units));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,course,const DeepCollectionEquality().hash(units));

@override
String toString() {
  return 'CourseDetail(course: $course, units: $units)';
}


}

/// @nodoc
abstract mixin class $CourseDetailCopyWith<$Res>  {
  factory $CourseDetailCopyWith(CourseDetail value, $Res Function(CourseDetail) _then) = _$CourseDetailCopyWithImpl;
@useResult
$Res call({
 CourseSummary course, List<UnitSummary> units
});


$CourseSummaryCopyWith<$Res> get course;

}
/// @nodoc
class _$CourseDetailCopyWithImpl<$Res>
    implements $CourseDetailCopyWith<$Res> {
  _$CourseDetailCopyWithImpl(this._self, this._then);

  final CourseDetail _self;
  final $Res Function(CourseDetail) _then;

/// Create a copy of CourseDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? course = null,Object? units = null,}) {
  return _then(_self.copyWith(
course: null == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as CourseSummary,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<UnitSummary>,
  ));
}
/// Create a copy of CourseDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseSummaryCopyWith<$Res> get course {
  
  return $CourseSummaryCopyWith<$Res>(_self.course, (value) {
    return _then(_self.copyWith(course: value));
  });
}
}


/// Adds pattern-matching-related methods to [CourseDetail].
extension CourseDetailPatterns on CourseDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseDetail value)  $default,){
final _that = this;
switch (_that) {
case _CourseDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseDetail value)?  $default,){
final _that = this;
switch (_that) {
case _CourseDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CourseSummary course,  List<UnitSummary> units)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseDetail() when $default != null:
return $default(_that.course,_that.units);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CourseSummary course,  List<UnitSummary> units)  $default,) {final _that = this;
switch (_that) {
case _CourseDetail():
return $default(_that.course,_that.units);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CourseSummary course,  List<UnitSummary> units)?  $default,) {final _that = this;
switch (_that) {
case _CourseDetail() when $default != null:
return $default(_that.course,_that.units);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseDetail implements CourseDetail {
  const _CourseDetail({required this.course, required final  List<UnitSummary> units}): _units = units;
  factory _CourseDetail.fromJson(Map<String, dynamic> json) => _$CourseDetailFromJson(json);

@override final  CourseSummary course;
 final  List<UnitSummary> _units;
@override List<UnitSummary> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}


/// Create a copy of CourseDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseDetailCopyWith<_CourseDetail> get copyWith => __$CourseDetailCopyWithImpl<_CourseDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseDetail&&(identical(other.course, course) || other.course == course)&&const DeepCollectionEquality().equals(other._units, _units));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,course,const DeepCollectionEquality().hash(_units));

@override
String toString() {
  return 'CourseDetail(course: $course, units: $units)';
}


}

/// @nodoc
abstract mixin class _$CourseDetailCopyWith<$Res> implements $CourseDetailCopyWith<$Res> {
  factory _$CourseDetailCopyWith(_CourseDetail value, $Res Function(_CourseDetail) _then) = __$CourseDetailCopyWithImpl;
@override @useResult
$Res call({
 CourseSummary course, List<UnitSummary> units
});


@override $CourseSummaryCopyWith<$Res> get course;

}
/// @nodoc
class __$CourseDetailCopyWithImpl<$Res>
    implements _$CourseDetailCopyWith<$Res> {
  __$CourseDetailCopyWithImpl(this._self, this._then);

  final _CourseDetail _self;
  final $Res Function(_CourseDetail) _then;

/// Create a copy of CourseDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? course = null,Object? units = null,}) {
  return _then(_CourseDetail(
course: null == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as CourseSummary,units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<UnitSummary>,
  ));
}

/// Create a copy of CourseDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseSummaryCopyWith<$Res> get course {
  
  return $CourseSummaryCopyWith<$Res>(_self.course, (value) {
    return _then(_self.copyWith(course: value));
  });
}
}


/// @nodoc
mixin _$ExerciseSummary {

@JsonKey(name: '_id') String get id; String get name; int get orderIndex; int get questionCount;/// Distinct types in the order they first appear; exercises are
/// mixed-type.
@JsonKey(unknownEnumValue: QuestionType.unknown) List<QuestionType> get questionTypes;/// Students only: done at any score; the best session's percent.
@JsonKey(unknownEnumValue: ExerciseStatus.notStarted) ExerciseStatus? get status; int? get bestPercent;
/// Create a copy of ExerciseSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseSummaryCopyWith<ExerciseSummary> get copyWith => _$ExerciseSummaryCopyWithImpl<ExerciseSummary>(this as ExerciseSummary, _$identity);

  /// Serializes this ExerciseSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&const DeepCollectionEquality().equals(other.questionTypes, questionTypes)&&(identical(other.status, status) || other.status == status)&&(identical(other.bestPercent, bestPercent) || other.bestPercent == bestPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,orderIndex,questionCount,const DeepCollectionEquality().hash(questionTypes),status,bestPercent);

@override
String toString() {
  return 'ExerciseSummary(id: $id, name: $name, orderIndex: $orderIndex, questionCount: $questionCount, questionTypes: $questionTypes, status: $status, bestPercent: $bestPercent)';
}


}

/// @nodoc
abstract mixin class $ExerciseSummaryCopyWith<$Res>  {
  factory $ExerciseSummaryCopyWith(ExerciseSummary value, $Res Function(ExerciseSummary) _then) = _$ExerciseSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String name, int orderIndex, int questionCount,@JsonKey(unknownEnumValue: QuestionType.unknown) List<QuestionType> questionTypes,@JsonKey(unknownEnumValue: ExerciseStatus.notStarted) ExerciseStatus? status, int? bestPercent
});




}
/// @nodoc
class _$ExerciseSummaryCopyWithImpl<$Res>
    implements $ExerciseSummaryCopyWith<$Res> {
  _$ExerciseSummaryCopyWithImpl(this._self, this._then);

  final ExerciseSummary _self;
  final $Res Function(ExerciseSummary) _then;

/// Create a copy of ExerciseSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? orderIndex = null,Object? questionCount = null,Object? questionTypes = null,Object? status = freezed,Object? bestPercent = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,questionTypes: null == questionTypes ? _self.questionTypes : questionTypes // ignore: cast_nullable_to_non_nullable
as List<QuestionType>,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExerciseStatus?,bestPercent: freezed == bestPercent ? _self.bestPercent : bestPercent // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseSummary].
extension ExerciseSummaryPatterns on ExerciseSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseSummary value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String name,  int orderIndex,  int questionCount, @JsonKey(unknownEnumValue: QuestionType.unknown)  List<QuestionType> questionTypes, @JsonKey(unknownEnumValue: ExerciseStatus.notStarted)  ExerciseStatus? status,  int? bestPercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseSummary() when $default != null:
return $default(_that.id,_that.name,_that.orderIndex,_that.questionCount,_that.questionTypes,_that.status,_that.bestPercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String name,  int orderIndex,  int questionCount, @JsonKey(unknownEnumValue: QuestionType.unknown)  List<QuestionType> questionTypes, @JsonKey(unknownEnumValue: ExerciseStatus.notStarted)  ExerciseStatus? status,  int? bestPercent)  $default,) {final _that = this;
switch (_that) {
case _ExerciseSummary():
return $default(_that.id,_that.name,_that.orderIndex,_that.questionCount,_that.questionTypes,_that.status,_that.bestPercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String name,  int orderIndex,  int questionCount, @JsonKey(unknownEnumValue: QuestionType.unknown)  List<QuestionType> questionTypes, @JsonKey(unknownEnumValue: ExerciseStatus.notStarted)  ExerciseStatus? status,  int? bestPercent)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseSummary() when $default != null:
return $default(_that.id,_that.name,_that.orderIndex,_that.questionCount,_that.questionTypes,_that.status,_that.bestPercent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseSummary implements ExerciseSummary {
  const _ExerciseSummary({@JsonKey(name: '_id') required this.id, required this.name, required this.orderIndex, required this.questionCount, @JsonKey(unknownEnumValue: QuestionType.unknown) final  List<QuestionType> questionTypes = const <QuestionType>[], @JsonKey(unknownEnumValue: ExerciseStatus.notStarted) this.status, this.bestPercent}): _questionTypes = questionTypes;
  factory _ExerciseSummary.fromJson(Map<String, dynamic> json) => _$ExerciseSummaryFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String name;
@override final  int orderIndex;
@override final  int questionCount;
/// Distinct types in the order they first appear; exercises are
/// mixed-type.
 final  List<QuestionType> _questionTypes;
/// Distinct types in the order they first appear; exercises are
/// mixed-type.
@override@JsonKey(unknownEnumValue: QuestionType.unknown) List<QuestionType> get questionTypes {
  if (_questionTypes is EqualUnmodifiableListView) return _questionTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questionTypes);
}

/// Students only: done at any score; the best session's percent.
@override@JsonKey(unknownEnumValue: ExerciseStatus.notStarted) final  ExerciseStatus? status;
@override final  int? bestPercent;

/// Create a copy of ExerciseSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseSummaryCopyWith<_ExerciseSummary> get copyWith => __$ExerciseSummaryCopyWithImpl<_ExerciseSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&const DeepCollectionEquality().equals(other._questionTypes, _questionTypes)&&(identical(other.status, status) || other.status == status)&&(identical(other.bestPercent, bestPercent) || other.bestPercent == bestPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,orderIndex,questionCount,const DeepCollectionEquality().hash(_questionTypes),status,bestPercent);

@override
String toString() {
  return 'ExerciseSummary(id: $id, name: $name, orderIndex: $orderIndex, questionCount: $questionCount, questionTypes: $questionTypes, status: $status, bestPercent: $bestPercent)';
}


}

/// @nodoc
abstract mixin class _$ExerciseSummaryCopyWith<$Res> implements $ExerciseSummaryCopyWith<$Res> {
  factory _$ExerciseSummaryCopyWith(_ExerciseSummary value, $Res Function(_ExerciseSummary) _then) = __$ExerciseSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String name, int orderIndex, int questionCount,@JsonKey(unknownEnumValue: QuestionType.unknown) List<QuestionType> questionTypes,@JsonKey(unknownEnumValue: ExerciseStatus.notStarted) ExerciseStatus? status, int? bestPercent
});




}
/// @nodoc
class __$ExerciseSummaryCopyWithImpl<$Res>
    implements _$ExerciseSummaryCopyWith<$Res> {
  __$ExerciseSummaryCopyWithImpl(this._self, this._then);

  final _ExerciseSummary _self;
  final $Res Function(_ExerciseSummary) _then;

/// Create a copy of ExerciseSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? orderIndex = null,Object? questionCount = null,Object? questionTypes = null,Object? status = freezed,Object? bestPercent = freezed,}) {
  return _then(_ExerciseSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,questionTypes: null == questionTypes ? _self._questionTypes : questionTypes // ignore: cast_nullable_to_non_nullable
as List<QuestionType>,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExerciseStatus?,bestPercent: freezed == bestPercent ? _self.bestPercent : bestPercent // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$UnitDetail {

@JsonKey(name: '_id') String get id; String get courseId; String get courseName; String get name; int get orderIndex; List<ExerciseSummary> get exercises; Progress? get progress; String? get nextExerciseId;
/// Create a copy of UnitDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitDetailCopyWith<UnitDetail> get copyWith => _$UnitDetailCopyWithImpl<UnitDetail>(this as UnitDetail, _$identity);

  /// Serializes this UnitDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.name, name) || other.name == name)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&const DeepCollectionEquality().equals(other.exercises, exercises)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.nextExerciseId, nextExerciseId) || other.nextExerciseId == nextExerciseId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,name,orderIndex,const DeepCollectionEquality().hash(exercises),progress,nextExerciseId);

@override
String toString() {
  return 'UnitDetail(id: $id, courseId: $courseId, courseName: $courseName, name: $name, orderIndex: $orderIndex, exercises: $exercises, progress: $progress, nextExerciseId: $nextExerciseId)';
}


}

/// @nodoc
abstract mixin class $UnitDetailCopyWith<$Res>  {
  factory $UnitDetailCopyWith(UnitDetail value, $Res Function(UnitDetail) _then) = _$UnitDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String courseId, String courseName, String name, int orderIndex, List<ExerciseSummary> exercises, Progress? progress, String? nextExerciseId
});


$ProgressCopyWith<$Res>? get progress;

}
/// @nodoc
class _$UnitDetailCopyWithImpl<$Res>
    implements $UnitDetailCopyWith<$Res> {
  _$UnitDetailCopyWithImpl(this._self, this._then);

  final UnitDetail _self;
  final $Res Function(UnitDetail) _then;

/// Create a copy of UnitDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? courseName = null,Object? name = null,Object? orderIndex = null,Object? exercises = null,Object? progress = freezed,Object? nextExerciseId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<ExerciseSummary>,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,nextExerciseId: freezed == nextExerciseId ? _self.nextExerciseId : nextExerciseId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of UnitDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $ProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// Adds pattern-matching-related methods to [UnitDetail].
extension UnitDetailPatterns on UnitDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnitDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnitDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnitDetail value)  $default,){
final _that = this;
switch (_that) {
case _UnitDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnitDetail value)?  $default,){
final _that = this;
switch (_that) {
case _UnitDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String courseId,  String courseName,  String name,  int orderIndex,  List<ExerciseSummary> exercises,  Progress? progress,  String? nextExerciseId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnitDetail() when $default != null:
return $default(_that.id,_that.courseId,_that.courseName,_that.name,_that.orderIndex,_that.exercises,_that.progress,_that.nextExerciseId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String courseId,  String courseName,  String name,  int orderIndex,  List<ExerciseSummary> exercises,  Progress? progress,  String? nextExerciseId)  $default,) {final _that = this;
switch (_that) {
case _UnitDetail():
return $default(_that.id,_that.courseId,_that.courseName,_that.name,_that.orderIndex,_that.exercises,_that.progress,_that.nextExerciseId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String courseId,  String courseName,  String name,  int orderIndex,  List<ExerciseSummary> exercises,  Progress? progress,  String? nextExerciseId)?  $default,) {final _that = this;
switch (_that) {
case _UnitDetail() when $default != null:
return $default(_that.id,_that.courseId,_that.courseName,_that.name,_that.orderIndex,_that.exercises,_that.progress,_that.nextExerciseId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnitDetail implements UnitDetail {
  const _UnitDetail({@JsonKey(name: '_id') required this.id, required this.courseId, required this.courseName, required this.name, required this.orderIndex, required final  List<ExerciseSummary> exercises, this.progress, this.nextExerciseId}): _exercises = exercises;
  factory _UnitDetail.fromJson(Map<String, dynamic> json) => _$UnitDetailFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String courseId;
@override final  String courseName;
@override final  String name;
@override final  int orderIndex;
 final  List<ExerciseSummary> _exercises;
@override List<ExerciseSummary> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override final  Progress? progress;
@override final  String? nextExerciseId;

/// Create a copy of UnitDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitDetailCopyWith<_UnitDetail> get copyWith => __$UnitDetailCopyWithImpl<_UnitDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.name, name) || other.name == name)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.nextExerciseId, nextExerciseId) || other.nextExerciseId == nextExerciseId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,name,orderIndex,const DeepCollectionEquality().hash(_exercises),progress,nextExerciseId);

@override
String toString() {
  return 'UnitDetail(id: $id, courseId: $courseId, courseName: $courseName, name: $name, orderIndex: $orderIndex, exercises: $exercises, progress: $progress, nextExerciseId: $nextExerciseId)';
}


}

/// @nodoc
abstract mixin class _$UnitDetailCopyWith<$Res> implements $UnitDetailCopyWith<$Res> {
  factory _$UnitDetailCopyWith(_UnitDetail value, $Res Function(_UnitDetail) _then) = __$UnitDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String courseId, String courseName, String name, int orderIndex, List<ExerciseSummary> exercises, Progress? progress, String? nextExerciseId
});


@override $ProgressCopyWith<$Res>? get progress;

}
/// @nodoc
class __$UnitDetailCopyWithImpl<$Res>
    implements _$UnitDetailCopyWith<$Res> {
  __$UnitDetailCopyWithImpl(this._self, this._then);

  final _UnitDetail _self;
  final $Res Function(_UnitDetail) _then;

/// Create a copy of UnitDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? courseName = null,Object? name = null,Object? orderIndex = null,Object? exercises = null,Object? progress = freezed,Object? nextExerciseId = freezed,}) {
  return _then(_UnitDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<ExerciseSummary>,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,nextExerciseId: freezed == nextExerciseId ? _self.nextExerciseId : nextExerciseId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of UnitDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $ProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

// dart format on
