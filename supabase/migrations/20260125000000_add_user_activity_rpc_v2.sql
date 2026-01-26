-- Migration: Add RPC functions for user activity CRUD
-- These functions handle atomic multi-table inserts and return the user_activity record.
-- Use PostgREST relationships to fetch related data after calling these RPCs.

-- ============================================================================
-- create_user_activity: Atomic insert for single user activity
-- ============================================================================

CREATE OR REPLACE FUNCTION public.create_user_activity(
  p_user_activity jsonb,
  p_details jsonb DEFAULT '[]'::jsonb,
  p_sub_activity_ids uuid[] DEFAULT '{}'::uuid[]
)
RETURNS SETOF public.user_activity
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  new_user_activity_id uuid;
BEGIN
  -- Insert the user activity record
  INSERT INTO public.user_activity (
    user_id,
    activity_id,
    activity_timestamp,
    activity_date,
    comments,
    activity_name_override
  )
  VALUES (
    auth.uid(),
    (p_user_activity->>'activity_id')::uuid,
    (p_user_activity->>'activity_timestamp')::timestamptz,
    (p_user_activity->>'activity_date')::date,
    (p_user_activity->>'comments')::text,
    (p_user_activity->>'activity_name_override')::text
  )
  RETURNING user_activity_id INTO new_user_activity_id;

  -- Insert activity details (if provided)
  IF jsonb_array_length(p_details) > 0 THEN
    INSERT INTO public.user_activity_detail (
      user_activity_id,
      activity_detail_id,
      activity_detail_type,
      text_value,
      environment_value,
      numeric_value,
      duration_in_sec,
      distance_in_meters,
      liquid_volume_in_liters,
      weight_in_kilograms
    )
    SELECT
      new_user_activity_id,
      (detail->>'activity_detail_id')::uuid,
      (detail->>'activity_detail_type')::public.activity_detail_type,
      (detail->>'text_value')::text,
      (detail->>'environment_value')::public.environment_type,
      (detail->>'numeric_value')::double precision,
      (detail->>'duration_in_sec')::int,
      (detail->>'distance_in_meters')::double precision,
      (detail->>'liquid_volume_in_liters')::double precision,
      (detail->>'weight_in_kilograms')::double precision
    FROM jsonb_array_elements(p_details) AS detail
    WHERE (detail->>'activity_detail_id') IS NOT NULL
    ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
    SET
      activity_detail_type = excluded.activity_detail_type,
      text_value = excluded.text_value,
      environment_value = excluded.environment_value,
      numeric_value = excluded.numeric_value,
      duration_in_sec = excluded.duration_in_sec,
      distance_in_meters = excluded.distance_in_meters,
      liquid_volume_in_liters = excluded.liquid_volume_in_liters,
      weight_in_kilograms = excluded.weight_in_kilograms;
  END IF;

  -- Insert sub-activities (if provided)
  IF array_length(p_sub_activity_ids, 1) > 0 THEN
    INSERT INTO public.user_activity_sub_activity (user_activity_id, sub_activity_id)
    SELECT new_user_activity_id, sub_activity_id
    FROM unnest(p_sub_activity_ids) AS sub_activity_id;
  END IF;

  -- Return the created user_activity record
  RETURN QUERY
  SELECT * FROM public.user_activity WHERE user_activity_id = new_user_activity_id;
END;
$$;

-- ============================================================================
-- update_user_activity: Atomic update for single user activity
-- ============================================================================

CREATE OR REPLACE FUNCTION public.update_user_activity(
  p_user_activity jsonb,
  p_details jsonb DEFAULT '[]'::jsonb,
  p_sub_activity_ids uuid[] DEFAULT '{}'::uuid[]
)
RETURNS SETOF public.user_activity
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  target_user_activity_id uuid;
BEGIN
  target_user_activity_id := (p_user_activity->>'user_activity_id')::uuid;

  -- Verify ownership
  IF NOT EXISTS (
    SELECT 1 FROM public.user_activity
    WHERE user_activity_id = target_user_activity_id
      AND user_id = auth.uid()
  ) THEN
    RAISE EXCEPTION 'User activity not found or access denied';
  END IF;

  -- Update the user activity record
  UPDATE public.user_activity
  SET
    activity_timestamp = (p_user_activity->>'activity_timestamp')::timestamptz,
    activity_date = (p_user_activity->>'activity_date')::date,
    comments = (p_user_activity->>'comments')::text,
    activity_name_override = (p_user_activity->>'activity_name_override')::text
  WHERE user_activity_id = target_user_activity_id;

  -- Delete existing details and re-insert
  DELETE FROM public.user_activity_detail
  WHERE user_activity_id = target_user_activity_id;

  IF jsonb_array_length(p_details) > 0 THEN
    INSERT INTO public.user_activity_detail (
      user_activity_id,
      activity_detail_id,
      activity_detail_type,
      text_value,
      environment_value,
      numeric_value,
      duration_in_sec,
      distance_in_meters,
      liquid_volume_in_liters,
      weight_in_kilograms
    )
    SELECT
      target_user_activity_id,
      (detail->>'activity_detail_id')::uuid,
      (detail->>'activity_detail_type')::public.activity_detail_type,
      (detail->>'text_value')::text,
      (detail->>'environment_value')::public.environment_type,
      (detail->>'numeric_value')::double precision,
      (detail->>'duration_in_sec')::int,
      (detail->>'distance_in_meters')::double precision,
      (detail->>'liquid_volume_in_liters')::double precision,
      (detail->>'weight_in_kilograms')::double precision
    FROM jsonb_array_elements(p_details) AS detail
    WHERE (detail->>'activity_detail_id') IS NOT NULL;
  END IF;

  -- Delete existing sub-activities and re-insert
  DELETE FROM public.user_activity_sub_activity
  WHERE user_activity_id = target_user_activity_id;

  IF array_length(p_sub_activity_ids, 1) > 0 THEN
    INSERT INTO public.user_activity_sub_activity (user_activity_id, sub_activity_id)
    SELECT target_user_activity_id, sub_activity_id
    FROM unnest(p_sub_activity_ids) AS sub_activity_id;
  END IF;

  -- Return the updated user_activity record
  RETURN QUERY
  SELECT * FROM public.user_activity WHERE user_activity_id = target_user_activity_id;
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION public.create_user_activity(jsonb, jsonb, uuid[]) TO authenticated;
GRANT EXECUTE ON FUNCTION public.update_user_activity(jsonb, jsonb, uuid[]) TO authenticated;
