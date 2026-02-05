-- period_category_counts: activity counts per category for each time period
-- Used for summary chart
create or replace view period_category_counts
with (security_invoker = true)
as
with data as (
  select ua.user_id,
    ua.activity_date,
    a.activity_id,
    a.activity_category_id
  from user_activity ua
    join activity a using (activity_id)
)
select user_id,
  activity_category_id,
  count(1) filter (where activity_date >= current_date - interval '6 days') as past_week,
  count(1) filter (where activity_date >= current_date - interval '29 days') as past_month,
  count(1) filter (where activity_date >= current_date - interval '364 days') as past_year,
  count(1) as all_time
from data
group by user_id, activity_category_id;

-- daily_category_counts: activity counts per category by day
-- Used for contribution chart and monthly chart
create or replace view daily_category_counts
with (security_invoker = true)
as
with data as (
  select ua.user_id,
    ua.activity_date,
    a.activity_id,
    a.activity_category_id
  from user_activity ua
    join activity a using (activity_id)
)
select user_id,
  activity_date,
  array_agg(
    jsonb_build_object(
      'activity_category_id', activity_category_id,
      'count', count
    )
  ) as categories
from (
  select user_id,
    activity_date,
    activity_category_id,
    count(1) as count
  from data
  group by user_id, activity_date, activity_category_id
) sub
group by user_id, activity_date;

-- dow_category_counts: activity counts per day-of-week and category
-- day_of_week is 0-based indexing starting with Sunday (Postgres date_part('dow'))
-- Used for radar chart
create or replace view dow_category_counts
with (security_invoker = true)
as
with data as (
  select ua.user_id,
    ua.activity_date,
    a.activity_id,
    a.activity_category_id
  from user_activity ua
    join activity a using (activity_id)
)
select user_id,
  date_part('dow', activity_date) as day_of_week,
  activity_category_id,
  count(1) filter (where activity_date >= current_date - interval '6 days') as past_week,
  count(1) filter (where activity_date >= current_date - interval '29 days') as past_month,
  count(1) filter (where activity_date >= current_date - interval '364 days') as past_year,
  count(1) as all_time
from data
group by user_id, date_part('dow', activity_date), activity_category_id;

-- user_stats: streak and consistency data
-- Used for streak card
create or replace view user_stats
with (security_invoker = true)
as
with daily_activity as (
  select distinct ua.user_id, ua.activity_date
  from user_activity ua
    join activity a using (activity_id)
),
islands as (
  select
    user_id,
    activity_date,
    activity_date - (row_number() over (partition by user_id order by activity_date))::int as island
  from daily_activity
),
streaks as (
  select
    user_id,
    max(activity_date) as streak_end,
    count(*)::int as streak_length
  from islands
  group by user_id, island
),
current_streak as (
  select distinct on (user_id)
    user_id,
    case
      when streak_end >= current_date - 1
      then streak_length
      else 0
    end as current_streak
  from streaks
  order by user_id, streak_end desc
),
longest_streak as (
  select distinct on (user_id)
    user_id,
    streak_length as longest_streak
  from streaks
  order by user_id, streak_length desc
),
consistency as (
  select
    user_id,
    round(
      count(*) filter (where activity_date >= current_date - 29) * 100.0 / 30,
      1
    )::double precision as consistency_pct
  from daily_activity
  group by user_id
)
select
  c.user_id,
  coalesce(cs.current_streak, 0) as current_streak,
  coalesce(ls.longest_streak, 0) as longest_streak,
  coalesce(c.consistency_pct, 0) as consistency_pct
from consistency c
  join current_streak cs using (user_id)
  join longest_streak ls using (user_id);
