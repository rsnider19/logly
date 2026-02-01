// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_answers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingAnswers {

 String? get gender; DateTime? get dateOfBirth; String? get unitSystem; List<String> get motivations; List<String> get progressPreferences; List<String> get userDescriptors;
/// Create a copy of OnboardingAnswers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingAnswersCopyWith<OnboardingAnswers> get copyWith => _$OnboardingAnswersCopyWithImpl<OnboardingAnswers>(this as OnboardingAnswers, _$identity);

  /// Serializes this OnboardingAnswers to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingAnswers&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.unitSystem, unitSystem) || other.unitSystem == unitSystem)&&const DeepCollectionEquality().equals(other.motivations, motivations)&&const DeepCollectionEquality().equals(other.progressPreferences, progressPreferences)&&const DeepCollectionEquality().equals(other.userDescriptors, userDescriptors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gender,dateOfBirth,unitSystem,const DeepCollectionEquality().hash(motivations),const DeepCollectionEquality().hash(progressPreferences),const DeepCollectionEquality().hash(userDescriptors));

@override
String toString() {
  return 'OnboardingAnswers(gender: $gender, dateOfBirth: $dateOfBirth, unitSystem: $unitSystem, motivations: $motivations, progressPreferences: $progressPreferences, userDescriptors: $userDescriptors)';
}


}

