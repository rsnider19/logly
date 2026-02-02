CREATE OR REPLACE FUNCTION get_sub_activity_frequency(p_activity_id uuid)
RETURNS TABLE(sub_activity_id uuid, usage_count bigint)
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
  SELECT uasa.sub_activity_id, COUNT(*) AS usage_count
  FROM user_activity_sub_activity uasa
  JOIN user_activity ua ON ua.user_activity_id = uasa.user_activity_id
  WHERE ua.activity_id = p_activity_id AND ua.user_id = auth.uid()
  GROUP BY uasa.sub_activity_id
  ORDER BY usage_count DESC;
$$;
