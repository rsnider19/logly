// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserActivity {

 String get userActivityId; String get userId; String get activityId; DateTime get activityTimestamp; DateTime? get createdAt; DateTime? get updatedAt; String? get comments; String? get activityNameOverride;/// The activity definition (populated via join).
 Activity? get activity;/// The detail values for this log (populated via join).
 List<UserActivityDetail> get userActivityDetail;/// The selected subactivities (populated via join).
 List<SubActivity> get subActivity;
/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserActivityCopyWith<UserActivity> get copyWith => _$UserActivityCopyWithImpl<UserActivity>(this as UserActivity, _$identity);

  /// Serializes this UserActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserActivity&&(identical(other.userActivityId, userActivityId) || other.userActivityId == userActivityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.activityTimestamp, activityTimestamp) || other.activityTimestamp == activityTimestamp)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.activityNameOverride, activityNameOverride) || other.activityNameOverride == activityNameOverride)&&(identical(other.activity, activity) || other.activity == activity)&&const DeepCollectionEquality().equals(other.userActivityDetail, userActivityDetail)&&const DeepCollectionEquality().equals(other.subActivity, subActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userActivityId,userId,activityId,activityTimestamp,createdAt,updatedAt,comments,activityNameOverride,activity,const DeepCollectionEquality().hash(userActivityDetail),const DeepCollectionEquality().hash(subActivity));

@override
String toString() {
  return 'UserActivity(userActivityId: $userActivityId, userId: $userId, activityId: $activityId, activityTimestamp: $activityTimestamp, createdAt: $createdAt, updatedAt: $updatedAt, comments: $comments, activityNameOverride: $activityNameOverride, activity: $activity, userActivityDetail: $userActivityDetail, subActivity: $subActivity)';
}


}

/// @nodoc
abstract mixin class $UserActivityCopyWith<$Res>  {
  factory $UserActivityCopyWith(UserActivity value, $Res Function(UserActivity) _then) = _$UserActivityCopyWithImpl;
@useResult
$Res call({
 String userActivityId, String userId, String activityId, DateTime activityTimestamp, DateTime? createdAt, DateTime? updatedAt, String? comments, String? activityNameOverride, Activity? activity, List<UserActivityDetail> userActivityDetail, List<SubActivity> subActivity
});


$ActivityCopyWith<$Res>? get activity;

}
/// @nodoc
class _$UserActivityCopyWithImpl<$Res>
    implements $UserActivityCopyWith<$Res> {
  _$UserActivityCopyWithImpl(this._self, this._then);

  final UserActivity _self;
  final $Res Function(UserActivity) _then;

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userActivityId = null,Object? userId = null,Object? activityId = null,Object? activityTimestamp = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? comments = freezed,Object? activityNameOverride = freezed,Object? activity = freezed,Object? userActivityDetail = null,Object? subActivity = null,}) {
  return _then(_self.copyWith(
userActivityId: null == userActivityId ? _self.userActivityId : userActivityId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,activityTimestamp: null == activityTimestamp ? _self.activityTimestamp : activityTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,activityNameOverride: freezed == activityNameOverride ? _self.activityNameOverride : activityNameOverride // ignore: cast_nullable_to_non_nullable
as String?,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as Activity?,userActivityDetail: null == userActivityDetail ? _self.userActivityDetail : userActivityDetail // ignore: cast_nullable_to_non_nullable
as List<UserActivityDetail>,subActivity: null == subActivity ? _self.subActivity : subActivity // ignore: cast_nullable_to_non_nullable
as List<SubActivity>,
  ));
}
/// Create a copy of UserActivity
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


