// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateUserActivity {

/// The ID of the user activity to update.
 String get userActivityId;/// The updated timestamp of the activity.
 DateTime get activityTimestamp;/// The updated date of the activity (date only, calculated client-side).
 DateTime get activityDate;/// Updated comments/notes.
 String? get comments;/// Updated custom name override.
 String? get activityNameOverride;/// Updated sub-activity IDs.
 List<String> get subActivityIds;/// Updated detail values.
 List<CreateUserActivityDetail> get details;
/// Create a copy of UpdateUserActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateUserActivityCopyWith<UpdateUserActivity> get copyWith => _$UpdateUserActivityCopyWithImpl<UpdateUserActivity>(this as UpdateUserActivity, _$identity);

  /// Serializes this UpdateUserActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateUserActivity&&(identical(other.userActivityId, userActivityId) || other.userActivityId == userActivityId)&&(identical(other.activityTimestamp, activityTimestamp) || other.activityTimestamp == activityTimestamp)&&(identical(other.activityDate, activityDate) || other.activityDate == activityDate)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.activityNameOverride, activityNameOverride) || other.activityNameOverride == activityNameOverride)&&const DeepCollectionEquality().equals(other.subActivityIds, subActivityIds)&&const DeepCollectionEquality().equals(other.details, details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userActivityId,activityTimestamp,activityDate,comments,activityNameOverride,const DeepCollectionEquality().hash(subActivityIds),const DeepCollectionEquality().hash(details));

@override
String toString() {
  return 'UpdateUserActivity(userActivityId: $userActivityId, activityTimestamp: $activityTimestamp, activityDate: $activityDate, comments: $comments, activityNameOverride: $activityNameOverride, subActivityIds: $subActivityIds, details: $details)';
}


}

