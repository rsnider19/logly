with user_days as (
  select *
  from (
    select
      user_id,
      generate_series(current_date - interval '500 days', current_date, interval '1 day')::date as day
    from public.profile
  ) x
  where random() >= 0.5
),
all_data as (
  select row_number() over(partition by ra.user_id, ra.day order by random()) as row_num,
    ra.user_id,
    ra.day,
    a.activity_id
  from user_days ra
    cross join public.activity a
)
insert into user_activity(user_id, activity_id, created_at, activity_timestamp)
select user_id,
  activity_id,
  day + (floor(random() * 24) || ' hours')::interval,
  day + (floor(random() * 24) || ' hours')::interval
from all_data
where row_num between 1 and 10 * random();

insert into favorite_user_activity(user_id, activity_id)
select u.id, a.activity_id
from activity a
  cross join auth.users u
where u.email = 'daphnee@foo.com'
order by random()
limit 10;

truncate table public.trending_activity;
insert into trending_activity(activity_id, activity_category_id, previous_rank, current_rank, rank_change)
select * from public.global_trending_activity();
