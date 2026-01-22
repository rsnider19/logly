// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trending_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrendingActivity {

 String get activityId; int get currentRank; int get previousRank; int get rankChange;/// The activity definition (populated via join).
 Activity? get activity;
/// Create a copy of TrendingActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendingActivityCopyWith<TrendingActivity> get copyWith => _$TrendingActivityCopyWithImpl<TrendingActivity>(this as TrendingActivity, _$identity);

  /// Serializes this TrendingActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendingActivity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.currentRank, currentRank) || other.currentRank == currentRank)&&(identical(other.previousRank, previousRank) || other.previousRank == previousRank)&&(identical(other.rankChange, rankChange) || other.rankChange == rankChange)&&(identical(other.activity, activity) || other.activity == activity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,currentRank,previousRank,rankChange,activity);

@override
String toString() {
  return 'TrendingActivity(activityId: $activityId, currentRank: $currentRank, previousRank: $previousRank, rankChange: $rankChange, activity: $activity)';
}


}

/// @nodoc
abstract mixin class $TrendingActivityCopyWith<$Res>  {
  factory $TrendingActivityCopyWith(TrendingActivity value, $Res Function(TrendingActivity) _then) = _$TrendingActivityCopyWithImpl;
@useResult
$Res call({
 String activityId, int currentRank, int previousRank, int rankChange, Activity? activity
});


$ActivityCopyWith<$Res>? get activity;

}
/// @nodoc
class _$TrendingActivityCopyWithImpl<$Res>
    implements $TrendingActivityCopyWith<$Res> {
  _$TrendingActivityCopyWithImpl(this._self, this._then);

  final TrendingActivity _self;
  final $Res Function(TrendingActivity) _then;

/// Create a copy of TrendingActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityId = null,Object? currentRank = null,Object? previousRank = null,Object? rankChange = null,Object? activity = freezed,}) {
  return _then(_self.copyWith(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,currentRank: null == currentRank ? _self.currentRank : currentRank // ignore: cast_nullable_to_non_nullable
as int,previousRank: null == previousRank ? _self.previousRank : previousRank // ignore: cast_nullable_to_non_nullable
as int,rankChange: null == rankChange ? _self.rankChange : rankChange // ignore: cast_nullable_to_non_nullable
as int,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as Activity?,
  ));
}
/// Create a copy of TrendingActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityCopyWith<$Res>? get activity {
    if (_self.activity == null) {
    return null;
  }

  return $ActivityCopyWith<$Res>(_self.activity!, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrendingActivity].
extension TrendingActivityPatterns on TrendingActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendingActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendingActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendingActivity value)  $default,){
final _that = this;
switch (_that) {
case _TrendingActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendingActivity value)?  $default,){
final _that = this;
switch (_that) {
case _TrendingActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String activityId,  int currentRank,  int previousRank,  int rankChange,  Activity? activity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendingActivity() when $default != null:
return $default(_that.activityId,_that.currentRank,_that.previousRank,_that.rankChange,_that.activity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String activityId,  int currentRank,  int previousRank,  int rankChange,  Activity? activity)  $default,) {final _that = this;
switch (_that) {
case _TrendingActivity():
return $default(_that.activityId,_that.currentRank,_that.previousRank,_that.rankChange,_that.activity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String activityId,  int currentRank,  int previousRank,  int rankChange,  Activity? activity)?  $default,) {final _that = this;
switch (_that) {
case _TrendingActivity() when $default != null:
return $default(_that.activityId,_that.currentRank,_that.previousRank,_that.rankChange,_that.activity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrendingActivity extends TrendingActivity {
  const _TrendingActivity({required this.activityId, required this.currentRank, required this.previousRank, required this.rankChange, this.activity}): super._();
  factory _TrendingActivity.fromJson(Map<String, dynamic> json) => _$TrendingActivityFromJson(json);

@override final  String activityId;
@override final  int currentRank;
@override final  int previousRank;
@override final  int rankChange;
/// The activity definition (populated via join).
@override final  Activity? activity;

/// Create a copy of TrendingActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendingActivityCopyWith<_TrendingActivity> get copyWith => __$TrendingActivityCopyWithImpl<_TrendingActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrendingActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendingActivity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.currentRank, currentRank) || other.currentRank == currentRank)&&(identical(other.previousRank, previousRank) || other.previousRank == previousRank)&&(identical(other.rankChange, rankChange) || other.rankChange == rankChange)&&(identical(other.activity, activity) || other.activity == activity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,currentRank,previousRank,rankChange,activity);

@override
String toString() {
  return 'TrendingActivity(activityId: $activityId, currentRank: $currentRank, previousRank: $previousRank, rankChange: $rankChange, activity: $activity)';
}


}

/// @nodoc
abstract mixin class _$TrendingActivityCopyWith<$Res> implements $TrendingActivityCopyWith<$Res> {
  factory _$TrendingActivityCopyWith(_TrendingActivity value, $Res Function(_TrendingActivity) _then) = __$TrendingActivityCopyWithImpl;
@override @useResult
$Res call({
 String activityId, int currentRank, int previousRank, int rankChange, Activity? activity
});


@override $ActivityCopyWith<$Res>? get activity;

}
/// @nodoc
class __$TrendingActivityCopyWithImpl<$Res>
    implements _$TrendingActivityCopyWith<$Res> {
  __$TrendingActivityCopyWithImpl(this._self, this._then);

  final _TrendingActivity _self;
  final $Res Function(_TrendingActivity) _then;

/// Create a copy of TrendingActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityId = null,Object? currentRank = null,Object? previousRank = null,Object? rankChange = null,Object? activity = freezed,}) {
  return _then(_TrendingActivity(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,currentRank: null == currentRank ? _self.currentRank : currentRank // ignore: cast_nullable_to_non_nullable
as int,previousRank: null == previousRank ? _self.previousRank : previousRank // ignore: cast_nullable_to_non_nullable
as int,rankChange: null == rankChange ? _self.rankChange : rankChange // ignore: cast_nullable_to_non_nullable
as int,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as Activity?,
  ));
}

/// Create a copy of TrendingActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityCopyWith<$Res>? get activity {
    if (_self.activity == null) {
    return null;
  }

  return $ActivityCopyWith<$Res>(_self.activity!, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}

// dart format on
