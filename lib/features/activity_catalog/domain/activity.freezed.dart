// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Activity {

 String get activityId; String get activityCategoryId; String get name; String get activityCode; String? get description; String? get hexColor; String? get icon; ActivityDateType get activityDateType; PaceType? get paceType; bool get isSuggestedFavorite;/// The category this activity belongs to (populated via join).
 ActivityCategory? get activityCategory;/// Detail configurations for this activity (populated via join).
 List<ActivityDetail> get activityDetail;/// Subactivities for this activity (populated via join).
 List<SubActivity> get subActivity;
/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityCopyWith<Activity> get copyWith => _$ActivityCopyWithImpl<Activity>(this as Activity, _$identity);

  /// Serializes this Activity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Activity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.activityCode, activityCode) || other.activityCode == activityCode)&&(identical(other.description, description) || other.description == description)&&(identical(other.hexColor, hexColor) || other.hexColor == hexColor)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.activityDateType, activityDateType) || other.activityDateType == activityDateType)&&(identical(other.paceType, paceType) || other.paceType == paceType)&&(identical(other.isSuggestedFavorite, isSuggestedFavorite) || other.isSuggestedFavorite == isSuggestedFavorite)&&(identical(other.activityCategory, activityCategory) || other.activityCategory == activityCategory)&&const DeepCollectionEquality().equals(other.activityDetail, activityDetail)&&const DeepCollectionEquality().equals(other.subActivity, subActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,activityCategoryId,name,activityCode,description,hexColor,icon,activityDateType,paceType,isSuggestedFavorite,activityCategory,const DeepCollectionEquality().hash(activityDetail),const DeepCollectionEquality().hash(subActivity));

@override
String toString() {
  return 'Activity(activityId: $activityId, activityCategoryId: $activityCategoryId, name: $name, activityCode: $activityCode, description: $description, hexColor: $hexColor, icon: $icon, activityDateType: $activityDateType, paceType: $paceType, isSuggestedFavorite: $isSuggestedFavorite, activityCategory: $activityCategory, activityDetail: $activityDetail, subActivity: $subActivity)';
}


}

/// @nodoc
abstract mixin class $ActivityCopyWith<$Res>  {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) _then) = _$ActivityCopyWithImpl;
@useResult
$Res call({
 String activityId, String activityCategoryId, String name, String activityCode, String? description, String? hexColor, String? icon, ActivityDateType activityDateType, PaceType? paceType, bool isSuggestedFavorite, ActivityCategory? activityCategory, List<ActivityDetail> activityDetail, List<SubActivity> subActivity
});


$ActivityCategoryCopyWith<$Res>? get activityCategory;

}
/// @nodoc
class _$ActivityCopyWithImpl<$Res>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._self, this._then);

  final Activity _self;
  final $Res Function(Activity) _then;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityId = null,Object? activityCategoryId = null,Object? name = null,Object? activityCode = null,Object? description = freezed,Object? hexColor = freezed,Object? icon = freezed,Object? activityDateType = null,Object? paceType = freezed,Object? isSuggestedFavorite = null,Object? activityCategory = freezed,Object? activityDetail = null,Object? subActivity = null,}) {
  return _then(_self.copyWith(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,activityCategoryId: null == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,activityCode: null == activityCode ? _self.activityCode : activityCode // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,hexColor: freezed == hexColor ? _self.hexColor : hexColor // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,activityDateType: null == activityDateType ? _self.activityDateType : activityDateType // ignore: cast_nullable_to_non_nullable
as ActivityDateType,paceType: freezed == paceType ? _self.paceType : paceType // ignore: cast_nullable_to_non_nullable
as PaceType?,isSuggestedFavorite: null == isSuggestedFavorite ? _self.isSuggestedFavorite : isSuggestedFavorite // ignore: cast_nullable_to_non_nullable
as bool,activityCategory: freezed == activityCategory ? _self.activityCategory : activityCategory // ignore: cast_nullable_to_non_nullable
as ActivityCategory?,activityDetail: null == activityDetail ? _self.activityDetail : activityDetail // ignore: cast_nullable_to_non_nullable
as List<ActivityDetail>,subActivity: null == subActivity ? _self.subActivity : subActivity // ignore: cast_nullable_to_non_nullable
as List<SubActivity>,
  ));
}
/// Create a copy of Activity
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


