// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_workout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthWorkout {

/// Unique identifier from the health platform source.
 String get sourceId;/// The workout activity type (e.g., RUNNING, CYCLING).
 String get workoutActivityType;/// When the workout started.
 DateTime get dateFrom;/// When the workout ended.
 DateTime get dateTo;/// Total distance in meters (if available).
 double? get totalDistance;/// Unit of distance measurement from the source.
 String? get totalDistanceUnit;/// Total energy burned in kcal (if available).
 double? get totalEnergyBurned;/// Unit of energy measurement from the source.
 String? get totalEnergyUnit;
/// Create a copy of HealthWorkout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthWorkoutCopyWith<HealthWorkout> get copyWith => _$HealthWorkoutCopyWithImpl<HealthWorkout>(this as HealthWorkout, _$identity);

  /// Serializes this HealthWorkout to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthWorkout&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.workoutActivityType, workoutActivityType) || other.workoutActivityType == workoutActivityType)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.totalDistanceUnit, totalDistanceUnit) || other.totalDistanceUnit == totalDistanceUnit)&&(identical(other.totalEnergyBurned, totalEnergyBurned) || other.totalEnergyBurned == totalEnergyBurned)&&(identical(other.totalEnergyUnit, totalEnergyUnit) || other.totalEnergyUnit == totalEnergyUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,workoutActivityType,dateFrom,dateTo,totalDistance,totalDistanceUnit,totalEnergyBurned,totalEnergyUnit);

@override
String toString() {
  return 'HealthWorkout(sourceId: $sourceId, workoutActivityType: $workoutActivityType, dateFrom: $dateFrom, dateTo: $dateTo, totalDistance: $totalDistance, totalDistanceUnit: $totalDistanceUnit, totalEnergyBurned: $totalEnergyBurned, totalEnergyUnit: $totalEnergyUnit)';
}


}

