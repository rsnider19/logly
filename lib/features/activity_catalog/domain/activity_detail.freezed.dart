// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityDetail {

 String get activityDetailId; String get activityId; String get label; ActivityDetailType get activityDetailType; int get sortOrder; double? get minNumeric; double? get maxNumeric; int? get minDurationInSec; int? get maxDurationInSec; double? get minDistanceInMeters; double? get maxDistanceInMeters; double? get minLiquidVolumeInLiters; double? get maxLiquidVolumeInLiters; double? get minWeightInKilograms; double? get maxWeightInKilograms; double? get sliderInterval; MetricUom? get metricUom; ImperialUom? get imperialUom; bool get useForPaceCalculation;
/// Create a copy of ActivityDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityDetailCopyWith<ActivityDetail> get copyWith => _$ActivityDetailCopyWithImpl<ActivityDetail>(this as ActivityDetail, _$identity);

  /// Serializes this ActivityDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityDetail&&(identical(other.activityDetailId, activityDetailId) || other.activityDetailId == activityDetailId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.label, label) || other.label == label)&&(identical(other.activityDetailType, activityDetailType) || other.activityDetailType == activityDetailType)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.minNumeric, minNumeric) || other.minNumeric == minNumeric)&&(identical(other.maxNumeric, maxNumeric) || other.maxNumeric == maxNumeric)&&(identical(other.minDurationInSec, minDurationInSec) || other.minDurationInSec == minDurationInSec)&&(identical(other.maxDurationInSec, maxDurationInSec) || other.maxDurationInSec == maxDurationInSec)&&(identical(other.minDistanceInMeters, minDistanceInMeters) || other.minDistanceInMeters == minDistanceInMeters)&&(identical(other.maxDistanceInMeters, maxDistanceInMeters) || other.maxDistanceInMeters == maxDistanceInMeters)&&(identical(other.minLiquidVolumeInLiters, minLiquidVolumeInLiters) || other.minLiquidVolumeInLiters == minLiquidVolumeInLiters)&&(identical(other.maxLiquidVolumeInLiters, maxLiquidVolumeInLiters) || other.maxLiquidVolumeInLiters == maxLiquidVolumeInLiters)&&(identical(other.minWeightInKilograms, minWeightInKilograms) || other.minWeightInKilograms == minWeightInKilograms)&&(identical(other.maxWeightInKilograms, maxWeightInKilograms) || other.maxWeightInKilograms == maxWeightInKilograms)&&(identical(other.sliderInterval, sliderInterval) || other.sliderInterval == sliderInterval)&&(identical(other.metricUom, metricUom) || other.metricUom == metricUom)&&(identical(other.imperialUom, imperialUom) || other.imperialUom == imperialUom)&&(identical(other.useForPaceCalculation, useForPaceCalculation) || other.useForPaceCalculation == useForPaceCalculation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,activityDetailId,activityId,label,activityDetailType,sortOrder,minNumeric,maxNumeric,minDurationInSec,maxDurationInSec,minDistanceInMeters,maxDistanceInMeters,minLiquidVolumeInLiters,maxLiquidVolumeInLiters,minWeightInKilograms,maxWeightInKilograms,sliderInterval,metricUom,imperialUom,useForPaceCalculation]);

@override
String toString() {
  return 'ActivityDetail(activityDetailId: $activityDetailId, activityId: $activityId, label: $label, activityDetailType: $activityDetailType, sortOrder: $sortOrder, minNumeric: $minNumeric, maxNumeric: $maxNumeric, minDurationInSec: $minDurationInSec, maxDurationInSec: $maxDurationInSec, minDistanceInMeters: $minDistanceInMeters, maxDistanceInMeters: $maxDistanceInMeters, minLiquidVolumeInLiters: $minLiquidVolumeInLiters, maxLiquidVolumeInLiters: $maxLiquidVolumeInLiters, minWeightInKilograms: $minWeightInKilograms, maxWeightInKilograms: $maxWeightInKilograms, sliderInterval: $sliderInterval, metricUom: $metricUom, imperialUom: $imperialUom, useForPaceCalculation: $useForPaceCalculation)';
}


}

