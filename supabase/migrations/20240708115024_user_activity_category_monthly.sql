create table public._user_activity_category_month (
  user_activity_category_month_id uuid not null default gen_random_uuid(),
  user_id uuid not null,
  activity_category_id uuid null,
  activity_month timestamp with time zone not null,
  activity_count bigint not null default 0,
  constraint _user_activity_category_month_pkey primary key (user_activity_category_month_id),
  constraint _user_activity_category_month_user_id_fkey foreign key (user_id) references public.profile (user_id),
  constraint _user_activity_category_month_activity_category_id_fkey foreign key (activity_category_id) references public.activity_category (activity_category_id)
) tablespace pg_default;

alter table public._user_activity_category_month enable row level security;

create policy "User Activity Category Month - select only their own"
  on public._user_activity_category_month
  as permissive for select
  to authenticated
  using (
    user_id = (select auth.uid())
  );

create function public.user_activity_category_monthly(
  _activity_category_id uuid default extensions.uuid_nil()
)
returns setof public._user_activity_category_month
stable
language plpgsql
set search_path = ''
as $$
begin
  perform public.set_local_timezone();

  return query
  with months as (
    select generate_series(
      date_trunc('month', current_timestamp) - interval '11 months',
      date_trunc('month', current_timestamp),
      interval '1 month'
    ) as month
  ),
  activity_data as (
    select auth.uid() as user_id,
      nullif(_activity_category_id, extensions.uuid_nil()) as activity_category_id,
      date_trunc('month', ua.activity_timestamp) as activity_month,
      count(ua.activity_id) as activity_count
    from public.activity a
    join public.user_activity ua on a.activity_id = ua.activity_id
      and ua.user_id = auth.uid()
      and date_trunc('month', ua.activity_timestamp) > date_trunc('month', current_timestamp - interval '1 year')
    where _activity_category_id = extensions.uuid_nil()
      or a.activity_category_id = _activity_category_id
    group by date_trunc('month', ua.activity_timestamp)
  )
  select gen_random_uuid() as user_activity_category_month_id,
    auth.uid() as user_id,
    activity_category_id,
    m.month as activity_month,
    coalesce(ad.activity_count, 0) as activity_count
  from months m
    left join activity_data ad on m.month = ad.activity_month
  order by m.month;
end
$$;
