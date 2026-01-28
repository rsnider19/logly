// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_detail_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ActivityDetailConfig _$ActivityDetailConfigFromJson(
  Map<String, dynamic> json
) {
        switch (json['detailType']) {
                  case 'number':
          return NumberDetailConfig.fromJson(
            json
          );
                case 'duration':
          return DurationDetailConfig.fromJson(
            json
          );
                case 'distance':
          return DistanceDetailConfig.fromJson(
            json
          );
                case 'environment':
          return EnvironmentDetailConfig.fromJson(
            json
          );
                case 'pace':
          return PaceDetailConfig.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'detailType',
  'ActivityDetailConfig',
  'Invalid union type "${json['detailType']}"!'
);
        }
      
}

/// @nodoc
mixin _$ActivityDetailConfig {

 String get id;
/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityDetailConfigCopyWith<ActivityDetailConfig> get copyWith => _$ActivityDetailConfigCopyWithImpl<ActivityDetailConfig>(this as ActivityDetailConfig, _$identity);

  /// Serializes this ActivityDetailConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityDetailConfig&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ActivityDetailConfig(id: $id)';
}


}

/// @nodoc
abstract mixin class $ActivityDetailConfigCopyWith<$Res>  {
  factory $ActivityDetailConfigCopyWith(ActivityDetailConfig value, $Res Function(ActivityDetailConfig) _then) = _$ActivityDetailConfigCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$ActivityDetailConfigCopyWithImpl<$Res>
    implements $ActivityDetailConfigCopyWith<$Res> {
  _$ActivityDetailConfigCopyWithImpl(this._self, this._then);

  final ActivityDetailConfig _self;
  final $Res Function(ActivityDetailConfig) _then;

/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityDetailConfig].
extension ActivityDetailConfigPatterns on ActivityDetailConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NumberDetailConfig value)?  number,TResult Function( DurationDetailConfig value)?  duration,TResult Function( DistanceDetailConfig value)?  distance,TResult Function( EnvironmentDetailConfig value)?  environment,TResult Function( PaceDetailConfig value)?  pace,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NumberDetailConfig() when number != null:
return number(_that);case DurationDetailConfig() when duration != null:
return duration(_that);case DistanceDetailConfig() when distance != null:
return distance(_that);case EnvironmentDetailConfig() when environment != null:
return environment(_that);case PaceDetailConfig() when pace != null:
return pace(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NumberDetailConfig value)  number,required TResult Function( DurationDetailConfig value)  duration,required TResult Function( DistanceDetailConfig value)  distance,required TResult Function( EnvironmentDetailConfig value)  environment,required TResult Function( PaceDetailConfig value)  pace,}){
final _that = this;
switch (_that) {
case NumberDetailConfig():
return number(_that);case DurationDetailConfig():
return duration(_that);case DistanceDetailConfig():
return distance(_that);case EnvironmentDetailConfig():
return environment(_that);case PaceDetailConfig():
return pace(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NumberDetailConfig value)?  number,TResult? Function( DurationDetailConfig value)?  duration,TResult? Function( DistanceDetailConfig value)?  distance,TResult? Function( EnvironmentDetailConfig value)?  environment,TResult? Function( PaceDetailConfig value)?  pace,}){
final _that = this;
switch (_that) {
case NumberDetailConfig() when number != null:
return number(_that);case DurationDetailConfig() when duration != null:
return duration(_that);case DistanceDetailConfig() when distance != null:
return distance(_that);case EnvironmentDetailConfig() when environment != null:
return environment(_that);case PaceDetailConfig() when pace != null:
return pace(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  String label,  bool isInteger,  double maxValue)?  number,TResult Function( String id,  String label,  int maxSeconds,  bool useForPace)?  duration,TResult Function( String id,  String label,  bool isShort,  double maxValue,  bool useForPace)?  distance,TResult Function( String id,  String label)?  environment,TResult Function( String id,  PaceType paceType)?  pace,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NumberDetailConfig() when number != null:
return number(_that.id,_that.label,_that.isInteger,_that.maxValue);case DurationDetailConfig() when duration != null:
return duration(_that.id,_that.label,_that.maxSeconds,_that.useForPace);case DistanceDetailConfig() when distance != null:
return distance(_that.id,_that.label,_that.isShort,_that.maxValue,_that.useForPace);case EnvironmentDetailConfig() when environment != null:
return environment(_that.id,_that.label);case PaceDetailConfig() when pace != null:
return pace(_that.id,_that.paceType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  String label,  bool isInteger,  double maxValue)  number,required TResult Function( String id,  String label,  int maxSeconds,  bool useForPace)  duration,required TResult Function( String id,  String label,  bool isShort,  double maxValue,  bool useForPace)  distance,required TResult Function( String id,  String label)  environment,required TResult Function( String id,  PaceType paceType)  pace,}) {final _that = this;
switch (_that) {
case NumberDetailConfig():
return number(_that.id,_that.label,_that.isInteger,_that.maxValue);case DurationDetailConfig():
return duration(_that.id,_that.label,_that.maxSeconds,_that.useForPace);case DistanceDetailConfig():
return distance(_that.id,_that.label,_that.isShort,_that.maxValue,_that.useForPace);case EnvironmentDetailConfig():
return environment(_that.id,_that.label);case PaceDetailConfig():
return pace(_that.id,_that.paceType);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  String label,  bool isInteger,  double maxValue)?  number,TResult? Function( String id,  String label,  int maxSeconds,  bool useForPace)?  duration,TResult? Function( String id,  String label,  bool isShort,  double maxValue,  bool useForPace)?  distance,TResult? Function( String id,  String label)?  environment,TResult? Function( String id,  PaceType paceType)?  pace,}) {final _that = this;
switch (_that) {
case NumberDetailConfig() when number != null:
return number(_that.id,_that.label,_that.isInteger,_that.maxValue);case DurationDetailConfig() when duration != null:
return duration(_that.id,_that.label,_that.maxSeconds,_that.useForPace);case DistanceDetailConfig() when distance != null:
return distance(_that.id,_that.label,_that.isShort,_that.maxValue,_that.useForPace);case EnvironmentDetailConfig() when environment != null:
return environment(_that.id,_that.label);case PaceDetailConfig() when pace != null:
return pace(_that.id,_that.paceType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class NumberDetailConfig extends ActivityDetailConfig {
  const NumberDetailConfig({required this.id, this.label = '', this.isInteger = true, this.maxValue = 100.0, final  String? $type}): $type = $type ?? 'number',super._();
  factory NumberDetailConfig.fromJson(Map<String, dynamic> json) => _$NumberDetailConfigFromJson(json);

@override final  String id;
@JsonKey() final  String label;
@JsonKey() final  bool isInteger;
@JsonKey() final  double maxValue;

@JsonKey(name: 'detailType')
final String $type;


/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NumberDetailConfigCopyWith<NumberDetailConfig> get copyWith => _$NumberDetailConfigCopyWithImpl<NumberDetailConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NumberDetailConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NumberDetailConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.isInteger, isInteger) || other.isInteger == isInteger)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,isInteger,maxValue);

@override
String toString() {
  return 'ActivityDetailConfig.number(id: $id, label: $label, isInteger: $isInteger, maxValue: $maxValue)';
}


}

