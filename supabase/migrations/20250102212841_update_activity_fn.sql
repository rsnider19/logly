create or replace function update_activity_with_details(
  p_user_activity jsonb,
  p_user_activity_details jsonb
)
returns void as $$
begin
  -- Parse and insert the user activity record
  update public.user_activity
  set
    activity_timestamp = (p_user_activity->>'activity_timestamp')::timestamptz,
    comments = (p_user_activity->>'comments')::text,
    activity_name_override = (p_user_activity->>'activity_name_override')::text
  where user_activity_id = (p_user_activity->>'user_activity_id')::uuid;

  -- Parse and insert the activity details
  insert into public.user_activity_detail (
    user_activity_id, activity_detail_id, text_value, environment_value,
    numeric_value, duration_in_sec, distance_in_meters, liquid_volume_in_liters,
    weight_in_kilograms, lat_lng
  )
  select
    (p_user_activity->>'user_activity_id')::uuid,
    (detail->>'activity_detail_id')::uuid,
    (detail->>'text_value')::text,
    (detail->>'environment_value')::public.environment_type,
    (detail->>'numeric_value')::double precision,
    (detail->>'duration_in_sec')::int,
    (detail->>'distance_in_meters')::double precision,
    (detail->>'liquid_volume_in_liters')::double precision,
    (detail->>'weight_in_kilograms')::double precision,
    (detail->>'lat_lng')::geography(point)
  from jsonb_array_elements(p_user_activity_details) as detail
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

  delete from public.user_activity_sub_activity
  where user_activity_id = (p_user_activity->>'user_activity_id')::uuid;

  -- Parse and insert the sub activities
  insert into public.user_activity_sub_activity (user_activity_id, sub_activity_id)
  select
    (p_user_activity->>'user_activity_id')::uuid,
    sub_activity_id::uuid
  from jsonb_array_elements_text(p_user_activity->'sub_activity_ids') as sub_activity_id;
end;
$$ language plpgsql;
