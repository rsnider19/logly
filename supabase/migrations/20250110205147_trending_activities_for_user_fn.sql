create or replace function trending_activities_for_user()
returns setof activity
as $$
begin
  return query
  with recent_user_activities as (
    -- fetch activities by the user in the last 30 days
    select
      ua.activity_id,
      a.name,
      a.activity_category_id,
      max(ua.activity_timestamp) as last_used,
      count(*) as total_usage
    from public.user_activity ua
    join public.activity a on ua.activity_id = a.activity_id
    where ua.user_id = auth.uid()
      and ua.activity_timestamp >= now() - interval '30 days'
    group by ua.activity_id, a.name, a.activity_category_id
  ),
  weighted_activities as (
    -- calculate the weight for each activity
    select
      ra.activity_category_id,
      ra.activity_id,
      ra.name,
      exp(extract(epoch from (now() - ra.last_used)) / -86400.0) * 0.7 + ra.total_usage * 0.3 as weight
    from recent_user_activities ra
  ),
  combined_results as (
    -- trending user activites
    select
      wa.activity_category_id,
      wa.activity_id,
      wa.name,
      row_number() over (partition by wa.activity_category_id order by wa.weight desc, wa.name asc) as rank,
      1 as grouping
    from weighted_activities wa
    union
    -- trending global activities
    select a.activity_category_id,
      a.activity_id,
      a.name,
      current_rank as rank,
      2 as grouping
    from trending_activity ta
      join activity a using (activity_id)
    union
    -- all activities
    select a.activity_category_id,
      a.activity_id,
      a.name,
      row_number() over (order by a.name asc) as rank,
      3 as grouping
    from public.activity a
  ),
  distinct_results as (
    -- Rank distinct activities based on grouping and rank
    select distinct on (activity_id)
      cr.activity_id,
      cr.activity_category_id,
      cr.name,
      cr.grouping,
      cr.rank
    from combined_results cr
    order by cr.activity_id, cr.grouping, cr.rank
  )
  select a.*
  from public.activity a
  join (
    select
      activity_id,
      row_number() over (partition by activity_category_id order by grouping asc, rank asc, name asc) as rank
    from distinct_results
  ) x using (activity_id)
  where x.rank <= 10
  order by rank;
end;
$$ language plpgsql stable;
