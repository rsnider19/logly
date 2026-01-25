// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entitlement_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EntitlementState {

 bool get isLoading; Set<String> get activeEntitlements; String? get error;
/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntitlementStateCopyWith<EntitlementState> get copyWith => _$EntitlementStateCopyWithImpl<EntitlementState>(this as EntitlementState, _$identity);

  /// Serializes this EntitlementState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntitlementState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.activeEntitlements, activeEntitlements)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(activeEntitlements),error);

@override
String toString() {
  return 'EntitlementState(isLoading: $isLoading, activeEntitlements: $activeEntitlements, error: $error)';
}


}

/// @nodoc
abstract mixin class $EntitlementStateCopyWith<$Res>  {
  factory $EntitlementStateCopyWith(EntitlementState value, $Res Function(EntitlementState) _then) = _$EntitlementStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, Set<String> activeEntitlements, String? error
});




}
/// @nodoc
class _$EntitlementStateCopyWithImpl<$Res>
    implements $EntitlementStateCopyWith<$Res> {
  _$EntitlementStateCopyWithImpl(this._self, this._then);

  final EntitlementState _self;
  final $Res Function(EntitlementState) _then;

/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? activeEntitlements = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,activeEntitlements: null == activeEntitlements ? _self.activeEntitlements : activeEntitlements // ignore: cast_nullable_to_non_nullable
as Set<String>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EntitlementState].
extension EntitlementStatePatterns on EntitlementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntitlementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntitlementState value)  $default,){
final _that = this;
switch (_that) {
case _EntitlementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntitlementState value)?  $default,){
final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  Set<String> activeEntitlements,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
return $default(_that.isLoading,_that.activeEntitlements,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  Set<String> activeEntitlements,  String? error)  $default,) {final _that = this;
switch (_that) {
case _EntitlementState():
return $default(_that.isLoading,_that.activeEntitlements,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  Set<String> activeEntitlements,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
return $default(_that.isLoading,_that.activeEntitlements,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntitlementState extends EntitlementState {
  const _EntitlementState({this.isLoading = true, final  Set<String> activeEntitlements = const {}, this.error}): _activeEntitlements = activeEntitlements,super._();
  factory _EntitlementState.fromJson(Map<String, dynamic> json) => _$EntitlementStateFromJson(json);

@override@JsonKey() final  bool isLoading;
 final  Set<String> _activeEntitlements;
@override@JsonKey() Set<String> get activeEntitlements {
  if (_activeEntitlements is EqualUnmodifiableSetView) return _activeEntitlements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_activeEntitlements);
}

@override final  String? error;

/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntitlementStateCopyWith<_EntitlementState> get copyWith => __$EntitlementStateCopyWithImpl<_EntitlementState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntitlementStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntitlementState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._activeEntitlements, _activeEntitlements)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_activeEntitlements),error);

@override
String toString() {
  return 'EntitlementState(isLoading: $isLoading, activeEntitlements: $activeEntitlements, error: $error)';
}


}

/// @nodoc
abstract mixin class _$EntitlementStateCopyWith<$Res> implements $EntitlementStateCopyWith<$Res> {
  factory _$EntitlementStateCopyWith(_EntitlementState value, $Res Function(_EntitlementState) _then) = __$EntitlementStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, Set<String> activeEntitlements, String? error
});




}
/// @nodoc
class __$EntitlementStateCopyWithImpl<$Res>
    implements _$EntitlementStateCopyWith<$Res> {
  __$EntitlementStateCopyWithImpl(this._self, this._then);

  final _EntitlementState _self;
  final $Res Function(_EntitlementState) _then;

/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? activeEntitlements = null,Object? error = freezed,}) {
  return _then(_EntitlementState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,activeEntitlements: null == activeEntitlements ? _self._activeEntitlements : activeEntitlements // ignore: cast_nullable_to_non_nullable
as Set<String>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