/// @nodoc
abstract mixin class $ActivityDetailCopyWith<$Res>  {
  factory $ActivityDetailCopyWith(ActivityDetail value, $Res Function(ActivityDetail) _then) = _$ActivityDetailCopyWithImpl;
@useResult
$Res call({
 String activityDetailId, String activityId, String label, ActivityDetailType activityDetailType, int sortOrder, double? minNumeric, double? maxNumeric, int? minDurationInSec, int? maxDurationInSec, double? minDistanceInMeters, double? maxDistanceInMeters, double? minLiquidVolumeInLiters, double? maxLiquidVolumeInLiters, double? minWeightInKilograms, double? maxWeightInKilograms, double? sliderInterval, MetricUom? metricUom, ImperialUom? imperialUom, bool useForPaceCalculation
});




}
/// @nodoc
class _$ActivityDetailCopyWithImpl<$Res>
    implements $ActivityDetailCopyWith<$Res> {
  _$ActivityDetailCopyWithImpl(this._self, this._then);

  final ActivityDetail _self;
  final $Res Function(ActivityDetail) _then;

/// Create a copy of ActivityDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityDetailId = null,Object? activityId = null,Object? label = null,Object? activityDetailType = null,Object? sortOrder = null,Object? minNumeric = freezed,Object? maxNumeric = freezed,Object? minDurationInSec = freezed,Object? maxDurationInSec = freezed,Object? minDistanceInMeters = freezed,Object? maxDistanceInMeters = freezed,Object? minLiquidVolumeInLiters = freezed,Object? maxLiquidVolumeInLiters = freezed,Object? minWeightInKilograms = freezed,Object? maxWeightInKilograms = freezed,Object? sliderInterval = freezed,Object? metricUom = freezed,Object? imperialUom = freezed,Object? useForPaceCalculation = null,}) {
  return _then(_self.copyWith(
activityDetailId: null == activityDetailId ? _self.activityDetailId : activityDetailId // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,activityDetailType: null == activityDetailType ? _self.activityDetailType : activityDetailType // ignore: cast_nullable_to_non_nullable
as ActivityDetailType,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,minNumeric: freezed == minNumeric ? _self.minNumeric : minNumeric // ignore: cast_nullable_to_non_nullable
as double?,maxNumeric: freezed == maxNumeric ? _self.maxNumeric : maxNumeric // ignore: cast_nullable_to_non_nullable
as double?,minDurationInSec: freezed == minDurationInSec ? _self.minDurationInSec : minDurationInSec // ignore: cast_nullable_to_non_nullable
as int?,maxDurationInSec: freezed == maxDurationInSec ? _self.maxDurationInSec : maxDurationInSec // ignore: cast_nullable_to_non_nullable
as int?,minDistanceInMeters: freezed == minDistanceInMeters ? _self.minDistanceInMeters : minDistanceInMeters // ignore: cast_nullable_to_non_nullable
as double?,maxDistanceInMeters: freezed == maxDistanceInMeters ? _self.maxDistanceInMeters : maxDistanceInMeters // ignore: cast_nullable_to_non_nullable
as double?,minLiquidVolumeInLiters: freezed == minLiquidVolumeInLiters ? _self.minLiquidVolumeInLiters : minLiquidVolumeInLiters // ignore: cast_nullable_to_non_nullable
as double?,maxLiquidVolumeInLiters: freezed == maxLiquidVolumeInLiters ? _self.maxLiquidVolumeInLiters : maxLiquidVolumeInLiters // ignore: cast_nullable_to_non_nullable
as double?,minWeightInKilograms: freezed == minWeightInKilograms ? _self.minWeightInKilograms : minWeightInKilograms // ignore: cast_nullable_to_non_nullable
as double?,maxWeightInKilograms: freezed == maxWeightInKilograms ? _self.maxWeightInKilograms : maxWeightInKilograms // ignore: cast_nullable_to_non_nullable
as double?,sliderInterval: freezed == sliderInterval ? _self.sliderInterval : sliderInterval // ignore: cast_nullable_to_non_nullable
as double?,metricUom: freezed == metricUom ? _self.metricUom : metricUom // ignore: cast_nullable_to_non_nullable
as MetricUom?,imperialUom: freezed == imperialUom ? _self.imperialUom : imperialUom // ignore: cast_nullable_to_non_nullable
as ImperialUom?,useForPaceCalculation: null == useForPaceCalculation ? _self.useForPaceCalculation : useForPaceCalculation // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityDetail].
extension ActivityDetailPatterns on ActivityDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityDetail value)  $default,){
final _that = this;
switch (_that) {
case _ActivityDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String activityDetailId,  String activityId,  String label,  ActivityDetailType activityDetailType,  int sortOrder,  double? minNumeric,  double? maxNumeric,  int? minDurationInSec,  int? maxDurationInSec,  double? minDistanceInMeters,  double? maxDistanceInMeters,  double? minLiquidVolumeInLiters,  double? maxLiquidVolumeInLiters,  double? minWeightInKilograms,  double? maxWeightInKilograms,  double? sliderInterval,  MetricUom? metricUom,  ImperialUom? imperialUom,  bool useForPaceCalculation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityDetail() when $default != null:
return $default(_that.activityDetailId,_that.activityId,_that.label,_that.activityDetailType,_that.sortOrder,_that.minNumeric,_that.maxNumeric,_that.minDurationInSec,_that.maxDurationInSec,_that.minDistanceInMeters,_that.maxDistanceInMeters,_that.minLiquidVolumeInLiters,_that.maxLiquidVolumeInLiters,_that.minWeightInKilograms,_that.maxWeightInKilograms,_that.sliderInterval,_that.metricUom,_that.imperialUom,_that.useForPaceCalculation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String activityDetailId,  String activityId,  String label,  ActivityDetailType activityDetailType,  int sortOrder,  double? minNumeric,  double? maxNumeric,  int? minDurationInSec,  int? maxDurationInSec,  double? minDistanceInMeters,  double? maxDistanceInMeters,  double? minLiquidVolumeInLiters,  double? maxLiquidVolumeInLiters,  double? minWeightInKilograms,  double? maxWeightInKilograms,  double? sliderInterval,  MetricUom? metricUom,  ImperialUom? imperialUom,  bool useForPaceCalculation)  $default,) {final _that = this;
switch (_that) {
case _ActivityDetail():
return $default(_that.activityDetailId,_that.activityId,_that.label,_that.activityDetailType,_that.sortOrder,_that.minNumeric,_that.maxNumeric,_that.minDurationInSec,_that.maxDurationInSec,_that.minDistanceInMeters,_that.maxDistanceInMeters,_that.minLiquidVolumeInLiters,_that.maxLiquidVolumeInLiters,_that.minWeightInKilograms,_that.maxWeightInKilograms,_that.sliderInterval,_that.metricUom,_that.imperialUom,_that.useForPaceCalculation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String activityDetailId,  String activityId,  String label,  ActivityDetailType activityDetailType,  int sortOrder,  double? minNumeric,  double? maxNumeric,  int? minDurationInSec,  int? maxDurationInSec,  double? minDistanceInMeters,  double? maxDistanceInMeters,  double? minLiquidVolumeInLiters,  double? maxLiquidVolumeInLiters,  double? minWeightInKilograms,  double? maxWeightInKilograms,  double? sliderInterval,  MetricUom? metricUom,  ImperialUom? imperialUom,  bool useForPaceCalculation)?  $default,) {final _that = this;
switch (_that) {
case _ActivityDetail() when $default != null:
return $default(_that.activityDetailId,_that.activityId,_that.label,_that.activityDetailType,_that.sortOrder,_that.minNumeric,_that.maxNumeric,_that.minDurationInSec,_that.maxDurationInSec,_that.minDistanceInMeters,_that.maxDistanceInMeters,_that.minLiquidVolumeInLiters,_that.maxLiquidVolumeInLiters,_that.minWeightInKilograms,_that.maxWeightInKilograms,_that.sliderInterval,_that.metricUom,_that.imperialUom,_that.useForPaceCalculation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityDetail implements ActivityDetail {
  const _ActivityDetail({required this.activityDetailId, required this.activityId, required this.label, required this.activityDetailType, required this.sortOrder, this.minNumeric, this.maxNumeric, this.minDurationInSec, this.maxDurationInSec, this.minDistanceInMeters, this.maxDistanceInMeters, this.minLiquidVolumeInLiters, this.maxLiquidVolumeInLiters, this.minWeightInKilograms, this.maxWeightInKilograms, this.sliderInterval, this.metricUom, this.imperialUom, this.useForPaceCalculation = false});
  factory _ActivityDetail.fromJson(Map<String, dynamic> json) => _$ActivityDetailFromJson(json);

@override final  String activityDetailId;
@override final  String activityId;
@override final  String label;
@override final  ActivityDetailType activityDetailType;
@override final  int sortOrder;
@override final  double? minNumeric;
@override final  double? maxNumeric;
@override final  int? minDurationInSec;
@override final  int? maxDurationInSec;
@override final  double? minDistanceInMeters;
@override final  double? maxDistanceInMeters;
@override final  double? minLiquidVolumeInLiters;
@override final  double? maxLiquidVolumeInLiters;
@override final  double? minWeightInKilograms;
@override final  double? maxWeightInKilograms;
@override final  double? sliderInterval;
@override final  MetricUom? metricUom;
@override final  ImperialUom? imperialUom;
@override@JsonKey() final  bool useForPaceCalculation;

/// Create a copy of ActivityDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDetailCopyWith<_ActivityDetail> get copyWith => __$ActivityDetailCopyWithImpl<_ActivityDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDetail&&(identical(other.activityDetailId, activityDetailId) || other.activityDetailId == activityDetailId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.label, label) || other.label == label)&&(identical(other.activityDetailType, activityDetailType) || other.activityDetailType == activityDetailType)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.minNumeric, minNumeric) || other.minNumeric == minNumeric)&&(identical(other.maxNumeric, maxNumeric) || other.maxNumeric == maxNumeric)&&(identical(other.minDurationInSec, minDurationInSec) || other.minDurationInSec == minDurationInSec)&&(identical(other.maxDurationInSec, maxDurationInSec) || other.maxDurationInSec == maxDurationInSec)&&(identical(other.minDistanceInMeters, minDistanceInMeters) || other.minDistanceInMeters == minDistanceInMeters)&&(identical(other.maxDistanceInMeters, maxDistanceInMeters) || other.maxDistanceInMeters == maxDistanceInMeters)&&(identical(other.minLiquidVolumeInLiters, minLiquidVolumeInLiters) || other.minLiquidVolumeInLiters == minLiquidVolumeInLiters)&&(identical(other.maxLiquidVolumeInLiters, maxLiquidVolumeInLiters) || other.maxLiquidVolumeInLiters == maxLiquidVolumeInLiters)&&(identical(other.minWeightInKilograms, minWeightInKilograms) || other.minWeightInKilograms == minWeightInKilograms)&&(identical(other.maxWeightInKilograms, maxWeightInKilograms) || other.maxWeightInKilograms == maxWeightInKilograms)&&(identical(other.sliderInterval, sliderInterval) || other.sliderInterval == sliderInterval)&&(identical(other.metricUom, metricUom) || other.metricUom == metricUom)&&(identical(other.imperialUom, imperialUom) || other.imperialUom == imperialUom)&&(identical(other.useForPaceCalculation, useForPaceCalculation) || other.useForPaceCalculation == useForPaceCalculation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,activityDetailId,activityId,label,activityDetailType,sortOrder,minNumeric,maxNumeric,minDurationInSec,maxDurationInSec,minDistanceInMeters,maxDistanceInMeters,minLiquidVolumeInLiters,maxLiquidVolumeInLiters,minWeightInKilograms,maxWeightInKilograms,sliderInterval,metricUom,imperialUom,useForPaceCalculation]);

@override
String toString() {
  return 'ActivityDetail(activityDetailId: $activityDetailId, activityId: $activityId, label: $label, activityDetailType: $activityDetailType, sortOrder: $sortOrder, minNumeric: $minNumeric, maxNumeric: $maxNumeric, minDurationInSec: $minDurationInSec, maxDurationInSec: $maxDurationInSec, minDistanceInMeters: $minDistanceInMeters, maxDistanceInMeters: $maxDistanceInMeters, minLiquidVolumeInLiters: $minLiquidVolumeInLiters, maxLiquidVolumeInLiters: $maxLiquidVolumeInLiters, minWeightInKilograms: $minWeightInKilograms, maxWeightInKilograms: $maxWeightInKilograms, sliderInterval: $sliderInterval, metricUom: $metricUom, imperialUom: $imperialUom, useForPaceCalculation: $useForPaceCalculation)';
}


}

/// @nodoc
abstract mixin class _$ActivityDetailCopyWith<$Res> implements $ActivityDetailCopyWith<$Res> {
  factory _$ActivityDetailCopyWith(_ActivityDetail value, $Res Function(_ActivityDetail) _then) = __$ActivityDetailCopyWithImpl;
@override @useResult
$Res call({
 String activityDetailId, String activityId, String label, ActivityDetailType activityDetailType, int sortOrder, double? minNumeric, double? maxNumeric, int? minDurationInSec, int? maxDurationInSec, double? minDistanceInMeters, double? maxDistanceInMeters, double? minLiquidVolumeInLiters, double? maxLiquidVolumeInLiters, double? minWeightInKilograms, double? maxWeightInKilograms, double? sliderInterval, MetricUom? metricUom, ImperialUom? imperialUom, bool useForPaceCalculation
});




}
/// @nodoc
class __$ActivityDetailCopyWithImpl<$Res>
    implements _$ActivityDetailCopyWith<$Res> {
  __$ActivityDetailCopyWithImpl(this._self, this._then);

  final _ActivityDetail _self;
  final $Res Function(_ActivityDetail) _then;

/// Create a copy of ActivityDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityDetailId = null,Object? activityId = null,Object? label = null,Object? activityDetailType = null,Object? sortOrder = null,Object? minNumeric = freezed,Object? maxNumeric = freezed,Object? minDurationInSec = freezed,Object? maxDurationInSec = freezed,Object? minDistanceInMeters = freezed,Object? maxDistanceInMeters = freezed,Object? minLiquidVolumeInLiters = freezed,Object? maxLiquidVolumeInLiters = freezed,Object? minWeightInKilograms = freezed,Object? maxWeightInKilograms = freezed,Object? sliderInterval = freezed,Object? metricUom = freezed,Object? imperialUom = freezed,Object? useForPaceCalculation = null,}) {
  return _then(_ActivityDetail(
activityDetailId: null == activityDetailId ? _self.activityDetailId : activityDetailId // ignore: cast_nullable_to_non_nullable
as String,activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,activityDetailType: null == activityDetailType ? _self.activityDetailType : activityDetailType // ignore: cast_nullable_to_non_nullable
as ActivityDetailType,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,minNumeric: freezed == minNumeric ? _self.minNumeric : minNumeric // ignore: cast_nullable_to_non_nullable
as double?,maxNumeric: freezed == maxNumeric ? _self.maxNumeric : maxNumeric // ignore: cast_nullable_to_non_nullable
as double?,minDurationInSec: freezed == minDurationInSec ? _self.minDurationInSec : minDurationInSec // ignore: cast_nullable_to_non_nullable
as int?,maxDurationInSec: freezed == maxDurationInSec ? _self.maxDurationInSec : maxDurationInSec // ignore: cast_nullable_to_non_nullable
as int?,minDistanceInMeters: freezed == minDistanceInMeters ? _self.minDistanceInMeters : minDistanceInMeters // ignore: cast_nullable_to_non_nullable
as double?,maxDistanceInMeters: freezed == maxDistanceInMeters ? _self.maxDistanceInMeters : maxDistanceInMeters // ignore: cast_nullable_to_non_nullable
as double?,minLiquidVolumeInLiters: freezed == minLiquidVolumeInLiters ? _self.minLiquidVolumeInLiters : minLiquidVolumeInLiters // ignore: cast_nullable_to_non_nullable
as double?,maxLiquidVolumeInLiters: freezed == maxLiquidVolumeInLiters ? _self.maxLiquidVolumeInLiters : maxLiquidVolumeInLiters // ignore: cast_nullable_to_non_nullable
as double?,minWeightInKilograms: freezed == minWeightInKilograms ? _self.minWeightInKilograms : minWeightInKilograms // ignore: cast_nullable_to_non_nullable
as double?,maxWeightInKilograms: freezed == maxWeightInKilograms ? _self.maxWeightInKilograms : maxWeightInKilograms // ignore: cast_nullable_to_non_nullable
as double?,sliderInterval: freezed == sliderInterval ? _self.sliderInterval : sliderInterval // ignore: cast_nullable_to_non_nullable
as double?,metricUom: freezed == metricUom ? _self.metricUom : metricUom // ignore: cast_nullable_to_non_nullable
as MetricUom?,imperialUom: freezed == imperialUom ? _self.imperialUom : imperialUom // ignore: cast_nullable_to_non_nullable
as ImperialUom?,useForPaceCalculation: null == useForPaceCalculation ? _self.useForPaceCalculation : useForPaceCalculation // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
