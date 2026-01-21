create type public.activity_detail_type as enum (
  'string',
  'integer',
  'double',
  'duration',
  'distance',
  'location',
  'environment',
  'liquidVolume',
  'weight'
);

create type public.environment_type as enum (
  'indoor',
  'outdoor'
);

create type public.distance_uom as enum (
  'meters',
  'yards',
  'kilometers',
  'miles'
);

create type public.liquid_volume_uom as enum (
  'milliliters',
  'fluidOunces',
  'liters',
  'gallons'
);

create type public.weight_uom as enum (
  'grams',
  'kilograms',
  'ounces',
  'pounds'
);

create type public.metric_uom as enum (
  'meters',
  'kilometers',
  'milliliters',
  'liters',
  'grams',
  'kilograms'
);

create type public.imperial_uom as enum (
  'yards',
  'miles',
  'fluidOunces',
  'gallons',
  'ounces',
  'pounds'
);

create table public.activity_detail (
  activity_detail_id uuid not null default gen_random_uuid() primary key,
  created_by uuid not null default auth.uid() references public.profile(user_id),
  created_at timestamp with time zone not null default now(),
  updated_by uuid null references public.profile(user_id),
  updated_at timestamp with time zone null,
  activity_id uuid not null references public.activity(activity_id),
  label text not null,
  activity_detail_type public.activity_detail_type not null,
  sort_order int not null,
  min_numeric double precision null,
  max_numeric double precision null,
  min_duration_in_sec int null,
  max_duration_in_sec int null,
  min_distance_in_meters double precision null,
  max_distance_in_meters double precision null,
  min_liquid_volume_in_liters double precision null,
  max_liquid_volume_in_liters double precision null,
  min_weight_in_kilograms double precision null,
  max_weight_in_kilograms double precision null,
  slider_interval double precision null,
  metric_uom public.metric_uom null,
  imperial_uom public.imperial_uom null
) tablespace pg_default;

create index on public.activity_detail using btree (activity_id);

create trigger handle_updated_at before update on public.activity_detail
  for each row execute procedure moddatetime (updated_at);

alter table public.activity_detail enable row level security;
create policy "Activity Detail - select for authenticated users"
  on public.activity_detail
  as permissive for select
  to authenticated
  using (true);

alter table public.activity_detail
add constraint check_activity_detail_string_and_location
check (
  activity_detail_type not in ('string', 'location') or (
    min_numeric is null and
    max_numeric is null and
    min_duration_in_sec is null and
    max_duration_in_sec is null and
    min_distance_in_meters is null and
    max_distance_in_meters is null and
    min_liquid_volume_in_liters is null and
    max_liquid_volume_in_liters is null and
    min_weight_in_kilograms is null and
    max_weight_in_kilograms is null and
    slider_interval is null and
    metric_uom is null and
    imperial_uom is null
  )
);

alter table public.activity_detail
add constraint check_activity_detail_integer_and_double
check (
  activity_detail_type not in ('integer', 'double') or (
    min_numeric is not null and
    max_numeric is not null and
    min_duration_in_sec is null and
    max_duration_in_sec is null and
    min_distance_in_meters is null and
    max_distance_in_meters is null and
    min_liquid_volume_in_liters is null and
    max_liquid_volume_in_liters is null and
    min_weight_in_kilograms is null and
    max_weight_in_kilograms is null and
    slider_interval is not null and
    metric_uom is null and
    imperial_uom is null
  )
);

alter table public.activity_detail
add constraint check_activity_detail_duration
check (
  activity_detail_type <> 'duration' or (
    min_numeric is null and
    max_numeric is null and
    min_duration_in_sec is not null and
    max_duration_in_sec is not null and
    min_distance_in_meters is null and
    max_distance_in_meters is null and
    min_liquid_volume_in_liters is null and
    max_liquid_volume_in_liters is null and
    min_weight_in_kilograms is null and
    max_weight_in_kilograms is null and
    slider_interval is not null and
    metric_uom is null and
    imperial_uom is null
  )
);

alter table public.activity_detail
add constraint check_activity_detail_distance
check (
  activity_detail_type <> 'distance' or (
    min_numeric is null and
    max_numeric is null and
    min_duration_in_sec is null and
    max_duration_in_sec is null and
    min_distance_in_meters is not null and
    max_distance_in_meters is not null and
    min_liquid_volume_in_liters is null and
    max_liquid_volume_in_liters is null and
    min_weight_in_kilograms is null and
    max_weight_in_kilograms is null and
    slider_interval is not null and
    metric_uom is not null and
    imperial_uom is not null
  )
);

alter table public.activity_detail
add constraint check_activity_detail_liquid_volume
check (
  activity_detail_type <> 'liquidVolume' or (
    min_numeric is null and
    max_numeric is null and
    min_duration_in_sec is null and
    max_duration_in_sec is null and
    min_distance_in_meters is null and
    max_distance_in_meters is null and
    min_liquid_volume_in_liters is not null and
    max_liquid_volume_in_liters is not null and
    min_weight_in_kilograms is null and
    max_weight_in_kilograms is null and
    slider_interval is not null and
    metric_uom is not null and
    imperial_uom is not null
  )
);

alter table public.activity_detail
add constraint check_activity_detail_weight
check (
  activity_detail_type <> 'weight' or (
    min_numeric is null and
    max_numeric is null and
    min_duration_in_sec is null and
    max_duration_in_sec is null and
    min_distance_in_meters is null and
    max_distance_in_meters is null and
    min_liquid_volume_in_liters is null and
    max_liquid_volume_in_liters is null and
    min_weight_in_kilograms is not null and
    max_weight_in_kilograms is not null and
    slider_interval is not null and
    metric_uom is not null and
    imperial_uom is not null
  )
);
