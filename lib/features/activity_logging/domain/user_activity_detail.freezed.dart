// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_activity_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserActivityDetail {

 String get userActivityId; String get activityDetailId; ActivityDetailType get activityDetailType; DateTime? get createdAt; DateTime? get updatedAt; String? get textValue; EnvironmentType? get environmentValue; double? get numericValue; int? get durationInSec; double? get distanceInMeters; double? get liquidVolumeInLiters; double? get weightInKilograms; String? get latLng;/// The activity detail configuration (populated via join).
 ActivityDetail? get activityDetail;
/// Create a copy of UserActivityDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserActivityDetailCopyWith<UserActivityDetail> get copyWith => _$UserActivityDetailCopyWithImpl<UserActivityDetail>(this as UserActivityDetail, _$identity);

  /// Serializes this UserActivityDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserActivityDetail&&(identical(other.userActivityId, userActivityId) || other.userActivityId == userActivityId)&&(identical(other.activityDetailId, activityDetailId) || other.activityDetailId == activityDetailId)&&(identical(other.activityDetailType, activityDetailType) || other.activityDetailType == activityDetailType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.textValue, textValue) || other.textValue == textValue)&&(identical(other.environmentValue, environmentValue) || other.environmentValue == environmentValue)&&(identical(other.numericValue, numericValue) || other.numericValue == numericValue)&&(identical(other.durationInSec, durationInSec) || other.durationInSec == durationInSec)&&(identical(other.distanceInMeters, distanceInMeters) || other.distanceInMeters == distanceInMeters)&&(identical(other.liquidVolumeInLiters, liquidVolumeInLiters) || other.liquidVolumeInLiters == liquidVolumeInLiters)&&(identical(other.weightInKilograms, weightInKilograms) || other.weightInKilograms == weightInKilograms)&&(identical(other.latLng, latLng) || other.latLng == latLng)&&(identical(other.activityDetail, activityDetail) || other.activityDetail == activityDetail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userActivityId,activityDetailId,activityDetailType,createdAt,updatedAt,textValue,environmentValue,numericValue,durationInSec,distanceInMeters,liquidVolumeInLiters,weightInKilograms,latLng,activityDetail);

@override
String toString() {
  return 'UserActivityDetail(userActivityId: $userActivityId, activityDetailId: $activityDetailId, activityDetailType: $activityDetailType, createdAt: $createdAt, updatedAt: $updatedAt, textValue: $textValue, environmentValue: $environmentValue, numericValue: $numericValue, durationInSec: $durationInSec, distanceInMeters: $distanceInMeters, liquidVolumeInLiters: $liquidVolumeInLiters, weightInKilograms: $weightInKilograms, latLng: $latLng, activityDetail: $activityDetail)';
}


}

