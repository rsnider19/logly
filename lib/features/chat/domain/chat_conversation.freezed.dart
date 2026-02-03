// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatConversation {

@JsonKey(name: 'conversation_id') String get conversationId;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt; String? get title;@JsonKey(name: 'last_response_id') String? get lastResponseId;@JsonKey(name: 'last_conversion_id') String? get lastConversionId;
/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatConversationCopyWith<ChatConversation> get copyWith => _$ChatConversationCopyWithImpl<ChatConversation>(this as ChatConversation, _$identity);

  /// Serializes this ChatConversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatConversation&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.lastResponseId, lastResponseId) || other.lastResponseId == lastResponseId)&&(identical(other.lastConversionId, lastConversionId) || other.lastConversionId == lastConversionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,userId,createdAt,updatedAt,title,lastResponseId,lastConversionId);

@override
String toString() {
  return 'ChatConversation(conversationId: $conversationId, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, lastResponseId: $lastResponseId, lastConversionId: $lastConversionId)';
}


}

/// @nodoc
abstract mixin class $ChatConversationCopyWith<$Res>  {
  factory $ChatConversationCopyWith(ChatConversation value, $Res Function(ChatConversation) _then) = _$ChatConversationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'conversation_id') String conversationId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, String? title,@JsonKey(name: 'last_response_id') String? lastResponseId,@JsonKey(name: 'last_conversion_id') String? lastConversionId
});




}
/// @nodoc
class _$ChatConversationCopyWithImpl<$Res>
    implements $ChatConversationCopyWith<$Res> {
  _$ChatConversationCopyWithImpl(this._self, this._then);

  final ChatConversation _self;
  final $Res Function(ChatConversation) _then;

/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? userId = null,Object? createdAt = null,Object? updatedAt = null,Object? title = freezed,Object? lastResponseId = freezed,Object? lastConversionId = freezed,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,lastResponseId: freezed == lastResponseId ? _self.lastResponseId : lastResponseId // ignore: cast_nullable_to_non_nullable
as String?,lastConversionId: freezed == lastConversionId ? _self.lastConversionId : lastConversionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatConversation].
extension ChatConversationPatterns on ChatConversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatConversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatConversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatConversation value)  $default,){
final _that = this;
switch (_that) {
case _ChatConversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatConversation value)?  $default,){
final _that = this;
switch (_that) {
case _ChatConversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  String? title, @JsonKey(name: 'last_response_id')  String? lastResponseId, @JsonKey(name: 'last_conversion_id')  String? lastConversionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatConversation() when $default != null:
return $default(_that.conversationId,_that.userId,_that.createdAt,_that.updatedAt,_that.title,_that.lastResponseId,_that.lastConversionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  String? title, @JsonKey(name: 'last_response_id')  String? lastResponseId, @JsonKey(name: 'last_conversion_id')  String? lastConversionId)  $default,) {final _that = this;
switch (_that) {
case _ChatConversation():
return $default(_that.conversationId,_that.userId,_that.createdAt,_that.updatedAt,_that.title,_that.lastResponseId,_that.lastConversionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  String? title, @JsonKey(name: 'last_response_id')  String? lastResponseId, @JsonKey(name: 'last_conversion_id')  String? lastConversionId)?  $default,) {final _that = this;
switch (_that) {
case _ChatConversation() when $default != null:
return $default(_that.conversationId,_that.userId,_that.createdAt,_that.updatedAt,_that.title,_that.lastResponseId,_that.lastConversionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatConversation implements ChatConversation {
  const _ChatConversation({@JsonKey(name: 'conversation_id') required this.conversationId, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, this.title, @JsonKey(name: 'last_response_id') this.lastResponseId, @JsonKey(name: 'last_conversion_id') this.lastConversionId});
  factory _ChatConversation.fromJson(Map<String, dynamic> json) => _$ChatConversationFromJson(json);

@override@JsonKey(name: 'conversation_id') final  String conversationId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
@override final  String? title;
@override@JsonKey(name: 'last_response_id') final  String? lastResponseId;
@override@JsonKey(name: 'last_conversion_id') final  String? lastConversionId;

/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatConversationCopyWith<_ChatConversation> get copyWith => __$ChatConversationCopyWithImpl<_ChatConversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatConversation&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.lastResponseId, lastResponseId) || other.lastResponseId == lastResponseId)&&(identical(other.lastConversionId, lastConversionId) || other.lastConversionId == lastConversionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,userId,createdAt,updatedAt,title,lastResponseId,lastConversionId);

@override
String toString() {
  return 'ChatConversation(conversationId: $conversationId, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, lastResponseId: $lastResponseId, lastConversionId: $lastConversionId)';
}


}

/// @nodoc
abstract mixin class _$ChatConversationCopyWith<$Res> implements $ChatConversationCopyWith<$Res> {
  factory _$ChatConversationCopyWith(_ChatConversation value, $Res Function(_ChatConversation) _then) = __$ChatConversationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'conversation_id') String conversationId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, String? title,@JsonKey(name: 'last_response_id') String? lastResponseId,@JsonKey(name: 'last_conversion_id') String? lastConversionId
});




}
/// @nodoc
class __$ChatConversationCopyWithImpl<$Res>
    implements _$ChatConversationCopyWith<$Res> {
  __$ChatConversationCopyWithImpl(this._self, this._then);

  final _ChatConversation _self;
  final $Res Function(_ChatConversation) _then;

/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? userId = null,Object? createdAt = null,Object? updatedAt = null,Object? title = freezed,Object? lastResponseId = freezed,Object? lastConversionId = freezed,}) {
  return _then(_ChatConversation(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,lastResponseId: freezed == lastResponseId ? _self.lastResponseId : lastResponseId // ignore: cast_nullable_to_non_nullable
as String?,lastConversionId: freezed == lastConversionId ? _self.lastConversionId : lastConversionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
