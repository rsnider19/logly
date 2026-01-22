// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_user_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateUserActivity {

 String get activityId; DateTime get activityStartDate; DateTime get activityEndDate; String? get comments; String? get activityNameOverride; List<String> get subActivityIds; List<CreateUserActivityDetail> get details;
/// Create a copy of CreateUserActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateUserActivityCopyWith<CreateUserActivity> get copyWith => _$CreateUserActivityCopyWithImpl<CreateUserActivity>(this as CreateUserActivity, _$identity);

  /// Serializes this CreateUserActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateUserActivity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.activityStartDate, activityStartDate) || other.activityStartDate == activityStartDate)&&(identical(other.activityEndDate, activityEndDate) || other.activityEndDate == activityEndDate)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.activityNameOverride, activityNameOverride) || other.activityNameOverride == activityNameOverride)&&const DeepCollectionEquality().equals(other.subActivityIds, subActivityIds)&&const DeepCollectionEquality().equals(other.details, details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,activityStartDate,activityEndDate,comments,activityNameOverride,const DeepCollectionEquality().hash(subActivityIds),const DeepCollectionEquality().hash(details));

@override
String toString() {
  return 'CreateUserActivity(activityId: $activityId, activityStartDate: $activityStartDate, activityEndDate: $activityEndDate, comments: $comments, activityNameOverride: $activityNameOverride, subActivityIds: $subActivityIds, details: $details)';
}


}

