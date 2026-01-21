create table public.profile (
  user_id uuid not null references auth.users on delete cascade,
  created_at timestamp with time zone not null default now(),
  primary key (user_id)
);

alter table public.profile enable row level security;

create policy "Profiles are viewable by the user."
  on public.profile
  as permissive for select
  using (
    user_id = (select auth.uid())
  );

create policy "Profiles are updatable by the user."
  on public.profile
  as permissive for update
  using (
    user_id = (select auth.uid())
  );

create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
  begin
    insert into public.profile (user_id)
    values (new.id);
    return new;
  end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create function public.my_profile()
returns public.profile
stable
language sql
set search_path = ''
as $$
  select *
  from public.profile
  where user_id = auth.uid();
$$;