/// Adds pattern-matching-related methods to [UserActivity].
extension UserActivityPatterns on UserActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserActivity value)  $default,){
final _that = this;
switch (_that) {
case _UserActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserActivity value)?  $default,){
final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userActivityId,  String userId,  String activityId,  DateTime activityTimestamp,  DateTime? createdAt,  DateTime? updatedAt,  String? comments,  String? activityNameOverride,  Activity? activity,  List<UserActivityDetail> userActivityDetail,  List<SubActivity> subActivity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that.userActivityId,_that.userId,_that.activityId,_that.activityTimestamp,_that.createdAt,_that.updatedAt,_that.comments,_that.activityNameOverride,_that.activity,_that.userActivityDetail,_that.subActivity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userActivityId,  String userId,  String activityId,  DateTime activityTimestamp,  DateTime? createdAt,  DateTime? updatedAt,  String? comments,  String? activityNameOverride,  Activity? activity,  List<UserActivityDetail> userActivityDetail,  List<SubActivity> subActivity)  $default,) {final _that = this;
switch (_that) {
case _UserActivity():
return $default(_that.userActivityId,_that.userId,_that.activityId,_that.activityTimestamp,_that.createdAt,_that.updatedAt,_that.comments,_that.activityNameOverride,_that.activity,_that.userActivityDetail,_that.subActivity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userActivityId,  String userId,  String activityId,  DateTime activityTimestamp,  DateTime? createdAt,  DateTime? updatedAt,  String? comments,  String? activityNameOverride,  Activity? activity,  List<UserActivityDetail> userActivityDetail,  List<SubActivity> subActivity)?  $default,) {final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that.userActivityId,_that.userId,_that.activityId,_that.activityTimestamp,_that.createdAt,_that.updatedAt,_that.comments,_that.activityNameOverride,_that.activity,_that.userActivityDetail,_that.subActivity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserActivity extends UserActivity {
  const _UserActivity({required this.userActivityId, required this.userId, required this.activityId, required this.activityTimestamp, this.createdAt, this.updatedAt, this.comments, this.activityNameOverride, this.activity, final  List<UserActivityDetail> userActivityDetail = const [], final  List<SubActivity> subActivity = const []}): _userActivityDetail = userActivityDetail,_subActivity = subActivity,super._();
  factory _UserActivity.fromJson(Map<String, dynamic> json) => _$UserActivityFromJson(json);

@override final  String userActivityId;
@override final  String userId;
@override final  String activityId;
@override final  DateTime activityTimestamp;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  String? comments;
@override final  String? activityNameOverride;
/// The activity definition (populated via join).
@override final  Activity? activity;
/// The detail values for this log (populated via join).
 final  List<UserActivityDetail> _userActivityDetail;
/// The detail values for this log (populated via join).
@override@JsonKey() List<UserActivityDetail> get userActivityDetail {
  if (_userActivityDetail is EqualUnmodifiableListView) return _userActivityDetail;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userActivityDetail);
}

/// The selected subactivities (populated via join).
 final  List<SubActivity> _subActivity;
/// The selected subactivities (populated via join).
@override@JsonKey() List<SubActivity> get subActivity {
  if (_subActivity is EqualUnmodifiableListView) return _subActivity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subActivity);
}


/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserActivityCopyWith<_UserActivity> get copyWith => __$UserActivityCopyWithImpl<_UserActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserActivity&&(identical(other.userActivityId, userActivityId) || other.userActivityId == userActivityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.activityTimestamp, activityTimestamp) || other.activityTimestamp == activityTimestamp)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.activityNameOverride, activityNameOverride) || other.activityNameOverride == activityNameOverride)&&(identical(other.activity, activity) || other.activity == activity)&&const DeepCollectionEquality().equals(other._userActivityDetail, _userActivityDetail)&&const DeepCollectionEquality().equals(other._subActivity, _subActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userActivityId,userId,activityId,activityTimestamp,createdAt,updatedAt,comments,activityNameOverride,activity,const DeepCollectionEquality().hash(_userActivityDetail),const DeepCollectionEquality().hash(_subActivity));

@override
String toString() {
  return 'UserActivity(userActivityId: $userActivityId, userId: $userId, activityId: $activityId, activityTimestamp: $activityTimestamp, createdAt: $createdAt, updatedAt: $updatedAt, comments: $comments, activityNameOverride: $activityNameOverride, activity: $activity, userActivityDetail: $userActivityDetail, subActivity: $subActivity)';
}


}

/// @nodoc
abstract mixin class _$UserActivityCopyWith<$Res> implements $UserActivityCopyWith<$Res> {
  factory _$UserActivityCopyWith(_UserActivity value, $Res Function(_UserActivity) _then) = __$UserActivityCopyWithImpl;
@override @useResult
$Res call({
 String userActivityId, String userId, String activityId, DateTime activityTimestamp, DateTime? createdAt, DateTime? updatedAt, String? comments, String? activityNameOverride, Activity? activity, List<UserActivityDetail> userActivityDetail, List<SubActivity> subActivity
});


@override $ActivityCopyWith<$Res>? get activity;

}
/// @nodoc
class __$UserActivityCopyWithImpl<$Res>
    implements _$UserActivityCopyWith<$Res> {
  __$UserActivityCopyWithImpl(this._self, this._then);

  final _UserActivity _self;
  final $Res Function(_UserActivity) _then;

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userActivityId = null,Object? userId = null,Object? activityId = null,Object? activityTimestamp = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? comments = freezed,Object? activityNameOverride = freezed,Object? activity = freezed,Object? userActivityDetail = null,Object? subActivity = null,}) {
  return _then(_UserActivity(
userActivityId: null == userActivityId ? _self.userActivityId : userActivityId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,activityTimestamp: null == activityTimestamp ? _self.activityTimestamp : activityTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,activityNameOverride: freezed == activityNameOverride ? _self.activityNameOverride : activityNameOverride // ignore: cast_nullable_to_non_nullable
as String?,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as Activity?,userActivityDetail: null == userActivityDetail ? _self._userActivityDetail : userActivityDetail // ignore: cast_nullable_to_non_nullable
as List<UserActivityDetail>,subActivity: null == subActivity ? _self._subActivity : subActivity // ignore: cast_nullable_to_non_nullable
as List<SubActivity>,
  ));
}

/// Create a copy of UserActivity
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
