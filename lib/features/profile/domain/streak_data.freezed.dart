// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StreakData {

@JsonKey(name: 'current_streak') int get currentStreak;@JsonKey(name: 'longest_streak') int get longestStreak;@JsonKey(name: 'workout_days_this_week') int get workoutDaysThisWeek;
/// Create a copy of StreakData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakDataCopyWith<StreakData> get copyWith => _$StreakDataCopyWithImpl<StreakData>(this as StreakData, _$identity);

  /// Serializes this StreakData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakData&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.workoutDaysThisWeek, workoutDaysThisWeek) || other.workoutDaysThisWeek == workoutDaysThisWeek));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStreak,longestStreak,workoutDaysThisWeek);

@override
String toString() {
  return 'StreakData(currentStreak: $currentStreak, longestStreak: $longestStreak, workoutDaysThisWeek: $workoutDaysThisWeek)';
}


}

/// @nodoc
abstract mixin class $StreakDataCopyWith<$Res>  {
  factory $StreakDataCopyWith(StreakData value, $Res Function(StreakData) _then) = _$StreakDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current_streak') int currentStreak,@JsonKey(name: 'longest_streak') int longestStreak,@JsonKey(name: 'workout_days_this_week') int workoutDaysThisWeek
});




}
/// @nodoc
class _$StreakDataCopyWithImpl<$Res>
    implements $StreakDataCopyWith<$Res> {
  _$StreakDataCopyWithImpl(this._self, this._then);

  final StreakData _self;
  final $Res Function(StreakData) _then;

/// Create a copy of StreakData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStreak = null,Object? longestStreak = null,Object? workoutDaysThisWeek = null,}) {
  return _then(_self.copyWith(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,workoutDaysThisWeek: null == workoutDaysThisWeek ? _self.workoutDaysThisWeek : workoutDaysThisWeek // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StreakData].
extension StreakDataPatterns on StreakData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreakData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreakData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreakData value)  $default,){
final _that = this;
switch (_that) {
case _StreakData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreakData value)?  $default,){
final _that = this;
switch (_that) {
case _StreakData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_streak')  int currentStreak, @JsonKey(name: 'longest_streak')  int longestStreak, @JsonKey(name: 'workout_days_this_week')  int workoutDaysThisWeek)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreakData() when $default != null:
return $default(_that.currentStreak,_that.longestStreak,_that.workoutDaysThisWeek);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_streak')  int currentStreak, @JsonKey(name: 'longest_streak')  int longestStreak, @JsonKey(name: 'workout_days_this_week')  int workoutDaysThisWeek)  $default,) {final _that = this;
switch (_that) {
case _StreakData():
return $default(_that.currentStreak,_that.longestStreak,_that.workoutDaysThisWeek);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'current_streak')  int currentStreak, @JsonKey(name: 'longest_streak')  int longestStreak, @JsonKey(name: 'workout_days_this_week')  int workoutDaysThisWeek)?  $default,) {final _that = this;
switch (_that) {
case _StreakData() when $default != null:
return $default(_that.currentStreak,_that.longestStreak,_that.workoutDaysThisWeek);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StreakData implements StreakData {
  const _StreakData({@JsonKey(name: 'current_streak') required this.currentStreak, @JsonKey(name: 'longest_streak') required this.longestStreak, @JsonKey(name: 'workout_days_this_week') required this.workoutDaysThisWeek});
  factory _StreakData.fromJson(Map<String, dynamic> json) => _$StreakDataFromJson(json);

@override@JsonKey(name: 'current_streak') final  int currentStreak;
@override@JsonKey(name: 'longest_streak') final  int longestStreak;
@override@JsonKey(name: 'workout_days_this_week') final  int workoutDaysThisWeek;

/// Create a copy of StreakData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakDataCopyWith<_StreakData> get copyWith => __$StreakDataCopyWithImpl<_StreakData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreakDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakData&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.workoutDaysThisWeek, workoutDaysThisWeek) || other.workoutDaysThisWeek == workoutDaysThisWeek));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStreak,longestStreak,workoutDaysThisWeek);

@override
String toString() {
  return 'StreakData(currentStreak: $currentStreak, longestStreak: $longestStreak, workoutDaysThisWeek: $workoutDaysThisWeek)';
}


}

/// @nodoc
abstract mixin class _$StreakDataCopyWith<$Res> implements $StreakDataCopyWith<$Res> {
  factory _$StreakDataCopyWith(_StreakData value, $Res Function(_StreakData) _then) = __$StreakDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current_streak') int currentStreak,@JsonKey(name: 'longest_streak') int longestStreak,@JsonKey(name: 'workout_days_this_week') int workoutDaysThisWeek
});




}
/// @nodoc
class __$StreakDataCopyWithImpl<$Res>
    implements _$StreakDataCopyWith<$Res> {
  __$StreakDataCopyWithImpl(this._self, this._then);

  final _StreakData _self;
  final $Res Function(_StreakData) _then;

/// Create a copy of StreakData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStreak = null,Object? longestStreak = null,Object? workoutDaysThisWeek = null,}) {
  return _then(_StreakData(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,workoutDaysThisWeek: null == workoutDaysThisWeek ? _self.workoutDaysThisWeek : workoutDaysThisWeek // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