/// @nodoc
abstract mixin class $UpdateUserActivityCopyWith<$Res>  {
  factory $UpdateUserActivityCopyWith(UpdateUserActivity value, $Res Function(UpdateUserActivity) _then) = _$UpdateUserActivityCopyWithImpl;
@useResult
$Res call({
 String userActivityId, DateTime activityTimestamp, DateTime activityDate, String? comments, String? activityNameOverride, List<String> subActivityIds, List<CreateUserActivityDetail> details
});




}
/// @nodoc
class _$UpdateUserActivityCopyWithImpl<$Res>
    implements $UpdateUserActivityCopyWith<$Res> {
  _$UpdateUserActivityCopyWithImpl(this._self, this._then);

  final UpdateUserActivity _self;
  final $Res Function(UpdateUserActivity) _then;

/// Create a copy of UpdateUserActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userActivityId = null,Object? activityTimestamp = null,Object? activityDate = null,Object? comments = freezed,Object? activityNameOverride = freezed,Object? subActivityIds = null,Object? details = null,}) {
  return _then(_self.copyWith(
userActivityId: null == userActivityId ? _self.userActivityId : userActivityId // ignore: cast_nullable_to_non_nullable
as String,activityTimestamp: null == activityTimestamp ? _self.activityTimestamp : activityTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,activityDate: null == activityDate ? _self.activityDate : activityDate // ignore: cast_nullable_to_non_nullable
as DateTime,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,activityNameOverride: freezed == activityNameOverride ? _self.activityNameOverride : activityNameOverride // ignore: cast_nullable_to_non_nullable
as String?,subActivityIds: null == subActivityIds ? _self.subActivityIds : subActivityIds // ignore: cast_nullable_to_non_nullable
as List<String>,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as List<CreateUserActivityDetail>,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateUserActivity].
extension UpdateUserActivityPatterns on UpdateUserActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateUserActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateUserActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateUserActivity value)  $default,){
final _that = this;
switch (_that) {
case _UpdateUserActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateUserActivity value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateUserActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userActivityId,  DateTime activityTimestamp,  DateTime activityDate,  String? comments,  String? activityNameOverride,  List<String> subActivityIds,  List<CreateUserActivityDetail> details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateUserActivity() when $default != null:
return $default(_that.userActivityId,_that.activityTimestamp,_that.activityDate,_that.comments,_that.activityNameOverride,_that.subActivityIds,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userActivityId,  DateTime activityTimestamp,  DateTime activityDate,  String? comments,  String? activityNameOverride,  List<String> subActivityIds,  List<CreateUserActivityDetail> details)  $default,) {final _that = this;
switch (_that) {
case _UpdateUserActivity():
return $default(_that.userActivityId,_that.activityTimestamp,_that.activityDate,_that.comments,_that.activityNameOverride,_that.subActivityIds,_that.details);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userActivityId,  DateTime activityTimestamp,  DateTime activityDate,  String? comments,  String? activityNameOverride,  List<String> subActivityIds,  List<CreateUserActivityDetail> details)?  $default,) {final _that = this;
switch (_that) {
case _UpdateUserActivity() when $default != null:
return $default(_that.userActivityId,_that.activityTimestamp,_that.activityDate,_that.comments,_that.activityNameOverride,_that.subActivityIds,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateUserActivity extends UpdateUserActivity {
  const _UpdateUserActivity({required this.userActivityId, required this.activityTimestamp, required this.activityDate, this.comments, this.activityNameOverride, final  List<String> subActivityIds = const [], final  List<CreateUserActivityDetail> details = const []}): _subActivityIds = subActivityIds,_details = details,super._();
  factory _UpdateUserActivity.fromJson(Map<String, dynamic> json) => _$UpdateUserActivityFromJson(json);

/// The ID of the user activity to update.
@override final  String userActivityId;
/// The updated timestamp of the activity.
@override final  DateTime activityTimestamp;
/// The updated date of the activity (date only, calculated client-side).
@override final  DateTime activityDate;
/// Updated comments/notes.
@override final  String? comments;
/// Updated custom name override.
@override final  String? activityNameOverride;
/// Updated sub-activity IDs.
 final  List<String> _subActivityIds;
/// Updated sub-activity IDs.
@override@JsonKey() List<String> get subActivityIds {
  if (_subActivityIds is EqualUnmodifiableListView) return _subActivityIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subActivityIds);
}

/// Updated detail values.
 final  List<CreateUserActivityDetail> _details;
/// Updated detail values.
@override@JsonKey() List<CreateUserActivityDetail> get details {
  if (_details is EqualUnmodifiableListView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_details);
}


/// Create a copy of UpdateUserActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateUserActivityCopyWith<_UpdateUserActivity> get copyWith => __$UpdateUserActivityCopyWithImpl<_UpdateUserActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateUserActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateUserActivity&&(identical(other.userActivityId, userActivityId) || other.userActivityId == userActivityId)&&(identical(other.activityTimestamp, activityTimestamp) || other.activityTimestamp == activityTimestamp)&&(identical(other.activityDate, activityDate) || other.activityDate == activityDate)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.activityNameOverride, activityNameOverride) || other.activityNameOverride == activityNameOverride)&&const DeepCollectionEquality().equals(other._subActivityIds, _subActivityIds)&&const DeepCollectionEquality().equals(other._details, _details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userActivityId,activityTimestamp,activityDate,comments,activityNameOverride,const DeepCollectionEquality().hash(_subActivityIds),const DeepCollectionEquality().hash(_details));

@override
String toString() {
  return 'UpdateUserActivity(userActivityId: $userActivityId, activityTimestamp: $activityTimestamp, activityDate: $activityDate, comments: $comments, activityNameOverride: $activityNameOverride, subActivityIds: $subActivityIds, details: $details)';
}


}

/// @nodoc
abstract mixin class _$UpdateUserActivityCopyWith<$Res> implements $UpdateUserActivityCopyWith<$Res> {
  factory _$UpdateUserActivityCopyWith(_UpdateUserActivity value, $Res Function(_UpdateUserActivity) _then) = __$UpdateUserActivityCopyWithImpl;
@override @useResult
$Res call({
 String userActivityId, DateTime activityTimestamp, DateTime activityDate, String? comments, String? activityNameOverride, List<String> subActivityIds, List<CreateUserActivityDetail> details
});




}
/// @nodoc
class __$UpdateUserActivityCopyWithImpl<$Res>
    implements _$UpdateUserActivityCopyWith<$Res> {
  __$UpdateUserActivityCopyWithImpl(this._self, this._then);

  final _UpdateUserActivity _self;
  final $Res Function(_UpdateUserActivity) _then;

/// Create a copy of UpdateUserActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userActivityId = null,Object? activityTimestamp = null,Object? activityDate = null,Object? comments = freezed,Object? activityNameOverride = freezed,Object? subActivityIds = null,Object? details = null,}) {
  return _then(_UpdateUserActivity(
userActivityId: null == userActivityId ? _self.userActivityId : userActivityId // ignore: cast_nullable_to_non_nullable
as String,activityTimestamp: null == activityTimestamp ? _self.activityTimestamp : activityTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,activityDate: null == activityDate ? _self.activityDate : activityDate // ignore: cast_nullable_to_non_nullable
as DateTime,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,activityNameOverride: freezed == activityNameOverride ? _self.activityNameOverride : activityNameOverride // ignore: cast_nullable_to_non_nullable
as String?,subActivityIds: null == subActivityIds ? _self._subActivityIds : subActivityIds // ignore: cast_nullable_to_non_nullable
as List<String>,details: null == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as List<CreateUserActivityDetail>,
  ));
}


}

// dart format on
