// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_parse_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VoiceParseResult {

/// The original transcript from speech recognition.
 String get rawTranscript;/// The extracted activity query for searching.
 String get activityQuery;/// Extracted duration in seconds (e.g., "45 minutes" -> 2700).
 int? get durationSeconds;/// Extracted distance in meters (e.g., "5 miles" -> 8046.72).
 double? get distanceMeters;/// Extracted date/time for the activity.
 DateTime? get activityDate;/// Any remaining text that could be used as comments.
 String? get comments;
/// Create a copy of VoiceParseResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceParseResultCopyWith<VoiceParseResult> get copyWith => _$VoiceParseResultCopyWithImpl<VoiceParseResult>(this as VoiceParseResult, _$identity);

  /// Serializes this VoiceParseResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceParseResult&&(identical(other.rawTranscript, rawTranscript) || other.rawTranscript == rawTranscript)&&(identical(other.activityQuery, activityQuery) || other.activityQuery == activityQuery)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.activityDate, activityDate) || other.activityDate == activityDate)&&(identical(other.comments, comments) || other.comments == comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rawTranscript,activityQuery,durationSeconds,distanceMeters,activityDate,comments);

@override
String toString() {
  return 'VoiceParseResult(rawTranscript: $rawTranscript, activityQuery: $activityQuery, durationSeconds: $durationSeconds, distanceMeters: $distanceMeters, activityDate: $activityDate, comments: $comments)';
}


}

/// @nodoc
abstract mixin class $VoiceParseResultCopyWith<$Res>  {
  factory $VoiceParseResultCopyWith(VoiceParseResult value, $Res Function(VoiceParseResult) _then) = _$VoiceParseResultCopyWithImpl;
@useResult
$Res call({
 String rawTranscript, String activityQuery, int? durationSeconds, double? distanceMeters, DateTime? activityDate, String? comments
});




}
/// @nodoc
class _$VoiceParseResultCopyWithImpl<$Res>
    implements $VoiceParseResultCopyWith<$Res> {
  _$VoiceParseResultCopyWithImpl(this._self, this._then);

  final VoiceParseResult _self;
  final $Res Function(VoiceParseResult) _then;

/// Create a copy of VoiceParseResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rawTranscript = null,Object? activityQuery = null,Object? durationSeconds = freezed,Object? distanceMeters = freezed,Object? activityDate = freezed,Object? comments = freezed,}) {
  return _then(_self.copyWith(
rawTranscript: null == rawTranscript ? _self.rawTranscript : rawTranscript // ignore: cast_nullable_to_non_nullable
as String,activityQuery: null == activityQuery ? _self.activityQuery : activityQuery // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,activityDate: freezed == activityDate ? _self.activityDate : activityDate // ignore: cast_nullable_to_non_nullable
as DateTime?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceParseResult].
extension VoiceParseResultPatterns on VoiceParseResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceParseResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceParseResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceParseResult value)  $default,){
final _that = this;
switch (_that) {
case _VoiceParseResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceParseResult value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceParseResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rawTranscript,  String activityQuery,  int? durationSeconds,  double? distanceMeters,  DateTime? activityDate,  String? comments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceParseResult() when $default != null:
return $default(_that.rawTranscript,_that.activityQuery,_that.durationSeconds,_that.distanceMeters,_that.activityDate,_that.comments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rawTranscript,  String activityQuery,  int? durationSeconds,  double? distanceMeters,  DateTime? activityDate,  String? comments)  $default,) {final _that = this;
switch (_that) {
case _VoiceParseResult():
return $default(_that.rawTranscript,_that.activityQuery,_that.durationSeconds,_that.distanceMeters,_that.activityDate,_that.comments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rawTranscript,  String activityQuery,  int? durationSeconds,  double? distanceMeters,  DateTime? activityDate,  String? comments)?  $default,) {final _that = this;
switch (_that) {
case _VoiceParseResult() when $default != null:
return $default(_that.rawTranscript,_that.activityQuery,_that.durationSeconds,_that.distanceMeters,_that.activityDate,_that.comments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VoiceParseResult implements VoiceParseResult {
  const _VoiceParseResult({required this.rawTranscript, required this.activityQuery, this.durationSeconds, this.distanceMeters, this.activityDate, this.comments});
  factory _VoiceParseResult.fromJson(Map<String, dynamic> json) => _$VoiceParseResultFromJson(json);

/// The original transcript from speech recognition.
@override final  String rawTranscript;
/// The extracted activity query for searching.
@override final  String activityQuery;
/// Extracted duration in seconds (e.g., "45 minutes" -> 2700).
@override final  int? durationSeconds;
/// Extracted distance in meters (e.g., "5 miles" -> 8046.72).
@override final  double? distanceMeters;
/// Extracted date/time for the activity.
@override final  DateTime? activityDate;
/// Any remaining text that could be used as comments.
@override final  String? comments;

/// Create a copy of VoiceParseResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceParseResultCopyWith<_VoiceParseResult> get copyWith => __$VoiceParseResultCopyWithImpl<_VoiceParseResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoiceParseResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceParseResult&&(identical(other.rawTranscript, rawTranscript) || other.rawTranscript == rawTranscript)&&(identical(other.activityQuery, activityQuery) || other.activityQuery == activityQuery)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.activityDate, activityDate) || other.activityDate == activityDate)&&(identical(other.comments, comments) || other.comments == comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rawTranscript,activityQuery,durationSeconds,distanceMeters,activityDate,comments);

@override
String toString() {
  return 'VoiceParseResult(rawTranscript: $rawTranscript, activityQuery: $activityQuery, durationSeconds: $durationSeconds, distanceMeters: $distanceMeters, activityDate: $activityDate, comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$VoiceParseResultCopyWith<$Res> implements $VoiceParseResultCopyWith<$Res> {
  factory _$VoiceParseResultCopyWith(_VoiceParseResult value, $Res Function(_VoiceParseResult) _then) = __$VoiceParseResultCopyWithImpl;
@override @useResult
$Res call({
 String rawTranscript, String activityQuery, int? durationSeconds, double? distanceMeters, DateTime? activityDate, String? comments
});




}
/// @nodoc
class __$VoiceParseResultCopyWithImpl<$Res>
    implements _$VoiceParseResultCopyWith<$Res> {
  __$VoiceParseResultCopyWithImpl(this._self, this._then);

  final _VoiceParseResult _self;
  final $Res Function(_VoiceParseResult) _then;

/// Create a copy of VoiceParseResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rawTranscript = null,Object? activityQuery = null,Object? durationSeconds = freezed,Object? distanceMeters = freezed,Object? activityDate = freezed,Object? comments = freezed,}) {
  return _then(_VoiceParseResult(
rawTranscript: null == rawTranscript ? _self.rawTranscript : rawTranscript // ignore: cast_nullable_to_non_nullable
as String,activityQuery: null == activityQuery ? _self.activityQuery : activityQuery // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,activityDate: freezed == activityDate ? _self.activityDate : activityDate // ignore: cast_nullable_to_non_nullable
as DateTime?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
