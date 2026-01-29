-- Fix: to_tsquery fails when query_text contains spaces (e.g. "weight lifting").
-- Adds a helper that sanitizes raw user input into a valid prefix-matching tsquery,
-- then recreates hybrid_search_activities to use it.

-- Safely converts raw user text into a prefix-matching tsquery.
-- Strips special characters, splits on whitespace, and joins with :* &.
--
-- Examples:
--   'weight'           -> 'weight:*'::tsquery
--   'weight lifting'   -> 'weight:* & lifting:*'::tsquery
--   'bench-press'      -> 'bench:* & press:*'::tsquery
--   '' or NULL          -> NULL (matches nothing)
create or replace function public.safe_prefix_tsquery(raw_query text)
returns tsquery
language sql
immutable
as $$
  select case
    when nullif(
      trim(regexp_replace(coalesce(raw_query, ''), '[^\w\s]', ' ', 'g')),
      ''
    ) is null then null::tsquery
    else to_tsquery(
      regexp_replace(
        trim(regexp_replace(raw_query, '[^\w\s]', ' ', 'g')),
        '\s+', ':* & ', 'g'
      ) || ':*'
    )
  end;
$$;

create or replace function public.hybrid_search_activities(
  query_text text,
  query_embedding extensions.halfvec(384),
  match_count int,
  rrf_k int = 50,
  fts_weight float = 3.0,
  trigram_weight float = 1.5,
  semantic_weight float = 1.0,
  sub_weight_multiplier float = 0.8
)
returns setof public.activity
language sql
set search_path = 'public', 'extensions'
as $$
  with

  -- FTS search on activity names (from embedding)
  fts_hits as (
    select
      ae.activity_id,
      ts_rank_cd(ae.fts, safe_prefix_tsquery(query_text)) as fts_rank
    from public.activity_embedding ae
    where ae.fts @@ safe_prefix_tsquery(query_text)
    order by fts_rank desc
    limit least(match_count, 30) * 2
  ),

  -- Trigram similarity on activity names (need to join activity table)
  trigram_hits as (
    select
      ae.activity_id,
      similarity(a.name, query_text) as trigram_score
    from public.activity_embedding ae
    join public.activity a on a.activity_id = ae.activity_id
    where a.name % query_text
    order by trigram_score desc
    limit least(match_count, 30) * 2
  ),

  -- Embedding similarity (vector distance)
  semantic_hits as (
    select
      ae.activity_id,
      ae.embedding <#> query_embedding as semantic_distance
    from public.activity_embedding ae
    order by semantic_distance
    limit least(match_count, 30) * 2
  ),

  -- Sub-activity hits aggregated to parent activity
  subactivity_hits as (
    select
      sa.activity_id,  -- get parent activity id from sub_activity table
      min(sae.embedding <#> query_embedding) as best_semantic_distance,
      max(similarity(sa.name, query_text)) as best_trigram_score,
      max(ts_rank_cd(sae.fts, safe_prefix_tsquery(query_text))) as best_fts_rank
    from public.sub_activity_embedding sae
    join public.sub_activity sa
      on sa.sub_activity_id = sae.sub_activity_id  -- get sub_activity name and parent activity
    where sae.fts @@ safe_prefix_tsquery(query_text)
      or sa.name % query_text
      or sae.embedding <#> query_embedding < 0.8
    group by sa.activity_id
  )

  select a.*
  from public.activity a
    left join fts_hits on a.activity_id = fts_hits.activity_id
    left join trigram_hits on a.activity_id = trigram_hits.activity_id
    left join semantic_hits on a.activity_id = semantic_hits.activity_id
    left join subactivity_hits on a.activity_id = subactivity_hits.activity_id
  order by (
    -- Main activity weights
    coalesce(1.0 / (rrf_k + fts_hits.fts_rank), 0.0) * fts_weight +
    coalesce(trigram_hits.trigram_score, 0.0) * trigram_weight +
    coalesce(1.0 / (rrf_k + semantic_hits.semantic_distance), 0.0) * semantic_weight +
    -- Sub-activity contributions scaled by multiplier
    coalesce(1.0 / (rrf_k + subactivity_hits.best_fts_rank), 0.0) * fts_weight * sub_weight_multiplier +
    coalesce(subactivity_hits.best_trigram_score, 0.0) * trigram_weight * sub_weight_multiplier +
    coalesce(1.0 / (rrf_k + subactivity_hits.best_semantic_distance), 0.0) * semantic_weight * sub_weight_multiplier
  ) desc
  limit least(match_count, 30);
$$;
