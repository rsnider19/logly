create or replace function create_activity_with_details(
  p_user_activity jsonb,
  p_user_activity_details jsonb
)
returns void as $$
declare
  new_user_activity_id uuid;
  start_date timestamptz;
  end_date timestamptz;
  activity_date timestamptz;
begin
  start_date := (p_user_activity->>'activity_start_date')::timestamptz;
  end_date := (p_user_activity->>'activity_end_date')::timestamptz;

  activity_date := start_date;
  while activity_date::date <= end_date::date loop
    -- Parse and insert the user activity record
    insert into public.user_activity (user_id, activity_id, activity_timestamp, comments, activity_name_override)
    select
      auth.uid(),
      (p_user_activity->>'activity_id')::uuid,
      activity_date,
      (p_user_activity->>'comments')::text,
      (p_user_activity->>'activity_name_override')::text
    returning user_activity_id into new_user_activity_id;

    -- Parse and insert the activity details
    insert into public.user_activity_detail (
      user_activity_id, activity_detail_id, text_value, environment_value,
      numeric_value, duration_in_sec, distance_in_meters, liquid_volume_in_liters,
      weight_in_kilograms, lat_lng
    )
    select
      new_user_activity_id,
      a.activity_detail_id,
      (detail->>'text_value')::text,
      (detail->>'environment_value')::public.environment_type,
      (detail->>'numeric_value')::double precision,
      (detail->>'duration_in_sec')::int,
      (detail->>'distance_in_meters')::double precision,
      (detail->>'liquid_volume_in_liters')::double precision,
      (detail->>'weight_in_kilograms')::double precision,
      (detail->>'lat_lng')::geography(point)
    from activity_detail a
      left join jsonb_array_elements(p_user_activity_details) as detail on a.activity_detail_id = (detail->>'activity_detail_id')::uuid
    where a.activity_id = (p_user_activity->>'activity_id')::uuid
    on conflict (user_activity_id, activity_detail_id) do update
    set
      text_value = excluded.text_value,
      environment_value = excluded.environment_value,
      numeric_value = excluded.numeric_value,
      duration_in_sec = excluded.duration_in_sec,
      distance_in_meters = excluded.distance_in_meters,
      liquid_volume_in_liters = excluded.liquid_volume_in_liters,
      weight_in_kilograms = excluded.weight_in_kilograms,
      lat_lng = excluded.lat_lng;

    -- Parse and insert the sub activities
    insert into public.user_activity_sub_activity (user_activity_id, sub_activity_id)
    select new_user_activity_id, sub_activity_id::uuid
    from jsonb_array_elements_text(p_user_activity->'sub_activity_ids') as sub_activity_id;

    activity_date := activity_date + interval '1 day';
  end loop;
end;
$$ language plpgsql;
