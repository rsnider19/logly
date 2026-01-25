// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_count_by_date.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityCountByDate {

@JsonKey(name: 'activity_date') DateTime get activityDate;@JsonKey(name: 'activity_category_id') String get activityCategoryId; int get count;
/// Create a copy of ActivityCountByDate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityCountByDateCopyWith<ActivityCountByDate> get copyWith => _$ActivityCountByDateCopyWithImpl<ActivityCountByDate>(this as ActivityCountByDate, _$identity);

  /// Serializes this ActivityCountByDate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityCountByDate&&(identical(other.activityDate, activityDate) || other.activityDate == activityDate)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityDate,activityCategoryId,count);

@override
String toString() {
  return 'ActivityCountByDate(activityDate: $activityDate, activityCategoryId: $activityCategoryId, count: $count)';
}


}

/// @nodoc
abstract mixin class $ActivityCountByDateCopyWith<$Res>  {
  factory $ActivityCountByDateCopyWith(ActivityCountByDate value, $Res Function(ActivityCountByDate) _then) = _$ActivityCountByDateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'activity_date') DateTime activityDate,@JsonKey(name: 'activity_category_id') String activityCategoryId, int count
});




}
/// @nodoc
class _$ActivityCountByDateCopyWithImpl<$Res>
    implements $ActivityCountByDateCopyWith<$Res> {
  _$ActivityCountByDateCopyWithImpl(this._self, this._then);

  final ActivityCountByDate _self;
  final $Res Function(ActivityCountByDate) _then;

/// Create a copy of ActivityCountByDate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityDate = null,Object? activityCategoryId = null,Object? count = null,}) {
  return _then(_self.copyWith(
activityDate: null == activityDate ? _self.activityDate : activityDate // ignore: cast_nullable_to_non_nullable
as DateTime,activityCategoryId: null == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityCountByDate].
extension ActivityCountByDatePatterns on ActivityCountByDate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityCountByDate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityCountByDate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityCountByDate value)  $default,){
final _that = this;
switch (_that) {
case _ActivityCountByDate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityCountByDate value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityCountByDate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_date')  DateTime activityDate, @JsonKey(name: 'activity_category_id')  String activityCategoryId,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityCountByDate() when $default != null:
return $default(_that.activityDate,_that.activityCategoryId,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_date')  DateTime activityDate, @JsonKey(name: 'activity_category_id')  String activityCategoryId,  int count)  $default,) {final _that = this;
switch (_that) {
case _ActivityCountByDate():
return $default(_that.activityDate,_that.activityCategoryId,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'activity_date')  DateTime activityDate, @JsonKey(name: 'activity_category_id')  String activityCategoryId,  int count)?  $default,) {final _that = this;
switch (_that) {
case _ActivityCountByDate() when $default != null:
return $default(_that.activityDate,_that.activityCategoryId,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityCountByDate implements ActivityCountByDate {
  const _ActivityCountByDate({@JsonKey(name: 'activity_date') required this.activityDate, @JsonKey(name: 'activity_category_id') required this.activityCategoryId, required this.count});
  factory _ActivityCountByDate.fromJson(Map<String, dynamic> json) => _$ActivityCountByDateFromJson(json);

@override@JsonKey(name: 'activity_date') final  DateTime activityDate;
@override@JsonKey(name: 'activity_category_id') final  String activityCategoryId;
@override final  int count;

/// Create a copy of ActivityCountByDate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityCountByDateCopyWith<_ActivityCountByDate> get copyWith => __$ActivityCountByDateCopyWithImpl<_ActivityCountByDate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityCountByDateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityCountByDate&&(identical(other.activityDate, activityDate) || other.activityDate == activityDate)&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityDate,activityCategoryId,count);

@override
String toString() {
  return 'ActivityCountByDate(activityDate: $activityDate, activityCategoryId: $activityCategoryId, count: $count)';
}


}

/// @nodoc
abstract mixin class _$ActivityCountByDateCopyWith<$Res> implements $ActivityCountByDateCopyWith<$Res> {
  factory _$ActivityCountByDateCopyWith(_ActivityCountByDate value, $Res Function(_ActivityCountByDate) _then) = __$ActivityCountByDateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'activity_date') DateTime activityDate,@JsonKey(name: 'activity_category_id') String activityCategoryId, int count
});




}
/// @nodoc
class __$ActivityCountByDateCopyWithImpl<$Res>
    implements _$ActivityCountByDateCopyWith<$Res> {
  __$ActivityCountByDateCopyWithImpl(this._self, this._then);

  final _ActivityCountByDate _self;
  final $Res Function(_ActivityCountByDate) _then;

/// Create a copy of ActivityCountByDate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityDate = null,Object? activityCategoryId = null,Object? count = null,}) {
  return _then(_ActivityCountByDate(
activityDate: null == activityDate ? _self.activityDate : activityDate // ignore: cast_nullable_to_non_nullable
as DateTime,activityCategoryId: null == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
