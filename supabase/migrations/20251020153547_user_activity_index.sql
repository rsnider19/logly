drop index if exists idx_activity_activity_category_id;
drop index if exists idx_activity_detail_activity_id;
drop index if exists idx_favorite_user_activity_user_id;
drop index if exists idx_user_activity_activity_id;
drop index if exists idx_user_activity_user_id;

create index if not exists idx_user_activity_user_date_ts
  on public.user_activity (user_id, activity_timestamp);
