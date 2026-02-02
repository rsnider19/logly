/**
 * Compressed database schema for NL-to-SQL generation.
 *
 * This schema is optimized for token efficiency - each table is defined
 * in a compact single-line format with only essential columns.
 * It is embedded in the system prompt so the LLM knows the database structure.
 *
 * This is the same schema used by the ai-insights function since
 * both functions query the same database.
 */

export const COMPRESSED_SCHEMA = `
## SCHEMA

### public.activity_category
(activity_category_id,name,activity_category_code)

### public.activity
(activity_id,name,activity_category_id,pace_type)
FK: activity.activity_category_id → activity_category.activity_category_id

### public.activity_detail
(activity_detail_id,activity_id,label,activity_detail_type,min_numeric,max_numeric,min_duration_in_sec,max_duration_in_sec,min_distance_in_meters,max_distance_in_meters,use_for_pace_calculation)
FK: activity_detail.activity_id → activity.activity_id

### public.activity_embedding
(activity_id,fts)
FK: activity_embedding.activity_id → activity.activity_id

### public.sub_activity
(sub_activity_id,activity_id,name)
FK: sub_activity.activity_id → activity.activity_id

### public.user_activity
(user_activity_id,user_id,activity_id,activity_timestamp,comments,activity_name_override)
FK: user_activity.activity_id → activity.activity_id
FK: user_activity.user_id → profile.user_id

### public.user_activity_detail
(user_activity_id,activity_detail_id,activity_detail_type,text_value,environment_value,numeric_value,duration_in_sec,distance_in_meters,liquid_volume_in_liters,weight_in_kilograms,lat_lng)
FK: user_activity_detail.user_activity_id → user_activity.user_activity_id
FK: user_activity_detail.activity_detail_id → activity_detail.activity_detail_id

### public.user_activity_sub_activity
(user_activity_id,sub_activity_id)
FK: user_activity_sub_activity.user_activity_id → user_activity.user_activity_id
FK: user_activity_sub_activity.sub_activity_id → sub_activity.sub_activity_id

## ENUMS
activity_detail_type: string,integer,double,duration,distance,location,environment,liquidVolume,weight
environment_type: indoor,outdoor

## CATEGORY CODES
experiences,sports,mind_body,health,others,workouts
`.trim();
