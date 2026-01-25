// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_sync_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthSyncState {

/// Whether a sync is currently in progress.
 bool get isSyncing;/// Result of the last sync operation, if any.
 SyncResult? get lastSyncResult;/// The last successful sync date.
 DateTime? get lastSyncDate;/// Error message from the last failed sync, if any.
 String? get errorMessage;/// Current month being synced (1-indexed).
 int get currentMonth;/// Total number of months to sync.
 int get totalMonths;
/// Create a copy of HealthSyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthSyncStateCopyWith<HealthSyncState> get copyWith => _$HealthSyncStateCopyWithImpl<HealthSyncState>(this as HealthSyncState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthSyncState&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.lastSyncResult, lastSyncResult) || other.lastSyncResult == lastSyncResult)&&(identical(other.lastSyncDate, lastSyncDate) || other.lastSyncDate == lastSyncDate)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.currentMonth, currentMonth) || other.currentMonth == currentMonth)&&(identical(other.totalMonths, totalMonths) || other.totalMonths == totalMonths));
}


@override
int get hashCode => Object.hash(runtimeType,isSyncing,lastSyncResult,lastSyncDate,errorMessage,currentMonth,totalMonths);

@override
String toString() {
  return 'HealthSyncState(isSyncing: $isSyncing, lastSyncResult: $lastSyncResult, lastSyncDate: $lastSyncDate, errorMessage: $errorMessage, currentMonth: $currentMonth, totalMonths: $totalMonths)';
}


}