/// @nodoc
abstract mixin class $NumberDetailConfigCopyWith<$Res> implements $ActivityDetailConfigCopyWith<$Res> {
  factory $NumberDetailConfigCopyWith(NumberDetailConfig value, $Res Function(NumberDetailConfig) _then) = _$NumberDetailConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, bool isInteger, double maxValue
});




}
/// @nodoc
class _$NumberDetailConfigCopyWithImpl<$Res>
    implements $NumberDetailConfigCopyWith<$Res> {
  _$NumberDetailConfigCopyWithImpl(this._self, this._then);

  final NumberDetailConfig _self;
  final $Res Function(NumberDetailConfig) _then;

/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? isInteger = null,Object? maxValue = null,}) {
  return _then(NumberDetailConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isInteger: null == isInteger ? _self.isInteger : isInteger // ignore: cast_nullable_to_non_nullable
as bool,maxValue: null == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
@JsonSerializable()

class DurationDetailConfig extends ActivityDetailConfig {
  const DurationDetailConfig({required this.id, this.label = '', this.maxSeconds = 7200, this.useForPace = false, final  String? $type}): $type = $type ?? 'duration',super._();
  factory DurationDetailConfig.fromJson(Map<String, dynamic> json) => _$DurationDetailConfigFromJson(json);

@override final  String id;
@JsonKey() final  String label;
@JsonKey() final  int maxSeconds;
@JsonKey() final  bool useForPace;

@JsonKey(name: 'detailType')
final String $type;


/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DurationDetailConfigCopyWith<DurationDetailConfig> get copyWith => _$DurationDetailConfigCopyWithImpl<DurationDetailConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DurationDetailConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DurationDetailConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.maxSeconds, maxSeconds) || other.maxSeconds == maxSeconds)&&(identical(other.useForPace, useForPace) || other.useForPace == useForPace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,maxSeconds,useForPace);

@override
String toString() {
  return 'ActivityDetailConfig.duration(id: $id, label: $label, maxSeconds: $maxSeconds, useForPace: $useForPace)';
}


}

