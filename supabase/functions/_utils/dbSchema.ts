export const activityCategory = "" +
  "public.activity_category(activity_category_id,created_by,created_at,name,activity_category_code,description,hex_color,icon,legacy_id,sort_order)";

export const activity = "" +
  "public.activity(activity_id,created_by,created_at,updated_at,name,activity_code,description,hex_color,icon,legacy_id,activity_date_type,activity_category_id,is_suggested_favorite,pace_type,embedding_content)" +
  "activity.activity_category_id -> activity_category.activity_category_id";

export const activityDetail = "" +
  "public.activity_detail (activity_detail_id,created_by,created_at,updated_by,updated_at,activity_id,label,activity_detail_type,sort_order,min_numeric,max_numeric,min_duration_in_sec,max_duration_in_sec,min_distance_in_meters,max_distance_in_meters,min_liquid_volume_in_liters,max_liquid_volume_in_liters,min_weight_in_kilograms,max_weight_in_kilograms,slider_interval,metric_uom,imperial_uom,use_for_pace_calculation)" +
  "activity_detail.activity_id -> activity.activity_id";

export const activityEmbedding = "" +
  "public.activity_embedding (,activity_id,embedding,fts,created_at,updated_at)" +
  "activity_embedding.activity_id -> activity.activity_id";

export const subActivity = "" +
  "public.sub_activity (sub_activity_id,activity_id,created_by,created_at,updated_at,name,sub_activity_code,icon,legacy_id)" +
  "sub_activity.activity_id -> activity.activity_id";

export const userActivity ='' +
  'public.user_activity (user_activity_id,created_at,updated_at,user_id,activity_id,activity_timestamp,comments,activity_name_override,external_data_id)' +
  'user_activity.activity_id -> activity.activity_id' +
  'user_activity.user_id -> profile.user_id' +
  'user_activity.external_data_id, user_activity.user_id -> external_data.external_data_id, external_data.user_id';

export const userActivityDetail = '' +
  'public.user_activity_detail (user_activity_id,activity_detail_id,activity_detail_type,created_at,updated_at,text_value,environment_value,numeric_value,duration_in_sec,distance_in_meters,liquid_volume_in_liters,weight_in_kilograms,lat_lng)' +
  'user_activity_detail.user_activity_id -> user_activity.user_activity_id' +
  'user_activity_detail.activity_detail_id -> activity_detail.activity_detail_id';

export const userActivitySubActivity = '' +
  'public.user_activity_sub_activity (user_activity_id,sub_activity_id)' +
  'user_activity_sub_activity.user_activity_id -> user_activity.user_activity_id' +
  'user_activity_sub_activity.sub_activity_id -> sub_activity.sub_activity_id';

export const enums = `
  public.activity_detail_type as enum (string,integer,double,duration,distance,location,environment,liquidVolume,weight)
  public.environment_type as enum (indoor,outdoor)
  public.distance_uom as enum (meters,yards,kilometers,miles)
  public.liquid_volume_uom as enum (milliliters,fluidOunces,liters,gallons)
  public.weight_uom as enum (grams,kilograms,ounces,pounds)
  public.metric_uom as enum (meters,kilometers,milliliters,liters,grams,kilogram)
  create type public.imperial_uom as enum (yards,miles,fluidOunces,gallons,ounces,pounds)
`;
