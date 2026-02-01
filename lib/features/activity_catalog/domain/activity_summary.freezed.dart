// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivitySummary {

 String get activityId; String get activityCategoryId; String get name; String get activityCode; ActivityDateType get activityDateType; String? get description; bool get isSuggestedFavorite;/// The category this activity belongs to (populated via join).
 ActivityCategory? get activityCategory;
/// Create a copy of ActivitySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivitySummaryCopyWith<ActivitySummary> get copyWith => _$ActivitySummaryCopyWithImpl<ActivitySummary>(this as ActivitySummary, _$identity);

  /// Serializes this ActivitySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivitySummary&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.activityCode, activityCode) || other.activityCode == activityCode)&&(identical(other.activityDateType, activityDateType) || other.activityDateType == activityDateType)&&(identical(other.description, description) || other.description == description)&&(identical(other.isSuggestedFavorite, isSuggestedFavorite) || other.isSuggestedFavorite == isSuggestedFavorite)&&(identical(other.activityCategory, activityCategory) || other.activityCategory == activityCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,activityCategoryId,name,activityCode,activityDateType,description,isSuggestedFavorite,activityCategory);

@override
String toString() {
  return 'ActivitySummary(activityId: $activityId, activityCategoryId: $activityCategoryId, name: $name, activityCode: $activityCode, activityDateType: $activityDateType, description: $description, isSuggestedFavorite: $isSuggestedFavorite, activityCategory: $activityCategory)';
}


}