/// @nodoc
abstract mixin class $CreateUserActivityCopyWith<$Res>  {
  factory $CreateUserActivityCopyWith(CreateUserActivity value, $Res Function(CreateUserActivity) _then) = _$CreateUserActivityCopyWithImpl;
@useResult
$Res call({
 String activityId, DateTime activityStartDate, DateTime activityEndDate, String? comments, String? activityNameOverride, List<String> subActivityIds, List<CreateUserActivityDetail> details
});




}
/// @nodoc
class _$CreateUserActivityCopyWithImpl<$Res>
    implements $CreateUserActivityCopyWith<$Res> {
  _$CreateUserActivityCopyWithImpl(this._self, this._then);

  final CreateUserActivity _self;
  final $Res Function(CreateUserActivity) _then;

/// Create a copy of CreateUserActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityId = null,Object? activityStartDate = null,Object? activityEndDate = null,Object? comments = freezed,Object? activityNameOverride = freezed,Object? subActivityIds = null,Object? details = null,}) {
  return _then(_self.copyWith(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,activityStartDate: null == activityStartDate ? _self.activityStartDate : activityStartDate // ignore: cast_nullable_to_non_nullable
as DateTime,activityEndDate: null == activityEndDate ? _self.activityEndDate : activityEndDate // ignore: cast_nullable_to_non_nullable
as DateTime,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,activityNameOverride: freezed == activityNameOverride ? _self.activityNameOverride : activityNameOverride // ignore: cast_nullable_to_non_nullable
as String?,subActivityIds: null == subActivityIds ? _self.subActivityIds : subActivityIds // ignore: cast_nullable_to_non_nullable
as List<String>,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as List<CreateUserActivityDetail>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateUserActivity].
extension CreateUserActivityPatterns on CreateUserActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateUserActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateUserActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateUserActivity value)  $default,){
final _that = this;
switch (_that) {
case _CreateUserActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateUserActivity value)?  $default,){
final _that = this;
switch (_that) {
case _CreateUserActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String activityId,  DateTime activityStartDate,  DateTime activityEndDate,  String? comments,  String? activityNameOverride,  List<String> subActivityIds,  List<CreateUserActivityDetail> details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateUserActivity() when $default != null:
return $default(_that.activityId,_that.activityStartDate,_that.activityEndDate,_that.comments,_that.activityNameOverride,_that.subActivityIds,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String activityId,  DateTime activityStartDate,  DateTime activityEndDate,  String? comments,  String? activityNameOverride,  List<String> subActivityIds,  List<CreateUserActivityDetail> details)  $default,) {final _that = this;
switch (_that) {
case _CreateUserActivity():
return $default(_that.activityId,_that.activityStartDate,_that.activityEndDate,_that.comments,_that.activityNameOverride,_that.subActivityIds,_that.details);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String activityId,  DateTime activityStartDate,  DateTime activityEndDate,  String? comments,  String? activityNameOverride,  List<String> subActivityIds,  List<CreateUserActivityDetail> details)?  $default,) {final _that = this;
switch (_that) {
case _CreateUserActivity() when $default != null:
return $default(_that.activityId,_that.activityStartDate,_that.activityEndDate,_that.comments,_that.activityNameOverride,_that.subActivityIds,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateUserActivity implements CreateUserActivity {
  const _CreateUserActivity({required this.activityId, required this.activityStartDate, required this.activityEndDate, this.comments, this.activityNameOverride, final  List<String> subActivityIds = const [], final  List<CreateUserActivityDetail> details = const []}): _subActivityIds = subActivityIds,_details = details;
  factory _CreateUserActivity.fromJson(Map<String, dynamic> json) => _$CreateUserActivityFromJson(json);

@override final  String activityId;
@override final  DateTime activityStartDate;
@override final  DateTime activityEndDate;
@override final  String? comments;
@override final  String? activityNameOverride;
 final  List<String> _subActivityIds;
@override@JsonKey() List<String> get subActivityIds {
  if (_subActivityIds is EqualUnmodifiableListView) return _subActivityIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subActivityIds);
}

 final  List<CreateUserActivityDetail> _details;
@override@JsonKey() List<CreateUserActivityDetail> get details {
  if (_details is EqualUnmodifiableListView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_details);
}


/// Create a copy of CreateUserActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateUserActivityCopyWith<_CreateUserActivity> get copyWith => __$CreateUserActivityCopyWithImpl<_CreateUserActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateUserActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateUserActivity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.activityStartDate, activityStartDate) || other.activityStartDate == activityStartDate)&&(identical(other.activityEndDate, activityEndDate) || other.activityEndDate == activityEndDate)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.activityNameOverride, activityNameOverride) || other.activityNameOverride == activityNameOverride)&&const DeepCollectionEquality().equals(other._subActivityIds, _subActivityIds)&&const DeepCollectionEquality().equals(other._details, _details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,activityStartDate,activityEndDate,comments,activityNameOverride,const DeepCollectionEquality().hash(_subActivityIds),const DeepCollectionEquality().hash(_details));

@override
String toString() {
  return 'CreateUserActivity(activityId: $activityId, activityStartDate: $activityStartDate, activityEndDate: $activityEndDate, comments: $comments, activityNameOverride: $activityNameOverride, subActivityIds: $subActivityIds, details: $details)';
}


}

/// @nodoc
abstract mixin class _$CreateUserActivityCopyWith<$Res> implements $CreateUserActivityCopyWith<$Res> {
  factory _$CreateUserActivityCopyWith(_CreateUserActivity value, $Res Function(_CreateUserActivity) _then) = __$CreateUserActivityCopyWithImpl;
@override @useResult
$Res call({
 String activityId, DateTime activityStartDate, DateTime activityEndDate, String? comments, String? activityNameOverride, List<String> subActivityIds, List<CreateUserActivityDetail> details
});




}
/// @nodoc
class __$CreateUserActivityCopyWithImpl<$Res>
    implements _$CreateUserActivityCopyWith<$Res> {
  __$CreateUserActivityCopyWithImpl(this._self, this._then);

  final _CreateUserActivity _self;
  final $Res Function(_CreateUserActivity) _then;

/// Create a copy of CreateUserActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityId = null,Object? activityStartDate = null,Object? activityEndDate = null,Object? comments = freezed,Object? activityNameOverride = freezed,Object? subActivityIds = null,Object? details = null,}) {
  return _then(_CreateUserActivity(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,activityStartDate: null == activityStartDate ? _self.activityStartDate : activityStartDate // ignore: cast_nullable_to_non_nullable
as DateTime,activityEndDate: null == activityEndDate ? _self.activityEndDate : activityEndDate // ignore: cast_nullable_to_non_nullable
as DateTime,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,activityNameOverride: freezed == activityNameOverride ? _self.activityNameOverride : activityNameOverride // ignore: cast_nullable_to_non_nullable
as String?,subActivityIds: null == subActivityIds ? _self._subActivityIds : subActivityIds // ignore: cast_nullable_to_non_nullable
as List<String>,details: null == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as List<CreateUserActivityDetail>,
  ));
}


}

// dart format on
