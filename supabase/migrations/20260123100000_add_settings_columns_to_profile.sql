-- Add settings columns to profile table
alter table public.profile
add column theme_mode text not null default 'system',
add column health_sync_enabled boolean not null default false;

-- Add comments for documentation
comment on column public.profile.theme_mode is 'User preferred theme mode: system, light, or dark';
comment on column public.profile.health_sync_enabled is 'Whether health data sync is enabled for this user';
