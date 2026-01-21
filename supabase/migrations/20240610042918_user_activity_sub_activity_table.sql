create table public.user_activity_sub_activity (
  user_activity_id uuid not null,
  sub_activity_id uuid not null,
  constraint user_activity_sub_activity_pkey primary key (user_activity_id, sub_activity_id),
  constraint user_activity_sub_activity_user_activity_id_fkey foreign key (user_activity_id) references public.user_activity (user_activity_id) on delete cascade,
  constraint user_activity_sub_activity_sub_activity_id_fkey foreign key (sub_activity_id) references public.sub_activity (sub_activity_id)
) tablespace pg_default;

alter table public.user_activity_sub_activity enable row level security;

create policy "User Activity Sub Activity - crud only their own"
  on public.user_activity_sub_activity
  as permissive for all
  to authenticated
  using (
    user_activity_id in (
      select user_activity_id
      from public.user_activity
      where user_id = (select auth.uid())
    )
  );
