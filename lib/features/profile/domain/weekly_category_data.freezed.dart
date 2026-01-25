// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_category_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeeklyCategoryData {

 int get dayOfWeek; int get activityCount; String? get activityCategoryId;
/// Create a copy of WeeklyCategoryData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyCategoryDataCopyWith<WeeklyCategoryData> get copyWith => _$WeeklyCategoryDataCopyWithImpl<WeeklyCategoryData>(this as WeeklyCategoryData, _$identity);

  /// Serializes this WeeklyCategoryData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyCategoryData&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.activityCount, activityCount) || other.activityCount == activityCount)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayOfWeek,activityCount,activityCategoryId);

@override
String toString() {
  return 'WeeklyCategoryData(dayOfWeek: $dayOfWeek, activityCount: $activityCount, activityCategoryId: $activityCategoryId)';
}


}

/// @nodoc
abstract mixin class $WeeklyCategoryDataCopyWith<$Res>  {
  factory $WeeklyCategoryDataCopyWith(WeeklyCategoryData value, $Res Function(WeeklyCategoryData) _then) = _$WeeklyCategoryDataCopyWithImpl;
@useResult
$Res call({
 int dayOfWeek, int activityCount, String? activityCategoryId
});




}
/// @nodoc
class _$WeeklyCategoryDataCopyWithImpl<$Res>
    implements $WeeklyCategoryDataCopyWith<$Res> {
  _$WeeklyCategoryDataCopyWithImpl(this._self, this._then);

  final WeeklyCategoryData _self;
  final $Res Function(WeeklyCategoryData) _then;

/// Create a copy of WeeklyCategoryData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayOfWeek = null,Object? activityCount = null,Object? activityCategoryId = freezed,}) {
  return _then(_self.copyWith(
dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,activityCount: null == activityCount ? _self.activityCount : activityCount // ignore: cast_nullable_to_non_nullable
as int,activityCategoryId: freezed == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyCategoryData].
extension WeeklyCategoryDataPatterns on WeeklyCategoryData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyCategoryData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyCategoryData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyCategoryData value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyCategoryData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyCategoryData value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyCategoryData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dayOfWeek,  int activityCount,  String? activityCategoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyCategoryData() when $default != null:
return $default(_that.dayOfWeek,_that.activityCount,_that.activityCategoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dayOfWeek,  int activityCount,  String? activityCategoryId)  $default,) {final _that = this;
switch (_that) {
case _WeeklyCategoryData():
return $default(_that.dayOfWeek,_that.activityCount,_that.activityCategoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dayOfWeek,  int activityCount,  String? activityCategoryId)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyCategoryData() when $default != null:
return $default(_that.dayOfWeek,_that.activityCount,_that.activityCategoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyCategoryData implements WeeklyCategoryData {
  const _WeeklyCategoryData({required this.dayOfWeek, required this.activityCount, this.activityCategoryId});
  factory _WeeklyCategoryData.fromJson(Map<String, dynamic> json) => _$WeeklyCategoryDataFromJson(json);

@override final  int dayOfWeek;
@override final  int activityCount;
@override final  String? activityCategoryId;

/// Create a copy of WeeklyCategoryData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyCategoryDataCopyWith<_WeeklyCategoryData> get copyWith => __$WeeklyCategoryDataCopyWithImpl<_WeeklyCategoryData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyCategoryDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyCategoryData&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.activityCount, activityCount) || other.activityCount == activityCount)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayOfWeek,activityCount,activityCategoryId);

@override
String toString() {
  return 'WeeklyCategoryData(dayOfWeek: $dayOfWeek, activityCount: $activityCount, activityCategoryId: $activityCategoryId)';
}


}

/// @nodoc
abstract mixin class _$WeeklyCategoryDataCopyWith<$Res> implements $WeeklyCategoryDataCopyWith<$Res> {
  factory _$WeeklyCategoryDataCopyWith(_WeeklyCategoryData value, $Res Function(_WeeklyCategoryData) _then) = __$WeeklyCategoryDataCopyWithImpl;
@override @useResult
$Res call({
 int dayOfWeek, int activityCount, String? activityCategoryId
});




}
/// @nodoc
class __$WeeklyCategoryDataCopyWithImpl<$Res>
    implements _$WeeklyCategoryDataCopyWith<$Res> {
  __$WeeklyCategoryDataCopyWithImpl(this._self, this._then);

  final _WeeklyCategoryData _self;
  final $Res Function(_WeeklyCategoryData) _then;

/// Create a copy of WeeklyCategoryData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayOfWeek = null,Object? activityCount = null,Object? activityCategoryId = freezed,}) {
  return _then(_WeeklyCategoryData(
dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,activityCount: null == activityCount ? _self.activityCount : activityCount // ignore: cast_nullable_to_non_nullable
as int,activityCategoryId: freezed == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
