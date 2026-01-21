create table public.favorite_user_activity (
  user_id uuid not null default gen_random_uuid (),
  activity_id uuid not null default gen_random_uuid (),
  created_at timestamp with time zone not null default now(),
  constraint favorite_user_activity_pkey primary key (user_id, activity_id),
  constraint public_favorite_user_activity_user_id_fkey foreign key (user_id) references public.profile (user_id) on delete cascade,
  constraint public_favorite_user_activity_activity_id_fkey foreign key (activity_id) references public.activity (activity_id)
) tablespace pg_default;

create index on public.favorite_user_activity using btree (user_id);

alter table public.favorite_user_activity enable row level security;

create policy "Favorite User Activity - select only their own"
  on public.favorite_user_activity
  as permissive for select
  to authenticated
  using (
    user_id = (select auth.uid())
  );

create policy "Favorite User Activity - insert only their own"
  on public.favorite_user_activity
  for insert with check (
    user_id = (select auth.uid())
  );

create policy "Favorite User Activity - delete only their own"
  on public.favorite_user_activity
  for delete using (
    user_id = (select auth.uid())
  );

create or replace function check_favorite_user_activity_limit()
returns trigger as $$
begin
  if (select count(*) from public.favorite_user_activity where user_id = new.user_id) >= 10 then
    raise exception 'User can only have 10 favorite activities';
  end if;
  return new;
end;
$$ language plpgsql;

-- Create the trigger
create trigger favorite_user_activity_limit
before insert on public.favorite_user_activity
for each row
execute function check_favorite_user_activity_limit();
