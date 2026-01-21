comment on schema public is e'@graphql({"inflect_names": true, "max_rows": 50})';

create extension if not exists pg_cron schema pg_catalog;
create extension if not exists pg_trgm schema extensions;
create extension if not exists postgis schema extensions;
create extension if not exists moddatetime schema extensions;
create extension if not exists pg_net schema extensions;

create or replace function public.timezone()
returns text
language sql
as $$
  select coalesce(auth.jwt() -> 'user_metadata' ->> 'timezone', 'UTC')
$$;

create or replace function public.set_local_timezone()
returns void
language plpgsql
set search_path = ''
as $$
declare
    tz text;
begin
    tz := public.timezone();
    execute 'set local timezone to ' || quote_literal(tz);
end;
$$;
