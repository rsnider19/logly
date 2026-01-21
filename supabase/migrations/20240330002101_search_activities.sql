create function public.search_activities(
  _query text
)
returns setof public.activity
stable
language sql
set search_path = ''
as $$
  select a.*
  from public.activity a
    left join lateral (
      select a2.activity_id, ua2.created_at
      from public.activity a2
        join public.user_activity ua2 on a2.activity_id = ua2.activity_id
      where a.activity_id = a2.activity_id
        and (
          a2.name operator(extensions.%>) _query
          or _query = ''
        )
      order by extensions.similarity(a2.name, _query) desc nulls last, ua2.created_at desc nulls last
      limit 1
    ) x on true
  where a.name operator(extensions.%>) _query
    or _query = ''
  order by extensions.similarity(a.name, _query) desc nulls last, x.created_at desc nulls last
  limit 10;
$$;
