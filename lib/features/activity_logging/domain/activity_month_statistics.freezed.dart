// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_month_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityMonthStatistics {

/// Map of date (year/month/day only) to log count for that day.
 Map<DateTime, int> get dailyActivityCounts;/// Subactivity counts sorted by count descending.
 List<SubActivityCount> get subActivityCounts;/// Total number of logs in this month.
 int get totalCount;/// The parent activity, used for icon fallback.
 Activity? get activity;
/// Create a copy of ActivityMonthStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityMonthStatisticsCopyWith<ActivityMonthStatistics> get copyWith => _$ActivityMonthStatisticsCopyWithImpl<ActivityMonthStatistics>(this as ActivityMonthStatistics, _$identity);

  /// Serializes this ActivityMonthStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityMonthStatistics&&const DeepCollectionEquality().equals(other.dailyActivityCounts, dailyActivityCounts)&&const DeepCollectionEquality().equals(other.subActivityCounts, subActivityCounts)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.activity, activity) || other.activity == activity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(dailyActivityCounts),const DeepCollectionEquality().hash(subActivityCounts),totalCount,activity);

@override
String toString() {
  return 'ActivityMonthStatistics(dailyActivityCounts: $dailyActivityCounts, subActivityCounts: $subActivityCounts, totalCount: $totalCount, activity: $activity)';
}


}

/// @nodoc
abstract mixin class $ActivityMonthStatisticsCopyWith<$Res>  {
  factory $ActivityMonthStatisticsCopyWith(ActivityMonthStatistics value, $Res Function(ActivityMonthStatistics) _then) = _$ActivityMonthStatisticsCopyWithImpl;
@useResult
$Res call({
 Map<DateTime, int> dailyActivityCounts, List<SubActivityCount> subActivityCounts, int totalCount, Activity? activity
});


$ActivityCopyWith<$Res>? get activity;

}
/// @nodoc
class _$ActivityMonthStatisticsCopyWithImpl<$Res>
    implements $ActivityMonthStatisticsCopyWith<$Res> {
  _$ActivityMonthStatisticsCopyWithImpl(this._self, this._then);

  final ActivityMonthStatistics _self;
  final $Res Function(ActivityMonthStatistics) _then;

/// Create a copy of ActivityMonthStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dailyActivityCounts = null,Object? subActivityCounts = null,Object? totalCount = null,Object? activity = freezed,}) {
  return _then(_self.copyWith(
dailyActivityCounts: null == dailyActivityCounts ? _self.dailyActivityCounts : dailyActivityCounts // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,subActivityCounts: null == subActivityCounts ? _self.subActivityCounts : subActivityCounts // ignore: cast_nullable_to_non_nullable
as List<SubActivityCount>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as Activity?,
  ));
}
/// Create a copy of ActivityMonthStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityCopyWith<$Res>? get activity {
    if (_self.activity == null) {
    return null;
  }

  return $ActivityCopyWith<$Res>(_self.activity!, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivityMonthStatistics].
