import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for chat feature errors.
abstract class ChatException extends AppException {
  const ChatException(super.message, [super.technicalDetails]);
}

/// Connection lost or failed to establish.
class ChatConnectionException extends ChatException {
  const ChatConnectionException([String? technicalDetails])
      : super('Unable to connect. Please try again.', technicalDetails);
}

/// Auth token invalid or expired (HTTP 401).
class ChatAuthException extends ChatException {
  const ChatAuthException() : super('Please sign in again to continue.', 'JWT expired or invalid');
}

/// User not subscribed to premium (HTTP 403).
class ChatPremiumRequiredException extends ChatException {
  const ChatPremiumRequiredException() : super('Premium subscription required.', 'HTTP 403 premium_required');
}

/// Rate limit exceeded (HTTP 429).
class ChatRateLimitException extends ChatException {
  const ChatRateLimitException()
      : super("You've been busy! Try again in a few minutes.", 'HTTP 429 rate_limit_exceeded');
}

/// Stream stalled (no SSE events received for 30 seconds).
class ChatStallException extends ChatException {
  const ChatStallException() : super('Connection stalled. Please try again.', 'No SSE event for 30s');
}
