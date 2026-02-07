// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_stream_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatCompletedStep {

 String get name;
/// Create a copy of ChatCompletedStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCompletedStepCopyWith<ChatCompletedStep> get copyWith => _$ChatCompletedStepCopyWithImpl<ChatCompletedStep>(this as ChatCompletedStep, _$identity);

  /// Serializes this ChatCompletedStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatCompletedStep&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'ChatCompletedStep(name: $name)';
}


}

/// @nodoc
abstract mixin class $ChatCompletedStepCopyWith<$Res>  {
  factory $ChatCompletedStepCopyWith(ChatCompletedStep value, $Res Function(ChatCompletedStep) _then) = _$ChatCompletedStepCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$ChatCompletedStepCopyWithImpl<$Res>
    implements $ChatCompletedStepCopyWith<$Res> {
  _$ChatCompletedStepCopyWithImpl(this._self, this._then);

  final ChatCompletedStep _self;
  final $Res Function(ChatCompletedStep) _then;

/// Create a copy of ChatCompletedStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatCompletedStep].
extension ChatCompletedStepPatterns on ChatCompletedStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatCompletedStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatCompletedStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatCompletedStep value)  $default,){
final _that = this;
switch (_that) {
case _ChatCompletedStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatCompletedStep value)?  $default,){
final _that = this;
switch (_that) {
case _ChatCompletedStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatCompletedStep() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name)  $default,) {final _that = this;
switch (_that) {
case _ChatCompletedStep():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name)?  $default,) {final _that = this;
switch (_that) {
case _ChatCompletedStep() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatCompletedStep implements ChatCompletedStep {
  const _ChatCompletedStep({required this.name});
  factory _ChatCompletedStep.fromJson(Map<String, dynamic> json) => _$ChatCompletedStepFromJson(json);

@override final  String name;

/// Create a copy of ChatCompletedStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCompletedStepCopyWith<_ChatCompletedStep> get copyWith => __$ChatCompletedStepCopyWithImpl<_ChatCompletedStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatCompletedStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatCompletedStep&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'ChatCompletedStep(name: $name)';
}


}

/// @nodoc
abstract mixin class _$ChatCompletedStepCopyWith<$Res> implements $ChatCompletedStepCopyWith<$Res> {
  factory _$ChatCompletedStepCopyWith(_ChatCompletedStep value, $Res Function(_ChatCompletedStep) _then) = __$ChatCompletedStepCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$ChatCompletedStepCopyWithImpl<$Res>
    implements _$ChatCompletedStepCopyWith<$Res> {
  __$ChatCompletedStepCopyWithImpl(this._self, this._then);

  final _ChatCompletedStep _self;
  final $Res Function(_ChatCompletedStep) _then;

/// Create a copy of ChatCompletedStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_ChatCompletedStep(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ChatStreamState {

/// Current connection/stream status.
 ChatConnectionStatus get status;/// Text for UI display (updated as tokens arrive).
 String get displayText;/// Complete accumulated text for copy/accessibility (all deltas concatenated).
 String get fullText;/// Active step label (null when no step is in progress).
 String? get currentStepName;/// Active step status ("start" or "complete").
 String? get currentStepStatus;/// History of completed pipeline steps.
 List<ChatCompletedStep> get completedSteps;/// Response ID for follow-up question chaining.
 String? get responseId;/// Conversion ID for SQL context chaining.
 String? get conversionId;/// The conversation ID (set by backend on first message, persists across requests).
 String? get conversationId;/// Follow-up question suggestions (populated from done event).
 List<String> get followUpSuggestions;/// User-friendly error message.
 String? get errorMessage;/// Whether a silent auto-retry is in progress.
 bool get isRetrying;
/// Create a copy of ChatStreamState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStreamStateCopyWith<ChatStreamState> get copyWith => _$ChatStreamStateCopyWithImpl<ChatStreamState>(this as ChatStreamState, _$identity);

  /// Serializes this ChatStreamState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStreamState&&(identical(other.status, status) || other.status == status)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.fullText, fullText) || other.fullText == fullText)&&(identical(other.currentStepName, currentStepName) || other.currentStepName == currentStepName)&&(identical(other.currentStepStatus, currentStepStatus) || other.currentStepStatus == currentStepStatus)&&const DeepCollectionEquality().equals(other.completedSteps, completedSteps)&&(identical(other.responseId, responseId) || other.responseId == responseId)&&(identical(other.conversionId, conversionId) || other.conversionId == conversionId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&const DeepCollectionEquality().equals(other.followUpSuggestions, followUpSuggestions)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isRetrying, isRetrying) || other.isRetrying == isRetrying));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,displayText,fullText,currentStepName,currentStepStatus,const DeepCollectionEquality().hash(completedSteps),responseId,conversionId,conversationId,const DeepCollectionEquality().hash(followUpSuggestions),errorMessage,isRetrying);

@override
String toString() {
  return 'ChatStreamState(status: $status, displayText: $displayText, fullText: $fullText, currentStepName: $currentStepName, currentStepStatus: $currentStepStatus, completedSteps: $completedSteps, responseId: $responseId, conversionId: $conversionId, conversationId: $conversationId, followUpSuggestions: $followUpSuggestions, errorMessage: $errorMessage, isRetrying: $isRetrying)';
}


}

/// @nodoc
abstract mixin class $ChatStreamStateCopyWith<$Res>  {
  factory $ChatStreamStateCopyWith(ChatStreamState value, $Res Function(ChatStreamState) _then) = _$ChatStreamStateCopyWithImpl;
@useResult
$Res call({
 ChatConnectionStatus status, String displayText, String fullText, String? currentStepName, String? currentStepStatus, List<ChatCompletedStep> completedSteps, String? responseId, String? conversionId, String? conversationId, List<String> followUpSuggestions, String? errorMessage, bool isRetrying
});




}
/// @nodoc
class _$ChatStreamStateCopyWithImpl<$Res>
    implements $ChatStreamStateCopyWith<$Res> {
  _$ChatStreamStateCopyWithImpl(this._self, this._then);

  final ChatStreamState _self;
  final $Res Function(ChatStreamState) _then;

/// Create a copy of ChatStreamState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? displayText = null,Object? fullText = null,Object? currentStepName = freezed,Object? currentStepStatus = freezed,Object? completedSteps = null,Object? responseId = freezed,Object? conversionId = freezed,Object? conversationId = freezed,Object? followUpSuggestions = null,Object? errorMessage = freezed,Object? isRetrying = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChatConnectionStatus,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,fullText: null == fullText ? _self.fullText : fullText // ignore: cast_nullable_to_non_nullable
as String,currentStepName: freezed == currentStepName ? _self.currentStepName : currentStepName // ignore: cast_nullable_to_non_nullable
as String?,currentStepStatus: freezed == currentStepStatus ? _self.currentStepStatus : currentStepStatus // ignore: cast_nullable_to_non_nullable
as String?,completedSteps: null == completedSteps ? _self.completedSteps : completedSteps // ignore: cast_nullable_to_non_nullable
as List<ChatCompletedStep>,responseId: freezed == responseId ? _self.responseId : responseId // ignore: cast_nullable_to_non_nullable
as String?,conversionId: freezed == conversionId ? _self.conversionId : conversionId // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,followUpSuggestions: null == followUpSuggestions ? _self.followUpSuggestions : followUpSuggestions // ignore: cast_nullable_to_non_nullable
as List<String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isRetrying: null == isRetrying ? _self.isRetrying : isRetrying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatStreamState].
extension ChatStreamStatePatterns on ChatStreamState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatStreamState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatStreamState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatStreamState value)  $default,){
final _that = this;
switch (_that) {
case _ChatStreamState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatStreamState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatStreamState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatConnectionStatus status,  String displayText,  String fullText,  String? currentStepName,  String? currentStepStatus,  List<ChatCompletedStep> completedSteps,  String? responseId,  String? conversionId,  String? conversationId,  List<String> followUpSuggestions,  String? errorMessage,  bool isRetrying)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatStreamState() when $default != null:
return $default(_that.status,_that.displayText,_that.fullText,_that.currentStepName,_that.currentStepStatus,_that.completedSteps,_that.responseId,_that.conversionId,_that.conversationId,_that.followUpSuggestions,_that.errorMessage,_that.isRetrying);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatConnectionStatus status,  String displayText,  String fullText,  String? currentStepName,  String? currentStepStatus,  List<ChatCompletedStep> completedSteps,  String? responseId,  String? conversionId,  String? conversationId,  List<String> followUpSuggestions,  String? errorMessage,  bool isRetrying)  $default,) {final _that = this;
switch (_that) {
case _ChatStreamState():
return $default(_that.status,_that.displayText,_that.fullText,_that.currentStepName,_that.currentStepStatus,_that.completedSteps,_that.responseId,_that.conversionId,_that.conversationId,_that.followUpSuggestions,_that.errorMessage,_that.isRetrying);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatConnectionStatus status,  String displayText,  String fullText,  String? currentStepName,  String? currentStepStatus,  List<ChatCompletedStep> completedSteps,  String? responseId,  String? conversionId,  String? conversationId,  List<String> followUpSuggestions,  String? errorMessage,  bool isRetrying)?  $default,) {final _that = this;
switch (_that) {
case _ChatStreamState() when $default != null:
return $default(_that.status,_that.displayText,_that.fullText,_that.currentStepName,_that.currentStepStatus,_that.completedSteps,_that.responseId,_that.conversionId,_that.conversationId,_that.followUpSuggestions,_that.errorMessage,_that.isRetrying);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatStreamState implements ChatStreamState {
  const _ChatStreamState({this.status = ChatConnectionStatus.idle, this.displayText = '', this.fullText = '', this.currentStepName, this.currentStepStatus, final  List<ChatCompletedStep> completedSteps = const [], this.responseId, this.conversionId, this.conversationId, final  List<String> followUpSuggestions = const [], this.errorMessage, this.isRetrying = false}): _completedSteps = completedSteps,_followUpSuggestions = followUpSuggestions;
  factory _ChatStreamState.fromJson(Map<String, dynamic> json) => _$ChatStreamStateFromJson(json);

/// Current connection/stream status.
@override@JsonKey() final  ChatConnectionStatus status;
/// Text for UI display (updated as tokens arrive).
@override@JsonKey() final  String displayText;
/// Complete accumulated text for copy/accessibility (all deltas concatenated).
@override@JsonKey() final  String fullText;
/// Active step label (null when no step is in progress).
@override final  String? currentStepName;
/// Active step status ("start" or "complete").
@override final  String? currentStepStatus;
/// History of completed pipeline steps.
 final  List<ChatCompletedStep> _completedSteps;
/// History of completed pipeline steps.
@override@JsonKey() List<ChatCompletedStep> get completedSteps {
  if (_completedSteps is EqualUnmodifiableListView) return _completedSteps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedSteps);
}

/// Response ID for follow-up question chaining.
@override final  String? responseId;
/// Conversion ID for SQL context chaining.
@override final  String? conversionId;
/// The conversation ID (set by backend on first message, persists across requests).
@override final  String? conversationId;
/// Follow-up question suggestions (populated from done event).
 final  List<String> _followUpSuggestions;
/// Follow-up question suggestions (populated from done event).
@override@JsonKey() List<String> get followUpSuggestions {
  if (_followUpSuggestions is EqualUnmodifiableListView) return _followUpSuggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_followUpSuggestions);
}

/// User-friendly error message.
@override final  String? errorMessage;
/// Whether a silent auto-retry is in progress.
@override@JsonKey() final  bool isRetrying;

/// Create a copy of ChatStreamState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStreamStateCopyWith<_ChatStreamState> get copyWith => __$ChatStreamStateCopyWithImpl<_ChatStreamState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatStreamStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatStreamState&&(identical(other.status, status) || other.status == status)&&(identical(other.displayText, displayText) || other.displayText == displayText)&&(identical(other.fullText, fullText) || other.fullText == fullText)&&(identical(other.currentStepName, currentStepName) || other.currentStepName == currentStepName)&&(identical(other.currentStepStatus, currentStepStatus) || other.currentStepStatus == currentStepStatus)&&const DeepCollectionEquality().equals(other._completedSteps, _completedSteps)&&(identical(other.responseId, responseId) || other.responseId == responseId)&&(identical(other.conversionId, conversionId) || other.conversionId == conversionId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&const DeepCollectionEquality().equals(other._followUpSuggestions, _followUpSuggestions)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isRetrying, isRetrying) || other.isRetrying == isRetrying));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,displayText,fullText,currentStepName,currentStepStatus,const DeepCollectionEquality().hash(_completedSteps),responseId,conversionId,conversationId,const DeepCollectionEquality().hash(_followUpSuggestions),errorMessage,isRetrying);

@override
String toString() {
  return 'ChatStreamState(status: $status, displayText: $displayText, fullText: $fullText, currentStepName: $currentStepName, currentStepStatus: $currentStepStatus, completedSteps: $completedSteps, responseId: $responseId, conversionId: $conversionId, conversationId: $conversationId, followUpSuggestions: $followUpSuggestions, errorMessage: $errorMessage, isRetrying: $isRetrying)';
}


}

