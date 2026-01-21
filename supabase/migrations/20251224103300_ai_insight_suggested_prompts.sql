-- Suggested prompts for AI Insights empty state
create table public.ai_insight_suggested_prompt (
  prompt_id uuid primary key default gen_random_uuid(),
  prompt_text text not null,
  display_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz default now()
);

-- RLS - read only for authenticated users
alter table public.ai_insight_suggested_prompt enable row level security;

create policy "Authenticated users can read prompts"
  on public.ai_insight_suggested_prompt
  for select
  to authenticated
  using (is_active = true);

-- Seed initial prompts
insert into public.ai_insight_suggested_prompt (prompt_text, display_order) values
  ('Show me trends over the past 3 months.', 1),
  ('Summarize my workouts over the past year.', 2),
  ('How far did I run last month?', 3);
