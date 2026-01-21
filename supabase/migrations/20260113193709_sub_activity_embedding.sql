-- change activities embeddings
create or replace function public.activity_embedding_input(p_activity public.activity)
returns text
language plpgsql
immutable
as $$
begin
return concat(
  '# ', p_activity.name,
  E'\n',
  p_activity.embedding_content
);
end;
$$;

alter table public.sub_activity
  add column if not exists embedding_content text null;

create table public.sub_activity_embedding (
  sub_activity_id uuid primary key not null references public.sub_activity(sub_activity_id),
  embedding extensions.halfvec(384),
  fts tsvector,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone null
);

create trigger handle_updated_at
  before update on public.sub_activity_embedding
  for each row execute procedure extensions.moddatetime (updated_at);

create index on public.sub_activity_embedding using hnsw (embedding extensions.halfvec_cosine_ops);
create index on public.sub_activity_embedding using gin (fts);

-- Customize the input for embedding generation
-- e.g. Concatenate title and content with a markdown header
create or replace function public.sub_activity_embedding_input(p_sub_activity public.sub_activity)
returns text
language plpgsql
immutable
as $$
begin
return concat(
  '# ', p_sub_activity.name,
  E'\n',
  p_sub_activity.embedding_content
 );
end;
$$;

-- Trigger for insert events
drop trigger if exists embed_sub_activity_on_insert on public.sub_activity;
create trigger embed_sub_activity_on_insert
  after insert on public.sub_activity
  for each row execute function util.queue_embeddings('sub_activity_embedding_input', 'embedding');

-- Trigger for update events
drop trigger if exists embed_sub_activity_on_update on public.sub_activity;
create trigger embed_sub_activity_on_update
  after update of name, embedding_content on public.sub_activity
  for each row execute function util.queue_embeddings('sub_activity_embedding_input', 'embedding');

alter table public.sub_activity_embedding enable row level security;
create policy sub_activity_embedding_select_policy
  on public.sub_activity_embedding
  for select
  to authenticated
  using (
    sub_activity_id in (
      select sa.sub_activity_id
      from public.sub_activity sa
    )
  );

create index if not exists idx_activity_name_trgm on public.activity using gin (name extensions.gin_trgm_ops);
create index if not exists idx_sub_activity_name_trgm on public.sub_activity using gin (name extensions.gin_trgm_ops);

drop function hybrid_search_activities;

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
      ts_rank_cd(ae.fts, to_tsquery(query_text || ':*')) as fts_rank
    from public.activity_embedding ae
    where ae.fts @@ to_tsquery(query_text || ':*')
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
      max(ts_rank_cd(sae.fts, to_tsquery(query_text || ':*'))) as best_fts_rank
    from public.sub_activity_embedding sae
    join public.sub_activity sa 
      on sa.sub_activity_id = sae.sub_activity_id  -- get sub_activity name and parent activity
    where sae.fts @@ to_tsquery(query_text || ':*') 
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
