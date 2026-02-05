// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_category_counts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryCount {

@JsonKey(name: 'activity_category_id') String get activityCategoryId; int get count;
/// Create a copy of CategoryCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCountCopyWith<CategoryCount> get copyWith => _$CategoryCountCopyWithImpl<CategoryCount>(this as CategoryCount, _$identity);

  /// Serializes this CategoryCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryCount&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityCategoryId,count);

@override
String toString() {
  return 'CategoryCount(activityCategoryId: $activityCategoryId, count: $count)';
}


}

/// @nodoc
abstract mixin class $CategoryCountCopyWith<$Res>  {
  factory $CategoryCountCopyWith(CategoryCount value, $Res Function(CategoryCount) _then) = _$CategoryCountCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'activity_category_id') String activityCategoryId, int count
});




}
/// @nodoc
class _$CategoryCountCopyWithImpl<$Res>
    implements $CategoryCountCopyWith<$Res> {
  _$CategoryCountCopyWithImpl(this._self, this._then);

  final CategoryCount _self;
  final $Res Function(CategoryCount) _then;

/// Create a copy of CategoryCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityCategoryId = null,Object? count = null,}) {
  return _then(_self.copyWith(
activityCategoryId: null == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryCount].
extension CategoryCountPatterns on CategoryCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryCount value)  $default,){
final _that = this;
switch (_that) {
case _CategoryCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryCount value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_category_id')  String activityCategoryId,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryCount() when $default != null:
return $default(_that.activityCategoryId,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_category_id')  String activityCategoryId,  int count)  $default,) {final _that = this;
switch (_that) {
case _CategoryCount():
return $default(_that.activityCategoryId,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'activity_category_id')  String activityCategoryId,  int count)?  $default,) {final _that = this;
switch (_that) {
case _CategoryCount() when $default != null:
return $default(_that.activityCategoryId,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryCount implements CategoryCount {
  const _CategoryCount({@JsonKey(name: 'activity_category_id') required this.activityCategoryId, required this.count});
  factory _CategoryCount.fromJson(Map<String, dynamic> json) => _$CategoryCountFromJson(json);

@override@JsonKey(name: 'activity_category_id') final  String activityCategoryId;
@override final  int count;

/// Create a copy of CategoryCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCountCopyWith<_CategoryCount> get copyWith => __$CategoryCountCopyWithImpl<_CategoryCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryCount&&(identical(other.activityCategoryId, activityCategoryId) || other.activityCategoryId == activityCategoryId)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityCategoryId,count);

@override
String toString() {
  return 'CategoryCount(activityCategoryId: $activityCategoryId, count: $count)';
}


}

/// @nodoc
abstract mixin class _$CategoryCountCopyWith<$Res> implements $CategoryCountCopyWith<$Res> {
  factory _$CategoryCountCopyWith(_CategoryCount value, $Res Function(_CategoryCount) _then) = __$CategoryCountCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'activity_category_id') String activityCategoryId, int count
});




}
/// @nodoc
class __$CategoryCountCopyWithImpl<$Res>
    implements _$CategoryCountCopyWith<$Res> {
  __$CategoryCountCopyWithImpl(this._self, this._then);

  final _CategoryCount _self;
  final $Res Function(_CategoryCount) _then;

/// Create a copy of CategoryCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityCategoryId = null,Object? count = null,}) {
  return _then(_CategoryCount(
activityCategoryId: null == activityCategoryId ? _self.activityCategoryId : activityCategoryId // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DailyCategoryCounts {

@JsonKey(name: 'activity_date') DateTime get activityDate; List<CategoryCount> get categories;
/// Create a copy of DailyCategoryCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyCategoryCountsCopyWith<DailyCategoryCounts> get copyWith => _$DailyCategoryCountsCopyWithImpl<DailyCategoryCounts>(this as DailyCategoryCounts, _$identity);

  /// Serializes this DailyCategoryCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyCategoryCounts&&(identical(other.activityDate, activityDate) || other.activityDate == activityDate)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityDate,const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'DailyCategoryCounts(activityDate: $activityDate, categories: $categories)';
}


}

/// @nodoc
abstract mixin class $DailyCategoryCountsCopyWith<$Res>  {
  factory $DailyCategoryCountsCopyWith(DailyCategoryCounts value, $Res Function(DailyCategoryCounts) _then) = _$DailyCategoryCountsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'activity_date') DateTime activityDate, List<CategoryCount> categories
});




}
/// @nodoc
class _$DailyCategoryCountsCopyWithImpl<$Res>
    implements $DailyCategoryCountsCopyWith<$Res> {
  _$DailyCategoryCountsCopyWithImpl(this._self, this._then);

  final DailyCategoryCounts _self;
  final $Res Function(DailyCategoryCounts) _then;

/// Create a copy of DailyCategoryCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityDate = null,Object? categories = null,}) {
  return _then(_self.copyWith(
activityDate: null == activityDate ? _self.activityDate : activityDate // ignore: cast_nullable_to_non_nullable
as DateTime,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryCount>,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyCategoryCounts].
extension DailyCategoryCountsPatterns on DailyCategoryCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyCategoryCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyCategoryCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyCategoryCounts value)  $default,){
final _that = this;
switch (_that) {
case _DailyCategoryCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyCategoryCounts value)?  $default,){
final _that = this;
switch (_that) {
case _DailyCategoryCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_date')  DateTime activityDate,  List<CategoryCount> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyCategoryCounts() when $default != null:
return $default(_that.activityDate,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_date')  DateTime activityDate,  List<CategoryCount> categories)  $default,) {final _that = this;
switch (_that) {
case _DailyCategoryCounts():
return $default(_that.activityDate,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'activity_date')  DateTime activityDate,  List<CategoryCount> categories)?  $default,) {final _that = this;
switch (_that) {
case _DailyCategoryCounts() when $default != null:
return $default(_that.activityDate,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyCategoryCounts implements DailyCategoryCounts {
  const _DailyCategoryCounts({@JsonKey(name: 'activity_date') required this.activityDate, required final  List<CategoryCount> categories}): _categories = categories;
  factory _DailyCategoryCounts.fromJson(Map<String, dynamic> json) => _$DailyCategoryCountsFromJson(json);

@override@JsonKey(name: 'activity_date') final  DateTime activityDate;
 final  List<CategoryCount> _categories;
@override List<CategoryCount> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of DailyCategoryCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyCategoryCountsCopyWith<_DailyCategoryCounts> get copyWith => __$DailyCategoryCountsCopyWithImpl<_DailyCategoryCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyCategoryCountsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyCategoryCounts&&(identical(other.activityDate, activityDate) || other.activityDate == activityDate)&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityDate,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'DailyCategoryCounts(activityDate: $activityDate, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$DailyCategoryCountsCopyWith<$Res> implements $DailyCategoryCountsCopyWith<$Res> {
  factory _$DailyCategoryCountsCopyWith(_DailyCategoryCounts value, $Res Function(_DailyCategoryCounts) _then) = __$DailyCategoryCountsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'activity_date') DateTime activityDate, List<CategoryCount> categories
});




}
/// @nodoc
class __$DailyCategoryCountsCopyWithImpl<$Res>
    implements _$DailyCategoryCountsCopyWith<$Res> {
  __$DailyCategoryCountsCopyWithImpl(this._self, this._then);

  final _DailyCategoryCounts _self;
  final $Res Function(_DailyCategoryCounts) _then;

/// Create a copy of DailyCategoryCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityDate = null,Object? categories = null,}) {
  return _then(_DailyCategoryCounts(
activityDate: null == activityDate ? _self.activityDate : activityDate // ignore: cast_nullable_to_non_nullable
as DateTime,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryCount>,
  ));
}


}

// dart format on