/// @nodoc
abstract mixin class $DurationDetailConfigCopyWith<$Res> implements $ActivityDetailConfigCopyWith<$Res> {
  factory $DurationDetailConfigCopyWith(DurationDetailConfig value, $Res Function(DurationDetailConfig) _then) = _$DurationDetailConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, int maxSeconds, bool useForPace
});




}
/// @nodoc
class _$DurationDetailConfigCopyWithImpl<$Res>
    implements $DurationDetailConfigCopyWith<$Res> {
  _$DurationDetailConfigCopyWithImpl(this._self, this._then);

  final DurationDetailConfig _self;
  final $Res Function(DurationDetailConfig) _then;

/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? maxSeconds = null,Object? useForPace = null,}) {
  return _then(DurationDetailConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,maxSeconds: null == maxSeconds ? _self.maxSeconds : maxSeconds // ignore: cast_nullable_to_non_nullable
as int,useForPace: null == useForPace ? _self.useForPace : useForPace // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class DistanceDetailConfig extends ActivityDetailConfig {
  const DistanceDetailConfig({required this.id, this.label = '', this.isShort = false, this.maxValue = 50.0, this.useForPace = false, final  String? $type}): $type = $type ?? 'distance',super._();
  factory DistanceDetailConfig.fromJson(Map<String, dynamic> json) => _$DistanceDetailConfigFromJson(json);

@override final  String id;
@JsonKey() final  String label;
@JsonKey() final  bool isShort;
@JsonKey() final  double maxValue;
@JsonKey() final  bool useForPace;

@JsonKey(name: 'detailType')
final String $type;


/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistanceDetailConfigCopyWith<DistanceDetailConfig> get copyWith => _$DistanceDetailConfigCopyWithImpl<DistanceDetailConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DistanceDetailConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DistanceDetailConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.isShort, isShort) || other.isShort == isShort)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.useForPace, useForPace) || other.useForPace == useForPace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,isShort,maxValue,useForPace);

@override
String toString() {
  return 'ActivityDetailConfig.distance(id: $id, label: $label, isShort: $isShort, maxValue: $maxValue, useForPace: $useForPace)';
}


}