/// Adds pattern-matching-related methods to [Activity].
extension ActivityPatterns on Activity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Activity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Activity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Activity value)  $default,){
final _that = this;
switch (_that) {
case _Activity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Activity value)?  $default,){
final _that = this;
switch (_that) {
case _Activity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String activityId,  String activityCategoryId,  String name,  String activityCode,  String? description,  String? hexColor,  String? icon,  ActivityDateType activityDateType,  PaceType? paceType,  bool isSuggestedFavorite,  ActivityCategory? activityCategory,  List<ActivityDetail> activityDetail,  List<SubActivity> subActivity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.activityId,_that.activityCategoryId,_that.name,_that.activityCode,_that.description,_that.hexColor,_that.icon,_that.activityDateType,_that.paceType,_that.isSuggestedFavorite,_that.activityCategory,_that.activityDetail,_that.subActivity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String activityId,  String activityCategoryId,  String name,  String activityCode,  String? description,  String? hexColor,  String? icon,  ActivityDateType activityDateType,  PaceType? paceType,  bool isSuggestedFavorite,  ActivityCategory? activityCategory,  List<ActivityDetail> activityDetail,  List<SubActivity> subActivity)  $default,) {final _that = this;
switch (_that) {
case _Activity():
return $default(_that.activityId,_that.activityCategoryId,_that.name,_that.activityCode,_that.description,_that.hexColor,_that.icon,_that.activityDateType,_that.paceType,_that.isSuggestedFavorite,_that.activityCategory,_that.activityDetail,_that.subActivity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String activityId,  String activityCategoryId,  String name,  String activityCode,  String? description,  String? hexColor,  String? icon,  ActivityDateType activityDateType,  PaceType? paceType,  bool isSuggestedFavorite,  ActivityCategory? activityCategory,  List<ActivityDetail> activityDetail,  List<SubActivity> subActivity)?  $default,) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.activityId,_that.activityCategoryId,_that.name,_that.activityCode,_that.description,_that.hexColor,_that.icon,_that.activityDateType,_that.paceType,_that.isSuggestedFavorite,_that.activityCategory,_that.activityDetail,_that.subActivity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Activity extends Activity {
  const _Activity({required this.activityId, required this.activityCategoryId, required this.name, required this.activityCode, this.description, this.hexColor, this.icon, required this.activityDateType, this.paceType, this.isSuggestedFavorite = false, this.activityCategory, final  List<ActivityDetail> activityDetail = const [], final  List<SubActivity> subActivity = const []}): _activityDetail = activityDetail,_subActivity = subActivity,super._();
  factory _Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

@override final  String activityId;
@override final  String activityCategoryId;
@override final  String name;
@override final  String activityCode;
@override final  String? description;
@override final  String? hexColor;
@override final  String? icon;
@override final  ActivityDateType activityDateType;
@override final  PaceType? paceType;
@override@JsonKey() final  bool isSuggestedFavorite;
/// The category this activity belongs to (populated via join).
@override final  ActivityCategory? activityCategory;
/// Detail configurations for this activity (populated via join).
 final  List<ActivityDetail> _activityDetail;
/// Detail configurations for this activity (populated via join).
@override@JsonKey() List<ActivityDetail> get activityDetail {
  if (_activityDetail is EqualUnmodifiableListView) return _activityDetail;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activityDetail);
}

/// Subactivities for this activity (populated via join).
 final  List<SubActivity> _subActivity;
/// Subactivities for this activity (populated via join).
@override@JsonKey() List<SubActivity> get subActivity {
  if (_subActivity is EqualUnmodifiableListView) return _subActivity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subActivity);
}


