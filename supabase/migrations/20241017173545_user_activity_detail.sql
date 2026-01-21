create table public.user_activity_detail (
  user_activity_id uuid not null references public.user_activity (user_activity_id) on delete cascade,
  activity_detail_id uuid not null references public.activity_detail (activity_detail_id),
  activity_detail_type public.activity_detail_type not null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone null,
  text_value text null,
  environment_value public.environment_type null,
  numeric_value double precision null,
  duration_in_sec int null,
  distance_in_meters double precision null,
  liquid_volume_in_liters double precision null,
  weight_in_kilograms double precision null,
  lat_lng geography(point) null,
  constraint user_activity_detail_pkey primary key (user_activity_id, activity_detail_id)
) tablespace pg_default;

alter table public.user_activity_detail enable row level security;

create policy "User Activity Details - crud only their own"
  on public.user_activity_detail
  as permissive for all
  to authenticated
  using (
    user_activity_id in (
      select user_activity_id
      from public.user_activity
      where user_id = (select auth.uid())
    )
  );

create trigger handle_updated_at before update on public.user_activity_detail
  for each row execute procedure moddatetime (updated_at);

create or replace function set_activity_detail_type()
returns trigger as $$
begin
  select activity_detail_type into new.activity_detail_type
  from public.activity_detail
  where activity_detail_id = new.activity_detail_id;
  return new;
end;
$$ language plpgsql;

create trigger set_activity_detail_type
before insert or update on public.user_activity_detail
for each row
execute function set_activity_detail_type();

alter table public.user_activity_detail
add constraint check_user_activity_detail_string
check (
  activity_detail_type <> 'string' or (
    environment_value is null and
    numeric_value is null and 
    duration_in_sec is null and 
    distance_in_meters is null and 
    liquid_volume_in_liters is null and 
    weight_in_kilograms is null and 
    lat_lng is null
  )
);

alter table public.user_activity_detail
add constraint check_user_activity_detail_environment
check (
  activity_detail_type <> 'environment' or (
    text_value is null and
    numeric_value is null and
    duration_in_sec is null and
    distance_in_meters is null and
    liquid_volume_in_liters is null and
    weight_in_kilograms is null and
    lat_lng is null
  )
);

alter table public.user_activity_detail
add constraint check_user_activity_detail_integer_and_double
check (
  activity_detail_type not in ('integer', 'double') or (
    text_value is null and
    environment_value is null and
    duration_in_sec is null and
    distance_in_meters is null and 
    liquid_volume_in_liters is null and 
    weight_in_kilograms is null and 
    lat_lng is null
  )
);

alter table public.user_activity_detail
add constraint check_user_activity_detail_duration
check (
  activity_detail_type <> 'duration' or (
    text_value is null and
    environment_value is null and
    numeric_value is null and
    distance_in_meters is null and 
    liquid_volume_in_liters is null and 
    weight_in_kilograms is null and 
    lat_lng is null
  )
);

alter table public.user_activity_detail
add constraint check_user_activity_detail_distance
check (
  activity_detail_type <> 'distance' or (
    text_value is null and
    environment_value is null and
    numeric_value is null and 
    duration_in_sec is null and
    liquid_volume_in_liters is null and 
    weight_in_kilograms is null and 
    lat_lng is null
  )
);

alter table public.user_activity_detail
add constraint check_user_activity_detail_location
check (
  activity_detail_type <> 'location' or (
    text_value is null and
    environment_value is null and
    numeric_value is null and 
    duration_in_sec is null and 
    distance_in_meters is null and 
    liquid_volume_in_liters is null and 
    weight_in_kilograms is null
  )
);

alter table public.user_activity_detail
add constraint check_user_activity_detail_liquid_volume
check (
  activity_detail_type <> 'liquidVolume' or (
    text_value is null and
    environment_value is null and
    numeric_value is null and 
    duration_in_sec is null and 
    distance_in_meters is null and
    weight_in_kilograms is null and 
    lat_lng is null
  )
);

alter table public.user_activity_detail
add constraint check_user_activity_detail_weight
check (
  activity_detail_type <> 'weight' or (
    text_value is null and
    environment_value is null and
    numeric_value is null and 
    duration_in_sec is null and 
    distance_in_meters is null and 
    liquid_volume_in_liters is null and
    lat_lng is null
  )
);
