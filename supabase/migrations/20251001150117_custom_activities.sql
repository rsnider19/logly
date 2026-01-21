alter table activity
  alter column created_by set default (auth.uid()),
  alter column legacy_id drop not null;

create policy activity_insert_by_owner on activity
for insert
to authenticated
with check (created_by = (select auth.uid()));

drop policy if exists "Activity - select for authenticated users" on activity;

create policy activity_select_policy on activity
for select
to authenticated
using (
  created_by = (select auth.uid())
  or created_by = '00000000-0000-0000-0000-000000000000'::uuid
);

drop trigger if exists set_unique_code on activity;
drop function if exists public.activity_generate_unique_code();

create function public.activity_generate_unique_code()
returns trigger
security definer
set search_path = public
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
before insert on public.activity
for each row execute function public.activity_generate_unique_code();

create policy activity_detail_insert_by_owner
  on activity_detail
  for insert
  to authenticated
  with check (
    created_by = (select auth.uid())
    and exists (
      select 1
      from activity
      where activity.activity_id = activity_detail.activity_id
        and activity.created_by = (select auth.uid())
    )
  );

drop policy if exists "Activity Detail - select for authenticated users" on activity_detail;
create policy activity_detail_select_policy on activity_detail
for select
to authenticated
using (
  created_by = (select auth.uid())
  or created_by = '00000000-0000-0000-0000-000000000000'::uuid
);