/// @nodoc
abstract mixin class $HealthSyncStateCopyWith<$Res>  {
  factory $HealthSyncStateCopyWith(HealthSyncState value, $Res Function(HealthSyncState) _then) = _$HealthSyncStateCopyWithImpl;
@useResult
$Res call({
 bool isSyncing, SyncResult? lastSyncResult, DateTime? lastSyncDate, String? errorMessage, int currentMonth, int totalMonths
});


$SyncResultCopyWith<$Res>? get lastSyncResult;

}
/// @nodoc
class _$HealthSyncStateCopyWithImpl<$Res>
    implements $HealthSyncStateCopyWith<$Res> {
  _$HealthSyncStateCopyWithImpl(this._self, this._then);

  final HealthSyncState _self;
  final $Res Function(HealthSyncState) _then;

/// Create a copy of HealthSyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSyncing = null,Object? lastSyncResult = freezed,Object? lastSyncDate = freezed,Object? errorMessage = freezed,Object? currentMonth = null,Object? totalMonths = null,}) {
  return _then(_self.copyWith(
isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,lastSyncResult: freezed == lastSyncResult ? _self.lastSyncResult : lastSyncResult // ignore: cast_nullable_to_non_nullable
as SyncResult?,lastSyncDate: freezed == lastSyncDate ? _self.lastSyncDate : lastSyncDate // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,currentMonth: null == currentMonth ? _self.currentMonth : currentMonth // ignore: cast_nullable_to_non_nullable
as int,totalMonths: null == totalMonths ? _self.totalMonths : totalMonths // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of HealthSyncState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncResultCopyWith<$Res>? get lastSyncResult {
    if (_self.lastSyncResult == null) {
    return null;
  }

  return $SyncResultCopyWith<$Res>(_self.lastSyncResult!, (value) {
    return _then(_self.copyWith(lastSyncResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [HealthSyncState].
extension HealthSyncStatePatterns on HealthSyncState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthSyncState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthSyncState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthSyncState value)  $default,){
final _that = this;
switch (_that) {
case _HealthSyncState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthSyncState value)?  $default,){
final _that = this;
switch (_that) {
case _HealthSyncState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSyncing,  SyncResult? lastSyncResult,  DateTime? lastSyncDate,  String? errorMessage,  int currentMonth,  int totalMonths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthSyncState() when $default != null:
return $default(_that.isSyncing,_that.lastSyncResult,_that.lastSyncDate,_that.errorMessage,_that.currentMonth,_that.totalMonths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSyncing,  SyncResult? lastSyncResult,  DateTime? lastSyncDate,  String? errorMessage,  int currentMonth,  int totalMonths)  $default,) {final _that = this;
switch (_that) {
case _HealthSyncState():
return $default(_that.isSyncing,_that.lastSyncResult,_that.lastSyncDate,_that.errorMessage,_that.currentMonth,_that.totalMonths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSyncing,  SyncResult? lastSyncResult,  DateTime? lastSyncDate,  String? errorMessage,  int currentMonth,  int totalMonths)?  $default,) {final _that = this;
switch (_that) {
case _HealthSyncState() when $default != null:
return $default(_that.isSyncing,_that.lastSyncResult,_that.lastSyncDate,_that.errorMessage,_that.currentMonth,_that.totalMonths);case _:
  return null;

}
}

}

/// @nodoc


class _HealthSyncState extends HealthSyncState {
  const _HealthSyncState({this.isSyncing = false, this.lastSyncResult, this.lastSyncDate, this.errorMessage, this.currentMonth = 0, this.totalMonths = 0}): super._();
  

/// Whether a sync is currently in progress.
@override@JsonKey() final  bool isSyncing;
/// Result of the last sync operation, if any.
@override final  SyncResult? lastSyncResult;
/// The last successful sync date.
@override final  DateTime? lastSyncDate;
/// Error message from the last failed sync, if any.
@override final  String? errorMessage;
/// Current month being synced (1-indexed).
@override@JsonKey() final  int currentMonth;
/// Total number of months to sync.
@override@JsonKey() final  int totalMonths;

/// Create a copy of HealthSyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthSyncStateCopyWith<_HealthSyncState> get copyWith => __$HealthSyncStateCopyWithImpl<_HealthSyncState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthSyncState&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.lastSyncResult, lastSyncResult) || other.lastSyncResult == lastSyncResult)&&(identical(other.lastSyncDate, lastSyncDate) || other.lastSyncDate == lastSyncDate)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.currentMonth, currentMonth) || other.currentMonth == currentMonth)&&(identical(other.totalMonths, totalMonths) || other.totalMonths == totalMonths));
}


@override
int get hashCode => Object.hash(runtimeType,isSyncing,lastSyncResult,lastSyncDate,errorMessage,currentMonth,totalMonths);

@override
String toString() {
  return 'HealthSyncState(isSyncing: $isSyncing, lastSyncResult: $lastSyncResult, lastSyncDate: $lastSyncDate, errorMessage: $errorMessage, currentMonth: $currentMonth, totalMonths: $totalMonths)';
}


}

/// @nodoc
abstract mixin class _$HealthSyncStateCopyWith<$Res> implements $HealthSyncStateCopyWith<$Res> {
  factory _$HealthSyncStateCopyWith(_HealthSyncState value, $Res Function(_HealthSyncState) _then) = __$HealthSyncStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSyncing, SyncResult? lastSyncResult, DateTime? lastSyncDate, String? errorMessage, int currentMonth, int totalMonths
});


@override $SyncResultCopyWith<$Res>? get lastSyncResult;

}
/// @nodoc
class __$HealthSyncStateCopyWithImpl<$Res>
    implements _$HealthSyncStateCopyWith<$Res> {
  __$HealthSyncStateCopyWithImpl(this._self, this._then);

  final _HealthSyncState _self;
  final $Res Function(_HealthSyncState) _then;

/// Create a copy of HealthSyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSyncing = null,Object? lastSyncResult = freezed,Object? lastSyncDate = freezed,Object? errorMessage = freezed,Object? currentMonth = null,Object? totalMonths = null,}) {
  return _then(_HealthSyncState(
isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,lastSyncResult: freezed == lastSyncResult ? _self.lastSyncResult : lastSyncResult // ignore: cast_nullable_to_non_nullable
as SyncResult?,lastSyncDate: freezed == lastSyncDate ? _self.lastSyncDate : lastSyncDate // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,currentMonth: null == currentMonth ? _self.currentMonth : currentMonth // ignore: cast_nullable_to_non_nullable
as int,totalMonths: null == totalMonths ? _self.totalMonths : totalMonths // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of HealthSyncState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncResultCopyWith<$Res>? get lastSyncResult {
    if (_self.lastSyncResult == null) {
    return null;
  }

  return $SyncResultCopyWith<$Res>(_self.lastSyncResult!, (value) {
    return _then(_self.copyWith(lastSyncResult: value));
  });
}
}

// dart format on
