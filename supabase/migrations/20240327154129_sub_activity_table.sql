create table public.sub_activity (
  sub_activity_id uuid not null default gen_random_uuid(),
  activity_id uuid not null,
  created_by uuid not null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone null,
  name text not null,
  sub_activity_code text not null,
  icon text null,
  legacy_id int not null,
  constraint sub_activity_pkey primary key (sub_activity_id),
  constraint sub_activity_activity_id_fkey foreign key (activity_id) references public.activity (activity_id),
  constraint sub_activity_created_by_fkey foreign key (created_by) references public.profile (user_id)
) tablespace pg_default;

create unique index on public.sub_activity using btree (sub_activity_code);
create unique index on public.sub_activity using btree (legacy_id);

create trigger handle_updated_at
  before update on public.sub_activity
  for each row execute procedure moddatetime (updated_at);

alter table public.sub_activity enable row level security;
create policy "Sub Activity - select for authenticated users"
  on public.sub_activity
  as permissive for select
  to authenticated
  using (true);

create function public.sub_activity_generate_unique_code()
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
        from public.sub_activity
        where sub_activity_code = new_code
          and sub_activity_id != new.sub_activity_id
    ) loop
        new_code := base_code || '_' || suffix;
        suffix := suffix + 1;
    end loop;

    new.sub_activity_code := new_code;

    return new;
end;
$$ language plpgsql;

create trigger set_unique_code
  before insert or update on public.sub_activity
  for each row execute function public.sub_activity_generate_unique_code();
