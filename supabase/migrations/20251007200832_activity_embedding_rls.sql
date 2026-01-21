alter table public.activity_embedding enable row level security;

create policy activity_embedding_select_policy
  on public.activity_embedding
  for select
  to authenticated
  using (
    activity_id in (
      select a.activity_id
      from public.activity a
    )
  );
