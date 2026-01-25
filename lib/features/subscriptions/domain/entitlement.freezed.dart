// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entitlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Entitlement {

 String get identifier; bool get isActive; DateTime? get expirationDate; DateTime? get purchaseDate; String? get productIdentifier;
/// Create a copy of Entitlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntitlementCopyWith<Entitlement> get copyWith => _$EntitlementCopyWithImpl<Entitlement>(this as Entitlement, _$identity);

  /// Serializes this Entitlement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Entitlement&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.productIdentifier, productIdentifier) || other.productIdentifier == productIdentifier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,identifier,isActive,expirationDate,purchaseDate,productIdentifier);

@override
String toString() {
  return 'Entitlement(identifier: $identifier, isActive: $isActive, expirationDate: $expirationDate, purchaseDate: $purchaseDate, productIdentifier: $productIdentifier)';
}


}

/// @nodoc
abstract mixin class $EntitlementCopyWith<$Res>  {
  factory $EntitlementCopyWith(Entitlement value, $Res Function(Entitlement) _then) = _$EntitlementCopyWithImpl;
@useResult
$Res call({
 String identifier, bool isActive, DateTime? expirationDate, DateTime? purchaseDate, String? productIdentifier
});




}
/// @nodoc
class _$EntitlementCopyWithImpl<$Res>
    implements $EntitlementCopyWith<$Res> {
  _$EntitlementCopyWithImpl(this._self, this._then);

  final Entitlement _self;
  final $Res Function(Entitlement) _then;

/// Create a copy of Entitlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? identifier = null,Object? isActive = null,Object? expirationDate = freezed,Object? purchaseDate = freezed,Object? productIdentifier = freezed,}) {
  return _then(_self.copyWith(
identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,productIdentifier: freezed == productIdentifier ? _self.productIdentifier : productIdentifier // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Entitlement].
extension EntitlementPatterns on Entitlement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Entitlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Entitlement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Entitlement value)  $default,){
final _that = this;
switch (_that) {
case _Entitlement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Entitlement value)?  $default,){
final _that = this;
switch (_that) {
case _Entitlement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String identifier,  bool isActive,  DateTime? expirationDate,  DateTime? purchaseDate,  String? productIdentifier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Entitlement() when $default != null:
return $default(_that.identifier,_that.isActive,_that.expirationDate,_that.purchaseDate,_that.productIdentifier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String identifier,  bool isActive,  DateTime? expirationDate,  DateTime? purchaseDate,  String? productIdentifier)  $default,) {final _that = this;
switch (_that) {
case _Entitlement():
return $default(_that.identifier,_that.isActive,_that.expirationDate,_that.purchaseDate,_that.productIdentifier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String identifier,  bool isActive,  DateTime? expirationDate,  DateTime? purchaseDate,  String? productIdentifier)?  $default,) {final _that = this;
switch (_that) {
case _Entitlement() when $default != null:
return $default(_that.identifier,_that.isActive,_that.expirationDate,_that.purchaseDate,_that.productIdentifier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Entitlement implements Entitlement {
  const _Entitlement({required this.identifier, required this.isActive, this.expirationDate, this.purchaseDate, this.productIdentifier});
  factory _Entitlement.fromJson(Map<String, dynamic> json) => _$EntitlementFromJson(json);

@override final  String identifier;
@override final  bool isActive;
@override final  DateTime? expirationDate;
@override final  DateTime? purchaseDate;
@override final  String? productIdentifier;

/// Create a copy of Entitlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntitlementCopyWith<_Entitlement> get copyWith => __$EntitlementCopyWithImpl<_Entitlement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntitlementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Entitlement&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.productIdentifier, productIdentifier) || other.productIdentifier == productIdentifier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,identifier,isActive,expirationDate,purchaseDate,productIdentifier);

@override
String toString() {
  return 'Entitlement(identifier: $identifier, isActive: $isActive, expirationDate: $expirationDate, purchaseDate: $purchaseDate, productIdentifier: $productIdentifier)';
}


}

/// @nodoc
abstract mixin class _$EntitlementCopyWith<$Res> implements $EntitlementCopyWith<$Res> {
  factory _$EntitlementCopyWith(_Entitlement value, $Res Function(_Entitlement) _then) = __$EntitlementCopyWithImpl;
@override @useResult
$Res call({
 String identifier, bool isActive, DateTime? expirationDate, DateTime? purchaseDate, String? productIdentifier
});




}
/// @nodoc
class __$EntitlementCopyWithImpl<$Res>
    implements _$EntitlementCopyWith<$Res> {
  __$EntitlementCopyWithImpl(this._self, this._then);

  final _Entitlement _self;
  final $Res Function(_Entitlement) _then;

/// Create a copy of Entitlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? identifier = null,Object? isActive = null,Object? expirationDate = freezed,Object? purchaseDate = freezed,Object? productIdentifier = freezed,}) {
  return _then(_Entitlement(
identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,productIdentifier: freezed == productIdentifier ? _self.productIdentifier : productIdentifier // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
