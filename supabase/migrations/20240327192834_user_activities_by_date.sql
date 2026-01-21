create table public._user_activities_by_date (
  user_id uuid not null,
  activity_date timestamp with time zone not null,
  activity_count bigint not null,
  user_activities jsonb not null default '[]'::jsonb,
  constraint _user_activities_by_date_pkey primary key (user_id, activity_date),
  constraint public__user_activities_by_date_user_id_fkey foreign key (user_id) references public.profile (user_id)
) tablespace pg_default;

alter table public._user_activities_by_date enable row level security;

create policy "User Activities By Date - select only their own"
  on public._user_activities_by_date
  as permissive for select
  to authenticated
  using (
    user_id = (select auth.uid())
  );

create or replace function public.user_activities_by_date()
returns setof public._user_activities_by_date
stable
language plpgsql
set search_path = ''
as $$
begin
  perform public.set_local_timezone();

  return query
  with date_series as (
    select generate_series(
      least((
        select min(activity_timestamp::date)
        from public.user_activity
        where user_id = auth.uid()
      ), current_date - interval '30 days'),
      current_date,
      interval '1 day'
    )::timestamptz as activity_date
  )
  select
    auth.uid() as user_id,
    ds.activity_date,
    coalesce(count(ua), 0) as activity_count,
    coalesce(
      jsonb_build_object(
        'userActivities', jsonb_build_object(
          '__typename', 'UserActivityConnection',
          'edges', case when count(ua) = 0 then '[]' else jsonb_agg(
            jsonb_build_object(
              '__typename', 'UserActivityEdge',
              'node', jsonb_build_object(
                '__typename', 'UserActivity',
                'userActivityId', ua.user_activity_id,
                'activityTimestamp', ua.activity_timestamp,
                'activityId', ua.activity_id,
                'activityNameOverride', ua.activity_name_override,
                'activity', jsonb_build_object(
                  '__typename', 'Activity',
                  'activityId', a.activity_id,
                  'icon', a.icon,
                  'name', a.name,
                  'activityCategory', jsonb_build_object(
                    '__typename', 'ActivityCategory',
                    'activityCategoryId', ac.activity_category_id,
                    'icon', ac.icon,
                    'name', ac.name,
                    'hexColor', ac.hex_color,
                    'sortOrder', ac.sort_order
                  )
                ),
                'userActivitySubActivityCollection', jsonb_build_object(
                  '__typename', 'UserActivitySubActivityConnection',
                  'edges', coalesce(x.sub_activities, '[]')
                )
              )
            )
            order by ua.created_at desc
          ) end
        )
      ),
      jsonb_build_object(
        'userActivities', jsonb_build_object(
          'edges', '[]'::jsonb
        )
      )
    ) as user_activities
  from date_series ds
  left join public.user_activity ua
    on ds.activity_date = ua.activity_timestamp::date::timestamptz
    and ua.user_id = auth.uid()
  left join public.activity a using (activity_id)
  left join public.activity_category ac using (activity_category_id)
  left join lateral (
      select jsonb_agg(
        jsonb_build_object(
          '__typename', 'UserActivitySubActivityEdge',
          'node', jsonb_build_object(
            '__typename', 'UserActivitySubActivity',
            'subActivity', jsonb_build_object(
              '__typename', 'SubActivity',
              'icon', sa.icon,
              'name', sa.name,
              'activity', jsonb_build_object(
                '__typename', 'Activity',
                'icon', a.icon,
                'name', a.name,
                'activityId', a.activity_id,
                'activityCategory', jsonb_build_object(
                  '__typename', 'ActivityCategory',
                  'icon', ac.icon,
                  'name', ac.name,
                  'hexColor', ac.hex_color,
                  'sortOrder', ac.sort_order,
                  'activityCategoryId', ac.activity_category_id
                ),
                'activityDateType', a.activity_date_type,
                'activityCategoryId', a.activity_category_id
              ),
              'activityId', sa.activity_id,
              'subActivityId', sa.sub_activity_id
            )
          )
        )
      ) as sub_activities
      from public.user_activity_sub_activity uac
        join public.sub_activity sa on uac.sub_activity_id = sa.sub_activity_id
        join public.activity a2 on sa.activity_id = a2.activity_id
        join public.activity_category ac on a.activity_category_id = ac.activity_category_id
      where ua.user_activity_id = uac.user_activity_id
    ) x on true
  where ds.activity_date <= current_timestamp
  group by ds.activity_date, ua.user_id;
end
$$;