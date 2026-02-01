// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileData {

 String get userId; DateTime get createdAt; bool get onboardingCompleted; DateTime? get lastHealthSyncDate; String? get gender; DateTime? get dateOfBirth;@_JsonbStringListConverter() List<String>? get motivations;@_JsonbStringListConverter() List<String>? get progressPreferences;@_JsonbStringListConverter() List<String>? get userDescriptors;
/// Create a copy of ProfileData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDataCopyWith<ProfileData> get copyWith => _$ProfileDataCopyWithImpl<ProfileData>(this as ProfileData, _$identity);

  /// Serializes this ProfileData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileData&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.lastHealthSyncDate, lastHealthSyncDate) || other.lastHealthSyncDate == lastHealthSyncDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&const DeepCollectionEquality().equals(other.motivations, motivations)&&const DeepCollectionEquality().equals(other.progressPreferences, progressPreferences)&&const DeepCollectionEquality().equals(other.userDescriptors, userDescriptors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,createdAt,onboardingCompleted,lastHealthSyncDate,gender,dateOfBirth,const DeepCollectionEquality().hash(motivations),const DeepCollectionEquality().hash(progressPreferences),const DeepCollectionEquality().hash(userDescriptors));

@override
String toString() {
  return 'ProfileData(userId: $userId, createdAt: $createdAt, onboardingCompleted: $onboardingCompleted, lastHealthSyncDate: $lastHealthSyncDate, gender: $gender, dateOfBirth: $dateOfBirth, motivations: $motivations, progressPreferences: $progressPreferences, userDescriptors: $userDescriptors)';
}


}

