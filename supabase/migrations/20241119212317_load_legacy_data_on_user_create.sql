create function public.handle_new_user_legacy_data()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  functions_endpoint text;
  service_role_key text;
begin
  select decrypted_secret into functions_endpoint
  from vault.decrypted_secrets
  where name = 'functions-endpoint';
  
  select decrypted_secret into service_role_key
  from vault.decrypted_secrets
  where name = 'service-role-key';

  perform net.http_post(
    url:=concat(functions_endpoint, '/migrate-user'),
    headers:=concat('{ "Content-Type": "application/json", "Authorization": "Bearer ', service_role_key, '" }')::jsonb,
    body:=concat('{ "id": "', new.id, '", "email": "', new.email, '" }')::jsonb
  ) as request_id;
  
  return new;
end;
$$;

create trigger new_user_legacy_data_trigger
  after insert on auth.users
  for each row execute procedure public.handle_new_user_legacy_data();

create or replace function public.handle_external_data_legacy()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  _timezone text;
  _user_id uuid;
  _created_at timestamptz;
  _start_date timestamptz;
  _end_date timestamptz;
  _duration_in_seconds int;
  _unit_of_measure text;
  _distance double precision;
  _distance_in_meters double precision;
  _liquid_volume double precision;
  _liquid_volume_in_liters double precision;
  _weight double precision;
  _weight_in_kilograms double precision;
  _count double precision;
  _activity_id uuid;
  _user_activity_id uuid;
  _sub_activity_ids uuid[];
  _environment text;
  _comments text;
  _activity_name_override text;
begin
  if new.external_data_source <> 'legacy' then
    return new;
  end if;
  
  perform public.set_local_timezone();

  _user_id := new.user_id;
  _created_at := nullif(new.data ->> 'created_at', '')::timestamptz at time zone 'America/Chicago';
  _start_date := nullif(new.data ->> 'start_date', '')::timestamptz at time zone 'America/Chicago';
  _end_date := nullif(new.data ->> 'end_date', '')::timestamptz at time zone 'America/Chicago';
  _duration_in_seconds := nullif(new.data ->> 'duration', '')::int;
  _unit_of_measure := left(upper(nullif(nullif(new.data ->> 'measurement_name', ''), 'n/a')), -1);
  _distance := nullif(new.data ->> 'distance', '')::double precision;
  _distance_in_meters := public.convert_to_meters(_distance, _unit_of_measure);
  _liquid_volume := nullif(new.data ->> 'step_count', '')::double precision;
  _liquid_volume_in_liters := public.convert_to_liters(_liquid_volume, _unit_of_measure);
  _weight := nullif(new.data ->> 'step_count', '')::double precision;
  _weight_in_kilograms := public.convert_to_kilograms(_weight, _unit_of_measure);
  _count := nullif(new.data ->> 'step_count', '')::double precision;
  _environment := nullif(new.data ->> 'classification_name', '');
  _comments := nullif(new.data ->> 'comment', '');
  _activity_name_override := nullif(new.data ->> 'name_override', '');
  _activity_id := (
    select activity_id
    from public.activity
    where legacy_id = (new.data -> 'activity_id')::int
  );
  _sub_activity_ids = (
    select array_agg(sa.sub_activity_id)
    from public.sub_activity sa
      join (
        select unnest(concat('{', new.data ->> 'sub_activity', '}')::int[]) as sub_activity_id
      ) x on sa.legacy_id = x.sub_activity_id
  );

  if _activity_id is not null then
    insert into public.user_activity (user_id, activity_id, created_at, activity_timestamp, external_data_id, comments, activity_name_override)
    values (_user_id, _activity_id, _created_at, _start_date, new.external_data_id, _comments, _activity_name_override)
    returning user_activity_id into _user_activity_id;

    insert into public.user_activity_detail (user_activity_id, activity_detail_id, duration_in_sec)
    select _user_activity_id,
      d.activity_detail_id,
      _duration_in_seconds
    from public.activity_detail d
    where d.activity_id = _activity_id
      and d.activity_detail_type = 'duration'
    on conflict (user_activity_id, activity_detail_id) do update
    set duration_in_sec = _duration_in_seconds;

    insert into public.user_activity_detail (user_activity_id, activity_detail_id, distance_in_meters)
    select _user_activity_id,
      d.activity_detail_id,
      _distance_in_meters
    from public.activity_detail d
    where d.activity_id = _activity_id
      and d.activity_detail_type = 'distance'
    on conflict (user_activity_id, activity_detail_id) do update
    set distance_in_meters = _distance_in_meters;

    insert into public.user_activity_detail (user_activity_id, activity_detail_id, liquid_volume_in_liters)
    select _user_activity_id,
      d.activity_detail_id,
      _liquid_volume_in_liters
    from public.activity_detail d
    where d.activity_id = _activity_id
      and d.activity_detail_type = 'liquidVolume'
    on conflict (user_activity_id, activity_detail_id) do update
    set liquid_volume_in_liters = _liquid_volume_in_liters;

    insert into public.user_activity_detail (user_activity_id, activity_detail_id, weight_in_kilograms)
    select _user_activity_id,
      d.activity_detail_id,
      _weight_in_kilograms
    from public.activity_detail d
    where d.activity_id = _activity_id
      and d.activity_detail_type = 'weight'
    on conflict (user_activity_id, activity_detail_id) do update
    set weight_in_kilograms = _weight_in_kilograms;

    insert into public.user_activity_detail (user_activity_id, activity_detail_id, numeric_value)
    select _user_activity_id,
      d.activity_detail_id,
      _count::int
    from public.activity_detail d
    where d.activity_id = _activity_id
      and d.activity_detail_type = 'integer'
    on conflict (user_activity_id, activity_detail_id) do update
    set numeric_value = _count::int;

    insert into public.user_activity_detail (user_activity_id, activity_detail_id, numeric_value)
    select _user_activity_id,
      d.activity_detail_id,
      _count::double precision
    from public.activity_detail d
    where d.activity_id = _activity_id
      and d.activity_detail_type = 'double'
    on conflict (user_activity_id, activity_detail_id) do update
    set numeric_value = _count::double precision;

    insert into public.user_activity_detail (user_activity_id, activity_detail_id, environment_value)
    select _user_activity_id,
      d.activity_detail_id,
      lower(_environment)::public.environment_type
    from public.activity_detail d
    where d.activity_id = _activity_id
      and d.activity_detail_type = 'environment'
    on conflict (user_activity_id, activity_detail_id) do update
    set environment_value = lower(_environment)::public.environment_type;

    if _sub_activity_ids is not null then
      insert into public.user_activity_sub_activity(user_activity_id, sub_activity_id)
      select _user_activity_id, sub_activity_id
      from unnest(_sub_activity_ids) as sub_activity_id;
    end if;
  end if;

  return new;
end;
$$;

create or replace trigger handle_external_data_trigger_legacy
  after insert on public.external_data
  for each row execute procedure public.handle_external_data_legacy();
