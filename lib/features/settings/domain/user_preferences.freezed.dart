// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserPreferences {

/// The user's preferred theme mode.
@ThemeModeConverter() ThemeMode get themeMode;/// Whether health sync is enabled.
 bool get healthSyncEnabled;/// The user's preferred unit system.
@UnitSystemConverter() UnitSystem get unitSystem;
/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<UserPreferences> get copyWith => _$UserPreferencesCopyWithImpl<UserPreferences>(this as UserPreferences, _$identity);

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPreferences&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.healthSyncEnabled, healthSyncEnabled) || other.healthSyncEnabled == healthSyncEnabled)&&(identical(other.unitSystem, unitSystem) || other.unitSystem == unitSystem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,healthSyncEnabled,unitSystem);

@override
String toString() {
  return 'UserPreferences(themeMode: $themeMode, healthSyncEnabled: $healthSyncEnabled, unitSystem: $unitSystem)';
}


}

/// @nodoc
abstract mixin class $UserPreferencesCopyWith<$Res>  {
  factory $UserPreferencesCopyWith(UserPreferences value, $Res Function(UserPreferences) _then) = _$UserPreferencesCopyWithImpl;
@useResult
$Res call({
@ThemeModeConverter() ThemeMode themeMode, bool healthSyncEnabled,@UnitSystemConverter() UnitSystem unitSystem
});




}
/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._self, this._then);

  final UserPreferences _self;
  final $Res Function(UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? healthSyncEnabled = null,Object? unitSystem = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,healthSyncEnabled: null == healthSyncEnabled ? _self.healthSyncEnabled : healthSyncEnabled // ignore: cast_nullable_to_non_nullable
as bool,unitSystem: null == unitSystem ? _self.unitSystem : unitSystem // ignore: cast_nullable_to_non_nullable
as UnitSystem,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPreferences].
extension UserPreferencesPatterns on UserPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPreferences value)  $default,){
final _that = this;
switch (_that) {
case _UserPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ThemeModeConverter()  ThemeMode themeMode,  bool healthSyncEnabled, @UnitSystemConverter()  UnitSystem unitSystem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.themeMode,_that.healthSyncEnabled,_that.unitSystem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ThemeModeConverter()  ThemeMode themeMode,  bool healthSyncEnabled, @UnitSystemConverter()  UnitSystem unitSystem)  $default,) {final _that = this;
switch (_that) {
case _UserPreferences():
return $default(_that.themeMode,_that.healthSyncEnabled,_that.unitSystem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ThemeModeConverter()  ThemeMode themeMode,  bool healthSyncEnabled, @UnitSystemConverter()  UnitSystem unitSystem)?  $default,) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.themeMode,_that.healthSyncEnabled,_that.unitSystem);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserPreferences implements UserPreferences {
  const _UserPreferences({@ThemeModeConverter() this.themeMode = ThemeMode.system, this.healthSyncEnabled = false, @UnitSystemConverter() this.unitSystem = UnitSystem.metric});
  factory _UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);

/// The user's preferred theme mode.
@override@JsonKey()@ThemeModeConverter() final  ThemeMode themeMode;
/// Whether health sync is enabled.
@override@JsonKey() final  bool healthSyncEnabled;
/// The user's preferred unit system.
@override@JsonKey()@UnitSystemConverter() final  UnitSystem unitSystem;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPreferencesCopyWith<_UserPreferences> get copyWith => __$UserPreferencesCopyWithImpl<_UserPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPreferences&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.healthSyncEnabled, healthSyncEnabled) || other.healthSyncEnabled == healthSyncEnabled)&&(identical(other.unitSystem, unitSystem) || other.unitSystem == unitSystem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,healthSyncEnabled,unitSystem);

@override
String toString() {
  return 'UserPreferences(themeMode: $themeMode, healthSyncEnabled: $healthSyncEnabled, unitSystem: $unitSystem)';
}


}

/// @nodoc
abstract mixin class _$UserPreferencesCopyWith<$Res> implements $UserPreferencesCopyWith<$Res> {
  factory _$UserPreferencesCopyWith(_UserPreferences value, $Res Function(_UserPreferences) _then) = __$UserPreferencesCopyWithImpl;
@override @useResult
$Res call({
@ThemeModeConverter() ThemeMode themeMode, bool healthSyncEnabled,@UnitSystemConverter() UnitSystem unitSystem
});




}
/// @nodoc
class __$UserPreferencesCopyWithImpl<$Res>
    implements _$UserPreferencesCopyWith<$Res> {
  __$UserPreferencesCopyWithImpl(this._self, this._then);

  final _UserPreferences _self;
  final $Res Function(_UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? healthSyncEnabled = null,Object? unitSystem = null,}) {
  return _then(_UserPreferences(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,healthSyncEnabled: null == healthSyncEnabled ? _self.healthSyncEnabled : healthSyncEnabled // ignore: cast_nullable_to_non_nullable
as bool,unitSystem: null == unitSystem ? _self.unitSystem : unitSystem // ignore: cast_nullable_to_non_nullable
as UnitSystem,
  ));
}


}

// dart format on