/// @nodoc
abstract mixin class $ActivitySummaryCopyWith<$Res>  {
  factory $ActivitySummaryCopyWith(ActivitySummary value, $Res Function(ActivitySummary) _then) = _$ActivitySummaryCopyWithImpl;
@useResult
$Res call({
 String activityId, String activityCategoryId, String name, String activityCode, ActivityDateType activityDateType, String? description, bool isSuggestedFavorite, ActivityCategory? activityCategory
});


$ActivityCategoryCopyWith<$Res>? get activityCategory;

}
/// @nodoc
class _$ActivitySummaryCopyWithImpl<$Res>
    implements $ActivitySummaryCopyWith<$Res> {
  _$ActivitySummaryCopyWithImpl(this._self, this._then);

  final ActivitySummary _self;
  final $Res Function(ActivitySummary) _then;

/// Create a copy of ActivitySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityId = null,Object? activityCategoryId = null,Object? name = null,Object? activityCode = null,Object? activityDateType = null,Object? description = freezed,Object? isSuggestedFavorite = null,Object? activityCategory = freezed,}) {
  return _then(_self.copyWith(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,activityCategoryId: null == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,activityCode: null == activityCode ? _self.activityCode : activityCode // ignore: cast_nullable_to_non_nullable
as String,activityDateType: null == activityDateType ? _self.activityDateType : activityDateType // ignore: cast_nullable_to_non_nullable
as ActivityDateType,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isSuggestedFavorite: null == isSuggestedFavorite ? _self.isSuggestedFavorite : isSuggestedFavorite // ignore: cast_nullable_to_non_nullable
as bool,activityCategory: freezed == activityCategory ? _self.activityCategory : activityCategory // ignore: cast_nullable_to_non_nullable
as ActivityCategory?,
  ));
}
/// Create a copy of ActivitySummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityCategoryCopyWith<$Res>? get activityCategory {
    if (_self.activityCategory == null) {
    return null;
  }

  return $ActivityCategoryCopyWith<$Res>(_self.activityCategory!, (value) {
    return _then(_self.copyWith(activityCategory: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivitySummary].
extension ActivitySummaryPatterns on ActivitySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivitySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivitySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivitySummary value)  $default,){
final _that = this;
switch (_that) {
case _ActivitySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivitySummary value)?  $default,){
final _that = this;
switch (_that) {
case _ActivitySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String activityId,  String activityCategoryId,  String name,  String activityCode,  ActivityDateType activityDateType,  String? description,  bool isSuggestedFavorite,  ActivityCategory? activityCategory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivitySummary() when $default != null:
return $default(_that.activityId,_that.activityCategoryId,_that.name,_that.activityCode,_that.activityDateType,_that.description,_that.isSuggestedFavorite,_that.activityCategory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String activityId,  String activityCategoryId,  String name,  String activityCode,  ActivityDateType activityDateType,  String? description,  bool isSuggestedFavorite,  ActivityCategory? activityCategory)  $default,) {final _that = this;
switch (_that) {
case _ActivitySummary():
return $default(_that.activityId,_that.activityCategoryId,_that.name,_that.activityCode,_that.activityDateType,_that.description,_that.isSuggestedFavorite,_that.activityCategory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String activityId,  String activityCategoryId,  String name,  String activityCode,  ActivityDateType activityDateType,  String? description,  bool isSuggestedFavorite,  ActivityCategory? activityCategory)?  $default,) {final _that = this;
switch (_that) {
case _ActivitySummary() when $default != null:
return $default(_that.activityId,_that.activityCategoryId,_that.name,_that.activityCode,_that.activityDateType,_that.description,_that.isSuggestedFavorite,_that.activityCategory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivitySummary extends ActivitySummary {
  const _ActivitySummary({required this.activityId, required this.activityCategoryId, required this.name, required this.activityCode, required this.activityDateType, this.description, this.isSuggestedFavorite = false, this.activityCategory}): super._();
  factory _ActivitySummary.fromJson(Map<String, dynamic> json) => _$ActivitySummaryFromJson(json);

@override final  String activityId;
@override final  String activityCategoryId;
@override final  String name;
@override final  String activityCode;
@override final  ActivityDateType activityDateType;
@override final  String? description;
@override@JsonKey() final  bool isSuggestedFavorite;
/// The category this activity belongs to (populated via join).
@override final  ActivityCategory? activityCategory;

/// Create a copy of ActivitySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivitySummaryCopyWith<_ActivitySummary> get copyWith => __$ActivitySummaryCopyWithImpl<_ActivitySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivitySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivitySummary&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.activityCode, activityCode) || other.activityCode == activityCode)&&(identical(other.activityDateType, activityDateType) || other.activityDateType == activityDateType)&&(identical(other.description, description) || other.description == description)&&(identical(other.isSuggestedFavorite, isSuggestedFavorite) || other.isSuggestedFavorite == isSuggestedFavorite)&&(identical(other.activityCategory, activityCategory) || other.activityCategory == activityCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,activityCategoryId,name,activityCode,activityDateType,description,isSuggestedFavorite,activityCategory);

@override
String toString() {
  return 'ActivitySummary(activityId: $activityId, activityCategoryId: $activityCategoryId, name: $name, activityCode: $activityCode, activityDateType: $activityDateType, description: $description, isSuggestedFavorite: $isSuggestedFavorite, activityCategory: $activityCategory)';
}


}

/// @nodoc
abstract mixin class _$ActivitySummaryCopyWith<$Res> implements $ActivitySummaryCopyWith<$Res> {
  factory _$ActivitySummaryCopyWith(_ActivitySummary value, $Res Function(_ActivitySummary) _then) = __$ActivitySummaryCopyWithImpl;
@override @useResult
$Res call({
 String activityId, String activityCategoryId, String name, String activityCode, ActivityDateType activityDateType, String? description, bool isSuggestedFavorite, ActivityCategory? activityCategory
});


@override $ActivityCategoryCopyWith<$Res>? get activityCategory;

}
/// @nodoc
class __$ActivitySummaryCopyWithImpl<$Res>
    implements _$ActivitySummaryCopyWith<$Res> {
  __$ActivitySummaryCopyWithImpl(this._self, this._then);

  final _ActivitySummary _self;
  final $Res Function(_ActivitySummary) _then;

/// Create a copy of ActivitySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityId = null,Object? activityCategoryId = null,Object? name = null,Object? activityCode = null,Object? activityDateType = null,Object? description = freezed,Object? isSuggestedFavorite = null,Object? activityCategory = freezed,}) {
  return _then(_ActivitySummary(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,activityCategoryId: null == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,activityCode: null == activityCode ? _self.activityCode : activityCode // ignore: cast_nullable_to_non_nullable
as String,activityDateType: null == activityDateType ? _self.activityDateType : activityDateType // ignore: cast_nullable_to_non_nullable
as ActivityDateType,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isSuggestedFavorite: null == isSuggestedFavorite ? _self.isSuggestedFavorite : isSuggestedFavorite // ignore: cast_nullable_to_non_nullable
as bool,activityCategory: freezed == activityCategory ? _self.activityCategory : activityCategory // ignore: cast_nullable_to_non_nullable
as ActivityCategory?,
  ));
}

/// Create a copy of ActivitySummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityCategoryCopyWith<$Res>? get activityCategory {
    if (_self.activityCategory == null) {
    return null;
  }

  return $ActivityCategoryCopyWith<$Res>(_self.activityCategory!, (value) {
    return _then(_self.copyWith(activityCategory: value));
  });
}
}

// dart format on
