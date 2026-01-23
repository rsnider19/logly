// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubActivity {

 String get subActivityId; String get activityId; String get name; String get subActivityCode;
/// Create a copy of SubActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubActivityCopyWith<SubActivity> get copyWith => _$SubActivityCopyWithImpl<SubActivity>(this as SubActivity, _$identity);

  /// Serializes this SubActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubActivity&&(identical(other.subActivityId, subActivityId) || other.subActivityId == subActivityId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.name, name) || other.name == name)&&(identical(other.subActivityCode, subActivityCode) || other.subActivityCode == subActivityCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subActivityId,activityId,name,subActivityCode);

@override
String toString() {
  return 'SubActivity(subActivityId: $subActivityId, activityId: $activityId, name: $name, subActivityCode: $subActivityCode)';
}


}

/// @nodoc
abstract mixin class $SubActivityCopyWith<$Res>  {
  factory $SubActivityCopyWith(SubActivity value, $Res Function(SubActivity) _then) = _$SubActivityCopyWithImpl;
@useResult
$Res call({
 String subActivityId, String activityId, String name, String subActivityCode
});




}
/// @nodoc
class _$SubActivityCopyWithImpl<$Res>
    implements $SubActivityCopyWith<$Res> {
  _$SubActivityCopyWithImpl(this._self, this._then);

  final SubActivity _self;
  final $Res Function(SubActivity) _then;

/// Create a copy of SubActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subActivityId = null,Object? activityId = null,Object? name = null,Object? subActivityCode = null,}) {
  return _then(_self.copyWith(
subActivityId: null == subActivityId ? _self.subActivityId : subActivityId // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,subActivityCode: null == subActivityCode ? _self.subActivityCode : subActivityCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SubActivity].
extension SubActivityPatterns on SubActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubActivity value)  $default,){
final _that = this;
switch (_that) {
case _SubActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubActivity value)?  $default,){
final _that = this;
switch (_that) {
case _SubActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subActivityId,  String activityId,  String name,  String subActivityCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubActivity() when $default != null:
return $default(_that.subActivityId,_that.activityId,_that.name,_that.subActivityCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subActivityId,  String activityId,  String name,  String subActivityCode)  $default,) {final _that = this;
switch (_that) {
case _SubActivity():
return $default(_that.subActivityId,_that.activityId,_that.name,_that.subActivityCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subActivityId,  String activityId,  String name,  String subActivityCode)?  $default,) {final _that = this;
switch (_that) {
case _SubActivity() when $default != null:
return $default(_that.subActivityId,_that.activityId,_that.name,_that.subActivityCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubActivity extends SubActivity {
  const _SubActivity({required this.subActivityId, required this.activityId, required this.name, required this.subActivityCode}): super._();
  factory _SubActivity.fromJson(Map<String, dynamic> json) => _$SubActivityFromJson(json);

@override final  String subActivityId;
@override final  String activityId;
@override final  String name;
@override final  String subActivityCode;

/// Create a copy of SubActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubActivityCopyWith<_SubActivity> get copyWith => __$SubActivityCopyWithImpl<_SubActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubActivity&&(identical(other.subActivityId, subActivityId) || other.subActivityId == subActivityId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.name, name) || other.name == name)&&(identical(other.subActivityCode, subActivityCode) || other.subActivityCode == subActivityCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subActivityId,activityId,name,subActivityCode);

@override
String toString() {
  return 'SubActivity(subActivityId: $subActivityId, activityId: $activityId, name: $name, subActivityCode: $subActivityCode)';
}


}

/// @nodoc
abstract mixin class _$SubActivityCopyWith<$Res> implements $SubActivityCopyWith<$Res> {
  factory _$SubActivityCopyWith(_SubActivity value, $Res Function(_SubActivity) _then) = __$SubActivityCopyWithImpl;
@override @useResult
$Res call({
 String subActivityId, String activityId, String name, String subActivityCode
});




}
/// @nodoc
class __$SubActivityCopyWithImpl<$Res>
    implements _$SubActivityCopyWith<$Res> {
  __$SubActivityCopyWithImpl(this._self, this._then);

  final _SubActivity _self;
  final $Res Function(_SubActivity) _then;

/// Create a copy of SubActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subActivityId = null,Object? activityId = null,Object? name = null,Object? subActivityCode = null,}) {
  return _then(_SubActivity(
subActivityId: null == subActivityId ? _self.subActivityId : subActivityId // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,subActivityCode: null == subActivityCode ? _self.subActivityCode : subActivityCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
