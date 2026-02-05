// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dow_category_counts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DowCategoryCounts {

@JsonKey(name: 'day_of_week') int get dayOfWeek;@JsonKey(name: 'activity_category_id') String get activityCategoryId;@JsonKey(name: 'past_week') int get pastWeek;@JsonKey(name: 'past_month') int get pastMonth;@JsonKey(name: 'past_year') int get pastYear;@JsonKey(name: 'all_time') int get allTime;
/// Create a copy of DowCategoryCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DowCategoryCountsCopyWith<DowCategoryCounts> get copyWith => _$DowCategoryCountsCopyWithImpl<DowCategoryCounts>(this as DowCategoryCounts, _$identity);

  /// Serializes this DowCategoryCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DowCategoryCounts&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId)&&(identical(other.pastWeek, pastWeek) || other.pastWeek == pastWeek)&&(identical(other.pastMonth, pastMonth) || other.pastMonth == pastMonth)&&(identical(other.pastYear, pastYear) || other.pastYear == pastYear)&&(identical(other.allTime, allTime) || other.allTime == allTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayOfWeek,activityCategoryId,pastWeek,pastMonth,pastYear,allTime);

@override
String toString() {
  return 'DowCategoryCounts(dayOfWeek: $dayOfWeek, activityCategoryId: $activityCategoryId, pastWeek: $pastWeek, pastMonth: $pastMonth, pastYear: $pastYear, allTime: $allTime)';
}


}

