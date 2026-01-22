// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_activity_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyActivitySummary {

 DateTime get activityDate; int get activityCount; List<UserActivity> get userActivities;
/// Create a copy of DailyActivitySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyActivitySummaryCopyWith<DailyActivitySummary> get copyWith => _$DailyActivitySummaryCopyWithImpl<DailyActivitySummary>(this as DailyActivitySummary, _$identity);

  /// Serializes this DailyActivitySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyActivitySummary&&(identical(other.activityDate, activityDate) || other.activityDate == activityDate)&&(identical(other.activityCount, activityCount) || other.activityCount == activityCount)&&const DeepCollectionEquality().equals(other.userActivities, userActivities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityDate,activityCount,const DeepCollectionEquality().hash(userActivities));

@override
String toString() {
  return 'DailyActivitySummary(activityDate: $activityDate, activityCount: $activityCount, userActivities: $userActivities)';
}


}

/// @nodoc
abstract mixin class $DailyActivitySummaryCopyWith<$Res>  {
  factory $DailyActivitySummaryCopyWith(DailyActivitySummary value, $Res Function(DailyActivitySummary) _then) = _$DailyActivitySummaryCopyWithImpl;
@useResult
$Res call({
 DateTime activityDate, int activityCount, List<UserActivity> userActivities
});




}
/// @nodoc
class _$DailyActivitySummaryCopyWithImpl<$Res>
    implements $DailyActivitySummaryCopyWith<$Res> {
  _$DailyActivitySummaryCopyWithImpl(this._self, this._then);

  final DailyActivitySummary _self;
  final $Res Function(DailyActivitySummary) _then;

/// Create a copy of DailyActivitySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityDate = null,Object? activityCount = null,Object? userActivities = null,}) {
  return _then(_self.copyWith(
activityDate: null == activityDate ? _self.activityDate : activityDate // ignore: cast_nullable_to_non_nullable
as DateTime,activityCount: null == activityCount ? _self.activityCount : activityCount // ignore: cast_nullable_to_non_nullable
as int,userActivities: null == userActivities ? _self.userActivities : userActivities // ignore: cast_nullable_to_non_nullable
as List<UserActivity>,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyActivitySummary].
extension DailyActivitySummaryPatterns on DailyActivitySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyActivitySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyActivitySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyActivitySummary value)  $default,){
final _that = this;
switch (_that) {
case _DailyActivitySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyActivitySummary value)?  $default,){
final _that = this;
switch (_that) {
case _DailyActivitySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime activityDate,  int activityCount,  List<UserActivity> userActivities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyActivitySummary() when $default != null:
return $default(_that.activityDate,_that.activityCount,_that.userActivities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime activityDate,  int activityCount,  List<UserActivity> userActivities)  $default,) {final _that = this;
switch (_that) {
case _DailyActivitySummary():
return $default(_that.activityDate,_that.activityCount,_that.userActivities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime activityDate,  int activityCount,  List<UserActivity> userActivities)?  $default,) {final _that = this;
switch (_that) {
case _DailyActivitySummary() when $default != null:
return $default(_that.activityDate,_that.activityCount,_that.userActivities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyActivitySummary implements DailyActivitySummary {
  const _DailyActivitySummary({required this.activityDate, required this.activityCount, final  List<UserActivity> userActivities = const []}): _userActivities = userActivities;
  factory _DailyActivitySummary.fromJson(Map<String, dynamic> json) => _$DailyActivitySummaryFromJson(json);

@override final  DateTime activityDate;
@override final  int activityCount;
 final  List<UserActivity> _userActivities;
@override@JsonKey() List<UserActivity> get userActivities {
  if (_userActivities is EqualUnmodifiableListView) return _userActivities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userActivities);
}


/// Create a copy of DailyActivitySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyActivitySummaryCopyWith<_DailyActivitySummary> get copyWith => __$DailyActivitySummaryCopyWithImpl<_DailyActivitySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyActivitySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyActivitySummary&&(identical(other.activityDate, activityDate) || other.activityDate == activityDate)&&(identical(other.activityCount, activityCount) || other.activityCount == activityCount)&&const DeepCollectionEquality().equals(other._userActivities, _userActivities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityDate,activityCount,const DeepCollectionEquality().hash(_userActivities));

@override
String toString() {
  return 'DailyActivitySummary(activityDate: $activityDate, activityCount: $activityCount, userActivities: $userActivities)';
}


}

/// @nodoc
abstract mixin class _$DailyActivitySummaryCopyWith<$Res> implements $DailyActivitySummaryCopyWith<$Res> {
  factory _$DailyActivitySummaryCopyWith(_DailyActivitySummary value, $Res Function(_DailyActivitySummary) _then) = __$DailyActivitySummaryCopyWithImpl;
@override @useResult
$Res call({
 DateTime activityDate, int activityCount, List<UserActivity> userActivities
});




}
/// @nodoc
class __$DailyActivitySummaryCopyWithImpl<$Res>
    implements _$DailyActivitySummaryCopyWith<$Res> {
  __$DailyActivitySummaryCopyWithImpl(this._self, this._then);

  final _DailyActivitySummary _self;
  final $Res Function(_DailyActivitySummary) _then;

/// Create a copy of DailyActivitySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityDate = null,Object? activityCount = null,Object? userActivities = null,}) {
  return _then(_DailyActivitySummary(
activityDate: null == activityDate ? _self.activityDate : activityDate // ignore: cast_nullable_to_non_nullable
as DateTime,activityCount: null == activityCount ? _self.activityCount : activityCount // ignore: cast_nullable_to_non_nullable
as int,userActivities: null == userActivities ? _self._userActivities : userActivities // ignore: cast_nullable_to_non_nullable
as List<UserActivity>,
  ));
}


}

// dart format on