/// @nodoc
abstract mixin class $DistanceDetailConfigCopyWith<$Res> implements $ActivityDetailConfigCopyWith<$Res> {
  factory $DistanceDetailConfigCopyWith(DistanceDetailConfig value, $Res Function(DistanceDetailConfig) _then) = _$DistanceDetailConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, bool isShort, double maxValue, bool useForPace
});




}
/// @nodoc
class _$DistanceDetailConfigCopyWithImpl<$Res>
    implements $DistanceDetailConfigCopyWith<$Res> {
  _$DistanceDetailConfigCopyWithImpl(this._self, this._then);

  final DistanceDetailConfig _self;
  final $Res Function(DistanceDetailConfig) _then;

/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? isShort = null,Object? maxValue = null,Object? useForPace = null,}) {
  return _then(DistanceDetailConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isShort: null == isShort ? _self.isShort : isShort // ignore: cast_nullable_to_non_nullable
as bool,maxValue: null == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as double,useForPace: null == useForPace ? _self.useForPace : useForPace // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class EnvironmentDetailConfig extends ActivityDetailConfig {
  const EnvironmentDetailConfig({required this.id, this.label = '', final  String? $type}): $type = $type ?? 'environment',super._();
  factory EnvironmentDetailConfig.fromJson(Map<String, dynamic> json) => _$EnvironmentDetailConfigFromJson(json);

@override final  String id;
@JsonKey() final  String label;

@JsonKey(name: 'detailType')
final String $type;


/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnvironmentDetailConfigCopyWith<EnvironmentDetailConfig> get copyWith => _$EnvironmentDetailConfigCopyWithImpl<EnvironmentDetailConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnvironmentDetailConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnvironmentDetailConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label);

@override
String toString() {
  return 'ActivityDetailConfig.environment(id: $id, label: $label)';
}


}

/// @nodoc
abstract mixin class $EnvironmentDetailConfigCopyWith<$Res> implements $ActivityDetailConfigCopyWith<$Res> {
  factory $EnvironmentDetailConfigCopyWith(EnvironmentDetailConfig value, $Res Function(EnvironmentDetailConfig) _then) = _$EnvironmentDetailConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String label
});




}
/// @nodoc
class _$EnvironmentDetailConfigCopyWithImpl<$Res>
    implements $EnvironmentDetailConfigCopyWith<$Res> {
  _$EnvironmentDetailConfigCopyWithImpl(this._self, this._then);

  final EnvironmentDetailConfig _self;
  final $Res Function(EnvironmentDetailConfig) _then;

/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,}) {
  return _then(EnvironmentDetailConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PaceDetailConfig extends ActivityDetailConfig {
  const PaceDetailConfig({required this.id, this.paceType = PaceType.minutesPerUom, final  String? $type}): $type = $type ?? 'pace',super._();
  factory PaceDetailConfig.fromJson(Map<String, dynamic> json) => _$PaceDetailConfigFromJson(json);

@override final  String id;
@JsonKey() final  PaceType paceType;

@JsonKey(name: 'detailType')
final String $type;


/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaceDetailConfigCopyWith<PaceDetailConfig> get copyWith => _$PaceDetailConfigCopyWithImpl<PaceDetailConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaceDetailConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaceDetailConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.paceType, paceType) || other.paceType == paceType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,paceType);

@override
String toString() {
  return 'ActivityDetailConfig.pace(id: $id, paceType: $paceType)';
}


}

/// @nodoc
abstract mixin class $PaceDetailConfigCopyWith<$Res> implements $ActivityDetailConfigCopyWith<$Res> {
  factory $PaceDetailConfigCopyWith(PaceDetailConfig value, $Res Function(PaceDetailConfig) _then) = _$PaceDetailConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, PaceType paceType
});




}
/// @nodoc
class _$PaceDetailConfigCopyWithImpl<$Res>
    implements $PaceDetailConfigCopyWith<$Res> {
  _$PaceDetailConfigCopyWithImpl(this._self, this._then);

  final PaceDetailConfig _self;
  final $Res Function(PaceDetailConfig) _then;

/// Create a copy of ActivityDetailConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? paceType = null,}) {
  return _then(PaceDetailConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,paceType: null == paceType ? _self.paceType : paceType // ignore: cast_nullable_to_non_nullable
as PaceType,
  ));
}


}

// dart format on
