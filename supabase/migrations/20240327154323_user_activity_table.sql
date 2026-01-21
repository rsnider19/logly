create table public.user_activity (
  user_activity_id uuid not null default gen_random_uuid(),
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone null,
  user_id uuid not null default auth.uid(),
  activity_id uuid not null,
  activity_timestamp timestamp with time zone not null,
  comments text null,
  activity_name_override text null,
  constraint user_activity_pkey primary key (user_activity_id),
  constraint public_user_activity_activity_id_fkey foreign key (activity_id) references public.activity (activity_id),
  constraint public_user_activity_user_id_fkey foreign key (user_id) references public.profile (user_id) on delete cascade
) tablespace pg_default;

create index on public.user_activity using btree (user_id);
create index on public.user_activity using btree (activity_id);

create trigger handle_updated_at before update on public.user_activity
  for each row execute procedure moddatetime (updated_at);

create or replace function public.insert_user_activity_details()
returns trigger
language plpgsql
as $$
begin
  insert into public.user_activity_detail (user_activity_id, activity_detail_id, activity_detail_type)
  select new.user_activity_id,
    d.activity_detail_id,
    d.activity_detail_type
  from public.activity_detail d
  where d.activity_id = new.activity_id;

  return new;
end;
$$;

create trigger handle_insert_user_activity_details
  after insert on public.user_activity
  for each row execute procedure public.insert_user_activity_details();

alter table public.user_activity enable row level security;
create policy "User Activity - crud only their own"
  on public.user_activity
  as permissive for all
  to authenticated
  using (
    user_id = (select auth.uid())
  );

create function public.user_activity_by_id(
  _user_activity_id uuid
)
returns public.user_activity
stable
language sql
set search_path = ''
as $$
  select *
  from public.user_activity
  where user_activity_id = _user_activity_id
    and user_id = auth.uid()
$$;

create function public.user_activities_by_activity_category_id(
  _activity_category_id uuid
)
returns setof public.user_activity
stable
language sql
set search_path = ''
as $$
  select ua.*
  from public.user_activity ua
    join public.activity a on ua.activity_id = a.activity_id
  where a.activity_category_id = _activity_category_id
    and ua.user_id = auth.uid()
$$;