/// @nodoc
abstract mixin class $ProfileDataCopyWith<$Res>  {
  factory $ProfileDataCopyWith(ProfileData value, $Res Function(ProfileData) _then) = _$ProfileDataCopyWithImpl;
@useResult
$Res call({
 String userId, DateTime createdAt, bool onboardingCompleted, DateTime? lastHealthSyncDate, String? gender, DateTime? dateOfBirth,@_JsonbStringListConverter() List<String>? motivations,@_JsonbStringListConverter() List<String>? progressPreferences,@_JsonbStringListConverter() List<String>? userDescriptors
});




}
/// @nodoc
class _$ProfileDataCopyWithImpl<$Res>
    implements $ProfileDataCopyWith<$Res> {
  _$ProfileDataCopyWithImpl(this._self, this._then);

  final ProfileData _self;
  final $Res Function(ProfileData) _then;

/// Create a copy of ProfileData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? createdAt = null,Object? onboardingCompleted = null,Object? lastHealthSyncDate = freezed,Object? gender = freezed,Object? dateOfBirth = freezed,Object? motivations = freezed,Object? progressPreferences = freezed,Object? userDescriptors = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,lastHealthSyncDate: freezed == lastHealthSyncDate ? _self.lastHealthSyncDate : lastHealthSyncDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,motivations: freezed == motivations ? _self.motivations : motivations // ignore: cast_nullable_to_non_nullable
as List<String>?,progressPreferences: freezed == progressPreferences ? _self.progressPreferences : progressPreferences // ignore: cast_nullable_to_non_nullable
as List<String>?,userDescriptors: freezed == userDescriptors ? _self.userDescriptors : userDescriptors // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileData].
extension ProfileDataPatterns on ProfileData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileData value)  $default,){
final _that = this;
switch (_that) {
case _ProfileData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileData value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  DateTime createdAt,  bool onboardingCompleted,  DateTime? lastHealthSyncDate,  String? gender,  DateTime? dateOfBirth, @_JsonbStringListConverter()  List<String>? motivations, @_JsonbStringListConverter()  List<String>? progressPreferences, @_JsonbStringListConverter()  List<String>? userDescriptors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileData() when $default != null:
return $default(_that.userId,_that.createdAt,_that.onboardingCompleted,_that.lastHealthSyncDate,_that.gender,_that.dateOfBirth,_that.motivations,_that.progressPreferences,_that.userDescriptors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  DateTime createdAt,  bool onboardingCompleted,  DateTime? lastHealthSyncDate,  String? gender,  DateTime? dateOfBirth, @_JsonbStringListConverter()  List<String>? motivations, @_JsonbStringListConverter()  List<String>? progressPreferences, @_JsonbStringListConverter()  List<String>? userDescriptors)  $default,) {final _that = this;
switch (_that) {
case _ProfileData():
return $default(_that.userId,_that.createdAt,_that.onboardingCompleted,_that.lastHealthSyncDate,_that.gender,_that.dateOfBirth,_that.motivations,_that.progressPreferences,_that.userDescriptors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  DateTime createdAt,  bool onboardingCompleted,  DateTime? lastHealthSyncDate,  String? gender,  DateTime? dateOfBirth, @_JsonbStringListConverter()  List<String>? motivations, @_JsonbStringListConverter()  List<String>? progressPreferences, @_JsonbStringListConverter()  List<String>? userDescriptors)?  $default,) {final _that = this;
switch (_that) {
case _ProfileData() when $default != null:
return $default(_that.userId,_that.createdAt,_that.onboardingCompleted,_that.lastHealthSyncDate,_that.gender,_that.dateOfBirth,_that.motivations,_that.progressPreferences,_that.userDescriptors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileData implements ProfileData {
  const _ProfileData({required this.userId, required this.createdAt, required this.onboardingCompleted, this.lastHealthSyncDate, this.gender, this.dateOfBirth, @_JsonbStringListConverter() final  List<String>? motivations, @_JsonbStringListConverter() final  List<String>? progressPreferences, @_JsonbStringListConverter() final  List<String>? userDescriptors}): _motivations = motivations,_progressPreferences = progressPreferences,_userDescriptors = userDescriptors;
  factory _ProfileData.fromJson(Map<String, dynamic> json) => _$ProfileDataFromJson(json);

@override final  String userId;
@override final  DateTime createdAt;
@override final  bool onboardingCompleted;
@override final  DateTime? lastHealthSyncDate;
@override final  String? gender;
@override final  DateTime? dateOfBirth;
 final  List<String>? _motivations;
@override@_JsonbStringListConverter() List<String>? get motivations {
  final value = _motivations;
  if (value == null) return null;
  if (_motivations is EqualUnmodifiableListView) return _motivations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _progressPreferences;
@override@_JsonbStringListConverter() List<String>? get progressPreferences {
  final value = _progressPreferences;
  if (value == null) return null;
  if (_progressPreferences is EqualUnmodifiableListView) return _progressPreferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _userDescriptors;
@override@_JsonbStringListConverter() List<String>? get userDescriptors {
  final value = _userDescriptors;
  if (value == null) return null;
  if (_userDescriptors is EqualUnmodifiableListView) return _userDescriptors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ProfileData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileDataCopyWith<_ProfileData> get copyWith => __$ProfileDataCopyWithImpl<_ProfileData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileData&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.lastHealthSyncDate, lastHealthSyncDate) || other.lastHealthSyncDate == lastHealthSyncDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&const DeepCollectionEquality().equals(other._motivations, _motivations)&&const DeepCollectionEquality().equals(other._progressPreferences, _progressPreferences)&&const DeepCollectionEquality().equals(other._userDescriptors, _userDescriptors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,createdAt,onboardingCompleted,lastHealthSyncDate,gender,dateOfBirth,const DeepCollectionEquality().hash(_motivations),const DeepCollectionEquality().hash(_progressPreferences),const DeepCollectionEquality().hash(_userDescriptors));

@override
String toString() {
  return 'ProfileData(userId: $userId, createdAt: $createdAt, onboardingCompleted: $onboardingCompleted, lastHealthSyncDate: $lastHealthSyncDate, gender: $gender, dateOfBirth: $dateOfBirth, motivations: $motivations, progressPreferences: $progressPreferences, userDescriptors: $userDescriptors)';
}


}

/// @nodoc
abstract mixin class _$ProfileDataCopyWith<$Res> implements $ProfileDataCopyWith<$Res> {
  factory _$ProfileDataCopyWith(_ProfileData value, $Res Function(_ProfileData) _then) = __$ProfileDataCopyWithImpl;
@override @useResult
$Res call({
 String userId, DateTime createdAt, bool onboardingCompleted, DateTime? lastHealthSyncDate, String? gender, DateTime? dateOfBirth,@_JsonbStringListConverter() List<String>? motivations,@_JsonbStringListConverter() List<String>? progressPreferences,@_JsonbStringListConverter() List<String>? userDescriptors
});




}
/// @nodoc
class __$ProfileDataCopyWithImpl<$Res>
    implements _$ProfileDataCopyWith<$Res> {
  __$ProfileDataCopyWithImpl(this._self, this._then);

  final _ProfileData _self;
  final $Res Function(_ProfileData) _then;

/// Create a copy of ProfileData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? createdAt = null,Object? onboardingCompleted = null,Object? lastHealthSyncDate = freezed,Object? gender = freezed,Object? dateOfBirth = freezed,Object? motivations = freezed,Object? progressPreferences = freezed,Object? userDescriptors = freezed,}) {
  return _then(_ProfileData(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,lastHealthSyncDate: freezed == lastHealthSyncDate ? _self.lastHealthSyncDate : lastHealthSyncDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,motivations: freezed == motivations ? _self._motivations : motivations // ignore: cast_nullable_to_non_nullable
as List<String>?,progressPreferences: freezed == progressPreferences ? _self._progressPreferences : progressPreferences // ignore: cast_nullable_to_non_nullable
as List<String>?,userDescriptors: freezed == userDescriptors ? _self._userDescriptors : userDescriptors // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
