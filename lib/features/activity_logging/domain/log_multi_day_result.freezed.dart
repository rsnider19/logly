// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_multi_day_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LogMultiDayResult {

/// Successfully created user activities.
 List<UserActivity> get successes;/// Days that failed to log with their error messages.
 List<FailedDay> get failures;
/// Create a copy of LogMultiDayResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogMultiDayResultCopyWith<LogMultiDayResult> get copyWith => _$LogMultiDayResultCopyWithImpl<LogMultiDayResult>(this as LogMultiDayResult, _$identity);

  /// Serializes this LogMultiDayResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogMultiDayResult&&const DeepCollectionEquality().equals(other.successes, successes)&&const DeepCollectionEquality().equals(other.failures, failures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(successes),const DeepCollectionEquality().hash(failures));

@override
String toString() {
  return 'LogMultiDayResult(successes: $successes, failures: $failures)';
}


}

/// @nodoc
abstract mixin class $LogMultiDayResultCopyWith<$Res>  {
  factory $LogMultiDayResultCopyWith(LogMultiDayResult value, $Res Function(LogMultiDayResult) _then) = _$LogMultiDayResultCopyWithImpl;
@useResult
$Res call({
 List<UserActivity> successes, List<FailedDay> failures
});




}
/// @nodoc
class _$LogMultiDayResultCopyWithImpl<$Res>
    implements $LogMultiDayResultCopyWith<$Res> {
  _$LogMultiDayResultCopyWithImpl(this._self, this._then);

  final LogMultiDayResult _self;
  final $Res Function(LogMultiDayResult) _then;

/// Create a copy of LogMultiDayResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? successes = null,Object? failures = null,}) {
  return _then(_self.copyWith(
successes: null == successes ? _self.successes : successes // ignore: cast_nullable_to_non_nullable
as List<UserActivity>,failures: null == failures ? _self.failures : failures // ignore: cast_nullable_to_non_nullable
as List<FailedDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [LogMultiDayResult].
extension LogMultiDayResultPatterns on LogMultiDayResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogMultiDayResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogMultiDayResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogMultiDayResult value)  $default,){
final _that = this;
switch (_that) {
case _LogMultiDayResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogMultiDayResult value)?  $default,){
final _that = this;
switch (_that) {
case _LogMultiDayResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<UserActivity> successes,  List<FailedDay> failures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogMultiDayResult() when $default != null:
return $default(_that.successes,_that.failures);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<UserActivity> successes,  List<FailedDay> failures)  $default,) {final _that = this;
switch (_that) {
case _LogMultiDayResult():
return $default(_that.successes,_that.failures);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<UserActivity> successes,  List<FailedDay> failures)?  $default,) {final _that = this;
switch (_that) {
case _LogMultiDayResult() when $default != null:
return $default(_that.successes,_that.failures);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LogMultiDayResult extends LogMultiDayResult {
  const _LogMultiDayResult({required final  List<UserActivity> successes, required final  List<FailedDay> failures}): _successes = successes,_failures = failures,super._();
  factory _LogMultiDayResult.fromJson(Map<String, dynamic> json) => _$LogMultiDayResultFromJson(json);

/// Successfully created user activities.
 final  List<UserActivity> _successes;
/// Successfully created user activities.
@override List<UserActivity> get successes {
  if (_successes is EqualUnmodifiableListView) return _successes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_successes);
}

/// Days that failed to log with their error messages.
 final  List<FailedDay> _failures;
/// Days that failed to log with their error messages.
@override List<FailedDay> get failures {
  if (_failures is EqualUnmodifiableListView) return _failures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failures);
}


/// Create a copy of LogMultiDayResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogMultiDayResultCopyWith<_LogMultiDayResult> get copyWith => __$LogMultiDayResultCopyWithImpl<_LogMultiDayResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LogMultiDayResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogMultiDayResult&&const DeepCollectionEquality().equals(other._successes, _successes)&&const DeepCollectionEquality().equals(other._failures, _failures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_successes),const DeepCollectionEquality().hash(_failures));

@override
String toString() {
  return 'LogMultiDayResult(successes: $successes, failures: $failures)';
}


}

/// @nodoc
abstract mixin class _$LogMultiDayResultCopyWith<$Res> implements $LogMultiDayResultCopyWith<$Res> {
  factory _$LogMultiDayResultCopyWith(_LogMultiDayResult value, $Res Function(_LogMultiDayResult) _then) = __$LogMultiDayResultCopyWithImpl;
@override @useResult
$Res call({
 List<UserActivity> successes, List<FailedDay> failures
});




}
/// @nodoc
class __$LogMultiDayResultCopyWithImpl<$Res>
    implements _$LogMultiDayResultCopyWith<$Res> {
  __$LogMultiDayResultCopyWithImpl(this._self, this._then);

  final _LogMultiDayResult _self;
  final $Res Function(_LogMultiDayResult) _then;

/// Create a copy of LogMultiDayResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? successes = null,Object? failures = null,}) {
  return _then(_LogMultiDayResult(
successes: null == successes ? _self._successes : successes // ignore: cast_nullable_to_non_nullable
as List<UserActivity>,failures: null == failures ? _self._failures : failures // ignore: cast_nullable_to_non_nullable
as List<FailedDay>,
  ));
}


}


