/**
 * Persistence module for chat conversations and messages.
 *
 * The edge function (backend) owns all writes to chat tables.
 * Uses service_role key to bypass RLS for writes.
 */

import { createClient } from "npm:@supabase/supabase-js";

// Use service_role for server-side writes (bypasses RLS)
const supabaseAdmin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

export interface ConversationContext {
  conversationId: string;
  lastResponseId?: string;
  lastConversionId?: string;
}

/**
 * Creates a new conversation or returns existing one.
 *
 * If conversationId is provided in request, returns it.
 * Otherwise creates a new conversation with the first message as title.
 */
export async function getOrCreateConversation(
  userId: string,
  userMessage: string,
  existingConversationId?: string
): Promise<string> {
  // If continuing existing conversation, verify it exists and belongs to user
  if (existingConversationId) {
    const { data: existing } = await supabaseAdmin
      .from("chat_conversations")
      .select("conversation_id")
      .eq("conversation_id", existingConversationId)
      .eq("user_id", userId)
      .single();

    if (existing) {
      return existingConversationId;
    }
    // If not found, fall through to create new
    console.warn(
      `[Persistence] Conversation ${existingConversationId} not found for user, creating new`
    );
  }

  // Create new conversation
  const title =
    userMessage.length > 50
      ? `${userMessage.substring(0, 47)}...`
      : userMessage;

  const { data, error } = await supabaseAdmin
    .from("chat_conversations")
    .insert({
      user_id: userId,
      title,
    })
    .select("conversation_id")
    .single();

  if (error) {
    console.error("[Persistence] Failed to create conversation:", error);
    throw new Error("Failed to create conversation");
  }

  return data.conversation_id;
}

/**
 * Saves the user message to the conversation.
 * Called before processing the request.
 */
export async function saveUserMessage(
  conversationId: string,
  content: string
): Promise<string> {
  const { data, error } = await supabaseAdmin
    .from("chat_messages")
    .insert({
      conversation_id: conversationId,
      role: "user",
      content,
    })
    .select("message_id")
    .single();

  if (error) {
    console.error("[Persistence] Failed to save user message:", error);
    throw new Error("Failed to save user message");
  }

  return data.message_id;
}

/**
 * Saves the AI response message.
 * Called after response generation completes.
 */
export async function saveAssistantMessage(
  conversationId: string,
  content: string,
  metadata?: {
    followUpSuggestions?: string[];
    steps?: string[];
  }
): Promise<string> {
  const { data, error } = await supabaseAdmin
    .from("chat_messages")
    .insert({
      conversation_id: conversationId,
      role: "assistant",
      content,
      metadata: metadata
        ? {
            follow_up_suggestions: metadata.followUpSuggestions,
            steps: metadata.steps,
          }
        : null,
    })
    .select("message_id")
    .single();

  if (error) {
    console.error("[Persistence] Failed to save assistant message:", error);
    throw new Error("Failed to save assistant message");
  }

  return data.message_id;
}

/**
 * Updates conversation with latest response/conversion IDs.
 * Called after response generation completes.
 */
export async function updateConversationIds(
  conversationId: string,
  responseId?: string,
  conversionId?: string
): Promise<void> {
  const { error } = await supabaseAdmin
    .from("chat_conversations")
    .update({
      last_response_id: responseId,
      last_conversion_id: conversionId,
      updated_at: new Date().toISOString(),
    })
    .eq("conversation_id", conversationId);

  if (error) {
    console.error("[Persistence] Failed to update conversation IDs:", error);
    // Non-fatal - don't throw
  }
}

/**
 * Gets conversation context (IDs for follow-up chaining).
 */
export async function getConversationContext(
  conversationId: string,
  userId: string
): Promise<ConversationContext | null> {
  const { data, error } = await supabaseAdmin
    .from("chat_conversations")
    .select("conversation_id, last_response_id, last_conversion_id")
    .eq("conversation_id", conversationId)
    .eq("user_id", userId)
    .single();

  if (error || !data) return null;

  return {
    conversationId: data.conversation_id,
    lastResponseId: data.last_response_id,
    lastConversionId: data.last_conversion_id,
  };
}