extension ActivityMonthStatisticsPatterns on ActivityMonthStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityMonthStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityMonthStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityMonthStatistics value)  $default,){
final _that = this;
switch (_that) {
case _ActivityMonthStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityMonthStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityMonthStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<DateTime, int> dailyActivityCounts,  List<SubActivityCount> subActivityCounts,  int totalCount,  Activity? activity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityMonthStatistics() when $default != null:
return $default(_that.dailyActivityCounts,_that.subActivityCounts,_that.totalCount,_that.activity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<DateTime, int> dailyActivityCounts,  List<SubActivityCount> subActivityCounts,  int totalCount,  Activity? activity)  $default,) {final _that = this;
switch (_that) {
case _ActivityMonthStatistics():
return $default(_that.dailyActivityCounts,_that.subActivityCounts,_that.totalCount,_that.activity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<DateTime, int> dailyActivityCounts,  List<SubActivityCount> subActivityCounts,  int totalCount,  Activity? activity)?  $default,) {final _that = this;
switch (_that) {
case _ActivityMonthStatistics() when $default != null:
return $default(_that.dailyActivityCounts,_that.subActivityCounts,_that.totalCount,_that.activity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityMonthStatistics implements ActivityMonthStatistics {
  const _ActivityMonthStatistics({required final  Map<DateTime, int> dailyActivityCounts, required final  List<SubActivityCount> subActivityCounts, required this.totalCount, this.activity}): _dailyActivityCounts = dailyActivityCounts,_subActivityCounts = subActivityCounts;
  factory _ActivityMonthStatistics.fromJson(Map<String, dynamic> json) => _$ActivityMonthStatisticsFromJson(json);

/// Map of date (year/month/day only) to log count for that day.
 final  Map<DateTime, int> _dailyActivityCounts;
/// Map of date (year/month/day only) to log count for that day.
@override Map<DateTime, int> get dailyActivityCounts {
  if (_dailyActivityCounts is EqualUnmodifiableMapView) return _dailyActivityCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dailyActivityCounts);
}

/// Subactivity counts sorted by count descending.
 final  List<SubActivityCount> _subActivityCounts;
/// Subactivity counts sorted by count descending.
@override List<SubActivityCount> get subActivityCounts {
  if (_subActivityCounts is EqualUnmodifiableListView) return _subActivityCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subActivityCounts);
}

/// Total number of logs in this month.
@override final  int totalCount;
/// The parent activity, used for icon fallback.
@override final  Activity? activity;

/// Create a copy of ActivityMonthStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityMonthStatisticsCopyWith<_ActivityMonthStatistics> get copyWith => __$ActivityMonthStatisticsCopyWithImpl<_ActivityMonthStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityMonthStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityMonthStatistics&&const DeepCollectionEquality().equals(other._dailyActivityCounts, _dailyActivityCounts)&&const DeepCollectionEquality().equals(other._subActivityCounts, _subActivityCounts)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.activity, activity) || other.activity == activity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_dailyActivityCounts),const DeepCollectionEquality().hash(_subActivityCounts),totalCount,activity);

@override
String toString() {
  return 'ActivityMonthStatistics(dailyActivityCounts: $dailyActivityCounts, subActivityCounts: $subActivityCounts, totalCount: $totalCount, activity: $activity)';
}


}

/// @nodoc
abstract mixin class _$ActivityMonthStatisticsCopyWith<$Res> implements $ActivityMonthStatisticsCopyWith<$Res> {
  factory _$ActivityMonthStatisticsCopyWith(_ActivityMonthStatistics value, $Res Function(_ActivityMonthStatistics) _then) = __$ActivityMonthStatisticsCopyWithImpl;
@override @useResult
$Res call({
 Map<DateTime, int> dailyActivityCounts, List<SubActivityCount> subActivityCounts, int totalCount, Activity? activity
});


@override $ActivityCopyWith<$Res>? get activity;

}
/// @nodoc
class __$ActivityMonthStatisticsCopyWithImpl<$Res>
    implements _$ActivityMonthStatisticsCopyWith<$Res> {
  __$ActivityMonthStatisticsCopyWithImpl(this._self, this._then);

  final _ActivityMonthStatistics _self;
  final $Res Function(_ActivityMonthStatistics) _then;

/// Create a copy of ActivityMonthStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dailyActivityCounts = null,Object? subActivityCounts = null,Object? totalCount = null,Object? activity = freezed,}) {
  return _then(_ActivityMonthStatistics(
dailyActivityCounts: null == dailyActivityCounts ? _self._dailyActivityCounts : dailyActivityCounts // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,subActivityCounts: null == subActivityCounts ? _self._subActivityCounts : subActivityCounts // ignore: cast_nullable_to_non_nullable
as List<SubActivityCount>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as Activity?,
  ));
}

/// Create a copy of ActivityMonthStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityCopyWith<$Res>? get activity {
    if (_self.activity == null) {
    return null;
  }

  return $ActivityCopyWith<$Res>(_self.activity!, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}


/// @nodoc
mixin _$SubActivityCount {

 SubActivity get subActivity; int get count;
/// Create a copy of SubActivityCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubActivityCountCopyWith<SubActivityCount> get copyWith => _$SubActivityCountCopyWithImpl<SubActivityCount>(this as SubActivityCount, _$identity);

  /// Serializes this SubActivityCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubActivityCount&&(identical(other.subActivity, subActivity) || other.subActivity == subActivity)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subActivity,count);

@override
String toString() {
  return 'SubActivityCount(subActivity: $subActivity, count: $count)';
}


}

/// @nodoc
abstract mixin class $SubActivityCountCopyWith<$Res>  {
  factory $SubActivityCountCopyWith(SubActivityCount value, $Res Function(SubActivityCount) _then) = _$SubActivityCountCopyWithImpl;
@useResult
$Res call({
 SubActivity subActivity, int count
});


$SubActivityCopyWith<$Res> get subActivity;

}
/// @nodoc
class _$SubActivityCountCopyWithImpl<$Res>
    implements $SubActivityCountCopyWith<$Res> {
  _$SubActivityCountCopyWithImpl(this._self, this._then);

  final SubActivityCount _self;
  final $Res Function(SubActivityCount) _then;

/// Create a copy of SubActivityCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subActivity = null,Object? count = null,}) {
  return _then(_self.copyWith(
subActivity: null == subActivity ? _self.subActivity : subActivity // ignore: cast_nullable_to_non_nullable
as SubActivity,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of SubActivityCount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubActivityCopyWith<$Res> get subActivity {
  
  return $SubActivityCopyWith<$Res>(_self.subActivity, (value) {
    return _then(_self.copyWith(subActivity: value));
  });
}
}


/// Adds pattern-matching-related methods to [SubActivityCount].
extension SubActivityCountPatterns on SubActivityCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubActivityCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubActivityCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubActivityCount value)  $default,){
final _that = this;
switch (_that) {
case _SubActivityCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubActivityCount value)?  $default,){
final _that = this;
switch (_that) {
case _SubActivityCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SubActivity subActivity,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubActivityCount() when $default != null:
return $default(_that.subActivity,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SubActivity subActivity,  int count)  $default,) {final _that = this;
switch (_that) {
case _SubActivityCount():
return $default(_that.subActivity,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SubActivity subActivity,  int count)?  $default,) {final _that = this;
switch (_that) {
case _SubActivityCount() when $default != null:
return $default(_that.subActivity,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubActivityCount implements SubActivityCount {
  const _SubActivityCount({required this.subActivity, required this.count});
  factory _SubActivityCount.fromJson(Map<String, dynamic> json) => _$SubActivityCountFromJson(json);

@override final  SubActivity subActivity;
@override final  int count;

/// Create a copy of SubActivityCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubActivityCountCopyWith<_SubActivityCount> get copyWith => __$SubActivityCountCopyWithImpl<_SubActivityCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubActivityCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubActivityCount&&(identical(other.subActivity, subActivity) || other.subActivity == subActivity)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subActivity,count);

@override
String toString() {
  return 'SubActivityCount(subActivity: $subActivity, count: $count)';
}


}

/// @nodoc
abstract mixin class _$SubActivityCountCopyWith<$Res> implements $SubActivityCountCopyWith<$Res> {
  factory _$SubActivityCountCopyWith(_SubActivityCount value, $Res Function(_SubActivityCount) _then) = __$SubActivityCountCopyWithImpl;
@override @useResult
$Res call({
 SubActivity subActivity, int count
});


@override $SubActivityCopyWith<$Res> get subActivity;

}
/// @nodoc
class __$SubActivityCountCopyWithImpl<$Res>
    implements _$SubActivityCountCopyWith<$Res> {
  __$SubActivityCountCopyWithImpl(this._self, this._then);

  final _SubActivityCount _self;
  final $Res Function(_SubActivityCount) _then;

/// Create a copy of SubActivityCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subActivity = null,Object? count = null,}) {
  return _then(_SubActivityCount(
subActivity: null == subActivity ? _self.subActivity : subActivity // ignore: cast_nullable_to_non_nullable
as SubActivity,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of SubActivityCount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubActivityCopyWith<$Res> get subActivity {
  
  return $SubActivityCopyWith<$Res>(_self.subActivity, (value) {
    return _then(_self.copyWith(subActivity: value));
  });
}
}

// dart format on
