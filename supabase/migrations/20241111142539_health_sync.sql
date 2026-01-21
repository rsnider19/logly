alter table public.profile
add column last_health_sync_date timestamp with time zone null;

create type public.external_data_source as enum (
  'legacy',
  'apple_google'
);

create table public.external_data_mapping (
  external_data_mapping_id uuid primary key default gen_random_uuid(),
  external_data_source public.external_data_source not null,
  source_name text not null,
  activity_id uuid null references public.activity(activity_id),
  sub_activity_id uuid null references public.sub_activity(sub_activity_id),
  constraint external_data_mapping_reference check (
    activity_id <> null and sub_activity_id is null or
    activity_id is null and sub_activity_id <> null
  )
);

alter table public.external_data_mapping enable row level security;

create table public.external_data (
  external_data_id uuid not null,
  user_id uuid not null default auth.uid() references public.profile(user_id) on delete cascade,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone null,
  external_data_source public.external_data_source not null,
  data jsonb not null
);

alter table public.external_data add primary key (external_data_id, user_id);
alter table public.external_data enable row level security;

create policy "External Data - select for authenticated users"
  on public.external_data
  as permissive for select
  to authenticated
  using (
    user_id = (select auth.uid())
  );

create policy "External Data - insert for authenticated users"
  on public.external_data
  as permissive for insert
  to authenticated
  with check (
    user_id = (select auth.uid())
  );

create policy "External Data - update for authenticated users"
  on public.external_data
  as permissive for update
  to authenticated
  using (
    user_id = (select auth.uid())
  )
  with check (
    user_id = (select auth.uid())
  );

alter table public.user_activity
  add column external_data_id uuid null;

alter table public.user_activity
  add constraint user_activity_external_data_id_fkey
  foreign key (external_data_id, user_id)
  references public.external_data(external_data_id, user_id);

create trigger handle_updated_at before update on public.external_data
  for each row execute procedure moddatetime (updated_at);

create or replace function public.convert_to_meters(
  distance double precision,
  distance_unit text
) returns double precision
language plpgsql
immutable
as $$
declare
  conversion_factor float;
begin
  if distance is null or distance_unit is null then
    return null;
  end if;

  case upper(distance_unit)
    when 'METER' then
      conversion_factor := 1.0;
    when 'INCH' then
      conversion_factor := 0.0254;
    when 'FOOT' then
      conversion_factor := 0.3048;
    when 'YARD' then
      conversion_factor := 0.9144;
    when 'MILE' then
      conversion_factor := 1609.34;
    when 'KILOMETER' then
      conversion_factor := 1000.0;
    else
      return null;
  end case;

  return distance * conversion_factor;
end;
$$;

create or replace function public.convert_to_liters(
  liquid_volume double precision,
  liquid_volume_unit text
) returns double precision
language plpgsql
immutable
as $$
declare
  conversion_factor float;
begin
  if liquid_volume is null or liquid_volume_unit is null then
    return null;
  end if;

  case upper(liquid_volume_unit)
    when 'OUNCE' then
      conversion_factor := 0.0295735;
    when 'LITER' then
      conversion_factor := 1.0;
    else
      return null;
  end case;

  return liquid_volume * conversion_factor;
end;
$$;

create or replace function public.convert_to_kilograms(
  weight double precision,
  weight_unit text
) returns double precision
language plpgsql
immutable
as $$
declare
  conversion_factor float;
begin
  if weight is null or weight_unit is null then
    return null;
  end if;

  case upper(weight_unit)
    when 'POUND' then
      conversion_factor := 0.453592;
    when 'KILOGRAM' then
      conversion_factor := 1.0;
    else
      return null;
  end case;

  return weight * conversion_factor;
end;
$$;

create or replace function public.handle_external_data_apple_google()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  _user_id uuid;
  _start_date timestamptz;
  _end_date timestamptz;
  _distance_unit text;
  _distance float;
  _duration_in_seconds int;
  _distance_in_meters float;
  _activity_id uuid;
  _sub_activity_id uuid;
  _user_activity_id uuid;
begin
  if new.external_data_source <> 'apple_google' then
    return new;
  end if;

  perform public.set_local_timezone();

  _user_id := new.user_id;
  _start_date := (new.data ->> 'dateFrom')::timestamptz at time zone 'utc';
  _end_date := (new.data ->> 'dateTo')::timestamptz at time zone 'utc';
  _distance_unit := new.data -> 'value' ->> 'totalDistanceUnit';
  _distance := (new.data -> 'workoutSummary' ->> 'totalDistance')::float;
  _duration_in_seconds := extract(epoch from _end_date - _start_date)::int;
  _distance_in_meters := public.convert_to_meters(_distance, _distance_unit);

  select sa.activity_id, sa.sub_activity_id
  into _activity_id, _sub_activity_id
  from public.external_data_mapping m
    join public.sub_activity sa on m.sub_activity_id = sa.sub_activity_id
  where m.external_data_source = new.external_data_source
    and m.source_name = new.data -> 'value' ->> 'workoutActivityType'
    and new.data ->> 'type' = 'WORKOUT';

  if _activity_id is null then
    select a.activity_id
    into _activity_id
    from public.external_data_mapping m
      join public.activity a on m.activity_id = a.activity_id
    where m.external_data_source = new.external_data_source
      and m.source_name = new.data -> 'value' ->> 'workoutActivityType'
      and new.data ->> 'type' = 'WORKOUT';
  end if;

  if _activity_id is null then
    return new;
  end if;

  if _sub_activity_id is not null then
    insert into public.user_activity (user_id, activity_id, activity_timestamp, external_data_id)
    values (_user_id, _activity_id, _start_date, new.external_data_id)
    returning user_activity_id into _user_activity_id;

    insert into public.user_activity_sub_activity (user_activity_id, sub_activity_id)
    values (_user_activity_id, _sub_activity_id);
  else
    insert into public.user_activity (user_id, activity_id, activity_timestamp, external_data_id)
    values (_user_id, _activity_id, _start_date, new.external_data_id)
    returning user_activity_id into _user_activity_id;
  end if;

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

  return new;
end;
$$;

create or replace trigger handle_external_data_trigger_apple_google
  after insert on public.external_data
  for each row execute procedure public.handle_external_data_apple_google();
