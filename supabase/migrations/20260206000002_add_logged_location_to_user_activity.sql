-- Add logged_location column to user_activity for silent GPS capture
-- This stores the user's GPS coordinates at the time they logged the activity

ALTER TABLE public.user_activity
ADD COLUMN IF NOT EXISTS logged_location extensions.GEOGRAPHY(POINT, 4326) NULL;

-- Add comment explaining the column purpose
COMMENT ON COLUMN public.user_activity.logged_location IS
  'User GPS coordinates at time of logging (silently captured with permission). This is where the user was when they logged, not necessarily where the activity took place.';

-- Create spatial index for potential future proximity queries
CREATE INDEX IF NOT EXISTS user_activity_logged_location_idx
  ON public.user_activity
  USING GIST (logged_location)
  WHERE logged_location IS NOT NULL;