/// @nodoc
mixin _$FailedDay {

/// The date that failed to log.
 DateTime get date;/// The error message describing why it failed.
 String get errorMessage;
/// Create a copy of FailedDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailedDayCopyWith<FailedDay> get copyWith => _$FailedDayCopyWithImpl<FailedDay>(this as FailedDay, _$identity);

  /// Serializes this FailedDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FailedDay&&(identical(other.date, date) || other.date == date)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,errorMessage);

@override
String toString() {
  return 'FailedDay(date: $date, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $FailedDayCopyWith<$Res>  {
  factory $FailedDayCopyWith(FailedDay value, $Res Function(FailedDay) _then) = _$FailedDayCopyWithImpl;
@useResult
$Res call({
 DateTime date, String errorMessage
});




}
/// @nodoc
class _$FailedDayCopyWithImpl<$Res>
    implements $FailedDayCopyWith<$Res> {
  _$FailedDayCopyWithImpl(this._self, this._then);

  final FailedDay _self;
  final $Res Function(FailedDay) _then;

/// Create a copy of FailedDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FailedDay].
extension FailedDayPatterns on FailedDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FailedDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FailedDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FailedDay value)  $default,){
final _that = this;
switch (_that) {
case _FailedDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FailedDay value)?  $default,){
final _that = this;
switch (_that) {
case _FailedDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FailedDay() when $default != null:
return $default(_that.date,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _FailedDay():
return $default(_that.date,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _FailedDay() when $default != null:
return $default(_that.date,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FailedDay implements FailedDay {
  const _FailedDay({required this.date, required this.errorMessage});
  factory _FailedDay.fromJson(Map<String, dynamic> json) => _$FailedDayFromJson(json);

/// The date that failed to log.
@override final  DateTime date;
/// The error message describing why it failed.
@override final  String errorMessage;

/// Create a copy of FailedDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailedDayCopyWith<_FailedDay> get copyWith => __$FailedDayCopyWithImpl<_FailedDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FailedDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FailedDay&&(identical(other.date, date) || other.date == date)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,errorMessage);

@override
String toString() {
  return 'FailedDay(date: $date, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$FailedDayCopyWith<$Res> implements $FailedDayCopyWith<$Res> {
  factory _$FailedDayCopyWith(_FailedDay value, $Res Function(_FailedDay) _then) = __$FailedDayCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, String errorMessage
});




}
/// @nodoc
class __$FailedDayCopyWithImpl<$Res>
    implements _$FailedDayCopyWith<$Res> {
  __$FailedDayCopyWithImpl(this._self, this._then);

  final _FailedDay _self;
  final $Res Function(_FailedDay) _then;

/// Create a copy of FailedDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? errorMessage = null,}) {
  return _then(_FailedDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
