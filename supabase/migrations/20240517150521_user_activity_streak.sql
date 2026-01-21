create table public._user_activity_streak (
  user_id uuid not null,
  longest_streak int not null default 0,
  current_streak int not null default 0,
  workout_days_this_week int not null default 0,
  constraint _user_activity_streak_pkey primary key (user_id),
  constraint public__user_activity_streak_user_id_fkey foreign key (user_id) references public.profile (user_id)
) tablespace pg_default;

alter table public._user_activity_streak enable row level security;

create policy "User Activity Streak - select only their own"
  on public._user_activity_streak
  as permissive for select
  to authenticated
  using (
    user_id = (select auth.uid())
  );

create or replace function public.user_activity_streak()
returns public._user_activity_streak
stable
language plpgsql
set search_path = ''
as $$
declare
    user_id uuid;
    longest_streak int;
    current_streak int;
    workout_days_this_week int;
begin
  perform public.set_local_timezone();

  with user_activities as (
    select activity_date,
      activity_date - interval '1 day' * row_number() over (order by activity_date) as streak_group
    from (
      select distinct activity_timestamp::date as activity_date
      from public.user_activity ua
      where ua.user_id = auth.uid()
        and ua.activity_timestamp < (current_date + interval '1 day')
    ) ua
    order by activity_date
  ),
  streaks as (
      select min(activity_date) as streak_start_date,
        max(activity_date) as streak_end_date,
        count(*) as streak_length
      from user_activities
      group by streak_group
  ),
  workout_days_this_week as (
      select count(distinct ua.activity_timestamp::date) as workout_days_this_week
      from public.user_activity ua
        join public.activity a using (activity_id)
        join public.activity_category ac using (activity_category_id)
      where ua.user_id = auth.uid()
        and ac.activity_category_code = any(array['workouts', 'sports'])
        and ua.activity_timestamp >= (current_date - extract(dow from current_date)::integer)
  )
  select auth.uid(),
    coalesce(s.longest_streak, 0) as longest_streak,
    coalesce(s.current_streak, 0) as current_streak,
    coalesce(w.workout_days_this_week, 0) as workout_days_this_week
  into user_id, longest_streak, current_streak, workout_days_this_week
  from workout_days_this_week w
    right join (
      select max(s.streak_length) as longest_streak,
        max(s.streak_length) filter (where s.streak_end_date = current_date) as current_streak
      from streaks s
    ) s on true;

    return (
      user_id,
      longest_streak,
      current_streak,
      workout_days_this_week
    )::public._user_activity_streak;
end
$$;
