create or replace function public.user_activity_day_count(
  start_date timestamp with time zone,
  end_date timestamp with time zone
)
returns jsonb
stable
language plpgsql
set search_path = ''
as $$
begin
  perform public.set_local_timezone();

  return (
    with daily_activity_count as (
      select
        user_id,
        max(activity_timestamp) as activity_day,
        count(1)::int activity_count
      from
        public.user_activity
      where
        user_id = auth.uid() and
        activity_timestamp between start_date and end_date
      group by
        user_id, activity_timestamp::date
    )
    select jsonb_build_object(
      'data', jsonb_agg(to_jsonb(d))
    ) as result
    from daily_activity_count d
  );
end;
$$;
