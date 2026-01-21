create table public.activity_category (
  activity_category_id uuid not null default gen_random_uuid(),
  created_by uuid not null,
  created_at timestamp with time zone not null default now(),
  name text not null,
  activity_category_code text not null,
  description text null,
  hex_color text not null,
  icon text not null,
  legacy_id int not null,
  sort_order int not null,
  constraint activity_category_pkey primary key (activity_category_id),
  constraint activity_category_created_by_fkey foreign key (created_by) references public.profile (user_id)
) tablespace pg_default;

alter table public.activity_category enable row level security;

create policy "Activity Category - select for authenticated users"
  on public.activity_category
  as permissive for select
  to authenticated
  using (true);

create function public.activity_category_generate_unique_code()
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
        from public.activity_category
        where activity_category_code = new_code
          and activity_category_id != new.activity_category_id
    ) loop
        new_code := base_code || '_' || suffix;
        suffix := suffix + 1;
    end loop;

    new.activity_category_code := new_code;

    return new;
end;
$$ language plpgsql;

create trigger set_unique_code
before insert or update on public.activity_category
for each row execute function public.activity_category_generate_unique_code();
