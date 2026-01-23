-- Migration: Add activity_date column to user_activity table
-- This migration adds a dedicated DATE column to replace extracting dates from activity_timestamp::date
-- Improves query performance and simplifies date-based filtering

-- ============================================================================
-- PHASE 1: Schema Changes
-- ============================================================================

-- Add nullable column first (will be made NOT NULL after backfill)
ALTER TABLE public.user_activity ADD COLUMN activity_date DATE NULL;

-- Add composite index for common queries (user + date filtering)
CREATE INDEX idx_user_activity_user_activity_date
  ON public.user_activity (user_id, activity_date);

-- Create trigger function to auto-populate activity_date from activity_timestamp
-- Uses the user's timezone from their profile to correctly convert timestamp to date
CREATE OR REPLACE FUNCTION public.set_activity_date()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
  user_tz text;
BEGIN
  IF NEW.activity_date IS NULL THEN
    -- Get user's timezone from auth.users metadata, fallback to UTC if not set
    SELECT COALESCE(u.raw_user_meta_data ->> 'timezone', 'UTC')
    INTO user_tz
    FROM auth.users u
    WHERE u.id = NEW.user_id;

    -- Convert activity_timestamp to date in user's timezone
    NEW.activity_date := (NEW.activity_timestamp AT TIME ZONE COALESCE(user_tz, 'UTC'))::date;
  END IF;
  RETURN NEW;
END;
$$;

-- Create trigger to run before INSERT or UPDATE of activity_timestamp
CREATE TRIGGER handle_set_activity_date
  BEFORE INSERT OR UPDATE OF activity_timestamp ON public.user_activity
  FOR EACH ROW EXECUTE PROCEDURE public.set_activity_date();

-- ============================================================================
-- PHASE 2: Backfill & Constraint
-- ============================================================================

-- Backfill existing rows using each user's timezone
UPDATE public.user_activity ua
SET activity_date = (ua.activity_timestamp AT TIME ZONE COALESCE(u.raw_user_meta_data ->> 'timezone', 'UTC'))::date
FROM auth.users u
WHERE ua.user_id = u.id
  AND ua.activity_date IS NULL;

-- Now make the column NOT NULL
ALTER TABLE public.user_activity ALTER COLUMN activity_date SET NOT NULL;

-- ============================================================================
-- PHASE 3: Update Insert/Update Functions
-- ============================================================================