/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityCopyWith<_Activity> get copyWith => __$ActivityCopyWithImpl<_Activity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Activity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.activityCode, activityCode) || other.activityCode == activityCode)&&(identical(other.description, description) || other.description == description)&&(identical(other.hexColor, hexColor) || other.hexColor == hexColor)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.activityDateType, activityDateType) || other.activityDateType == activityDateType)&&(identical(other.paceType, paceType) || other.paceType == paceType)&&(identical(other.isSuggestedFavorite, isSuggestedFavorite) || other.isSuggestedFavorite == isSuggestedFavorite)&&(identical(other.activityCategory, activityCategory) || other.activityCategory == activityCategory)&&const DeepCollectionEquality().equals(other._activityDetail, _activityDetail)&&const DeepCollectionEquality().equals(other._subActivity, _subActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,activityCategoryId,name,activityCode,description,hexColor,icon,activityDateType,paceType,isSuggestedFavorite,activityCategory,const DeepCollectionEquality().hash(_activityDetail),const DeepCollectionEquality().hash(_subActivity));

@override
String toString() {
  return 'Activity(activityId: $activityId, activityCategoryId: $activityCategoryId, name: $name, activityCode: $activityCode, description: $description, hexColor: $hexColor, icon: $icon, activityDateType: $activityDateType, paceType: $paceType, isSuggestedFavorite: $isSuggestedFavorite, activityCategory: $activityCategory, activityDetail: $activityDetail, subActivity: $subActivity)';
}


}

/// @nodoc
abstract mixin class _$ActivityCopyWith<$Res> implements $ActivityCopyWith<$Res> {
  factory _$ActivityCopyWith(_Activity value, $Res Function(_Activity) _then) = __$ActivityCopyWithImpl;
@override @useResult
$Res call({
 String activityId, String activityCategoryId, String name, String activityCode, String? description, String? hexColor, String? icon, ActivityDateType activityDateType, PaceType? paceType, bool isSuggestedFavorite, ActivityCategory? activityCategory, List<ActivityDetail> activityDetail, List<SubActivity> subActivity
});


@override $ActivityCategoryCopyWith<$Res>? get activityCategory;

}
/// @nodoc
class __$ActivityCopyWithImpl<$Res>
    implements _$ActivityCopyWith<$Res> {
  __$ActivityCopyWithImpl(this._self, this._then);

  final _Activity _self;
  final $Res Function(_Activity) _then;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityId = null,Object? activityCategoryId = null,Object? name = null,Object? activityCode = null,Object? description = freezed,Object? hexColor = freezed,Object? icon = freezed,Object? activityDateType = null,Object? paceType = freezed,Object? isSuggestedFavorite = null,Object? activityCategory = freezed,Object? activityDetail = null,Object? subActivity = null,}) {
  return _then(_Activity(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,activityCategoryId: null == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,activityCode: null == activityCode ? _self.activityCode : activityCode // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,hexColor: freezed == hexColor ? _self.hexColor : hexColor // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,activityDateType: null == activityDateType ? _self.activityDateType : activityDateType // ignore: cast_nullable_to_non_nullable
as ActivityDateType,paceType: freezed == paceType ? _self.paceType : paceType // ignore: cast_nullable_to_non_nullable
as PaceType?,isSuggestedFavorite: null == isSuggestedFavorite ? _self.isSuggestedFavorite : isSuggestedFavorite // ignore: cast_nullable_to_non_nullable
as bool,activityCategory: freezed == activityCategory ? _self.activityCategory : activityCategory // ignore: cast_nullable_to_non_nullable
as ActivityCategory?,activityDetail: null == activityDetail ? _self._activityDetail : activityDetail // ignore: cast_nullable_to_non_nullable
as List<ActivityDetail>,subActivity: null == subActivity ? _self._subActivity : subActivity // ignore: cast_nullable_to_non_nullable
as List<SubActivity>,
  ));
}

/// Create a copy of Activity
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
