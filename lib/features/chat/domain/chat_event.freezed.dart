// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ChatEvent _$ChatEventFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'step':
          return ChatStepEvent.fromJson(
            json
          );
                case 'text_delta':
          return ChatTextDeltaEvent.fromJson(
            json
          );
                case 'response_id':
          return ChatResponseIdEvent.fromJson(
            json
          );
                case 'conversion_id':
          return ChatConversionIdEvent.fromJson(
            json
          );
                case 'error':
          return ChatErrorEvent.fromJson(
            json
          );
                case 'done':
          return ChatDoneEvent.fromJson(
            json
          );
                case 'follow_up_suggestions':
          return ChatFollowUpSuggestionsEvent.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'ChatEvent',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$ChatEvent {



  /// Serializes this ChatEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatEvent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent()';
}


}

/// @nodoc
class $ChatEventCopyWith<$Res>  {
$ChatEventCopyWith(ChatEvent _, $Res Function(ChatEvent) __);
}


/// Adds pattern-matching-related methods to [ChatEvent].
extension ChatEventPatterns on ChatEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChatStepEvent value)?  step,TResult Function( ChatTextDeltaEvent value)?  textDelta,TResult Function( ChatResponseIdEvent value)?  responseId,TResult Function( ChatConversionIdEvent value)?  conversionId,TResult Function( ChatErrorEvent value)?  error,TResult Function( ChatDoneEvent value)?  done,TResult Function( ChatFollowUpSuggestionsEvent value)?  followUpSuggestions,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChatStepEvent() when step != null:
return step(_that);case ChatTextDeltaEvent() when textDelta != null:
return textDelta(_that);case ChatResponseIdEvent() when responseId != null:
return responseId(_that);case ChatConversionIdEvent() when conversionId != null:
return conversionId(_that);case ChatErrorEvent() when error != null:
return error(_that);case ChatDoneEvent() when done != null:
return done(_that);case ChatFollowUpSuggestionsEvent() when followUpSuggestions != null:
return followUpSuggestions(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChatStepEvent value)  step,required TResult Function( ChatTextDeltaEvent value)  textDelta,required TResult Function( ChatResponseIdEvent value)  responseId,required TResult Function( ChatConversionIdEvent value)  conversionId,required TResult Function( ChatErrorEvent value)  error,required TResult Function( ChatDoneEvent value)  done,required TResult Function( ChatFollowUpSuggestionsEvent value)  followUpSuggestions,}){
final _that = this;
switch (_that) {
case ChatStepEvent():
return step(_that);case ChatTextDeltaEvent():
return textDelta(_that);case ChatResponseIdEvent():
return responseId(_that);case ChatConversionIdEvent():
return conversionId(_that);case ChatErrorEvent():
return error(_that);case ChatDoneEvent():
return done(_that);case ChatFollowUpSuggestionsEvent():
return followUpSuggestions(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChatStepEvent value)?  step,TResult? Function( ChatTextDeltaEvent value)?  textDelta,TResult? Function( ChatResponseIdEvent value)?  responseId,TResult? Function( ChatConversionIdEvent value)?  conversionId,TResult? Function( ChatErrorEvent value)?  error,TResult? Function( ChatDoneEvent value)?  done,TResult? Function( ChatFollowUpSuggestionsEvent value)?  followUpSuggestions,}){
final _that = this;
switch (_that) {
case ChatStepEvent() when step != null:
return step(_that);case ChatTextDeltaEvent() when textDelta != null:
return textDelta(_that);case ChatResponseIdEvent() when responseId != null:
return responseId(_that);case ChatConversionIdEvent() when conversionId != null:
return conversionId(_that);case ChatErrorEvent() when error != null:
return error(_that);case ChatDoneEvent() when done != null:
return done(_that);case ChatFollowUpSuggestionsEvent() when followUpSuggestions != null:
return followUpSuggestions(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String name,  String status)?  step,TResult Function( String delta)?  textDelta,TResult Function(@JsonKey(name: 'responseId')  String responseId)?  responseId,TResult Function(@JsonKey(name: 'conversionId')  String conversionId)?  conversionId,TResult Function( String message)?  error,TResult Function(@JsonKey(name: 'conversation_id')  String conversationId)?  done,TResult Function( List<String> suggestions)?  followUpSuggestions,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChatStepEvent() when step != null:
return step(_that.name,_that.status);case ChatTextDeltaEvent() when textDelta != null:
return textDelta(_that.delta);case ChatResponseIdEvent() when responseId != null:
return responseId(_that.responseId);case ChatConversionIdEvent() when conversionId != null:
return conversionId(_that.conversionId);case ChatErrorEvent() when error != null:
return error(_that.message);case ChatDoneEvent() when done != null:
return done(_that.conversationId);case ChatFollowUpSuggestionsEvent() when followUpSuggestions != null:
return followUpSuggestions(_that.suggestions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String name,  String status)  step,required TResult Function( String delta)  textDelta,required TResult Function(@JsonKey(name: 'responseId')  String responseId)  responseId,required TResult Function(@JsonKey(name: 'conversionId')  String conversionId)  conversionId,required TResult Function( String message)  error,required TResult Function(@JsonKey(name: 'conversation_id')  String conversationId)  done,required TResult Function( List<String> suggestions)  followUpSuggestions,}) {final _that = this;
switch (_that) {
case ChatStepEvent():
return step(_that.name,_that.status);case ChatTextDeltaEvent():
return textDelta(_that.delta);case ChatResponseIdEvent():
return responseId(_that.responseId);case ChatConversionIdEvent():
return conversionId(_that.conversionId);case ChatErrorEvent():
return error(_that.message);case ChatDoneEvent():
return done(_that.conversationId);case ChatFollowUpSuggestionsEvent():
return followUpSuggestions(_that.suggestions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String name,  String status)?  step,TResult? Function( String delta)?  textDelta,TResult? Function(@JsonKey(name: 'responseId')  String responseId)?  responseId,TResult? Function(@JsonKey(name: 'conversionId')  String conversionId)?  conversionId,TResult? Function( String message)?  error,TResult? Function(@JsonKey(name: 'conversation_id')  String conversationId)?  done,TResult? Function( List<String> suggestions)?  followUpSuggestions,}) {final _that = this;
switch (_that) {
case ChatStepEvent() when step != null:
return step(_that.name,_that.status);case ChatTextDeltaEvent() when textDelta != null:
return textDelta(_that.delta);case ChatResponseIdEvent() when responseId != null:
return responseId(_that.responseId);case ChatConversionIdEvent() when conversionId != null:
return conversionId(_that.conversionId);case ChatErrorEvent() when error != null:
return error(_that.message);case ChatDoneEvent() when done != null:
return done(_that.conversationId);case ChatFollowUpSuggestionsEvent() when followUpSuggestions != null:
return followUpSuggestions(_that.suggestions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ChatStepEvent extends ChatEvent {
  const ChatStepEvent({required this.name, required this.status, final  String? $type}): $type = $type ?? 'step',super._();
  factory ChatStepEvent.fromJson(Map<String, dynamic> json) => _$ChatStepEventFromJson(json);

 final  String name;
 final  String status;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStepEventCopyWith<ChatStepEvent> get copyWith => _$ChatStepEventCopyWithImpl<ChatStepEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatStepEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStepEvent&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,status);

@override
String toString() {
  return 'ChatEvent.step(name: $name, status: $status)';
}


}

/// @nodoc
abstract mixin class $ChatStepEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatStepEventCopyWith(ChatStepEvent value, $Res Function(ChatStepEvent) _then) = _$ChatStepEventCopyWithImpl;
@useResult
$Res call({
 String name, String status
});




}
/// @nodoc
class _$ChatStepEventCopyWithImpl<$Res>
    implements $ChatStepEventCopyWith<$Res> {
  _$ChatStepEventCopyWithImpl(this._self, this._then);

  final ChatStepEvent _self;
  final $Res Function(ChatStepEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = null,}) {
  return _then(ChatStepEvent(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ChatTextDeltaEvent extends ChatEvent {
  const ChatTextDeltaEvent({required this.delta, final  String? $type}): $type = $type ?? 'text_delta',super._();
  factory ChatTextDeltaEvent.fromJson(Map<String, dynamic> json) => _$ChatTextDeltaEventFromJson(json);

 final  String delta;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatTextDeltaEventCopyWith<ChatTextDeltaEvent> get copyWith => _$ChatTextDeltaEventCopyWithImpl<ChatTextDeltaEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatTextDeltaEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatTextDeltaEvent&&(identical(other.delta, delta) || other.delta == delta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,delta);

@override
String toString() {
  return 'ChatEvent.textDelta(delta: $delta)';
}


}

/// @nodoc
abstract mixin class $ChatTextDeltaEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatTextDeltaEventCopyWith(ChatTextDeltaEvent value, $Res Function(ChatTextDeltaEvent) _then) = _$ChatTextDeltaEventCopyWithImpl;
@useResult
$Res call({
 String delta
});




}
/// @nodoc
class _$ChatTextDeltaEventCopyWithImpl<$Res>
    implements $ChatTextDeltaEventCopyWith<$Res> {
  _$ChatTextDeltaEventCopyWithImpl(this._self, this._then);

  final ChatTextDeltaEvent _self;
  final $Res Function(ChatTextDeltaEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? delta = null,}) {
  return _then(ChatTextDeltaEvent(
delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ChatResponseIdEvent extends ChatEvent {
  const ChatResponseIdEvent({@JsonKey(name: 'responseId') required this.responseId, final  String? $type}): $type = $type ?? 'response_id',super._();
  factory ChatResponseIdEvent.fromJson(Map<String, dynamic> json) => _$ChatResponseIdEventFromJson(json);

@JsonKey(name: 'responseId') final  String responseId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatResponseIdEventCopyWith<ChatResponseIdEvent> get copyWith => _$ChatResponseIdEventCopyWithImpl<ChatResponseIdEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatResponseIdEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatResponseIdEvent&&(identical(other.responseId, responseId) || other.responseId == responseId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,responseId);

@override
String toString() {
  return 'ChatEvent.responseId(responseId: $responseId)';
}


}

/// @nodoc
abstract mixin class $ChatResponseIdEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatResponseIdEventCopyWith(ChatResponseIdEvent value, $Res Function(ChatResponseIdEvent) _then) = _$ChatResponseIdEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'responseId') String responseId
});




}
/// @nodoc
class _$ChatResponseIdEventCopyWithImpl<$Res>
    implements $ChatResponseIdEventCopyWith<$Res> {
  _$ChatResponseIdEventCopyWithImpl(this._self, this._then);

  final ChatResponseIdEvent _self;
  final $Res Function(ChatResponseIdEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? responseId = null,}) {
  return _then(ChatResponseIdEvent(
responseId: null == responseId ? _self.responseId : responseId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ChatConversionIdEvent extends ChatEvent {
  const ChatConversionIdEvent({@JsonKey(name: 'conversionId') required this.conversionId, final  String? $type}): $type = $type ?? 'conversion_id',super._();
  factory ChatConversionIdEvent.fromJson(Map<String, dynamic> json) => _$ChatConversionIdEventFromJson(json);

@JsonKey(name: 'conversionId') final  String conversionId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatConversionIdEventCopyWith<ChatConversionIdEvent> get copyWith => _$ChatConversionIdEventCopyWithImpl<ChatConversionIdEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatConversionIdEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatConversionIdEvent&&(identical(other.conversionId, conversionId) || other.conversionId == conversionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversionId);

@override
String toString() {
  return 'ChatEvent.conversionId(conversionId: $conversionId)';
}


}

/// @nodoc
abstract mixin class $ChatConversionIdEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatConversionIdEventCopyWith(ChatConversionIdEvent value, $Res Function(ChatConversionIdEvent) _then) = _$ChatConversionIdEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'conversionId') String conversionId
});




}
/// @nodoc
class _$ChatConversionIdEventCopyWithImpl<$Res>
    implements $ChatConversionIdEventCopyWith<$Res> {
  _$ChatConversionIdEventCopyWithImpl(this._self, this._then);

  final ChatConversionIdEvent _self;
  final $Res Function(ChatConversionIdEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? conversionId = null,}) {
  return _then(ChatConversionIdEvent(
conversionId: null == conversionId ? _self.conversionId : conversionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ChatErrorEvent extends ChatEvent {
  const ChatErrorEvent({required this.message, final  String? $type}): $type = $type ?? 'error',super._();
  factory ChatErrorEvent.fromJson(Map<String, dynamic> json) => _$ChatErrorEventFromJson(json);

 final  String message;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatErrorEventCopyWith<ChatErrorEvent> get copyWith => _$ChatErrorEventCopyWithImpl<ChatErrorEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatErrorEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatErrorEvent&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatEvent.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatErrorEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatErrorEventCopyWith(ChatErrorEvent value, $Res Function(ChatErrorEvent) _then) = _$ChatErrorEventCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatErrorEventCopyWithImpl<$Res>
    implements $ChatErrorEventCopyWith<$Res> {
  _$ChatErrorEventCopyWithImpl(this._self, this._then);

  final ChatErrorEvent _self;
  final $Res Function(ChatErrorEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatErrorEvent(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ChatDoneEvent extends ChatEvent {
  const ChatDoneEvent({@JsonKey(name: 'conversation_id') required this.conversationId, final  String? $type}): $type = $type ?? 'done',super._();
  factory ChatDoneEvent.fromJson(Map<String, dynamic> json) => _$ChatDoneEventFromJson(json);

@JsonKey(name: 'conversation_id') final  String conversationId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDoneEventCopyWith<ChatDoneEvent> get copyWith => _$ChatDoneEventCopyWithImpl<ChatDoneEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatDoneEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDoneEvent&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId);

@override
String toString() {
  return 'ChatEvent.done(conversationId: $conversationId)';
}


}

/// @nodoc
abstract mixin class $ChatDoneEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatDoneEventCopyWith(ChatDoneEvent value, $Res Function(ChatDoneEvent) _then) = _$ChatDoneEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'conversation_id') String conversationId
});




}
/// @nodoc
class _$ChatDoneEventCopyWithImpl<$Res>
    implements $ChatDoneEventCopyWith<$Res> {
  _$ChatDoneEventCopyWithImpl(this._self, this._then);

  final ChatDoneEvent _self;
  final $Res Function(ChatDoneEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? conversationId = null,}) {
  return _then(ChatDoneEvent(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ChatFollowUpSuggestionsEvent extends ChatEvent {
  const ChatFollowUpSuggestionsEvent({final  List<String> suggestions = const [], final  String? $type}): _suggestions = suggestions,$type = $type ?? 'follow_up_suggestions',super._();
  factory ChatFollowUpSuggestionsEvent.fromJson(Map<String, dynamic> json) => _$ChatFollowUpSuggestionsEventFromJson(json);

 final  List<String> _suggestions;
@JsonKey() List<String> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestions);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatFollowUpSuggestionsEventCopyWith<ChatFollowUpSuggestionsEvent> get copyWith => _$ChatFollowUpSuggestionsEventCopyWithImpl<ChatFollowUpSuggestionsEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatFollowUpSuggestionsEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatFollowUpSuggestionsEvent&&const DeepCollectionEquality().equals(other._suggestions, _suggestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_suggestions));

@override
String toString() {
  return 'ChatEvent.followUpSuggestions(suggestions: $suggestions)';
}


}

/// @nodoc
abstract mixin class $ChatFollowUpSuggestionsEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatFollowUpSuggestionsEventCopyWith(ChatFollowUpSuggestionsEvent value, $Res Function(ChatFollowUpSuggestionsEvent) _then) = _$ChatFollowUpSuggestionsEventCopyWithImpl;
@useResult
$Res call({
 List<String> suggestions
});




}
/// @nodoc
class _$ChatFollowUpSuggestionsEventCopyWithImpl<$Res>
    implements $ChatFollowUpSuggestionsEventCopyWith<$Res> {
  _$ChatFollowUpSuggestionsEventCopyWithImpl(this._self, this._then);

  final ChatFollowUpSuggestionsEvent _self;
  final $Res Function(ChatFollowUpSuggestionsEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? suggestions = null,}) {
  return _then(ChatFollowUpSuggestionsEvent(
suggestions: null == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
