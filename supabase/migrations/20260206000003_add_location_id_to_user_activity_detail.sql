-- Add location_id foreign key to user_activity_detail
-- This references the location table for activities with location detail type

ALTER TABLE public.user_activity_detail
ADD COLUMN IF NOT EXISTS location_id TEXT NULL REFERENCES public.location(location_id);

-- Deprecation note for lat_lng column
COMMENT ON COLUMN public.user_activity_detail.lat_lng IS
  'DEPRECATED: Use location_id instead. Kept for historical data compatibility.';

-- Create index on location_id for efficient joins
CREATE INDEX IF NOT EXISTS user_activity_detail_location_id_idx
  ON public.user_activity_detail(location_id)
  WHERE location_id IS NOT NULL;
