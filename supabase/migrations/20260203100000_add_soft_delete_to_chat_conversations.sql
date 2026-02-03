-- Add soft delete support to chat_conversations table.
-- Conversations are retained for analytics but hidden from user's history list.

-- Add deleted_at column for soft deletes
ALTER TABLE public.chat_conversations
  ADD COLUMN deleted_at timestamptz;

-- Create partial index for efficient queries filtering out deleted conversations
CREATE INDEX idx_chat_conversations_user_not_deleted
  ON public.chat_conversations (user_id, updated_at DESC)
  WHERE deleted_at IS NULL;

-- Drop the old index (replaced by partial index above)
DROP INDEX IF EXISTS idx_chat_conversations_user;
