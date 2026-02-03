-- Chat conversation history tables for the Logly chat feature.
-- Backend (edge function) owns all persistence; client is UI only.

-- ============================================================================
-- chat_conversations table
-- ============================================================================
-- Stores conversation metadata including follow-up IDs for multi-turn context.

CREATE TABLE IF NOT EXISTS public.chat_conversations (
  conversation_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title text,
  last_response_id text,
  last_conversion_id text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- RLS: users can only access their own conversations
ALTER TABLE public.chat_conversations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own conversations"
  ON public.chat_conversations
  FOR ALL
  USING (user_id = auth.uid());

-- Index for listing user's conversations sorted by recency
CREATE INDEX idx_chat_conversations_user
  ON public.chat_conversations (user_id, updated_at DESC);

-- ============================================================================
-- chat_messages table
-- ============================================================================
-- Stores individual messages within a conversation.

CREATE TABLE IF NOT EXISTS public.chat_messages (
  message_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL REFERENCES public.chat_conversations(conversation_id) ON DELETE CASCADE,
  role text NOT NULL CHECK (role IN ('user', 'assistant', 'system')),
  content text NOT NULL,
  metadata jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- RLS: users can only access messages in their own conversations
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own messages"
  ON public.chat_messages
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.chat_conversations c
      WHERE c.conversation_id = chat_messages.conversation_id
        AND c.user_id = auth.uid()
    )
  );

-- Index for loading messages in chronological order
CREATE INDEX idx_chat_messages_conversation
  ON public.chat_messages (conversation_id, created_at);
