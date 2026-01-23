// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_activity_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DayActivityCount {

@JsonKey(name: 'activity_day') DateTime get date;@JsonKey(name: 'activity_count') int get count;
/// Create a copy of DayActivityCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayActivityCountCopyWith<DayActivityCount> get copyWith => _$DayActivityCountCopyWithImpl<DayActivityCount>(this as DayActivityCount, _$identity);

  /// Serializes this DayActivityCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayActivityCount&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,count);

@override
String toString() {
  return 'DayActivityCount(date: $date, count: $count)';
}


}

/// @nodoc
abstract mixin class $DayActivityCountCopyWith<$Res>  {
  factory $DayActivityCountCopyWith(DayActivityCount value, $Res Function(DayActivityCount) _then) = _$DayActivityCountCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'activity_day') DateTime date,@JsonKey(name: 'activity_count') int count
});




}
/// @nodoc
class _$DayActivityCountCopyWithImpl<$Res>
    implements $DayActivityCountCopyWith<$Res> {
  _$DayActivityCountCopyWithImpl(this._self, this._then);

  final DayActivityCount _self;
  final $Res Function(DayActivityCount) _then;

/// Create a copy of DayActivityCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? count = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DayActivityCount].
extension DayActivityCountPatterns on DayActivityCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayActivityCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayActivityCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayActivityCount value)  $default,){
final _that = this;
switch (_that) {
case _DayActivityCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayActivityCount value)?  $default,){
final _that = this;
switch (_that) {
case _DayActivityCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_day')  DateTime date, @JsonKey(name: 'activity_count')  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayActivityCount() when $default != null:
return $default(_that.date,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_day')  DateTime date, @JsonKey(name: 'activity_count')  int count)  $default,) {final _that = this;
switch (_that) {
case _DayActivityCount():
return $default(_that.date,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'activity_day')  DateTime date, @JsonKey(name: 'activity_count')  int count)?  $default,) {final _that = this;
switch (_that) {
case _DayActivityCount() when $default != null:
return $default(_that.date,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayActivityCount implements DayActivityCount {
  const _DayActivityCount({@JsonKey(name: 'activity_day') required this.date, @JsonKey(name: 'activity_count') required this.count});
  factory _DayActivityCount.fromJson(Map<String, dynamic> json) => _$DayActivityCountFromJson(json);

@override@JsonKey(name: 'activity_day') final  DateTime date;
@override@JsonKey(name: 'activity_count') final  int count;

/// Create a copy of DayActivityCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayActivityCountCopyWith<_DayActivityCount> get copyWith => __$DayActivityCountCopyWithImpl<_DayActivityCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayActivityCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayActivityCount&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,count);

@override
String toString() {
  return 'DayActivityCount(date: $date, count: $count)';
}


}

/// @nodoc
abstract mixin class _$DayActivityCountCopyWith<$Res> implements $DayActivityCountCopyWith<$Res> {
  factory _$DayActivityCountCopyWith(_DayActivityCount value, $Res Function(_DayActivityCount) _then) = __$DayActivityCountCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'activity_day') DateTime date,@JsonKey(name: 'activity_count') int count
});




}
/// @nodoc
class __$DayActivityCountCopyWithImpl<$Res>
    implements _$DayActivityCountCopyWith<$Res> {
  __$DayActivityCountCopyWithImpl(this._self, this._then);

  final _DayActivityCount _self;
  final $Res Function(_DayActivityCount) _then;

/// Create a copy of DayActivityCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? count = null,}) {
  return _then(_DayActivityCount(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
