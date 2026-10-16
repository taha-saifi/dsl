// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learn_summaries.dart';

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

// dart format on
