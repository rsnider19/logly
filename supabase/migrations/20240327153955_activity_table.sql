create type public.activity_date_type as enum (
  'single',
  'range'
);

create table public.activity (
  activity_id uuid not null default gen_random_uuid(),
  created_by uuid not null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone null,
  name text not null,
  activity_code text not null,
  description text null,
  hex_color text null,
  icon text null,
  legacy_id int not null,
  activity_date_type public.activity_date_type not null,
  activity_category_id uuid not null,
  constraint activity_pkey primary key (activity_id),
  constraint activity_created_by_fkey foreign key (created_by) references public.profile (user_id),
  constraint activity_activity_category_id_fkey foreign key (activity_category_id) references public.activity_category (activity_category_id)
) tablespace pg_default;

create unique index on public.activity using btree (activity_code);
create unique index on public.activity using btree (legacy_id);
create index on public.activity using btree (activity_category_id);

create trigger handle_updated_at before update on public.activity
  for each row execute procedure moddatetime (updated_at);

alter table public.activity enable row level security;
create policy "Activity - select for authenticated users"
  on public.activity
  as permissive for select
  to authenticated
  using (true);

create function public.activity_generate_unique_code()
returns trigger
set search_path = ''
as $$
declare
    base_code text;
    new_code text;
    suffix int := 1;
begin
    base_code := lower(regexp_replace(new.name, '[^a-zA-Z0-9]+', '_', 'g'));
    new_code := base_code;

    while exists (
        select 1
        from public.activity
        where activity_code = new_code
          and activity_id != new.activity_id
    ) loop
        new_code := base_code || '_' || suffix;
        suffix := suffix + 1;
    end loop;

    new.activity_code := new_code;

    return new;
end;
$$ language plpgsql;

create trigger set_unique_code
before insert or update on public.activity
for each row execute function public.activity_generate_unique_code();

create function public.activity_by_id(
  _activity_id uuid
)
returns public.activity
stable
language sql
set search_path = ''
as $$
  select *
  from public.activity
  where activity_id = _activity_id
$$;