/// @nodoc
abstract mixin class _$ChatStreamStateCopyWith<$Res> implements $ChatStreamStateCopyWith<$Res> {
  factory _$ChatStreamStateCopyWith(_ChatStreamState value, $Res Function(_ChatStreamState) _then) = __$ChatStreamStateCopyWithImpl;
@override @useResult
$Res call({
 ChatConnectionStatus status, String displayText, String fullText, String? currentStepName, String? currentStepStatus, List<ChatCompletedStep> completedSteps, String? responseId, String? conversionId, String? conversationId, List<String> followUpSuggestions, String? errorMessage, bool isRetrying
});




}
/// @nodoc
class __$ChatStreamStateCopyWithImpl<$Res>
    implements _$ChatStreamStateCopyWith<$Res> {
  __$ChatStreamStateCopyWithImpl(this._self, this._then);

  final _ChatStreamState _self;
  final $Res Function(_ChatStreamState) _then;

/// Create a copy of ChatStreamState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? displayText = null,Object? fullText = null,Object? currentStepName = freezed,Object? currentStepStatus = freezed,Object? completedSteps = null,Object? responseId = freezed,Object? conversionId = freezed,Object? conversationId = freezed,Object? followUpSuggestions = null,Object? errorMessage = freezed,Object? isRetrying = null,}) {
  return _then(_ChatStreamState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChatConnectionStatus,displayText: null == displayText ? _self.displayText : displayText // ignore: cast_nullable_to_non_nullable
as String,fullText: null == fullText ? _self.fullText : fullText // ignore: cast_nullable_to_non_nullable
as String,currentStepName: freezed == currentStepName ? _self.currentStepName : currentStepName // ignore: cast_nullable_to_non_nullable
as String?,currentStepStatus: freezed == currentStepStatus ? _self.currentStepStatus : currentStepStatus // ignore: cast_nullable_to_non_nullable
as String?,completedSteps: null == completedSteps ? _self._completedSteps : completedSteps // ignore: cast_nullable_to_non_nullable
as List<ChatCompletedStep>,responseId: freezed == responseId ? _self.responseId : responseId // ignore: cast_nullable_to_non_nullable
as String?,conversionId: freezed == conversionId ? _self.conversionId : conversionId // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,followUpSuggestions: null == followUpSuggestions ? _self._followUpSuggestions : followUpSuggestions // ignore: cast_nullable_to_non_nullable
as List<String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isRetrying: null == isRetrying ? _self.isRetrying : isRetrying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