/// @nodoc
abstract mixin class $HealthWorkoutCopyWith<$Res>  {
  factory $HealthWorkoutCopyWith(HealthWorkout value, $Res Function(HealthWorkout) _then) = _$HealthWorkoutCopyWithImpl;
@useResult
$Res call({
 String sourceId, String workoutActivityType, DateTime dateFrom, DateTime dateTo, double? totalDistance, String? totalDistanceUnit, double? totalEnergyBurned, String? totalEnergyUnit
});




}
/// @nodoc
class _$HealthWorkoutCopyWithImpl<$Res>
    implements $HealthWorkoutCopyWith<$Res> {
  _$HealthWorkoutCopyWithImpl(this._self, this._then);

  final HealthWorkout _self;
  final $Res Function(HealthWorkout) _then;

/// Create a copy of HealthWorkout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceId = null,Object? workoutActivityType = null,Object? dateFrom = null,Object? dateTo = null,Object? totalDistance = freezed,Object? totalDistanceUnit = freezed,Object? totalEnergyBurned = freezed,Object? totalEnergyUnit = freezed,}) {
  return _then(_self.copyWith(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,workoutActivityType: null == workoutActivityType ? _self.workoutActivityType : workoutActivityType // ignore: cast_nullable_to_non_nullable
as String,dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime,totalDistance: freezed == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as double?,totalDistanceUnit: freezed == totalDistanceUnit ? _self.totalDistanceUnit : totalDistanceUnit // ignore: cast_nullable_to_non_nullable
as String?,totalEnergyBurned: freezed == totalEnergyBurned ? _self.totalEnergyBurned : totalEnergyBurned // ignore: cast_nullable_to_non_nullable
as double?,totalEnergyUnit: freezed == totalEnergyUnit ? _self.totalEnergyUnit : totalEnergyUnit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthWorkout].
extension HealthWorkoutPatterns on HealthWorkout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthWorkout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthWorkout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthWorkout value)  $default,){
final _that = this;
switch (_that) {
case _HealthWorkout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthWorkout value)?  $default,){
final _that = this;
switch (_that) {
case _HealthWorkout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceId,  String workoutActivityType,  DateTime dateFrom,  DateTime dateTo,  double? totalDistance,  String? totalDistanceUnit,  double? totalEnergyBurned,  String? totalEnergyUnit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthWorkout() when $default != null:
return $default(_that.sourceId,_that.workoutActivityType,_that.dateFrom,_that.dateTo,_that.totalDistance,_that.totalDistanceUnit,_that.totalEnergyBurned,_that.totalEnergyUnit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceId,  String workoutActivityType,  DateTime dateFrom,  DateTime dateTo,  double? totalDistance,  String? totalDistanceUnit,  double? totalEnergyBurned,  String? totalEnergyUnit)  $default,) {final _that = this;
switch (_that) {
case _HealthWorkout():
return $default(_that.sourceId,_that.workoutActivityType,_that.dateFrom,_that.dateTo,_that.totalDistance,_that.totalDistanceUnit,_that.totalEnergyBurned,_that.totalEnergyUnit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceId,  String workoutActivityType,  DateTime dateFrom,  DateTime dateTo,  double? totalDistance,  String? totalDistanceUnit,  double? totalEnergyBurned,  String? totalEnergyUnit)?  $default,) {final _that = this;
switch (_that) {
case _HealthWorkout() when $default != null:
return $default(_that.sourceId,_that.workoutActivityType,_that.dateFrom,_that.dateTo,_that.totalDistance,_that.totalDistanceUnit,_that.totalEnergyBurned,_that.totalEnergyUnit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthWorkout extends HealthWorkout {
  const _HealthWorkout({required this.sourceId, required this.workoutActivityType, required this.dateFrom, required this.dateTo, this.totalDistance, this.totalDistanceUnit, this.totalEnergyBurned, this.totalEnergyUnit}): super._();
  factory _HealthWorkout.fromJson(Map<String, dynamic> json) => _$HealthWorkoutFromJson(json);

/// Unique identifier from the health platform source.
@override final  String sourceId;
/// The workout activity type (e.g., RUNNING, CYCLING).
@override final  String workoutActivityType;
/// When the workout started.
@override final  DateTime dateFrom;
/// When the workout ended.
@override final  DateTime dateTo;
/// Total distance in meters (if available).
@override final  double? totalDistance;
/// Unit of distance measurement from the source.
@override final  String? totalDistanceUnit;
/// Total energy burned in kcal (if available).
@override final  double? totalEnergyBurned;
/// Unit of energy measurement from the source.
@override final  String? totalEnergyUnit;

/// Create a copy of HealthWorkout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthWorkoutCopyWith<_HealthWorkout> get copyWith => __$HealthWorkoutCopyWithImpl<_HealthWorkout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthWorkoutToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthWorkout&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.workoutActivityType, workoutActivityType) || other.workoutActivityType == workoutActivityType)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.totalDistanceUnit, totalDistanceUnit) || other.totalDistanceUnit == totalDistanceUnit)&&(identical(other.totalEnergyBurned, totalEnergyBurned) || other.totalEnergyBurned == totalEnergyBurned)&&(identical(other.totalEnergyUnit, totalEnergyUnit) || other.totalEnergyUnit == totalEnergyUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,workoutActivityType,dateFrom,dateTo,totalDistance,totalDistanceUnit,totalEnergyBurned,totalEnergyUnit);

@override
String toString() {
  return 'HealthWorkout(sourceId: $sourceId, workoutActivityType: $workoutActivityType, dateFrom: $dateFrom, dateTo: $dateTo, totalDistance: $totalDistance, totalDistanceUnit: $totalDistanceUnit, totalEnergyBurned: $totalEnergyBurned, totalEnergyUnit: $totalEnergyUnit)';
}


}

/// @nodoc
abstract mixin class _$HealthWorkoutCopyWith<$Res> implements $HealthWorkoutCopyWith<$Res> {
  factory _$HealthWorkoutCopyWith(_HealthWorkout value, $Res Function(_HealthWorkout) _then) = __$HealthWorkoutCopyWithImpl;
@override @useResult
$Res call({
 String sourceId, String workoutActivityType, DateTime dateFrom, DateTime dateTo, double? totalDistance, String? totalDistanceUnit, double? totalEnergyBurned, String? totalEnergyUnit
});




}
/// @nodoc
class __$HealthWorkoutCopyWithImpl<$Res>
    implements _$HealthWorkoutCopyWith<$Res> {
  __$HealthWorkoutCopyWithImpl(this._self, this._then);

  final _HealthWorkout _self;
  final $Res Function(_HealthWorkout) _then;

/// Create a copy of HealthWorkout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceId = null,Object? workoutActivityType = null,Object? dateFrom = null,Object? dateTo = null,Object? totalDistance = freezed,Object? totalDistanceUnit = freezed,Object? totalEnergyBurned = freezed,Object? totalEnergyUnit = freezed,}) {
  return _then(_HealthWorkout(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,workoutActivityType: null == workoutActivityType ? _self.workoutActivityType : workoutActivityType // ignore: cast_nullable_to_non_nullable
as String,dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime,totalDistance: freezed == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as double?,totalDistanceUnit: freezed == totalDistanceUnit ? _self.totalDistanceUnit : totalDistanceUnit // ignore: cast_nullable_to_non_nullable
as String?,totalEnergyBurned: freezed == totalEnergyBurned ? _self.totalEnergyBurned : totalEnergyBurned // ignore: cast_nullable_to_non_nullable
as double?,totalEnergyUnit: freezed == totalEnergyUnit ? _self.totalEnergyUnit : totalEnergyUnit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
