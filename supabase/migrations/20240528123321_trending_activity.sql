create table public.trending_activity (
  activity_id uuid not null,
  activity_category_id uuid null,
  previous_rank integer not null,
  current_rank integer not null,
  rank_change integer not null,
  constraint trending_activity_pkey primary key (activity_id),
  constraint public_trending_activity_activity_id_fkey foreign key (activity_id) references public.activity (activity_id),
  constraint public_trending_activity_activity_category_id_fkey foreign key (activity_category_id) references public.activity_category (activity_category_id)
) tablespace pg_default;

alter table public.trending_activity enable row level security;

create policy "Trending Activity - select for authenticated users"
  on public.trending_activity
  as permissive for select
  to authenticated
  using (true);

comment on constraint public_trending_activity_activity_id_fkey
  on public.trending_activity
  is E'@graphql({"foreign_name": "activity", "local_name": "trendingActivity"})';

create function public.global_trending_activity()
returns setof public.trending_activity
stable
language sql
set search_path = ''
as $$
  with current_activity_scores as (
    select activity_id,
      sum(exp(extract(epoch from (now() - created_at)) / -86400)) as current_recency_score
    from public.user_activity
    where created_at >= now() - interval '1 week'
    group by activity_id
  ),
  previous_activity_scores as (
    select activity_id,
      sum(exp(extract(epoch from (now() - interval '1 week' - created_at)) / -86400)) as previous_recency_score
    from public.user_activity
    where created_at >= now() - interval '2 week' and created_at < now() - interval '1 week'
    group by activity_id
  ),
  ranked_activities as (
    select c.activity_id,
      c.current_recency_score,
      coalesce(p.previous_recency_score, 0) as previous_recency_score,
      rank() over (order by coalesce(p.previous_recency_score, 0) desc) previous_rank,
      rank() over (order by c.current_recency_score desc) current_rank
    from current_activity_scores c
      left join previous_activity_scores p on c.activity_id = p.activity_id
  )
  select ra.activity_id,
    a.activity_category_id,
    ra.previous_rank,
    ra.current_rank,
    ra.previous_rank - ra.current_rank as rank_change
  from ranked_activities ra
    join public.activity a using(activity_id)
  order by current_rank asc;
$$;

select cron.schedule(
  'hourly_global_trending_activity_job',
  '0 * * * *',
  $$
    truncate table public.trending_activity;

    insert into public.trending_activity(activity_id, activity_category_id, previous_rank, current_rank, rank_change)
    select * from public.global_trending_activity();
  $$
);
