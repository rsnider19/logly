create table public._user_activity_category_summary (
  user_id uuid not null,
  activity_category_id uuid not null,
  activity_count bigint not null default 0,
  constraint _user_activity_category_summary_pkey primary key (user_id, activity_category_id),
  constraint _user_activity_category_summary_user_id_fkey foreign key (user_id) references public.profile (user_id),
  constraint _user_activity_category_summary_activity_category_id_fkey foreign key (activity_category_id) references public.activity_category (activity_category_id)
) tablespace pg_default;

alter table public._user_activity_category_summary enable row level security;

create policy "User Activity Category Summary - select only their own"
  on public._user_activity_category_summary
  as permissive for select
  to authenticated
  using (
    user_id = (select auth.uid())
  );

create function public.user_activity_category_summary(
  _start_date timestamptz default timestamp 'epoch',
  _end_date timestamptz default current_timestamp
)
returns setof public._user_activity_category_summary
stable
language plpgsql
set search_path = ''
as $$
begin
  perform public.set_local_timezone();

  return query
  select auth.uid() as user_id,
    a.activity_category_id,
    count(ua.activity_id) as activity_count
  from public.activity a
    left join public.user_activity ua on a.activity_id = ua.activity_id
      and ua.user_id = auth.uid()
      and ua.activity_timestamp between _start_date and _end_date
  group by a.activity_category_id;
 end
$$;
