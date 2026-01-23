-- Add unit_system column to profile table
alter table public.profile
add column unit_system text not null default 'metric';

-- Add comment for documentation
comment on column public.profile.unit_system is 'User preferred unit system: metric or imperial';