-- Update log_activity_with_details to explicitly set activity_date
CREATE OR REPLACE FUNCTION log_activity_with_details(
  p_user_activity jsonb,
  p_user_activity_details jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
  new_user_activity_id uuid;
  start_date timestamptz;
  end_date timestamptz;
  activity_date timestamptz;
BEGIN
  PERFORM public.set_local_timezone();

  start_date := (p_user_activity->>'activity_start_date')::timestamptz;
  end_date := (p_user_activity->>'activity_end_date')::timestamptz;

  activity_date := start_date;
  WHILE activity_date::date <= end_date::date LOOP
    -- Parse and insert the user activity record with activity_date
    INSERT INTO public.user_activity (user_id, activity_id, activity_timestamp, activity_date, comments, activity_name_override)
    SELECT
      auth.uid(),
      (p_user_activity->>'activity_id')::uuid,
      activity_date,
      activity_date::date,
      (p_user_activity->>'comments')::text,
      (p_user_activity->>'activity_name_override')::text
    RETURNING user_activity_id INTO new_user_activity_id;

    -- Parse and insert the activity details
    INSERT INTO public.user_activity_detail (
      user_activity_id, activity_detail_id, text_value, environment_value,
      numeric_value, duration_in_sec, distance_in_meters, liquid_volume_in_liters,
      weight_in_kilograms, lat_lng
    )
    SELECT
      new_user_activity_id,
      a.activity_detail_id,
      (detail->>'text_value')::text,
      (detail->>'environment_value')::public.environment_type,
      (detail->>'numeric_value')::double precision,
      (detail->>'duration_in_sec')::int,
      (detail->>'distance_in_meters')::double precision,
      (detail->>'liquid_volume_in_liters')::double precision,
      (detail->>'weight_in_kilograms')::double precision,
      (detail->>'lat_lng')::geography(point)
    FROM public.activity_detail a
      LEFT JOIN jsonb_array_elements(p_user_activity_details) AS detail ON a.activity_detail_id = (detail->>'activity_detail_id')::uuid
    WHERE a.activity_id = (p_user_activity->>'activity_id')::uuid
    ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
    SET
      text_value = excluded.text_value,
      environment_value = excluded.environment_value,
      numeric_value = excluded.numeric_value,
      duration_in_sec = excluded.duration_in_sec,
      distance_in_meters = excluded.distance_in_meters,
      liquid_volume_in_liters = excluded.liquid_volume_in_liters,
      weight_in_kilograms = excluded.weight_in_kilograms,
      lat_lng = excluded.lat_lng;

    -- Parse and insert the sub activities
    INSERT INTO public.user_activity_sub_activity (user_activity_id, sub_activity_id)
    SELECT new_user_activity_id, sub_activity_id::uuid
    FROM jsonb_array_elements_text(p_user_activity->'sub_activity_ids') AS sub_activity_id;

    activity_date := activity_date + interval '1 day';
  END LOOP;
END;
$$;

-- Update update_activity_with_details to explicitly set activity_date
CREATE OR REPLACE FUNCTION update_activity_with_details(
  p_user_activity jsonb,
  p_user_activity_details jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
  PERFORM public.set_local_timezone();

  -- Parse and update the user activity record with activity_date
  UPDATE public.user_activity
  SET
    activity_timestamp = (p_user_activity->>'activity_timestamp')::timestamptz,
    activity_date = ((p_user_activity->>'activity_timestamp')::timestamptz)::date,
    comments = (p_user_activity->>'comments')::text,
    activity_name_override = (p_user_activity->>'activity_name_override')::text
  WHERE user_activity_id = (p_user_activity->>'user_activity_id')::uuid;

  -- Parse and insert the activity details
  INSERT INTO public.user_activity_detail (
    user_activity_id, activity_detail_id, text_value, environment_value,
    numeric_value, duration_in_sec, distance_in_meters, liquid_volume_in_liters,
    weight_in_kilograms, lat_lng
  )
  SELECT
    (p_user_activity->>'user_activity_id')::uuid,
    (detail->>'activity_detail_id')::uuid,
    (detail->>'text_value')::text,
    (detail->>'environment_value')::public.environment_type,
    (detail->>'numeric_value')::double precision,
    (detail->>'duration_in_sec')::int,
    (detail->>'distance_in_meters')::double precision,
    (detail->>'liquid_volume_in_liters')::double precision,
    (detail->>'weight_in_kilograms')::double precision,
    (detail->>'lat_lng')::geography(point)
  FROM jsonb_array_elements(p_user_activity_details) AS detail
  ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
  SET
    text_value = excluded.text_value,
    environment_value = excluded.environment_value,
    numeric_value = excluded.numeric_value,
    duration_in_sec = excluded.duration_in_sec,
    distance_in_meters = excluded.distance_in_meters,
    liquid_volume_in_liters = excluded.liquid_volume_in_liters,
    weight_in_kilograms = excluded.weight_in_kilograms,
    lat_lng = excluded.lat_lng;

  DELETE FROM public.user_activity_sub_activity
  WHERE user_activity_id = (p_user_activity->>'user_activity_id')::uuid;

  -- Parse and insert the sub activities
  INSERT INTO public.user_activity_sub_activity (user_activity_id, sub_activity_id)
  SELECT
    (p_user_activity->>'user_activity_id')::uuid,
    sub_activity_id::uuid
  FROM jsonb_array_elements_text(p_user_activity->'sub_activity_ids') AS sub_activity_id;
END;
$$;

-- Update handle_external_data_apple_google to explicitly set activity_date
CREATE OR REPLACE FUNCTION public.handle_external_data_apple_google()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  _user_id uuid;
  _start_date timestamptz;
  _end_date timestamptz;
  _distance_unit text;
  _distance float;
  _duration_in_seconds int;
  _distance_in_meters float;
  _activity_id uuid;
  _sub_activity_id uuid;
  _user_activity_id uuid;
BEGIN
  IF new.external_data_source <> 'apple_google' THEN
    RETURN new;
  END IF;

  PERFORM public.set_local_timezone();

  _user_id := new.user_id;
  _start_date := (new.data ->> 'dateFrom')::timestamptz AT TIME ZONE 'utc';
  _end_date := (new.data ->> 'dateTo')::timestamptz AT TIME ZONE 'utc';
  _distance_unit := new.data -> 'value' ->> 'totalDistanceUnit';
  _distance := (new.data -> 'workoutSummary' ->> 'totalDistance')::float;
  _duration_in_seconds := extract(epoch FROM _end_date - _start_date)::int;
  _distance_in_meters := public.convert_to_meters(_distance, _distance_unit);

  SELECT sa.activity_id, sa.sub_activity_id
  INTO _activity_id, _sub_activity_id
  FROM public.external_data_mapping m
    JOIN public.sub_activity sa ON m.sub_activity_id = sa.sub_activity_id
  WHERE m.external_data_source = new.external_data_source
    AND m.source_name = new.data -> 'value' ->> 'workoutActivityType'
    AND new.data ->> 'type' = 'WORKOUT';

  IF _activity_id IS NULL THEN
    SELECT a.activity_id
    INTO _activity_id
    FROM public.external_data_mapping m
      JOIN public.activity a ON m.activity_id = a.activity_id
    WHERE m.external_data_source = new.external_data_source
      AND m.source_name = new.data -> 'value' ->> 'workoutActivityType'
      AND new.data ->> 'type' = 'WORKOUT';
  END IF;

  IF _activity_id IS NULL THEN
    RETURN new;
  END IF;

  IF _sub_activity_id IS NOT NULL THEN
    INSERT INTO public.user_activity (user_id, activity_id, activity_timestamp, activity_date, external_data_id)
    VALUES (_user_id, _activity_id, _start_date, _start_date::date, new.external_data_id)
    RETURNING user_activity_id INTO _user_activity_id;

    INSERT INTO public.user_activity_sub_activity (user_activity_id, sub_activity_id)
    VALUES (_user_activity_id, _sub_activity_id);
  ELSE
    INSERT INTO public.user_activity (user_id, activity_id, activity_timestamp, activity_date, external_data_id)
    VALUES (_user_id, _activity_id, _start_date, _start_date::date, new.external_data_id)
    RETURNING user_activity_id INTO _user_activity_id;
  END IF;

  INSERT INTO public.user_activity_detail (user_activity_id, activity_detail_id, duration_in_sec)
  SELECT _user_activity_id,
    d.activity_detail_id,
    _duration_in_seconds
  FROM public.activity_detail d
  WHERE d.activity_id = _activity_id
    AND d.activity_detail_type = 'duration'
  ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
  SET duration_in_sec = _duration_in_seconds;

  INSERT INTO public.user_activity_detail (user_activity_id, activity_detail_id, distance_in_meters)
  SELECT _user_activity_id,
    d.activity_detail_id,
    _distance_in_meters
  FROM public.activity_detail d
  WHERE d.activity_id = _activity_id
    AND d.activity_detail_type = 'distance'
  ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
  SET distance_in_meters = _distance_in_meters;

  RETURN new;
END;
$$;

-- Update handle_external_data_legacy to explicitly set activity_date
CREATE OR REPLACE FUNCTION public.handle_external_data_legacy()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  _timezone text;
  _user_id uuid;
  _created_at timestamptz;
  _start_date timestamptz;
  _end_date timestamptz;
  _duration_in_seconds int;
  _unit_of_measure text;
  _distance double precision;
  _distance_in_meters double precision;
  _liquid_volume double precision;
  _liquid_volume_in_liters double precision;
  _weight double precision;
  _weight_in_kilograms double precision;
  _count double precision;
  _activity_id uuid;
  _user_activity_id uuid;
  _sub_activity_ids uuid[];
  _environment text;
  _comments text;
  _activity_name_override text;
BEGIN
  IF new.external_data_source <> 'legacy' THEN
    RETURN new;
  END IF;

  PERFORM public.set_local_timezone();

  _user_id := new.user_id;
  _created_at := nullif(new.data ->> 'created_at', '')::timestamptz AT TIME ZONE 'America/Chicago';
  _start_date := nullif(new.data ->> 'start_date', '')::timestamptz AT TIME ZONE 'America/Chicago';
  _end_date := nullif(new.data ->> 'end_date', '')::timestamptz AT TIME ZONE 'America/Chicago';
  _duration_in_seconds := nullif(new.data ->> 'duration', '')::int;
  _unit_of_measure := left(upper(nullif(nullif(new.data ->> 'measurement_name', ''), 'n/a')), -1);
  _distance := nullif(new.data ->> 'distance', '')::double precision;
  _distance_in_meters := public.convert_to_meters(_distance, _unit_of_measure);
  _liquid_volume := nullif(new.data ->> 'step_count', '')::double precision;
  _liquid_volume_in_liters := public.convert_to_liters(_liquid_volume, _unit_of_measure);
  _weight := nullif(new.data ->> 'step_count', '')::double precision;
  _weight_in_kilograms := public.convert_to_kilograms(_weight, _unit_of_measure);
  _count := nullif(new.data ->> 'step_count', '')::double precision;
  _environment := nullif(new.data ->> 'classification_name', '');
  _comments := nullif(new.data ->> 'comment', '');
  _activity_name_override := nullif(new.data ->> 'name_override', '');
  _activity_id := (
    SELECT activity_id
    FROM public.activity
    WHERE legacy_id = (new.data -> 'activity_id')::int
  );
  _sub_activity_ids = (
    SELECT array_agg(sa.sub_activity_id)
    FROM public.sub_activity sa
      JOIN (
        SELECT unnest(concat('{', new.data ->> 'sub_activity', '}')::int[]) AS sub_activity_id
      ) x ON sa.legacy_id = x.sub_activity_id
  );

  IF _activity_id IS NOT NULL THEN
    INSERT INTO public.user_activity (user_id, activity_id, created_at, activity_timestamp, activity_date, external_data_id, comments, activity_name_override)
    VALUES (_user_id, _activity_id, _created_at, _start_date, _start_date::date, new.external_data_id, _comments, _activity_name_override)
    RETURNING user_activity_id INTO _user_activity_id;

    INSERT INTO public.user_activity_detail (user_activity_id, activity_detail_id, duration_in_sec)
    SELECT _user_activity_id,
      d.activity_detail_id,
      _duration_in_seconds
    FROM public.activity_detail d
    WHERE d.activity_id = _activity_id
      AND d.activity_detail_type = 'duration'
    ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
    SET duration_in_sec = _duration_in_seconds;

    INSERT INTO public.user_activity_detail (user_activity_id, activity_detail_id, distance_in_meters)
    SELECT _user_activity_id,
      d.activity_detail_id,
      _distance_in_meters
    FROM public.activity_detail d
    WHERE d.activity_id = _activity_id
      AND d.activity_detail_type = 'distance'
    ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
    SET distance_in_meters = _distance_in_meters;

    INSERT INTO public.user_activity_detail (user_activity_id, activity_detail_id, liquid_volume_in_liters)
    SELECT _user_activity_id,
      d.activity_detail_id,
      _liquid_volume_in_liters
    FROM public.activity_detail d
    WHERE d.activity_id = _activity_id
      AND d.activity_detail_type = 'liquidVolume'
    ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
    SET liquid_volume_in_liters = _liquid_volume_in_liters;

    INSERT INTO public.user_activity_detail (user_activity_id, activity_detail_id, weight_in_kilograms)
    SELECT _user_activity_id,
      d.activity_detail_id,
      _weight_in_kilograms
    FROM public.activity_detail d
    WHERE d.activity_id = _activity_id
      AND d.activity_detail_type = 'weight'
    ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
    SET weight_in_kilograms = _weight_in_kilograms;

    INSERT INTO public.user_activity_detail (user_activity_id, activity_detail_id, numeric_value)
    SELECT _user_activity_id,
      d.activity_detail_id,
      _count::int
    FROM public.activity_detail d
    WHERE d.activity_id = _activity_id
      AND d.activity_detail_type = 'integer'
    ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
    SET numeric_value = _count::int;

    INSERT INTO public.user_activity_detail (user_activity_id, activity_detail_id, numeric_value)
    SELECT _user_activity_id,
      d.activity_detail_id,
      _count::double precision
    FROM public.activity_detail d
    WHERE d.activity_id = _activity_id
      AND d.activity_detail_type = 'double'
    ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
    SET numeric_value = _count::double precision;

    INSERT INTO public.user_activity_detail (user_activity_id, activity_detail_id, environment_value)
    SELECT _user_activity_id,
      d.activity_detail_id,
      lower(_environment)::public.environment_type
    FROM public.activity_detail d
    WHERE d.activity_id = _activity_id
      AND d.activity_detail_type = 'environment'
    ON CONFLICT (user_activity_id, activity_detail_id) DO UPDATE
    SET environment_value = lower(_environment)::public.environment_type;

    IF _sub_activity_ids IS NOT NULL THEN
      INSERT INTO public.user_activity_sub_activity(user_activity_id, sub_activity_id)
      SELECT _user_activity_id, sub_activity_id
      FROM unnest(_sub_activity_ids) AS sub_activity_id;
    END IF;
  END IF;

  RETURN new;
END;
$$;

-- ============================================================================
-- PHASE 4: Update Query Functions
-- ============================================================================

-- Update user_activities_by_date to use activity_date column
CREATE OR REPLACE FUNCTION public.user_activities_by_date()
RETURNS SETOF public._user_activities_by_date
STABLE
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
  PERFORM public.set_local_timezone();

  RETURN QUERY
  WITH date_series AS (
    SELECT generate_series(
      least((
        SELECT min(activity_date)
        FROM public.user_activity
        WHERE user_id = auth.uid()
      ), current_date - interval '30 days'),
      current_date,
      interval '1 day'
    )::timestamptz AS activity_date
  )
  SELECT
    auth.uid() AS user_id,
    ds.activity_date,
    coalesce(count(ua), 0) AS activity_count,
    coalesce(
      jsonb_build_object(
        'userActivities', jsonb_build_object(
          '__typename', 'UserActivityConnection',
          'edges', CASE WHEN count(ua) = 0 THEN '[]' ELSE jsonb_agg(
            jsonb_build_object(
              '__typename', 'UserActivityEdge',
              'node', jsonb_build_object(
                '__typename', 'UserActivity',
                'userActivityId', ua.user_activity_id,
                'activityTimestamp', ua.activity_timestamp,
                'activityId', ua.activity_id,
                'activityNameOverride', ua.activity_name_override,
                'activity', jsonb_build_object(
                  '__typename', 'Activity',
                  'activityId', a.activity_id,
                  'icon', a.icon,
                  'name', a.name,
                  'activityCategory', jsonb_build_object(
                    '__typename', 'ActivityCategory',
                    'activityCategoryId', ac.activity_category_id,
                    'icon', ac.icon,
                    'name', ac.name,
                    'hexColor', ac.hex_color,
                    'sortOrder', ac.sort_order
                  )
                ),
                'userActivitySubActivityCollection', jsonb_build_object(
                  '__typename', 'UserActivitySubActivityConnection',
                  'edges', coalesce(x.sub_activities, '[]')
                )
              )
            )
            ORDER BY ua.created_at DESC
          ) END
        )
      ),
      jsonb_build_object(
        'userActivities', jsonb_build_object(
          'edges', '[]'::jsonb
        )
      )
    ) AS user_activities
  FROM date_series ds
  LEFT JOIN public.user_activity ua
    ON ds.activity_date::date = ua.activity_date
    AND ua.user_id = auth.uid()
  LEFT JOIN public.activity a USING (activity_id)
  LEFT JOIN public.activity_category ac USING (activity_category_id)
  LEFT JOIN LATERAL (
      SELECT jsonb_agg(
        jsonb_build_object(
          '__typename', 'UserActivitySubActivityEdge',
          'node', jsonb_build_object(
            '__typename', 'UserActivitySubActivity',
            'subActivity', jsonb_build_object(
              '__typename', 'SubActivity',
              'icon', sa.icon,
              'name', sa.name,
              'activity', jsonb_build_object(
                '__typename', 'Activity',
                'icon', a.icon,
                'name', a.name,
                'activityId', a.activity_id,
                'activityCategory', jsonb_build_object(
                  '__typename', 'ActivityCategory',
                  'icon', ac.icon,
                  'name', ac.name,
                  'hexColor', ac.hex_color,
                  'sortOrder', ac.sort_order,
                  'activityCategoryId', ac.activity_category_id
                ),
                'activityDateType', a.activity_date_type,
                'activityCategoryId', a.activity_category_id
              ),
              'activityId', sa.activity_id,
              'subActivityId', sa.sub_activity_id
            )
          )
        )
      ) AS sub_activities
      FROM public.user_activity_sub_activity uac
        JOIN public.sub_activity sa ON uac.sub_activity_id = sa.sub_activity_id
        JOIN public.activity a2 ON sa.activity_id = a2.activity_id
        JOIN public.activity_category ac ON a.activity_category_id = ac.activity_category_id
      WHERE ua.user_activity_id = uac.user_activity_id
    ) x ON TRUE
  WHERE ds.activity_date <= current_timestamp
  GROUP BY ds.activity_date, ua.user_id;
END
$$;

-- Update user_activity_streak to use activity_date column
CREATE OR REPLACE FUNCTION public.user_activity_streak()
RETURNS public._user_activity_streak
STABLE
LANGUAGE plpgsql
SET search_path = ''
AS $$
DECLARE
    user_id uuid;
    longest_streak int;
    current_streak int;
    workout_days_this_week int;
BEGIN
  PERFORM public.set_local_timezone();

  WITH user_activities AS (
    SELECT activity_date,
      activity_date - interval '1 day' * row_number() OVER (ORDER BY activity_date) AS streak_group
    FROM (
      SELECT DISTINCT activity_date
      FROM public.user_activity ua
      WHERE ua.user_id = auth.uid()
        AND ua.activity_date < (current_date + interval '1 day')::date
    ) ua
    ORDER BY activity_date
  ),
  streaks AS (
      SELECT min(activity_date) AS streak_start_date,
        max(activity_date) AS streak_end_date,
        count(*) AS streak_length
      FROM user_activities
      GROUP BY streak_group
  ),
  workout_days_this_week AS (
      SELECT count(DISTINCT ua.activity_date) AS workout_days_this_week
      FROM public.user_activity ua
        JOIN public.activity a USING (activity_id)
        JOIN public.activity_category ac USING (activity_category_id)
      WHERE ua.user_id = auth.uid()
        AND ac.activity_category_code = any(array['workouts', 'sports'])
        AND ua.activity_date >= (current_date - extract(dow FROM current_date)::integer)
  )
  SELECT auth.uid(),
    coalesce(s.longest_streak, 0) AS longest_streak,
    coalesce(s.current_streak, 0) AS current_streak,
    coalesce(w.workout_days_this_week, 0) AS workout_days_this_week
  INTO user_id, longest_streak, current_streak, workout_days_this_week
  FROM workout_days_this_week w
    RIGHT JOIN (
      SELECT max(s.streak_length) AS longest_streak,
        max(s.streak_length) FILTER (WHERE s.streak_end_date = current_date) AS current_streak
      FROM streaks s
    ) s ON TRUE;

    RETURN (
      user_id,
      longest_streak,
      current_streak,
      workout_days_this_week
    )::public._user_activity_streak;
END
$$;

-- Update user_activity_day_count to use activity_date column
CREATE OR REPLACE FUNCTION public.user_activity_day_count(
  start_date timestamp with time zone,
  end_date timestamp with time zone
)
RETURNS jsonb
STABLE
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
  PERFORM public.set_local_timezone();

  RETURN (
    WITH daily_activity_count AS (
      SELECT
        user_id,
        max(activity_timestamp) AS activity_day,
        count(1)::int activity_count
      FROM
        public.user_activity
      WHERE
        user_id = auth.uid() AND
        activity_timestamp BETWEEN start_date AND end_date
      GROUP BY
        user_id, activity_date
    )
    SELECT jsonb_build_object(
      'data', jsonb_agg(to_jsonb(d))
    ) AS result
    FROM daily_activity_count d
  );
END;
$$;

-- Create view for activity counts by date.
-- Mainly used by the profile screen
create view activity_counts_by_date
with (security_invoker = true)
as
select user_id, activity_date, activity_category_id, count(1)
from user_activity ua
  join activity a using (activity_id)
group by user_id, ua.activity_date, activity_category_id;

create function activity_category(activity_counts_by_date) returns setof activity_category rows 1 as $$
  select * from activity_category where activity_category_id = $1.activity_category_id
$$ stable language sql;
