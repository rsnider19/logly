// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessageMetadata {

@JsonKey(name: 'follow_up_suggestions') List<String>? get followUpSuggestions; List<String>? get steps;
/// Create a copy of ChatMessageMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageMetadataCopyWith<ChatMessageMetadata> get copyWith => _$ChatMessageMetadataCopyWithImpl<ChatMessageMetadata>(this as ChatMessageMetadata, _$identity);

  /// Serializes this ChatMessageMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageMetadata&&const DeepCollectionEquality().equals(other.followUpSuggestions, followUpSuggestions)&&const DeepCollectionEquality().equals(other.steps, steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(followUpSuggestions),const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'ChatMessageMetadata(followUpSuggestions: $followUpSuggestions, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $ChatMessageMetadataCopyWith<$Res>  {
  factory $ChatMessageMetadataCopyWith(ChatMessageMetadata value, $Res Function(ChatMessageMetadata) _then) = _$ChatMessageMetadataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'follow_up_suggestions') List<String>? followUpSuggestions, List<String>? steps
});




}
/// @nodoc
class _$ChatMessageMetadataCopyWithImpl<$Res>
    implements $ChatMessageMetadataCopyWith<$Res> {
  _$ChatMessageMetadataCopyWithImpl(this._self, this._then);

  final ChatMessageMetadata _self;
  final $Res Function(ChatMessageMetadata) _then;

/// Create a copy of ChatMessageMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? followUpSuggestions = freezed,Object? steps = freezed,}) {
  return _then(_self.copyWith(
followUpSuggestions: freezed == followUpSuggestions ? _self.followUpSuggestions : followUpSuggestions // ignore: cast_nullable_to_non_nullable
as List<String>?,steps: freezed == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageMetadata].
extension ChatMessageMetadataPatterns on ChatMessageMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageMetadata value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'follow_up_suggestions')  List<String>? followUpSuggestions,  List<String>? steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageMetadata() when $default != null:
return $default(_that.followUpSuggestions,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'follow_up_suggestions')  List<String>? followUpSuggestions,  List<String>? steps)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageMetadata():
return $default(_that.followUpSuggestions,_that.steps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'follow_up_suggestions')  List<String>? followUpSuggestions,  List<String>? steps)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageMetadata() when $default != null:
return $default(_that.followUpSuggestions,_that.steps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageMetadata implements ChatMessageMetadata {
  const _ChatMessageMetadata({@JsonKey(name: 'follow_up_suggestions') final  List<String>? followUpSuggestions, final  List<String>? steps}): _followUpSuggestions = followUpSuggestions,_steps = steps;
  factory _ChatMessageMetadata.fromJson(Map<String, dynamic> json) => _$ChatMessageMetadataFromJson(json);

 final  List<String>? _followUpSuggestions;
@override@JsonKey(name: 'follow_up_suggestions') List<String>? get followUpSuggestions {
  final value = _followUpSuggestions;
  if (value == null) return null;
  if (_followUpSuggestions is EqualUnmodifiableListView) return _followUpSuggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _steps;
@override List<String>? get steps {
  final value = _steps;
  if (value == null) return null;
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ChatMessageMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageMetadataCopyWith<_ChatMessageMetadata> get copyWith => __$ChatMessageMetadataCopyWithImpl<_ChatMessageMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageMetadata&&const DeepCollectionEquality().equals(other._followUpSuggestions, _followUpSuggestions)&&const DeepCollectionEquality().equals(other._steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_followUpSuggestions),const DeepCollectionEquality().hash(_steps));

@override
String toString() {
  return 'ChatMessageMetadata(followUpSuggestions: $followUpSuggestions, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageMetadataCopyWith<$Res> implements $ChatMessageMetadataCopyWith<$Res> {
  factory _$ChatMessageMetadataCopyWith(_ChatMessageMetadata value, $Res Function(_ChatMessageMetadata) _then) = __$ChatMessageMetadataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'follow_up_suggestions') List<String>? followUpSuggestions, List<String>? steps
});




}
/// @nodoc
class __$ChatMessageMetadataCopyWithImpl<$Res>
    implements _$ChatMessageMetadataCopyWith<$Res> {
  __$ChatMessageMetadataCopyWithImpl(this._self, this._then);

  final _ChatMessageMetadata _self;
  final $Res Function(_ChatMessageMetadata) _then;

/// Create a copy of ChatMessageMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? followUpSuggestions = freezed,Object? steps = freezed,}) {
  return _then(_ChatMessageMetadata(
followUpSuggestions: freezed == followUpSuggestions ? _self._followUpSuggestions : followUpSuggestions // ignore: cast_nullable_to_non_nullable
as List<String>?,steps: freezed == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$ChatMessage {

@JsonKey(name: 'message_id') String get messageId;@JsonKey(name: 'conversation_id') String get conversationId; ChatMessageRole get role; String get content;@JsonKey(name: 'created_at') DateTime get createdAt; ChatMessageMetadata? get metadata;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,conversationId,role,content,createdAt,metadata);

@override
String toString() {
  return 'ChatMessage(messageId: $messageId, conversationId: $conversationId, role: $role, content: $content, createdAt: $createdAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'conversation_id') String conversationId, ChatMessageRole role, String content,@JsonKey(name: 'created_at') DateTime createdAt, ChatMessageMetadata? metadata
});


$ChatMessageMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? conversationId = null,Object? role = null,Object? content = null,Object? createdAt = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatMessageRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ChatMessageMetadata?,
  ));
}
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $ChatMessageMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'conversation_id')  String conversationId,  ChatMessageRole role,  String content, @JsonKey(name: 'created_at')  DateTime createdAt,  ChatMessageMetadata? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.messageId,_that.conversationId,_that.role,_that.content,_that.createdAt,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'conversation_id')  String conversationId,  ChatMessageRole role,  String content, @JsonKey(name: 'created_at')  DateTime createdAt,  ChatMessageMetadata? metadata)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.messageId,_that.conversationId,_that.role,_that.content,_that.createdAt,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'conversation_id')  String conversationId,  ChatMessageRole role,  String content, @JsonKey(name: 'created_at')  DateTime createdAt,  ChatMessageMetadata? metadata)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.messageId,_that.conversationId,_that.role,_that.content,_that.createdAt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({@JsonKey(name: 'message_id') required this.messageId, @JsonKey(name: 'conversation_id') required this.conversationId, required this.role, required this.content, @JsonKey(name: 'created_at') required this.createdAt, this.metadata});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override@JsonKey(name: 'message_id') final  String messageId;
@override@JsonKey(name: 'conversation_id') final  String conversationId;
@override final  ChatMessageRole role;
@override final  String content;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override final  ChatMessageMetadata? metadata;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,conversationId,role,content,createdAt,metadata);

@override
String toString() {
  return 'ChatMessage(messageId: $messageId, conversationId: $conversationId, role: $role, content: $content, createdAt: $createdAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'conversation_id') String conversationId, ChatMessageRole role, String content,@JsonKey(name: 'created_at') DateTime createdAt, ChatMessageMetadata? metadata
});


@override $ChatMessageMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? conversationId = null,Object? role = null,Object? content = null,Object? createdAt = null,Object? metadata = freezed,}) {
  return _then(_ChatMessage(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatMessageRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ChatMessageMetadata?,
  ));
}

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $ChatMessageMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
