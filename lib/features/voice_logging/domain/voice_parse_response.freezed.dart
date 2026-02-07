// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_parse_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VoiceParseResponse {

/// The extracted activity data from the voice transcript.
 VoiceParsedData get parsed;/// Top matching activities from hybrid search.
 List<ActivitySummary> get activities;/// Optional telemetry ID for tracking voice parsing events.
 String? get telemetryId;
/// Create a copy of VoiceParseResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceParseResponseCopyWith<VoiceParseResponse> get copyWith => _$VoiceParseResponseCopyWithImpl<VoiceParseResponse>(this as VoiceParseResponse, _$identity);

  /// Serializes this VoiceParseResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceParseResponse&&(identical(other.parsed, parsed) || other.parsed == parsed)&&const DeepCollectionEquality().equals(other.activities, activities)&&(identical(other.telemetryId, telemetryId) || other.telemetryId == telemetryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,parsed,const DeepCollectionEquality().hash(activities),telemetryId);

@override
String toString() {
  return 'VoiceParseResponse(parsed: $parsed, activities: $activities, telemetryId: $telemetryId)';
}


}

/// @nodoc
abstract mixin class $VoiceParseResponseCopyWith<$Res>  {
  factory $VoiceParseResponseCopyWith(VoiceParseResponse value, $Res Function(VoiceParseResponse) _then) = _$VoiceParseResponseCopyWithImpl;
@useResult
$Res call({
 VoiceParsedData parsed, List<ActivitySummary> activities, String? telemetryId
});


$VoiceParsedDataCopyWith<$Res> get parsed;

}
/// @nodoc
class _$VoiceParseResponseCopyWithImpl<$Res>
    implements $VoiceParseResponseCopyWith<$Res> {
  _$VoiceParseResponseCopyWithImpl(this._self, this._then);

  final VoiceParseResponse _self;
  final $Res Function(VoiceParseResponse) _then;

/// Create a copy of VoiceParseResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parsed = null,Object? activities = null,Object? telemetryId = freezed,}) {
  return _then(_self.copyWith(
parsed: null == parsed ? _self.parsed : parsed // ignore: cast_nullable_to_non_nullable
as VoiceParsedData,activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as List<ActivitySummary>,telemetryId: freezed == telemetryId ? _self.telemetryId : telemetryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of VoiceParseResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VoiceParsedDataCopyWith<$Res> get parsed {
  
  return $VoiceParsedDataCopyWith<$Res>(_self.parsed, (value) {
    return _then(_self.copyWith(parsed: value));
  });
}
}


/// Adds pattern-matching-related methods to [VoiceParseResponse].
extension VoiceParseResponsePatterns on VoiceParseResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceParseResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceParseResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceParseResponse value)  $default,){
final _that = this;
switch (_that) {
case _VoiceParseResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceParseResponse value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceParseResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VoiceParsedData parsed,  List<ActivitySummary> activities,  String? telemetryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceParseResponse() when $default != null:
return $default(_that.parsed,_that.activities,_that.telemetryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VoiceParsedData parsed,  List<ActivitySummary> activities,  String? telemetryId)  $default,) {final _that = this;
switch (_that) {
case _VoiceParseResponse():
return $default(_that.parsed,_that.activities,_that.telemetryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VoiceParsedData parsed,  List<ActivitySummary> activities,  String? telemetryId)?  $default,) {final _that = this;
switch (_that) {
case _VoiceParseResponse() when $default != null:
return $default(_that.parsed,_that.activities,_that.telemetryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VoiceParseResponse implements VoiceParseResponse {
  const _VoiceParseResponse({required this.parsed, required final  List<ActivitySummary> activities, this.telemetryId}): _activities = activities;
  factory _VoiceParseResponse.fromJson(Map<String, dynamic> json) => _$VoiceParseResponseFromJson(json);

/// The extracted activity data from the voice transcript.
@override final  VoiceParsedData parsed;
/// Top matching activities from hybrid search.
 final  List<ActivitySummary> _activities;
/// Top matching activities from hybrid search.
@override List<ActivitySummary> get activities {
  if (_activities is EqualUnmodifiableListView) return _activities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activities);
}

/// Optional telemetry ID for tracking voice parsing events.
@override final  String? telemetryId;

/// Create a copy of VoiceParseResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceParseResponseCopyWith<_VoiceParseResponse> get copyWith => __$VoiceParseResponseCopyWithImpl<_VoiceParseResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoiceParseResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceParseResponse&&(identical(other.parsed, parsed) || other.parsed == parsed)&&const DeepCollectionEquality().equals(other._activities, _activities)&&(identical(other.telemetryId, telemetryId) || other.telemetryId == telemetryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,parsed,const DeepCollectionEquality().hash(_activities),telemetryId);

@override
String toString() {
  return 'VoiceParseResponse(parsed: $parsed, activities: $activities, telemetryId: $telemetryId)';
}


}

/// @nodoc
abstract mixin class _$VoiceParseResponseCopyWith<$Res> implements $VoiceParseResponseCopyWith<$Res> {
  factory _$VoiceParseResponseCopyWith(_VoiceParseResponse value, $Res Function(_VoiceParseResponse) _then) = __$VoiceParseResponseCopyWithImpl;
@override @useResult
$Res call({
 VoiceParsedData parsed, List<ActivitySummary> activities, String? telemetryId
});


@override $VoiceParsedDataCopyWith<$Res> get parsed;

}
/// @nodoc
class __$VoiceParseResponseCopyWithImpl<$Res>
    implements _$VoiceParseResponseCopyWith<$Res> {
  __$VoiceParseResponseCopyWithImpl(this._self, this._then);

  final _VoiceParseResponse _self;
  final $Res Function(_VoiceParseResponse) _then;

/// Create a copy of VoiceParseResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parsed = null,Object? activities = null,Object? telemetryId = freezed,}) {
  return _then(_VoiceParseResponse(
parsed: null == parsed ? _self.parsed : parsed // ignore: cast_nullable_to_non_nullable
as VoiceParsedData,activities: null == activities ? _self._activities : activities // ignore: cast_nullable_to_non_nullable
as List<ActivitySummary>,telemetryId: freezed == telemetryId ? _self.telemetryId : telemetryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of VoiceParseResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VoiceParsedDataCopyWith<$Res> get parsed {
  
  return $VoiceParsedDataCopyWith<$Res>(_self.parsed, (value) {
    return _then(_self.copyWith(parsed: value));
  });
}
}


/// @nodoc
mixin _$VoiceParsedData {

/// The normalized activity type for searching (e.g., "running", "yoga").
 String get activityQuery;/// Duration of the activity, if mentioned.
 VoiceDuration? get duration;/// Distance covered, if mentioned.
 VoiceDistance? get distance;/// When the activity happened, if mentioned.
 VoiceDate? get date;/// Any additional context from the transcript.
 String? get comments;
/// Create a copy of VoiceParsedData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceParsedDataCopyWith<VoiceParsedData> get copyWith => _$VoiceParsedDataCopyWithImpl<VoiceParsedData>(this as VoiceParsedData, _$identity);

  /// Serializes this VoiceParsedData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceParsedData&&(identical(other.activityQuery, activityQuery) || other.activityQuery == activityQuery)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.date, date) || other.date == date)&&(identical(other.comments, comments) || other.comments == comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityQuery,duration,distance,date,comments);

@override
String toString() {
  return 'VoiceParsedData(activityQuery: $activityQuery, duration: $duration, distance: $distance, date: $date, comments: $comments)';
}


}

/// @nodoc
abstract mixin class $VoiceParsedDataCopyWith<$Res>  {
  factory $VoiceParsedDataCopyWith(VoiceParsedData value, $Res Function(VoiceParsedData) _then) = _$VoiceParsedDataCopyWithImpl;
@useResult
$Res call({
 String activityQuery, VoiceDuration? duration, VoiceDistance? distance, VoiceDate? date, String? comments
});


$VoiceDurationCopyWith<$Res>? get duration;$VoiceDistanceCopyWith<$Res>? get distance;$VoiceDateCopyWith<$Res>? get date;

}
/// @nodoc
class _$VoiceParsedDataCopyWithImpl<$Res>
    implements $VoiceParsedDataCopyWith<$Res> {
  _$VoiceParsedDataCopyWithImpl(this._self, this._then);

  final VoiceParsedData _self;
  final $Res Function(VoiceParsedData) _then;

/// Create a copy of VoiceParsedData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityQuery = null,Object? duration = freezed,Object? distance = freezed,Object? date = freezed,Object? comments = freezed,}) {
  return _then(_self.copyWith(
activityQuery: null == activityQuery ? _self.activityQuery : activityQuery // ignore: cast_nullable_to_non_nullable
as String,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as VoiceDuration?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as VoiceDistance?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as VoiceDate?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of VoiceParsedData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VoiceDurationCopyWith<$Res>? get duration {
    if (_self.duration == null) {
    return null;
  }

  return $VoiceDurationCopyWith<$Res>(_self.duration!, (value) {
    return _then(_self.copyWith(duration: value));
  });
}/// Create a copy of VoiceParsedData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VoiceDistanceCopyWith<$Res>? get distance {
    if (_self.distance == null) {
    return null;
  }

  return $VoiceDistanceCopyWith<$Res>(_self.distance!, (value) {
    return _then(_self.copyWith(distance: value));
  });
}/// Create a copy of VoiceParsedData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VoiceDateCopyWith<$Res>? get date {
    if (_self.date == null) {
    return null;
  }

  return $VoiceDateCopyWith<$Res>(_self.date!, (value) {
    return _then(_self.copyWith(date: value));
  });
}
}


/// Adds pattern-matching-related methods to [VoiceParsedData].
extension VoiceParsedDataPatterns on VoiceParsedData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceParsedData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceParsedData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceParsedData value)  $default,){
final _that = this;
switch (_that) {
case _VoiceParsedData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceParsedData value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceParsedData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String activityQuery,  VoiceDuration? duration,  VoiceDistance? distance,  VoiceDate? date,  String? comments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceParsedData() when $default != null:
return $default(_that.activityQuery,_that.duration,_that.distance,_that.date,_that.comments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String activityQuery,  VoiceDuration? duration,  VoiceDistance? distance,  VoiceDate? date,  String? comments)  $default,) {final _that = this;
switch (_that) {
case _VoiceParsedData():
return $default(_that.activityQuery,_that.duration,_that.distance,_that.date,_that.comments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String activityQuery,  VoiceDuration? duration,  VoiceDistance? distance,  VoiceDate? date,  String? comments)?  $default,) {final _that = this;
switch (_that) {
case _VoiceParsedData() when $default != null:
return $default(_that.activityQuery,_that.duration,_that.distance,_that.date,_that.comments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VoiceParsedData implements VoiceParsedData {
  const _VoiceParsedData({required this.activityQuery, this.duration, this.distance, this.date, this.comments});
  factory _VoiceParsedData.fromJson(Map<String, dynamic> json) => _$VoiceParsedDataFromJson(json);

/// The normalized activity type for searching (e.g., "running", "yoga").
@override final  String activityQuery;
/// Duration of the activity, if mentioned.
@override final  VoiceDuration? duration;
/// Distance covered, if mentioned.
@override final  VoiceDistance? distance;
/// When the activity happened, if mentioned.
@override final  VoiceDate? date;
/// Any additional context from the transcript.
@override final  String? comments;

/// Create a copy of VoiceParsedData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceParsedDataCopyWith<_VoiceParsedData> get copyWith => __$VoiceParsedDataCopyWithImpl<_VoiceParsedData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoiceParsedDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceParsedData&&(identical(other.activityQuery, activityQuery) || other.activityQuery == activityQuery)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.date, date) || other.date == date)&&(identical(other.comments, comments) || other.comments == comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityQuery,duration,distance,date,comments);

@override
String toString() {
  return 'VoiceParsedData(activityQuery: $activityQuery, duration: $duration, distance: $distance, date: $date, comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$VoiceParsedDataCopyWith<$Res> implements $VoiceParsedDataCopyWith<$Res> {
  factory _$VoiceParsedDataCopyWith(_VoiceParsedData value, $Res Function(_VoiceParsedData) _then) = __$VoiceParsedDataCopyWithImpl;
@override @useResult
$Res call({
 String activityQuery, VoiceDuration? duration, VoiceDistance? distance, VoiceDate? date, String? comments
});


@override $VoiceDurationCopyWith<$Res>? get duration;@override $VoiceDistanceCopyWith<$Res>? get distance;@override $VoiceDateCopyWith<$Res>? get date;

}
/// @nodoc
class __$VoiceParsedDataCopyWithImpl<$Res>
    implements _$VoiceParsedDataCopyWith<$Res> {
  __$VoiceParsedDataCopyWithImpl(this._self, this._then);

  final _VoiceParsedData _self;
  final $Res Function(_VoiceParsedData) _then;

/// Create a copy of VoiceParsedData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityQuery = null,Object? duration = freezed,Object? distance = freezed,Object? date = freezed,Object? comments = freezed,}) {
  return _then(_VoiceParsedData(
activityQuery: null == activityQuery ? _self.activityQuery : activityQuery // ignore: cast_nullable_to_non_nullable
as String,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as VoiceDuration?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as VoiceDistance?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as VoiceDate?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of VoiceParsedData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VoiceDurationCopyWith<$Res>? get duration {
    if (_self.duration == null) {
    return null;
  }

  return $VoiceDurationCopyWith<$Res>(_self.duration!, (value) {
    return _then(_self.copyWith(duration: value));
  });
}/// Create a copy of VoiceParsedData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VoiceDistanceCopyWith<$Res>? get distance {
    if (_self.distance == null) {
    return null;
  }

  return $VoiceDistanceCopyWith<$Res>(_self.distance!, (value) {
    return _then(_self.copyWith(distance: value));
  });
}/// Create a copy of VoiceParsedData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VoiceDateCopyWith<$Res>? get date {
    if (_self.date == null) {
    return null;
  }

  return $VoiceDateCopyWith<$Res>(_self.date!, (value) {
    return _then(_self.copyWith(date: value));
  });
}
}


/// @nodoc
mixin _$VoiceDuration {

/// Duration in seconds.
 int get seconds;
/// Create a copy of VoiceDuration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceDurationCopyWith<VoiceDuration> get copyWith => _$VoiceDurationCopyWithImpl<VoiceDuration>(this as VoiceDuration, _$identity);

  /// Serializes this VoiceDuration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceDuration&&(identical(other.seconds, seconds) || other.seconds == seconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seconds);

@override
String toString() {
  return 'VoiceDuration(seconds: $seconds)';
}


}

/// @nodoc
abstract mixin class $VoiceDurationCopyWith<$Res>  {
  factory $VoiceDurationCopyWith(VoiceDuration value, $Res Function(VoiceDuration) _then) = _$VoiceDurationCopyWithImpl;
@useResult
$Res call({
 int seconds
});




}
/// @nodoc
class _$VoiceDurationCopyWithImpl<$Res>
    implements $VoiceDurationCopyWith<$Res> {
  _$VoiceDurationCopyWithImpl(this._self, this._then);

  final VoiceDuration _self;
  final $Res Function(VoiceDuration) _then;

/// Create a copy of VoiceDuration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seconds = null,}) {
  return _then(_self.copyWith(
seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceDuration].
extension VoiceDurationPatterns on VoiceDuration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceDuration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceDuration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceDuration value)  $default,){
final _that = this;
switch (_that) {
case _VoiceDuration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceDuration value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceDuration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceDuration() when $default != null:
return $default(_that.seconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seconds)  $default,) {final _that = this;
switch (_that) {
case _VoiceDuration():
return $default(_that.seconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seconds)?  $default,) {final _that = this;
switch (_that) {
case _VoiceDuration() when $default != null:
return $default(_that.seconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VoiceDuration implements VoiceDuration {
  const _VoiceDuration({required this.seconds});
  factory _VoiceDuration.fromJson(Map<String, dynamic> json) => _$VoiceDurationFromJson(json);

/// Duration in seconds.
@override final  int seconds;

/// Create a copy of VoiceDuration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceDurationCopyWith<_VoiceDuration> get copyWith => __$VoiceDurationCopyWithImpl<_VoiceDuration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoiceDurationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceDuration&&(identical(other.seconds, seconds) || other.seconds == seconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seconds);

@override
String toString() {
  return 'VoiceDuration(seconds: $seconds)';
}


}

/// @nodoc
abstract mixin class _$VoiceDurationCopyWith<$Res> implements $VoiceDurationCopyWith<$Res> {
  factory _$VoiceDurationCopyWith(_VoiceDuration value, $Res Function(_VoiceDuration) _then) = __$VoiceDurationCopyWithImpl;
@override @useResult
$Res call({
 int seconds
});




}
/// @nodoc
class __$VoiceDurationCopyWithImpl<$Res>
    implements _$VoiceDurationCopyWith<$Res> {
  __$VoiceDurationCopyWithImpl(this._self, this._then);

  final _VoiceDuration _self;
  final $Res Function(_VoiceDuration) _then;

/// Create a copy of VoiceDuration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seconds = null,}) {
  return _then(_VoiceDuration(
seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$VoiceDistance {

/// Distance in meters.
 double get meters;/// The original numeric value mentioned.
 double get originalValue;/// The original unit mentioned (e.g., "miles", "km").
 String get originalUnit;
/// Create a copy of VoiceDistance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceDistanceCopyWith<VoiceDistance> get copyWith => _$VoiceDistanceCopyWithImpl<VoiceDistance>(this as VoiceDistance, _$identity);

  /// Serializes this VoiceDistance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceDistance&&(identical(other.meters, meters) || other.meters == meters)&&(identical(other.originalValue, originalValue) || other.originalValue == originalValue)&&(identical(other.originalUnit, originalUnit) || other.originalUnit == originalUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meters,originalValue,originalUnit);

@override
String toString() {
  return 'VoiceDistance(meters: $meters, originalValue: $originalValue, originalUnit: $originalUnit)';
}


}

/// @nodoc
abstract mixin class $VoiceDistanceCopyWith<$Res>  {
  factory $VoiceDistanceCopyWith(VoiceDistance value, $Res Function(VoiceDistance) _then) = _$VoiceDistanceCopyWithImpl;
@useResult
$Res call({
 double meters, double originalValue, String originalUnit
});




}
/// @nodoc
class _$VoiceDistanceCopyWithImpl<$Res>
    implements $VoiceDistanceCopyWith<$Res> {
  _$VoiceDistanceCopyWithImpl(this._self, this._then);

  final VoiceDistance _self;
  final $Res Function(VoiceDistance) _then;

/// Create a copy of VoiceDistance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meters = null,Object? originalValue = null,Object? originalUnit = null,}) {
  return _then(_self.copyWith(
meters: null == meters ? _self.meters : meters // ignore: cast_nullable_to_non_nullable
as double,originalValue: null == originalValue ? _self.originalValue : originalValue // ignore: cast_nullable_to_non_nullable
as double,originalUnit: null == originalUnit ? _self.originalUnit : originalUnit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceDistance].
extension VoiceDistancePatterns on VoiceDistance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceDistance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceDistance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceDistance value)  $default,){
final _that = this;
switch (_that) {
case _VoiceDistance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceDistance value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceDistance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double meters,  double originalValue,  String originalUnit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceDistance() when $default != null:
return $default(_that.meters,_that.originalValue,_that.originalUnit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double meters,  double originalValue,  String originalUnit)  $default,) {final _that = this;
switch (_that) {
case _VoiceDistance():
return $default(_that.meters,_that.originalValue,_that.originalUnit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double meters,  double originalValue,  String originalUnit)?  $default,) {final _that = this;
switch (_that) {
case _VoiceDistance() when $default != null:
return $default(_that.meters,_that.originalValue,_that.originalUnit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VoiceDistance implements VoiceDistance {
  const _VoiceDistance({required this.meters, required this.originalValue, required this.originalUnit});
  factory _VoiceDistance.fromJson(Map<String, dynamic> json) => _$VoiceDistanceFromJson(json);

/// Distance in meters.
@override final  double meters;
/// The original numeric value mentioned.
@override final  double originalValue;
/// The original unit mentioned (e.g., "miles", "km").
@override final  String originalUnit;

/// Create a copy of VoiceDistance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceDistanceCopyWith<_VoiceDistance> get copyWith => __$VoiceDistanceCopyWithImpl<_VoiceDistance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoiceDistanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceDistance&&(identical(other.meters, meters) || other.meters == meters)&&(identical(other.originalValue, originalValue) || other.originalValue == originalValue)&&(identical(other.originalUnit, originalUnit) || other.originalUnit == originalUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meters,originalValue,originalUnit);

@override
String toString() {
  return 'VoiceDistance(meters: $meters, originalValue: $originalValue, originalUnit: $originalUnit)';
}


}

/// @nodoc
abstract mixin class _$VoiceDistanceCopyWith<$Res> implements $VoiceDistanceCopyWith<$Res> {
  factory _$VoiceDistanceCopyWith(_VoiceDistance value, $Res Function(_VoiceDistance) _then) = __$VoiceDistanceCopyWithImpl;
@override @useResult
$Res call({
 double meters, double originalValue, String originalUnit
});




}
/// @nodoc
class __$VoiceDistanceCopyWithImpl<$Res>
    implements _$VoiceDistanceCopyWith<$Res> {
  __$VoiceDistanceCopyWithImpl(this._self, this._then);

  final _VoiceDistance _self;
  final $Res Function(_VoiceDistance) _then;

/// Create a copy of VoiceDistance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meters = null,Object? originalValue = null,Object? originalUnit = null,}) {
  return _then(_VoiceDistance(
meters: null == meters ? _self.meters : meters // ignore: cast_nullable_to_non_nullable
as double,originalValue: null == originalValue ? _self.originalValue : originalValue // ignore: cast_nullable_to_non_nullable
as double,originalUnit: null == originalUnit ? _self.originalUnit : originalUnit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$VoiceDate {

/// ISO 8601 date string.
 String get iso;/// The relative time phrase used (e.g., "this morning", "yesterday").
 String? get relative;
/// Create a copy of VoiceDate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceDateCopyWith<VoiceDate> get copyWith => _$VoiceDateCopyWithImpl<VoiceDate>(this as VoiceDate, _$identity);

  /// Serializes this VoiceDate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceDate&&(identical(other.iso, iso) || other.iso == iso)&&(identical(other.relative, relative) || other.relative == relative));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,iso,relative);

@override
String toString() {
  return 'VoiceDate(iso: $iso, relative: $relative)';
}


}

/// @nodoc
abstract mixin class $VoiceDateCopyWith<$Res>  {
  factory $VoiceDateCopyWith(VoiceDate value, $Res Function(VoiceDate) _then) = _$VoiceDateCopyWithImpl;
@useResult
$Res call({
 String iso, String? relative
});




}
/// @nodoc
class _$VoiceDateCopyWithImpl<$Res>
    implements $VoiceDateCopyWith<$Res> {
  _$VoiceDateCopyWithImpl(this._self, this._then);

  final VoiceDate _self;
  final $Res Function(VoiceDate) _then;

/// Create a copy of VoiceDate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? iso = null,Object? relative = freezed,}) {
  return _then(_self.copyWith(
iso: null == iso ? _self.iso : iso // ignore: cast_nullable_to_non_nullable
as String,relative: freezed == relative ? _self.relative : relative // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceDate].
extension VoiceDatePatterns on VoiceDate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceDate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceDate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceDate value)  $default,){
final _that = this;
switch (_that) {
case _VoiceDate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceDate value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceDate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String iso,  String? relative)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceDate() when $default != null:
return $default(_that.iso,_that.relative);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String iso,  String? relative)  $default,) {final _that = this;
switch (_that) {
case _VoiceDate():
return $default(_that.iso,_that.relative);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String iso,  String? relative)?  $default,) {final _that = this;
switch (_that) {
case _VoiceDate() when $default != null:
return $default(_that.iso,_that.relative);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VoiceDate implements VoiceDate {
  const _VoiceDate({required this.iso, this.relative});
  factory _VoiceDate.fromJson(Map<String, dynamic> json) => _$VoiceDateFromJson(json);

/// ISO 8601 date string.
@override final  String iso;
/// The relative time phrase used (e.g., "this morning", "yesterday").
@override final  String? relative;

/// Create a copy of VoiceDate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceDateCopyWith<_VoiceDate> get copyWith => __$VoiceDateCopyWithImpl<_VoiceDate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoiceDateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceDate&&(identical(other.iso, iso) || other.iso == iso)&&(identical(other.relative, relative) || other.relative == relative));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,iso,relative);

@override
String toString() {
  return 'VoiceDate(iso: $iso, relative: $relative)';
}


}

/// @nodoc
abstract mixin class _$VoiceDateCopyWith<$Res> implements $VoiceDateCopyWith<$Res> {
  factory _$VoiceDateCopyWith(_VoiceDate value, $Res Function(_VoiceDate) _then) = __$VoiceDateCopyWithImpl;
@override @useResult
$Res call({
 String iso, String? relative
});




}
/// @nodoc
class __$VoiceDateCopyWithImpl<$Res>
    implements _$VoiceDateCopyWith<$Res> {
  __$VoiceDateCopyWithImpl(this._self, this._then);

  final _VoiceDate _self;
  final $Res Function(_VoiceDate) _then;

/// Create a copy of VoiceDate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? iso = null,Object? relative = freezed,}) {
  return _then(_VoiceDate(
iso: null == iso ? _self.iso : iso // ignore: cast_nullable_to_non_nullable
as String,relative: freezed == relative ? _self.relative : relative // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
