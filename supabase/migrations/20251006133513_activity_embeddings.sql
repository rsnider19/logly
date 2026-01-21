alter table public.activity
  add column if not exists embedding_content text null;

create table public.activity_embedding (
  activity_id uuid not null primary key references public.activity(activity_id),
  embedding extensions.halfvec(384),
  fts tsvector,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone null
);

create trigger handle_updated_at
  before update on public.activity_embedding
  for each row execute procedure extensions.moddatetime (updated_at);

create index on public.activity_embedding using hnsw (embedding extensions.halfvec_cosine_ops);
create index on public.activity_embedding using gin (fts);

-- Customize the input for embedding generation
-- e.g. Concatenate title and content with a markdown header
create or replace function public.activity_embedding_input(p_activity public.activity)
returns text
language plpgsql
immutable
as $$
begin
return concat(
    '# ', p_activity.name,
    E'\n\n',
    (select string_agg(sa.name, ', ') from public.sub_activity sa where sa.activity_id = p_activity.activity_id),
    E'\n\n',
    p_activity.embedding_content
  );
end;
$$;

-- Trigger for insert events
drop trigger if exists embed_activity_on_insert on public.activity;
create trigger embed_activity_on_insert
  after insert on public.activity
  for each row execute function util.queue_embeddings('activity_embedding_input', 'embedding');

-- Trigger for update events
drop trigger if exists embed_activity_on_update on public.activity;
create trigger embed_activity_on_update
  after update of name, embedding_content on public.activity
  for each row execute function util.queue_embeddings('activity_embedding_input', 'embedding');

create or replace function public.hybrid_search_activities(
  query_text text,
  query_embedding extensions.halfvec(384),
  match_count int,
  full_text_weight float = 1,
  semantic_weight float = 1,
  rrf_k int = 50
)
returns setof public.activity
language sql
set search_path = 'public', 'extensions'
as $$
  with full_text as (
    select
      activity_id,
      row_number() over(order by ts_rank_cd(fts, websearch_to_tsquery(query_text)) desc) as rank_ix
    from
      public.activity_embedding
    where
      fts @@ websearch_to_tsquery(query_text)
    order by rank_ix
    limit least(match_count, 30) * 2
  ),
  semantic as (
    select
      activity_id,
      row_number() over (order by embedding <#> query_embedding) as rank_ix
    from
      public.activity_embedding
    order by rank_ix
    limit least(match_count, 30) * 2
  )
  select
    activity.*
  from
    full_text
      full outer join semantic on full_text.activity_id = semantic.activity_id
      join public.activity on coalesce(full_text.activity_id, semantic.activity_id) = activity.activity_id
  order by
    coalesce(1.0 / (rrf_k + full_text.rank_ix), 0.0) * full_text_weight +
    coalesce(1.0 / (rrf_k + semantic.rank_ix), 0.0) * semantic_weight desc
    limit least(match_count, 30)
$$;
