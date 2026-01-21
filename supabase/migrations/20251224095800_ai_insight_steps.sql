-- Add chaining fields to main insight table
alter table public.user_ai_insight add column if not exists openai_response_id text;
alter table public.user_ai_insight add column if not exists openai_conversion_id text;
alter table public.user_ai_insight add column if not exists previous_response_id text;
alter table public.user_ai_insight add column if not exists previous_conversion_id text;

-- Create steps table for granular debugging
create table public.user_ai_insight_step (
  step_id uuid primary key default gen_random_uuid(),
  insight_id uuid references public.user_ai_insight(user_ai_insight_id) on delete cascade not null,
  step_name text not null,
  input_context jsonb,
  output_result jsonb,
  token_usage jsonb,
  duration_ms integer,
  created_at timestamptz default now()
);

-- RLS
alter table public.user_ai_insight_step enable row level security;

create policy "Service role insert steps"
  on public.user_ai_insight_step
  for insert
  with check (true);

drop policy if exists "User AI Insight - insert only self" on public.user_ai_insight;

create policy "User AI Insights Service Role All"
  on public.user_ai_insight_step
  for all
  with check (true);

create or replace view public.user_ai_insights_report
with (security_invoker = on)
as
  with model_pricing as (
  select
    'gpt-5.1' as model,
    1.25 as prompt_cost_per_1m,
    10 as completion_cost_per_1m,
    10 as reasoning_cost_per_1m
  union all
  select
    'gpt-4o-mini' as model,
    0.15 as prompt_cost_per_1m,
    0.60 as completion_cost_per_1m,
    0.60 as reasoning_cost_per_1m
  union all
  select
    'gpt-4.1-mini' as model,
    0.40 as prompt_cost_per_1m,
    1.60 as completion_cost_per_1m,
    1.60 as reasoning_cost_per_1m
)
select user_ai_insight_id,
  user_id,
  created_at,
  user_query,
  nl_to_sql_resp,
  nl_to_sql_timing_ms,
  query_error,
  query_results,
  query_timing_ms,
  friendly_answer_resp,
  friendly_answer_timing_ms,
  nl_to_sql_input_cost,
  nl_to_sql_output_cost,
  friendly_answer_input_cost,
  friendly_answer_output_cost,
  COALESCE(nl_to_sql_input_cost, 0::numeric) + COALESCE(nl_to_sql_output_cost, 0::numeric) + COALESCE(friendly_answer_input_cost, 0::numeric) + COALESCE(friendly_answer_output_cost, 0::numeric) AS total_cost,
  nl_to_sql_timing_ms + query_timing_ms + friendly_answer_timing_ms AS total_time_ms
from user_ai_insight uai
  join lateral (
    select (uai2.nl_to_sql_resp->'usage'->>'input_tokens')::numeric / 1000000 * nl.prompt_cost_per_1m as nl_to_sql_input_cost,
      (uai2.nl_to_sql_resp->'usage'->>'output_tokens')::numeric / 1000000 * nl.completion_cost_per_1m as nl_to_sql_output_cost,
      (uai2.friendly_answer_resp->'usage'->>'input_tokens')::numeric / 1000000 * fr.prompt_cost_per_1m as friendly_answer_input_cost,
      (uai2.friendly_answer_resp->'usage'->>'output_tokens')::numeric / 1000000 * fr.completion_cost_per_1m as friendly_answer_output_cost
    from user_ai_insight uai2
      cross join model_pricing nl
      cross join model_pricing fr
    where uai2.nl_to_sql_resp->>'model' like nl.model || '%'
      and uai2.friendly_answer_resp->>'model' like fr.model || '%'
      and uai.user_ai_insight_id = uai2.user_ai_insight_id
  ) x on true