/// @nodoc
abstract mixin class $UserActivityDetailCopyWith<$Res>  {
  factory $UserActivityDetailCopyWith(UserActivityDetail value, $Res Function(UserActivityDetail) _then) = _$UserActivityDetailCopyWithImpl;
@useResult
$Res call({
 String userActivityId, String activityDetailId, ActivityDetailType activityDetailType, DateTime? createdAt, DateTime? updatedAt, String? textValue, EnvironmentType? environmentValue, double? numericValue, int? durationInSec, double? distanceInMeters, double? liquidVolumeInLiters, double? weightInKilograms, String? latLng, ActivityDetail? activityDetail
});


$ActivityDetailCopyWith<$Res>? get activityDetail;

}
/// @nodoc
class _$UserActivityDetailCopyWithImpl<$Res>
    implements $UserActivityDetailCopyWith<$Res> {
  _$UserActivityDetailCopyWithImpl(this._self, this._then);

  final UserActivityDetail _self;
  final $Res Function(UserActivityDetail) _then;

/// Create a copy of UserActivityDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userActivityId = null,Object? activityDetailId = null,Object? activityDetailType = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? textValue = freezed,Object? environmentValue = freezed,Object? numericValue = freezed,Object? durationInSec = freezed,Object? distanceInMeters = freezed,Object? liquidVolumeInLiters = freezed,Object? weightInKilograms = freezed,Object? latLng = freezed,Object? activityDetail = freezed,}) {
  return _then(_self.copyWith(
userActivityId: null == userActivityId ? _self.userActivityId : userActivityId // ignore: cast_nullable_to_non_nullable
as String,activityDetailId: null == activityDetailId ? _self.activityDetailId : activityDetailId // ignore: cast_nullable_to_non_nullable
as String,activityDetailType: null == activityDetailType ? _self.activityDetailType : activityDetailType // ignore: cast_nullable_to_non_nullable
as ActivityDetailType,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,textValue: freezed == textValue ? _self.textValue : textValue // ignore: cast_nullable_to_non_nullable
as String?,environmentValue: freezed == environmentValue ? _self.environmentValue : environmentValue // ignore: cast_nullable_to_non_nullable
as EnvironmentType?,numericValue: freezed == numericValue ? _self.numericValue : numericValue // ignore: cast_nullable_to_non_nullable
as double?,durationInSec: freezed == durationInSec ? _self.durationInSec : durationInSec // ignore: cast_nullable_to_non_nullable
as int?,distanceInMeters: freezed == distanceInMeters ? _self.distanceInMeters : distanceInMeters // ignore: cast_nullable_to_non_nullable
as double?,liquidVolumeInLiters: freezed == liquidVolumeInLiters ? _self.liquidVolumeInLiters : liquidVolumeInLiters // ignore: cast_nullable_to_non_nullable
as double?,weightInKilograms: freezed == weightInKilograms ? _self.weightInKilograms : weightInKilograms // ignore: cast_nullable_to_non_nullable
as double?,latLng: freezed == latLng ? _self.latLng : latLng // ignore: cast_nullable_to_non_nullable
as String?,activityDetail: freezed == activityDetail ? _self.activityDetail : activityDetail // ignore: cast_nullable_to_non_nullable
as ActivityDetail?,
  ));
}
/// Create a copy of UserActivityDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityDetailCopyWith<$Res>? get activityDetail {
    if (_self.activityDetail == null) {
    return null;
  }

  return $ActivityDetailCopyWith<$Res>(_self.activityDetail!, (value) {
    return _then(_self.copyWith(activityDetail: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserActivityDetail].
extension UserActivityDetailPatterns on UserActivityDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserActivityDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserActivityDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserActivityDetail value)  $default,){
final _that = this;
switch (_that) {
case _UserActivityDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserActivityDetail value)?  $default,){
final _that = this;
switch (_that) {
case _UserActivityDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userActivityId,  String activityDetailId,  ActivityDetailType activityDetailType,  DateTime? createdAt,  DateTime? updatedAt,  String? textValue,  EnvironmentType? environmentValue,  double? numericValue,  int? durationInSec,  double? distanceInMeters,  double? liquidVolumeInLiters,  double? weightInKilograms,  String? latLng,  ActivityDetail? activityDetail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserActivityDetail() when $default != null:
return $default(_that.userActivityId,_that.activityDetailId,_that.activityDetailType,_that.createdAt,_that.updatedAt,_that.textValue,_that.environmentValue,_that.numericValue,_that.durationInSec,_that.distanceInMeters,_that.liquidVolumeInLiters,_that.weightInKilograms,_that.latLng,_that.activityDetail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userActivityId,  String activityDetailId,  ActivityDetailType activityDetailType,  DateTime? createdAt,  DateTime? updatedAt,  String? textValue,  EnvironmentType? environmentValue,  double? numericValue,  int? durationInSec,  double? distanceInMeters,  double? liquidVolumeInLiters,  double? weightInKilograms,  String? latLng,  ActivityDetail? activityDetail)  $default,) {final _that = this;
switch (_that) {
case _UserActivityDetail():
return $default(_that.userActivityId,_that.activityDetailId,_that.activityDetailType,_that.createdAt,_that.updatedAt,_that.textValue,_that.environmentValue,_that.numericValue,_that.durationInSec,_that.distanceInMeters,_that.liquidVolumeInLiters,_that.weightInKilograms,_that.latLng,_that.activityDetail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userActivityId,  String activityDetailId,  ActivityDetailType activityDetailType,  DateTime? createdAt,  DateTime? updatedAt,  String? textValue,  EnvironmentType? environmentValue,  double? numericValue,  int? durationInSec,  double? distanceInMeters,  double? liquidVolumeInLiters,  double? weightInKilograms,  String? latLng,  ActivityDetail? activityDetail)?  $default,) {final _that = this;
switch (_that) {
case _UserActivityDetail() when $default != null:
return $default(_that.userActivityId,_that.activityDetailId,_that.activityDetailType,_that.createdAt,_that.updatedAt,_that.textValue,_that.environmentValue,_that.numericValue,_that.durationInSec,_that.distanceInMeters,_that.liquidVolumeInLiters,_that.weightInKilograms,_that.latLng,_that.activityDetail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserActivityDetail extends UserActivityDetail {
  const _UserActivityDetail({required this.userActivityId, required this.activityDetailId, required this.activityDetailType, this.createdAt, this.updatedAt, this.textValue, this.environmentValue, this.numericValue, this.durationInSec, this.distanceInMeters, this.liquidVolumeInLiters, this.weightInKilograms, this.latLng, this.activityDetail}): super._();
  factory _UserActivityDetail.fromJson(Map<String, dynamic> json) => _$UserActivityDetailFromJson(json);

@override final  String userActivityId;
@override final  String activityDetailId;
@override final  ActivityDetailType activityDetailType;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  String? textValue;
@override final  EnvironmentType? environmentValue;
@override final  double? numericValue;
@override final  int? durationInSec;
@override final  double? distanceInMeters;
@override final  double? liquidVolumeInLiters;
@override final  double? weightInKilograms;
@override final  String? latLng;
/// The activity detail configuration (populated via join).
@override final  ActivityDetail? activityDetail;

/// Create a copy of UserActivityDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserActivityDetailCopyWith<_UserActivityDetail> get copyWith => __$UserActivityDetailCopyWithImpl<_UserActivityDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserActivityDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserActivityDetail&&(identical(other.userActivityId, userActivityId) || other.userActivityId == userActivityId)&&(identical(other.activityDetailId, activityDetailId) || other.activityDetailId == activityDetailId)&&(identical(other.activityDetailType, activityDetailType) || other.activityDetailType == activityDetailType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.textValue, textValue) || other.textValue == textValue)&&(identical(other.environmentValue, environmentValue) || other.environmentValue == environmentValue)&&(identical(other.numericValue, numericValue) || other.numericValue == numericValue)&&(identical(other.durationInSec, durationInSec) || other.durationInSec == durationInSec)&&(identical(other.distanceInMeters, distanceInMeters) || other.distanceInMeters == distanceInMeters)&&(identical(other.liquidVolumeInLiters, liquidVolumeInLiters) || other.liquidVolumeInLiters == liquidVolumeInLiters)&&(identical(other.weightInKilograms, weightInKilograms) || other.weightInKilograms == weightInKilograms)&&(identical(other.latLng, latLng) || other.latLng == latLng)&&(identical(other.activityDetail, activityDetail) || other.activityDetail == activityDetail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userActivityId,activityDetailId,activityDetailType,createdAt,updatedAt,textValue,environmentValue,numericValue,durationInSec,distanceInMeters,liquidVolumeInLiters,weightInKilograms,latLng,activityDetail);

@override
String toString() {
  return 'UserActivityDetail(userActivityId: $userActivityId, activityDetailId: $activityDetailId, activityDetailType: $activityDetailType, createdAt: $createdAt, updatedAt: $updatedAt, textValue: $textValue, environmentValue: $environmentValue, numericValue: $numericValue, durationInSec: $durationInSec, distanceInMeters: $distanceInMeters, liquidVolumeInLiters: $liquidVolumeInLiters, weightInKilograms: $weightInKilograms, latLng: $latLng, activityDetail: $activityDetail)';
}


}

/// @nodoc
abstract mixin class _$UserActivityDetailCopyWith<$Res> implements $UserActivityDetailCopyWith<$Res> {
  factory _$UserActivityDetailCopyWith(_UserActivityDetail value, $Res Function(_UserActivityDetail) _then) = __$UserActivityDetailCopyWithImpl;
@override @useResult
$Res call({
 String userActivityId, String activityDetailId, ActivityDetailType activityDetailType, DateTime? createdAt, DateTime? updatedAt, String? textValue, EnvironmentType? environmentValue, double? numericValue, int? durationInSec, double? distanceInMeters, double? liquidVolumeInLiters, double? weightInKilograms, String? latLng, ActivityDetail? activityDetail
});


@override $ActivityDetailCopyWith<$Res>? get activityDetail;

}
/// @nodoc
class __$UserActivityDetailCopyWithImpl<$Res>
    implements _$UserActivityDetailCopyWith<$Res> {
  __$UserActivityDetailCopyWithImpl(this._self, this._then);

  final _UserActivityDetail _self;
  final $Res Function(_UserActivityDetail) _then;

/// Create a copy of UserActivityDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userActivityId = null,Object? activityDetailId = null,Object? activityDetailType = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? textValue = freezed,Object? environmentValue = freezed,Object? numericValue = freezed,Object? durationInSec = freezed,Object? distanceInMeters = freezed,Object? liquidVolumeInLiters = freezed,Object? weightInKilograms = freezed,Object? latLng = freezed,Object? activityDetail = freezed,}) {
  return _then(_UserActivityDetail(
userActivityId: null == userActivityId ? _self.userActivityId : userActivityId // ignore: cast_nullable_to_non_nullable
as String,activityDetailId: null == activityDetailId ? _self.activityDetailId : activityDetailId // ignore: cast_nullable_to_non_nullable
as String,activityDetailType: null == activityDetailType ? _self.activityDetailType : activityDetailType // ignore: cast_nullable_to_non_nullable
as ActivityDetailType,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,textValue: freezed == textValue ? _self.textValue : textValue // ignore: cast_nullable_to_non_nullable
as String?,environmentValue: freezed == environmentValue ? _self.environmentValue : environmentValue // ignore: cast_nullable_to_non_nullable
as EnvironmentType?,numericValue: freezed == numericValue ? _self.numericValue : numericValue // ignore: cast_nullable_to_non_nullable
as double?,durationInSec: freezed == durationInSec ? _self.durationInSec : durationInSec // ignore: cast_nullable_to_non_nullable
as int?,distanceInMeters: freezed == distanceInMeters ? _self.distanceInMeters : distanceInMeters // ignore: cast_nullable_to_non_nullable
as double?,liquidVolumeInLiters: freezed == liquidVolumeInLiters ? _self.liquidVolumeInLiters : liquidVolumeInLiters // ignore: cast_nullable_to_non_nullable
as double?,weightInKilograms: freezed == weightInKilograms ? _self.weightInKilograms : weightInKilograms // ignore: cast_nullable_to_non_nullable
as double?,latLng: freezed == latLng ? _self.latLng : latLng // ignore: cast_nullable_to_non_nullable
as String?,activityDetail: freezed == activityDetail ? _self.activityDetail : activityDetail // ignore: cast_nullable_to_non_nullable
as ActivityDetail?,
  ));
}

/// Create a copy of UserActivityDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityDetailCopyWith<$Res>? get activityDetail {
    if (_self.activityDetail == null) {
    return null;
  }

  return $ActivityDetailCopyWith<$Res>(_self.activityDetail!, (value) {
    return _then(_self.copyWith(activityDetail: value));
  });
}
}

// dart format on
