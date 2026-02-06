-- Create the location table for globally shared places
-- Uses Google place_id as the primary key for deduplication

-- Enable PostGIS extension if not already enabled (should already be in extensions schema)
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA extensions;

-- Create the location table
CREATE TABLE IF NOT EXISTS public.location (
  location_id TEXT PRIMARY KEY, -- Google place_id
  lng_lat extensions.GEOGRAPHY(POINT, 4326) NOT NULL,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.location ENABLE ROW LEVEL SECURITY;

-- All authenticated users can read locations (shared globally)
CREATE POLICY "Locations - read for all authenticated"
  ON public.location
  AS PERMISSIVE FOR SELECT
  TO authenticated
  USING (true);

-- All authenticated users can insert locations (upsert pattern)
CREATE POLICY "Locations - insert for all authenticated"
  ON public.location
  AS PERMISSIVE FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Create spatial index for potential future proximity queries
CREATE INDEX IF NOT EXISTS location_lng_lat_idx
  ON public.location
  USING GIST (lng_lat);

-- Add comment for documentation
COMMENT ON TABLE public.location IS 'Globally shared location records from Google Places API';
COMMENT ON COLUMN public.location.location_id IS 'Google place_id - unique identifier for the location';
COMMENT ON COLUMN public.location.lng_lat IS 'Geographic point coordinates (longitude, latitude)';
COMMENT ON COLUMN public.location.name IS 'Primary name of the place from Google Places';
COMMENT ON COLUMN public.location.address IS 'Formatted address from Google Places';
