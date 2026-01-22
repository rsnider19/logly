// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_user_activity_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateUserActivityDetail {

 String get activityDetailId; String? get textValue; EnvironmentType? get environmentValue; double? get numericValue; int? get durationInSec; double? get distanceInMeters; double? get liquidVolumeInLiters; double? get weightInKilograms; String? get latLng;
/// Create a copy of CreateUserActivityDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateUserActivityDetailCopyWith<CreateUserActivityDetail> get copyWith => _$CreateUserActivityDetailCopyWithImpl<CreateUserActivityDetail>(this as CreateUserActivityDetail, _$identity);

  /// Serializes this CreateUserActivityDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateUserActivityDetail&&(identical(other.activityDetailId, activityDetailId) || other.activityDetailId == activityDetailId)&&(identical(other.textValue, textValue) || other.textValue == textValue)&&(identical(other.environmentValue, environmentValue) || other.environmentValue == environmentValue)&&(identical(other.numericValue, numericValue) || other.numericValue == numericValue)&&(identical(other.durationInSec, durationInSec) || other.durationInSec == durationInSec)&&(identical(other.distanceInMeters, distanceInMeters) || other.distanceInMeters == distanceInMeters)&&(identical(other.liquidVolumeInLiters, liquidVolumeInLiters) || other.liquidVolumeInLiters == liquidVolumeInLiters)&&(identical(other.weightInKilograms, weightInKilograms) || other.weightInKilograms == weightInKilograms)&&(identical(other.latLng, latLng) || other.latLng == latLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityDetailId,textValue,environmentValue,numericValue,durationInSec,distanceInMeters,liquidVolumeInLiters,weightInKilograms,latLng);

@override
String toString() {
  return 'CreateUserActivityDetail(activityDetailId: $activityDetailId, textValue: $textValue, environmentValue: $environmentValue, numericValue: $numericValue, durationInSec: $durationInSec, distanceInMeters: $distanceInMeters, liquidVolumeInLiters: $liquidVolumeInLiters, weightInKilograms: $weightInKilograms, latLng: $latLng)';
}


}

