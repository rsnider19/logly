-- Add onboarding_completed column to profile table
alter table public.profile
add column onboarding_completed boolean not null default false;

-- Add comment for documentation
comment on column public.profile.onboarding_completed is 'Indicates whether the user has completed the onboarding flow';
