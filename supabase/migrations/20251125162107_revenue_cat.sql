create schema if not exists revenue_cat;
          
grant usage on schema revenue_cat to service_role;
grant all on all tables in schema revenue_cat to service_role;
grant all on all routines in schema revenue_cat to service_role;
grant all on all sequences in schema revenue_cat to service_role;
alter default privileges for role postgres in schema revenue_cat grant all on tables to service_role;
alter default privileges for role postgres in schema revenue_cat grant all on routines to service_role;
alter default privileges for role postgres in schema revenue_cat grant all on sequences to service_role;

create table revenue_cat.webhook_event (
  webhook_event_id uuid primary key default gen_random_uuid(),
  received_at timestamptz not null default now(),
  user_id uuid not null,
  raw_payload jsonb not null
);

-- features a user can unlock
create table revenue_cat.feature (
  name text primary key
);
  
insert into revenue_cat.feature (name) values
  ('ai-insights'),
  ('create-custom-activity'),
  ('activity-name-override'),
  ('location-services');

create table revenue_cat.entitlement (
  entitlement_id text primary key,
  code text not null unique
);

insert into revenue_cat.entitlement (entitlement_id, code) values
  ('entlbf83d5b13d', 'logly_pro');

-- mapping of which features belong to which tier
-- (higher tiers explicitly include lower-tier features)
create table revenue_cat.entitlement_feature (
  entitlement_id text references revenue_cat.entitlement(entitlement_id) on delete restrict,
  feature text references revenue_cat.feature(name) on delete restrict,
  primary key (entitlement_id, feature)
);

insert into revenue_cat.entitlement_feature (entitlement_id, feature) values
  ('entlbf83d5b13d', 'ai-insights'),
  ('entlbf83d5b13d', 'create-custom-activity'),
  ('entlbf83d5b13d', 'activity-name-override'),
  ('entlbf83d5b13d', 'location-services');

-- the user's current subscription state
-- revenuecat is source of truth, this table is the cache
create table revenue_cat.user_entitlement (
  user_id uuid primary key references auth.users(id) on delete cascade,
  entitlement_id text not null,
  active_until timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz null
);

-- index to easily fetch by app_user_id
create index idx_revenue_cat_webhook_app_user_id
  on revenue_cat.webhook_event(user_id);

create or replace function revenue_cat.user_has_feature(
  p_user_id uuid,
  p_feature text
)
returns boolean
language sql stable as
$$
  select exists (
    select 1
    from revenue_cat.user_entitlement ue
      join revenue_cat.entitlement_feature ef on ue.entitlement_id = ef.entitlement_id
    where ue.user_id = p_user_id
      and ef.feature = p_feature
  );
$$;
