// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoriteActivity {

 String get userId; String get activityId; DateTime get createdAt;/// The activity summary (populated via join).
 ActivitySummary? get activity;
/// Create a copy of FavoriteActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteActivityCopyWith<FavoriteActivity> get copyWith => _$FavoriteActivityCopyWithImpl<FavoriteActivity>(this as FavoriteActivity, _$identity);

  /// Serializes this FavoriteActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteActivity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.activity, activity) || other.activity == activity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,activityId,createdAt,activity);

@override
String toString() {
  return 'FavoriteActivity(userId: $userId, activityId: $activityId, createdAt: $createdAt, activity: $activity)';
}


}

/// @nodoc
abstract mixin class $FavoriteActivityCopyWith<$Res>  {
  factory $FavoriteActivityCopyWith(FavoriteActivity value, $Res Function(FavoriteActivity) _then) = _$FavoriteActivityCopyWithImpl;
@useResult
$Res call({
 String userId, String activityId, DateTime createdAt, ActivitySummary? activity
});


$ActivitySummaryCopyWith<$Res>? get activity;

}
/// @nodoc
class _$FavoriteActivityCopyWithImpl<$Res>
    implements $FavoriteActivityCopyWith<$Res> {
  _$FavoriteActivityCopyWithImpl(this._self, this._then);

  final FavoriteActivity _self;
  final $Res Function(FavoriteActivity) _then;

/// Create a copy of FavoriteActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? activityId = null,Object? createdAt = null,Object? activity = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivitySummary?,
  ));
}
/// Create a copy of FavoriteActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivitySummaryCopyWith<$Res>? get activity {
    if (_self.activity == null) {
    return null;
  }

  return $ActivitySummaryCopyWith<$Res>(_self.activity!, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}


/// Adds pattern-matching-related methods to [FavoriteActivity].
extension FavoriteActivityPatterns on FavoriteActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteActivity value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteActivity value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String activityId,  DateTime createdAt,  ActivitySummary? activity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteActivity() when $default != null:
return $default(_that.userId,_that.activityId,_that.createdAt,_that.activity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String activityId,  DateTime createdAt,  ActivitySummary? activity)  $default,) {final _that = this;
switch (_that) {
case _FavoriteActivity():
return $default(_that.userId,_that.activityId,_that.createdAt,_that.activity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String activityId,  DateTime createdAt,  ActivitySummary? activity)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteActivity() when $default != null:
return $default(_that.userId,_that.activityId,_that.createdAt,_that.activity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoriteActivity implements FavoriteActivity {
  const _FavoriteActivity({required this.userId, required this.activityId, required this.createdAt, this.activity});
  factory _FavoriteActivity.fromJson(Map<String, dynamic> json) => _$FavoriteActivityFromJson(json);

@override final  String userId;
@override final  String activityId;
@override final  DateTime createdAt;
/// The activity summary (populated via join).
@override final  ActivitySummary? activity;

/// Create a copy of FavoriteActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteActivityCopyWith<_FavoriteActivity> get copyWith => __$FavoriteActivityCopyWithImpl<_FavoriteActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteActivity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.activity, activity) || other.activity == activity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,activityId,createdAt,activity);

@override
String toString() {
  return 'FavoriteActivity(userId: $userId, activityId: $activityId, createdAt: $createdAt, activity: $activity)';
}


}

/// @nodoc
abstract mixin class _$FavoriteActivityCopyWith<$Res> implements $FavoriteActivityCopyWith<$Res> {
  factory _$FavoriteActivityCopyWith(_FavoriteActivity value, $Res Function(_FavoriteActivity) _then) = __$FavoriteActivityCopyWithImpl;
@override @useResult
$Res call({
 String userId, String activityId, DateTime createdAt, ActivitySummary? activity
});


@override $ActivitySummaryCopyWith<$Res>? get activity;

}
/// @nodoc
class __$FavoriteActivityCopyWithImpl<$Res>
    implements _$FavoriteActivityCopyWith<$Res> {
  __$FavoriteActivityCopyWithImpl(this._self, this._then);

  final _FavoriteActivity _self;
  final $Res Function(_FavoriteActivity) _then;

/// Create a copy of FavoriteActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? activityId = null,Object? createdAt = null,Object? activity = freezed,}) {
  return _then(_FavoriteActivity(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivitySummary?,
  ));
}

/// Create a copy of FavoriteActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivitySummaryCopyWith<$Res>? get activity {
    if (_self.activity == null) {
    return null;
  }

  return $ActivitySummaryCopyWith<$Res>(_self.activity!, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}

// dart format on
