create function public.search_sub_activities(
  _query text
)
returns setof public.sub_activity
stable
language sql
set search_path = ''
as $$
  select sa.*
  from public.activity a
    join public.sub_activity sa on a.activity_id = sa.activity_id
    left join lateral (
      select a2.activity_id, ua2.created_at
      from public.activity a2
        join public.sub_activity sa2 on a2.activity_id = sa2.activity_id
        join public.user_activity ua2 on a2.activity_id = ua2.activity_id
      where a.activity_id = a2.activity_id
        and sa.sub_activity_id = sa2.sub_activity_id
        and (
          sa2.name operator(extensions.%>) _query
          or _query = ''
        )
      order by extensions.similarity(sa2.name, _query) desc nulls last, ua2.created_at desc nulls last
      limit 1
    ) x on true
  where sa.name operator(extensions.%>) _query
    or _query = ''
  order by extensions.similarity(sa.name, _query) desc nulls last, x.created_at desc nulls last
  limit 10;
$$;