/// @nodoc
abstract mixin class $OnboardingAnswersCopyWith<$Res>  {
  factory $OnboardingAnswersCopyWith(OnboardingAnswers value, $Res Function(OnboardingAnswers) _then) = _$OnboardingAnswersCopyWithImpl;
@useResult
$Res call({
 String? gender, DateTime? dateOfBirth, String? unitSystem, List<String> motivations, List<String> progressPreferences, List<String> userDescriptors
});




}
/// @nodoc
class _$OnboardingAnswersCopyWithImpl<$Res>
    implements $OnboardingAnswersCopyWith<$Res> {
  _$OnboardingAnswersCopyWithImpl(this._self, this._then);

  final OnboardingAnswers _self;
  final $Res Function(OnboardingAnswers) _then;

/// Create a copy of OnboardingAnswers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gender = freezed,Object? dateOfBirth = freezed,Object? unitSystem = freezed,Object? motivations = null,Object? progressPreferences = null,Object? userDescriptors = null,}) {
  return _then(_self.copyWith(
gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,unitSystem: freezed == unitSystem ? _self.unitSystem : unitSystem // ignore: cast_nullable_to_non_nullable
as String?,motivations: null == motivations ? _self.motivations : motivations // ignore: cast_nullable_to_non_nullable
as List<String>,progressPreferences: null == progressPreferences ? _self.progressPreferences : progressPreferences // ignore: cast_nullable_to_non_nullable
as List<String>,userDescriptors: null == userDescriptors ? _self.userDescriptors : userDescriptors // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingAnswers].
extension OnboardingAnswersPatterns on OnboardingAnswers {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingAnswers value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingAnswers() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingAnswers value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingAnswers():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingAnswers value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingAnswers() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? gender,  DateTime? dateOfBirth,  String? unitSystem,  List<String> motivations,  List<String> progressPreferences,  List<String> userDescriptors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingAnswers() when $default != null:
return $default(_that.gender,_that.dateOfBirth,_that.unitSystem,_that.motivations,_that.progressPreferences,_that.userDescriptors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? gender,  DateTime? dateOfBirth,  String? unitSystem,  List<String> motivations,  List<String> progressPreferences,  List<String> userDescriptors)  $default,) {final _that = this;
switch (_that) {
case _OnboardingAnswers():
return $default(_that.gender,_that.dateOfBirth,_that.unitSystem,_that.motivations,_that.progressPreferences,_that.userDescriptors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? gender,  DateTime? dateOfBirth,  String? unitSystem,  List<String> motivations,  List<String> progressPreferences,  List<String> userDescriptors)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingAnswers() when $default != null:
return $default(_that.gender,_that.dateOfBirth,_that.unitSystem,_that.motivations,_that.progressPreferences,_that.userDescriptors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingAnswers implements OnboardingAnswers {
  const _OnboardingAnswers({this.gender, this.dateOfBirth, this.unitSystem, final  List<String> motivations = const [], final  List<String> progressPreferences = const [], final  List<String> userDescriptors = const []}): _motivations = motivations,_progressPreferences = progressPreferences,_userDescriptors = userDescriptors;
  factory _OnboardingAnswers.fromJson(Map<String, dynamic> json) => _$OnboardingAnswersFromJson(json);

@override final  String? gender;
@override final  DateTime? dateOfBirth;
@override final  String? unitSystem;
 final  List<String> _motivations;
@override@JsonKey() List<String> get motivations {
  if (_motivations is EqualUnmodifiableListView) return _motivations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_motivations);
}

 final  List<String> _progressPreferences;
@override@JsonKey() List<String> get progressPreferences {
  if (_progressPreferences is EqualUnmodifiableListView) return _progressPreferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_progressPreferences);
}

 final  List<String> _userDescriptors;
@override@JsonKey() List<String> get userDescriptors {
  if (_userDescriptors is EqualUnmodifiableListView) return _userDescriptors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userDescriptors);
}


/// Create a copy of OnboardingAnswers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingAnswersCopyWith<_OnboardingAnswers> get copyWith => __$OnboardingAnswersCopyWithImpl<_OnboardingAnswers>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingAnswersToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingAnswers&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.unitSystem, unitSystem) || other.unitSystem == unitSystem)&&const DeepCollectionEquality().equals(other._motivations, _motivations)&&const DeepCollectionEquality().equals(other._progressPreferences, _progressPreferences)&&const DeepCollectionEquality().equals(other._userDescriptors, _userDescriptors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gender,dateOfBirth,unitSystem,const DeepCollectionEquality().hash(_motivations),const DeepCollectionEquality().hash(_progressPreferences),const DeepCollectionEquality().hash(_userDescriptors));

@override
String toString() {
  return 'OnboardingAnswers(gender: $gender, dateOfBirth: $dateOfBirth, unitSystem: $unitSystem, motivations: $motivations, progressPreferences: $progressPreferences, userDescriptors: $userDescriptors)';
}


}

/// @nodoc
abstract mixin class _$OnboardingAnswersCopyWith<$Res> implements $OnboardingAnswersCopyWith<$Res> {
  factory _$OnboardingAnswersCopyWith(_OnboardingAnswers value, $Res Function(_OnboardingAnswers) _then) = __$OnboardingAnswersCopyWithImpl;
@override @useResult
$Res call({
 String? gender, DateTime? dateOfBirth, String? unitSystem, List<String> motivations, List<String> progressPreferences, List<String> userDescriptors
});




}
/// @nodoc
class __$OnboardingAnswersCopyWithImpl<$Res>
    implements _$OnboardingAnswersCopyWith<$Res> {
  __$OnboardingAnswersCopyWithImpl(this._self, this._then);

  final _OnboardingAnswers _self;
  final $Res Function(_OnboardingAnswers) _then;

/// Create a copy of OnboardingAnswers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gender = freezed,Object? dateOfBirth = freezed,Object? unitSystem = freezed,Object? motivations = null,Object? progressPreferences = null,Object? userDescriptors = null,}) {
  return _then(_OnboardingAnswers(
gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,unitSystem: freezed == unitSystem ? _self.unitSystem : unitSystem // ignore: cast_nullable_to_non_nullable
as String?,motivations: null == motivations ? _self._motivations : motivations // ignore: cast_nullable_to_non_nullable
as List<String>,progressPreferences: null == progressPreferences ? _self._progressPreferences : progressPreferences // ignore: cast_nullable_to_non_nullable
as List<String>,userDescriptors: null == userDescriptors ? _self._userDescriptors : userDescriptors // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