/// @nodoc
abstract mixin class $CreateUserActivityDetailCopyWith<$Res>  {
  factory $CreateUserActivityDetailCopyWith(CreateUserActivityDetail value, $Res Function(CreateUserActivityDetail) _then) = _$CreateUserActivityDetailCopyWithImpl;
@useResult
$Res call({
 String activityDetailId, String? textValue, EnvironmentType? environmentValue, double? numericValue, int? durationInSec, double? distanceInMeters, double? liquidVolumeInLiters, double? weightInKilograms, String? latLng
});




}
/// @nodoc
class _$CreateUserActivityDetailCopyWithImpl<$Res>
    implements $CreateUserActivityDetailCopyWith<$Res> {
  _$CreateUserActivityDetailCopyWithImpl(this._self, this._then);

  final CreateUserActivityDetail _self;
  final $Res Function(CreateUserActivityDetail) _then;

/// Create a copy of CreateUserActivityDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityDetailId = null,Object? textValue = freezed,Object? environmentValue = freezed,Object? numericValue = freezed,Object? durationInSec = freezed,Object? distanceInMeters = freezed,Object? liquidVolumeInLiters = freezed,Object? weightInKilograms = freezed,Object? latLng = freezed,}) {
  return _then(_self.copyWith(
activityDetailId: null == activityDetailId ? _self.activityDetailId : activityDetailId // ignore: cast_nullable_to_non_nullable
as String,textValue: freezed == textValue ? _self.textValue : textValue // ignore: cast_nullable_to_non_nullable
as String?,environmentValue: freezed == environmentValue ? _self.environmentValue : environmentValue // ignore: cast_nullable_to_non_nullable
as EnvironmentType?,numericValue: freezed == numericValue ? _self.numericValue : numericValue // ignore: cast_nullable_to_non_nullable
as double?,durationInSec: freezed == durationInSec ? _self.durationInSec : durationInSec // ignore: cast_nullable_to_non_nullable
as int?,distanceInMeters: freezed == distanceInMeters ? _self.distanceInMeters : distanceInMeters // ignore: cast_nullable_to_non_nullable
as double?,liquidVolumeInLiters: freezed == liquidVolumeInLiters ? _self.liquidVolumeInLiters : liquidVolumeInLiters // ignore: cast_nullable_to_non_nullable
as double?,weightInKilograms: freezed == weightInKilograms ? _self.weightInKilograms : weightInKilograms // ignore: cast_nullable_to_non_nullable
as double?,latLng: freezed == latLng ? _self.latLng : latLng // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateUserActivityDetail].
extension CreateUserActivityDetailPatterns on CreateUserActivityDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateUserActivityDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateUserActivityDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateUserActivityDetail value)  $default,){
final _that = this;
switch (_that) {
case _CreateUserActivityDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateUserActivityDetail value)?  $default,){
final _that = this;
switch (_that) {
case _CreateUserActivityDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String activityDetailId,  String? textValue,  EnvironmentType? environmentValue,  double? numericValue,  int? durationInSec,  double? distanceInMeters,  double? liquidVolumeInLiters,  double? weightInKilograms,  String? latLng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateUserActivityDetail() when $default != null:
return $default(_that.activityDetailId,_that.textValue,_that.environmentValue,_that.numericValue,_that.durationInSec,_that.distanceInMeters,_that.liquidVolumeInLiters,_that.weightInKilograms,_that.latLng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String activityDetailId,  String? textValue,  EnvironmentType? environmentValue,  double? numericValue,  int? durationInSec,  double? distanceInMeters,  double? liquidVolumeInLiters,  double? weightInKilograms,  String? latLng)  $default,) {final _that = this;
switch (_that) {
case _CreateUserActivityDetail():
return $default(_that.activityDetailId,_that.textValue,_that.environmentValue,_that.numericValue,_that.durationInSec,_that.distanceInMeters,_that.liquidVolumeInLiters,_that.weightInKilograms,_that.latLng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String activityDetailId,  String? textValue,  EnvironmentType? environmentValue,  double? numericValue,  int? durationInSec,  double? distanceInMeters,  double? liquidVolumeInLiters,  double? weightInKilograms,  String? latLng)?  $default,) {final _that = this;
switch (_that) {
case _CreateUserActivityDetail() when $default != null:
return $default(_that.activityDetailId,_that.textValue,_that.environmentValue,_that.numericValue,_that.durationInSec,_that.distanceInMeters,_that.liquidVolumeInLiters,_that.weightInKilograms,_that.latLng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateUserActivityDetail implements CreateUserActivityDetail {
  const _CreateUserActivityDetail({required this.activityDetailId, this.textValue, this.environmentValue, this.numericValue, this.durationInSec, this.distanceInMeters, this.liquidVolumeInLiters, this.weightInKilograms, this.latLng});
  factory _CreateUserActivityDetail.fromJson(Map<String, dynamic> json) => _$CreateUserActivityDetailFromJson(json);

@override final  String activityDetailId;
@override final  String? textValue;
@override final  EnvironmentType? environmentValue;
@override final  double? numericValue;
@override final  int? durationInSec;
@override final  double? distanceInMeters;
@override final  double? liquidVolumeInLiters;
@override final  double? weightInKilograms;
@override final  String? latLng;

/// Create a copy of CreateUserActivityDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateUserActivityDetailCopyWith<_CreateUserActivityDetail> get copyWith => __$CreateUserActivityDetailCopyWithImpl<_CreateUserActivityDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateUserActivityDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateUserActivityDetail&&(identical(other.activityDetailId, activityDetailId) || other.activityDetailId == activityDetailId)&&(identical(other.textValue, textValue) || other.textValue == textValue)&&(identical(other.environmentValue, environmentValue) || other.environmentValue == environmentValue)&&(identical(other.numericValue, numericValue) || other.numericValue == numericValue)&&(identical(other.durationInSec, durationInSec) || other.durationInSec == durationInSec)&&(identical(other.distanceInMeters, distanceInMeters) || other.distanceInMeters == distanceInMeters)&&(identical(other.liquidVolumeInLiters, liquidVolumeInLiters) || other.liquidVolumeInLiters == liquidVolumeInLiters)&&(identical(other.weightInKilograms, weightInKilograms) || other.weightInKilograms == weightInKilograms)&&(identical(other.latLng, latLng) || other.latLng == latLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityDetailId,textValue,environmentValue,numericValue,durationInSec,distanceInMeters,liquidVolumeInLiters,weightInKilograms,latLng);

@override
String toString() {
  return 'CreateUserActivityDetail(activityDetailId: $activityDetailId, textValue: $textValue, environmentValue: $environmentValue, numericValue: $numericValue, durationInSec: $durationInSec, distanceInMeters: $distanceInMeters, liquidVolumeInLiters: $liquidVolumeInLiters, weightInKilograms: $weightInKilograms, latLng: $latLng)';
}


}

/// @nodoc
abstract mixin class _$CreateUserActivityDetailCopyWith<$Res> implements $CreateUserActivityDetailCopyWith<$Res> {
  factory _$CreateUserActivityDetailCopyWith(_CreateUserActivityDetail value, $Res Function(_CreateUserActivityDetail) _then) = __$CreateUserActivityDetailCopyWithImpl;
@override @useResult
$Res call({
 String activityDetailId, String? textValue, EnvironmentType? environmentValue, double? numericValue, int? durationInSec, double? distanceInMeters, double? liquidVolumeInLiters, double? weightInKilograms, String? latLng
});




}
/// @nodoc
class __$CreateUserActivityDetailCopyWithImpl<$Res>
    implements _$CreateUserActivityDetailCopyWith<$Res> {
  __$CreateUserActivityDetailCopyWithImpl(this._self, this._then);

  final _CreateUserActivityDetail _self;
  final $Res Function(_CreateUserActivityDetail) _then;

/// Create a copy of CreateUserActivityDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityDetailId = null,Object? textValue = freezed,Object? environmentValue = freezed,Object? numericValue = freezed,Object? durationInSec = freezed,Object? distanceInMeters = freezed,Object? liquidVolumeInLiters = freezed,Object? weightInKilograms = freezed,Object? latLng = freezed,}) {
  return _then(_CreateUserActivityDetail(
activityDetailId: null == activityDetailId ? _self.activityDetailId : activityDetailId // ignore: cast_nullable_to_non_nullable
as String,textValue: freezed == textValue ? _self.textValue : textValue // ignore: cast_nullable_to_non_nullable
as String?,environmentValue: freezed == environmentValue ? _self.environmentValue : environmentValue // ignore: cast_nullable_to_non_nullable
as EnvironmentType?,numericValue: freezed == numericValue ? _self.numericValue : numericValue // ignore: cast_nullable_to_non_nullable
as double?,durationInSec: freezed == durationInSec ? _self.durationInSec : durationInSec // ignore: cast_nullable_to_non_nullable
as int?,distanceInMeters: freezed == distanceInMeters ? _self.distanceInMeters : distanceInMeters // ignore: cast_nullable_to_non_nullable
as double?,liquidVolumeInLiters: freezed == liquidVolumeInLiters ? _self.liquidVolumeInLiters : liquidVolumeInLiters // ignore: cast_nullable_to_non_nullable
as double?,weightInKilograms: freezed == weightInKilograms ? _self.weightInKilograms : weightInKilograms // ignore: cast_nullable_to_non_nullable
as double?,latLng: freezed == latLng ? _self.latLng : latLng // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
