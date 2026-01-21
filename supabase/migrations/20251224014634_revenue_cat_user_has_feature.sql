create or replace function revenue_cat.user_has_feature(p_user_id uuid, p_feature text)
 returns boolean
 language sql
 stable
as $function$
  select exists (
    select 1
    from revenue_cat.user_entitlement ue
      join revenue_cat.entitlement_feature ef on ue.entitlement_id = ef.entitlement_id
    where ue.user_id = p_user_id
      and ef.feature = p_feature
  );
$function$;
