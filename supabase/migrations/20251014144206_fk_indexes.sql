-- FINALIZED: create missing indexes for foreign keys in public schema
-- This script uses plain CREATE INDEX (no CONCURRENTLY). It can be executed as a single batch.

-- _user_activity_category_month.activity_category_id
CREATE INDEX IF NOT EXISTS idx__user_activity_category_month_activity_category_id
  ON public._user_activity_category_month (activity_category_id);

-- _user_activity_category_month.user_id
CREATE INDEX IF NOT EXISTS idx__user_activity_category_month_user_id
  ON public._user_activity_category_month (user_id);

-- _user_activity_category_summary.activity_category_id
CREATE INDEX IF NOT EXISTS idx__user_activity_category_summary_activity_category_id
  ON public._user_activity_category_summary (activity_category_id);

-- _user_activity_category_summary.user_id
CREATE INDEX IF NOT EXISTS idx__user_activity_category_summary_user_id
  ON public._user_activity_category_summary (user_id);

-- activity.activity_category_id
CREATE INDEX IF NOT EXISTS idx_activity_activity_category_id
  ON public.activity (activity_category_id);

-- activity_category.created_by
CREATE INDEX IF NOT EXISTS idx_activity_category_created_by
  ON public.activity_category (created_by);

-- activity.created_by
CREATE INDEX IF NOT EXISTS idx_activity_created_by
  ON public.activity (created_by);

-- activity_detail.activity_id
CREATE INDEX IF NOT EXISTS idx_activity_detail_activity_id
  ON public.activity_detail (activity_id);

-- activity_detail.created_by
CREATE INDEX IF NOT EXISTS idx_activity_detail_created_by
  ON public.activity_detail (created_by);

-- activity_detail.updated_by
CREATE INDEX IF NOT EXISTS idx_activity_detail_updated_by
  ON public.activity_detail (updated_by);

-- activity_embedding.activity_id
CREATE INDEX IF NOT EXISTS idx_activity_embedding_activity_id
  ON public.activity_embedding (activity_id);

-- external_data_mapping.activity_id
CREATE INDEX IF NOT EXISTS idx_external_data_mapping_activity_id
  ON public.external_data_mapping (activity_id);

-- external_data_mapping.sub_activity_id
CREATE INDEX IF NOT EXISTS idx_external_data_mapping_sub_activity_id
  ON public.external_data_mapping (sub_activity_id);

-- external_data.user_id
CREATE INDEX IF NOT EXISTS idx_external_data_user_id
  ON public.external_data (user_id);

-- _user_activities_by_date.user_id
CREATE INDEX IF NOT EXISTS idx__user_activities_by_date_user_id
  ON public._user_activities_by_date (user_id);

-- _user_activity_streak.user_id
CREATE INDEX IF NOT EXISTS idx__user_activity_streak_user_id
  ON public._user_activity_streak (user_id);

-- favorite_user_activity.activity_id
CREATE INDEX IF NOT EXISTS idx_favorite_user_activity_activity_id
  ON public.favorite_user_activity (activity_id);

-- favorite_user_activity.user_id
CREATE INDEX IF NOT EXISTS idx_favorite_user_activity_user_id
  ON public.favorite_user_activity (user_id);

-- trending_activity.activity_category_id
CREATE INDEX IF NOT EXISTS idx_trending_activity_activity_category_id
  ON public.trending_activity (activity_category_id);

-- trending_activity.activity_id
CREATE INDEX IF NOT EXISTS idx_trending_activity_activity_id
  ON public.trending_activity (activity_id);

-- user_activity.activity_id
CREATE INDEX IF NOT EXISTS idx_user_activity_activity_id
  ON public.user_activity (activity_id);

-- user_activity.user_id
CREATE INDEX IF NOT EXISTS idx_user_activity_user_id
  ON public.user_activity (user_id);

-- sub_activity.activity_id
CREATE INDEX IF NOT EXISTS idx_sub_activity_activity_id
  ON public.sub_activity (activity_id);

-- sub_activity.created_by
CREATE INDEX IF NOT EXISTS idx_sub_activity_created_by
  ON public.sub_activity (created_by);

-- user_activity_detail.activity_detail_id
CREATE INDEX IF NOT EXISTS idx_user_activity_detail_activity_detail_id
  ON public.user_activity_detail (activity_detail_id);

-- user_activity_detail.user_activity_id
CREATE INDEX IF NOT EXISTS idx_user_activity_detail_user_activity_id
  ON public.user_activity_detail (user_activity_id);

-- user_activity (composite FK to external_data)
CREATE INDEX IF NOT EXISTS idx_user_activity_external_data_external_data_id_user_id
  ON public.user_activity (external_data_id, user_id);

-- user_activity_sub_activity.sub_activity_id
CREATE INDEX IF NOT EXISTS idx_user_activity_sub_activity_sub_activity_id
  ON public.user_activity_sub_activity (sub_activity_id);

-- user_activity_sub_activity.user_activity_id
CREATE INDEX IF NOT EXISTS idx_user_activity_sub_activity_user_activity_id
  ON public.user_activity_sub_activity (user_activity_id);

-- Refresh planner statistics
ANALYZE public._user_activity_category_month;
ANALYZE public._user_activity_category_summary;
ANALYZE public.activity_category;
ANALYZE public.activity;
ANALYZE public.activity_detail;
ANALYZE public.activity_embedding;
ANALYZE public.external_data_mapping;
ANALYZE public.external_data;
ANALYZE public._user_activities_by_date;
ANALYZE public._user_activity_streak;
ANALYZE public.favorite_user_activity;
ANALYZE public.trending_activity;
ANALYZE public.user_activity;
ANALYZE public.sub_activity;
ANALYZE public.user_activity_detail;
ANALYZE public.user_activity_sub_activity;
