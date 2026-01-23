// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_category_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyCategoryData {

@JsonKey(name: 'activity_month') DateTime get activityMonth;@JsonKey(name: 'activity_count') int get activityCount;@JsonKey(name: 'activity_category_id') String? get activityCategoryId;
/// Create a copy of MonthlyCategoryData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyCategoryDataCopyWith<MonthlyCategoryData> get copyWith => _$MonthlyCategoryDataCopyWithImpl<MonthlyCategoryData>(this as MonthlyCategoryData, _$identity);

  /// Serializes this MonthlyCategoryData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyCategoryData&&(identical(other.activityMonth, activityMonth) || other.activityMonth == activityMonth)&&(identical(other.activityCount, activityCount) || other.activityCount == activityCount)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityMonth,activityCount,activityCategoryId);

@override
String toString() {
  return 'MonthlyCategoryData(activityMonth: $activityMonth, activityCount: $activityCount, activityCategoryId: $activityCategoryId)';
}


}

/// @nodoc
abstract mixin class $MonthlyCategoryDataCopyWith<$Res>  {
  factory $MonthlyCategoryDataCopyWith(MonthlyCategoryData value, $Res Function(MonthlyCategoryData) _then) = _$MonthlyCategoryDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'activity_month') DateTime activityMonth,@JsonKey(name: 'activity_count') int activityCount,@JsonKey(name: 'activity_category_id') String? activityCategoryId
});




}
/// @nodoc
class _$MonthlyCategoryDataCopyWithImpl<$Res>
    implements $MonthlyCategoryDataCopyWith<$Res> {
  _$MonthlyCategoryDataCopyWithImpl(this._self, this._then);

  final MonthlyCategoryData _self;
  final $Res Function(MonthlyCategoryData) _then;

/// Create a copy of MonthlyCategoryData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityMonth = null,Object? activityCount = null,Object? activityCategoryId = freezed,}) {
  return _then(_self.copyWith(
activityMonth: null == activityMonth ? _self.activityMonth : activityMonth // ignore: cast_nullable_to_non_nullable
as DateTime,activityCount: null == activityCount ? _self.activityCount : activityCount // ignore: cast_nullable_to_non_nullable
as int,activityCategoryId: freezed == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyCategoryData].
extension MonthlyCategoryDataPatterns on MonthlyCategoryData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyCategoryData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyCategoryData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyCategoryData value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyCategoryData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyCategoryData value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyCategoryData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_month')  DateTime activityMonth, @JsonKey(name: 'activity_count')  int activityCount, @JsonKey(name: 'activity_category_id')  String? activityCategoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyCategoryData() when $default != null:
return $default(_that.activityMonth,_that.activityCount,_that.activityCategoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_month')  DateTime activityMonth, @JsonKey(name: 'activity_count')  int activityCount, @JsonKey(name: 'activity_category_id')  String? activityCategoryId)  $default,) {final _that = this;
switch (_that) {
case _MonthlyCategoryData():
return $default(_that.activityMonth,_that.activityCount,_that.activityCategoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'activity_month')  DateTime activityMonth, @JsonKey(name: 'activity_count')  int activityCount, @JsonKey(name: 'activity_category_id')  String? activityCategoryId)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyCategoryData() when $default != null:
return $default(_that.activityMonth,_that.activityCount,_that.activityCategoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyCategoryData implements MonthlyCategoryData {
  const _MonthlyCategoryData({@JsonKey(name: 'activity_month') required this.activityMonth, @JsonKey(name: 'activity_count') required this.activityCount, @JsonKey(name: 'activity_category_id') this.activityCategoryId});
  factory _MonthlyCategoryData.fromJson(Map<String, dynamic> json) => _$MonthlyCategoryDataFromJson(json);

@override@JsonKey(name: 'activity_month') final  DateTime activityMonth;
@override@JsonKey(name: 'activity_count') final  int activityCount;
@override@JsonKey(name: 'activity_category_id') final  String? activityCategoryId;

/// Create a copy of MonthlyCategoryData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyCategoryDataCopyWith<_MonthlyCategoryData> get copyWith => __$MonthlyCategoryDataCopyWithImpl<_MonthlyCategoryData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyCategoryDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyCategoryData&&(identical(other.activityMonth, activityMonth) || other.activityMonth == activityMonth)&&(identical(other.activityCount, activityCount) || other.activityCount == activityCount)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityMonth,activityCount,activityCategoryId);

@override
String toString() {
  return 'MonthlyCategoryData(activityMonth: $activityMonth, activityCount: $activityCount, activityCategoryId: $activityCategoryId)';
}


}

/// @nodoc
abstract mixin class _$MonthlyCategoryDataCopyWith<$Res> implements $MonthlyCategoryDataCopyWith<$Res> {
  factory _$MonthlyCategoryDataCopyWith(_MonthlyCategoryData value, $Res Function(_MonthlyCategoryData) _then) = __$MonthlyCategoryDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'activity_month') DateTime activityMonth,@JsonKey(name: 'activity_count') int activityCount,@JsonKey(name: 'activity_category_id') String? activityCategoryId
});




}
/// @nodoc
class __$MonthlyCategoryDataCopyWithImpl<$Res>
    implements _$MonthlyCategoryDataCopyWith<$Res> {
  __$MonthlyCategoryDataCopyWithImpl(this._self, this._then);

  final _MonthlyCategoryData _self;
  final $Res Function(_MonthlyCategoryData) _then;

/// Create a copy of MonthlyCategoryData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityMonth = null,Object? activityCount = null,Object? activityCategoryId = freezed,}) {
  return _then(_MonthlyCategoryData(
activityMonth: null == activityMonth ? _self.activityMonth : activityMonth // ignore: cast_nullable_to_non_nullable
as DateTime,activityCount: null == activityCount ? _self.activityCount : activityCount // ignore: cast_nullable_to_non_nullable
as int,activityCategoryId: freezed == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
