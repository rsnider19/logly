create type public.pace_type as enum (
  'minutesPerUom',
  'minutesPer100Uom',
  'minutesPer500m',
  'floorsPerMinute'
);

alter table public.activity
  add column pace_type public.pace_type null;