/// @nodoc
abstract mixin class $DowCategoryCountsCopyWith<$Res>  {
  factory $DowCategoryCountsCopyWith(DowCategoryCounts value, $Res Function(DowCategoryCounts) _then) = _$DowCategoryCountsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'activity_category_id') String activityCategoryId,@JsonKey(name: 'past_week') int pastWeek,@JsonKey(name: 'past_month') int pastMonth,@JsonKey(name: 'past_year') int pastYear,@JsonKey(name: 'all_time') int allTime
});




}
/// @nodoc
class _$DowCategoryCountsCopyWithImpl<$Res>
    implements $DowCategoryCountsCopyWith<$Res> {
  _$DowCategoryCountsCopyWithImpl(this._self, this._then);

  final DowCategoryCounts _self;
  final $Res Function(DowCategoryCounts) _then;

/// Create a copy of DowCategoryCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayOfWeek = null,Object? activityCategoryId = null,Object? pastWeek = null,Object? pastMonth = null,Object? pastYear = null,Object? allTime = null,}) {
  return _then(_self.copyWith(
dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,activityCategoryId: null == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String,pastWeek: null == pastWeek ? _self.pastWeek : pastWeek // ignore: cast_nullable_to_non_nullable
as int,pastMonth: null == pastMonth ? _self.pastMonth : pastMonth // ignore: cast_nullable_to_non_nullable
as int,pastYear: null == pastYear ? _self.pastYear : pastYear // ignore: cast_nullable_to_non_nullable
as int,allTime: null == allTime ? _self.allTime : allTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DowCategoryCounts].
extension DowCategoryCountsPatterns on DowCategoryCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DowCategoryCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DowCategoryCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DowCategoryCounts value)  $default,){
final _that = this;
switch (_that) {
case _DowCategoryCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DowCategoryCounts value)?  $default,){
final _that = this;
switch (_that) {
case _DowCategoryCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'activity_category_id')  String activityCategoryId, @JsonKey(name: 'past_week')  int pastWeek, @JsonKey(name: 'past_month')  int pastMonth, @JsonKey(name: 'past_year')  int pastYear, @JsonKey(name: 'all_time')  int allTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DowCategoryCounts() when $default != null:
return $default(_that.dayOfWeek,_that.activityCategoryId,_that.pastWeek,_that.pastMonth,_that.pastYear,_that.allTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'activity_category_id')  String activityCategoryId, @JsonKey(name: 'past_week')  int pastWeek, @JsonKey(name: 'past_month')  int pastMonth, @JsonKey(name: 'past_year')  int pastYear, @JsonKey(name: 'all_time')  int allTime)  $default,) {final _that = this;
switch (_that) {
case _DowCategoryCounts():
return $default(_that.dayOfWeek,_that.activityCategoryId,_that.pastWeek,_that.pastMonth,_that.pastYear,_that.allTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'activity_category_id')  String activityCategoryId, @JsonKey(name: 'past_week')  int pastWeek, @JsonKey(name: 'past_month')  int pastMonth, @JsonKey(name: 'past_year')  int pastYear, @JsonKey(name: 'all_time')  int allTime)?  $default,) {final _that = this;
switch (_that) {
case _DowCategoryCounts() when $default != null:
return $default(_that.dayOfWeek,_that.activityCategoryId,_that.pastWeek,_that.pastMonth,_that.pastYear,_that.allTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DowCategoryCounts implements DowCategoryCounts {
  const _DowCategoryCounts({@JsonKey(name: 'day_of_week') required this.dayOfWeek, @JsonKey(name: 'activity_category_id') required this.activityCategoryId, @JsonKey(name: 'past_week') required this.pastWeek, @JsonKey(name: 'past_month') required this.pastMonth, @JsonKey(name: 'past_year') required this.pastYear, @JsonKey(name: 'all_time') required this.allTime});
  factory _DowCategoryCounts.fromJson(Map<String, dynamic> json) => _$DowCategoryCountsFromJson(json);

@override@JsonKey(name: 'day_of_week') final  int dayOfWeek;
@override@JsonKey(name: 'activity_category_id') final  String activityCategoryId;
@override@JsonKey(name: 'past_week') final  int pastWeek;
@override@JsonKey(name: 'past_month') final  int pastMonth;
@override@JsonKey(name: 'past_year') final  int pastYear;
@override@JsonKey(name: 'all_time') final  int allTime;

/// Create a copy of DowCategoryCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DowCategoryCountsCopyWith<_DowCategoryCounts> get copyWith => __$DowCategoryCountsCopyWithImpl<_DowCategoryCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DowCategoryCountsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DowCategoryCounts&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId)&&(identical(other.pastWeek, pastWeek) || other.pastWeek == pastWeek)&&(identical(other.pastMonth, pastMonth) || other.pastMonth == pastMonth)&&(identical(other.pastYear, pastYear) || other.pastYear == pastYear)&&(identical(other.allTime, allTime) || other.allTime == allTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayOfWeek,activityCategoryId,pastWeek,pastMonth,pastYear,allTime);

@override
String toString() {
  return 'DowCategoryCounts(dayOfWeek: $dayOfWeek, activityCategoryId: $activityCategoryId, pastWeek: $pastWeek, pastMonth: $pastMonth, pastYear: $pastYear, allTime: $allTime)';
}


}

/// @nodoc
abstract mixin class _$DowCategoryCountsCopyWith<$Res> implements $DowCategoryCountsCopyWith<$Res> {
  factory _$DowCategoryCountsCopyWith(_DowCategoryCounts value, $Res Function(_DowCategoryCounts) _then) = __$DowCategoryCountsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'activity_category_id') String activityCategoryId,@JsonKey(name: 'past_week') int pastWeek,@JsonKey(name: 'past_month') int pastMonth,@JsonKey(name: 'past_year') int pastYear,@JsonKey(name: 'all_time') int allTime
});




}
/// @nodoc
class __$DowCategoryCountsCopyWithImpl<$Res>
    implements _$DowCategoryCountsCopyWith<$Res> {
  __$DowCategoryCountsCopyWithImpl(this._self, this._then);

  final _DowCategoryCounts _self;
  final $Res Function(_DowCategoryCounts) _then;

/// Create a copy of DowCategoryCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayOfWeek = null,Object? activityCategoryId = null,Object? pastWeek = null,Object? pastMonth = null,Object? pastYear = null,Object? allTime = null,}) {
  return _then(_DowCategoryCounts(
dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,activityCategoryId: null == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String,pastWeek: null == pastWeek ? _self.pastWeek : pastWeek // ignore: cast_nullable_to_non_nullable
as int,pastMonth: null == pastMonth ? _self.pastMonth : pastMonth // ignore: cast_nullable_to_non_nullable
as int,pastYear: null == pastYear ? _self.pastYear : pastYear // ignore: cast_nullable_to_non_nullable
as int,allTime: null == allTime ? _self.allTime : allTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
