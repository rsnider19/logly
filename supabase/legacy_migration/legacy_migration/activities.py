print()

import json
import uuid
import mysql.connector
import psycopg2
from collections import namedtuple

uuid_namespace = "mylogly.app"

old_db = mysql.connector.connect(
  host="ec2-3-136-84-120.us-east-2.compute.amazonaws.com",
  user="rob",
  password="BonusBuck.19",
  database="logly_live"
)

final_sql = ""
activity_category_sql = "insert into public.activity_category (activity_category_id, created_at, created_by, name, description, hex_color, icon, legacy_id, sort_order) values "
activity_sql = "insert into public.activity (activity_id, created_at, created_by, name, description, icon, legacy_id, activity_date_type, activity_category_id) values "
sub_activity_sql = "insert into public.sub_activity (sub_activity_id, created_at, created_by, name, icon, legacy_id, activity_id) values "

category_entity = namedtuple("category_entity", ("id", "name", "color", "icon"))
activity_entity = namedtuple("activity_entity", ("id", "name", "select_date", "category_id", "icon"))
sub_activity_entity = namedtuple("sub_activity_entity", ("id", "name", "icon", "activity_icon", "activity_id"))


def insert_categories():
    global final_sql

    mysql_cursor = old_db.cursor()
    mysql_cursor.execute('''
        select c.id,
          c.name,
          c.color,
          concat('https://loglyimages.s3.us-east-2.amazonaws.com/', i.icon) as icon
        from categories c 
          join icon i on c.icon_id = i.id
        where c.id in (1, 2, 3, 4, 6, 12)
    ''')
    
    categories = mysql_cursor.fetchall()

    final_sql += activity_category_sql + '\n'
    for i, category_row in enumerate(categories):
        category = category_entity(*category_row)
        activity_category_id = uuid.uuid5(namespace=uuid.NAMESPACE_URL, name=f"{uuid_namespace}/category/{category.id}")
        final_sql += f"  ('{activity_category_id}', clock_timestamp(), '00000000-0000-0000-0000-000000000000', '{category.name.replace("'", "''").strip()}', null, '{category.color.upper()}', '{category.icon}', {category.id}, {i}),\n"

    final_sql = final_sql[:-2]
    final_sql += ';\n\n'


def insert_activities():
    global final_sql
    
    mysql_cursor = old_db.cursor()
    mysql_cursor.execute(f'''
        select a.id,
            a.name, 
            a.select_date,
            a.category_id,
            concat('https://loglyimages.s3.us-east-2.amazonaws.com/', nullif(i.icon, '')) as icon
        from activities a 
            left join icon i on a.activity_icon = i.id
        where activity_type = 0
            and is_deleted <> 1
            and category_id in (1, 2, 3, 4, 6, 12)
    '''
    )
    
    activities = mysql_cursor.fetchall()

    final_sql += activity_sql + '\n'
    for activity_row in activities:
        activity = activity_entity(*activity_row)
        activity_id = uuid.uuid5(namespace=uuid.NAMESPACE_URL, name=f"{uuid_namespace}/activity/{activity.id}")
        category_id = uuid.uuid5(namespace=uuid.NAMESPACE_URL, name=f"{uuid_namespace}/category/{activity.category_id}")        
        final_sql += f"  ('{activity_id}', clock_timestamp(), '00000000-0000-0000-0000-000000000000', '{activity.name.replace("'", "''").strip()}', null, {("'" + activity.icon + "'") if activity.icon else 'null'}, {activity.id}, '{'range' if activity.select_date == '2' else 'single' }', '{category_id}'),\n"

    final_sql = final_sql[:-2]
    final_sql += ';\n\n'


def insert_sub_activities():
    global final_sql
    
    mysql_cursor = old_db.cursor()
    mysql_cursor.execute(f'''
        select sa.id,
            sa.name,
            concat('https://loglyimages.s3.us-east-2.amazonaws.com/', nullif(i.icon, '')) as icon,
            concat('https://loglyimages.s3.us-east-2.amazonaws.com/', nullif(ai.icon, '')) as activity_icon,
            sa.activity_id
        from sub_activities sa 
            join activities a on sa.activity_id = a.id
            left join icon i on sa.icon_id = i.id
            left join icon ai on a.activity_icon = ai.id
        where activity_type = 0
            and is_deleted <> 1
            and category_id in (1, 2, 3, 4, 6, 12)
    '''
    )
    
    sub_activities = mysql_cursor.fetchall()

    final_sql += sub_activity_sql + '\n'
    for sub_activity_row in sub_activities:
        sub_activity = sub_activity_entity(*sub_activity_row)
        sub_activity_id = uuid.uuid5(namespace=uuid.NAMESPACE_URL, name=f"{uuid_namespace}/sub_activity/{sub_activity.id}")
        activity_id = uuid.uuid5(namespace=uuid.NAMESPACE_URL, name=f"{uuid_namespace}/activity/{sub_activity.activity_id}")
        icon = sub_activity.icon if sub_activity.icon else sub_activity.activity_icon
        final_sql += f"  ('{sub_activity_id}', clock_timestamp(), '00000000-0000-0000-0000-000000000000', '{sub_activity.name.replace("'", "''").strip()}', {("'" + icon + "'") if icon else 'null'}, {sub_activity.id}, '{activity_id}'),\n"

    final_sql = final_sql[:-2]
    final_sql += ';\n\n'


def insert_activity_detail_environment():
    global final_sql

    mysql_cursor = old_db.cursor()
    mysql_cursor.execute(f'''
        select a.id
        from activities a
        where coalesce(indoor_outdoor, '') <> ''
          and activity_type = 0
          and is_deleted <> 1
          and category_id in (1, 2, 3, 4, 6, 12)
    '''
    )

    activities = mysql_cursor.fetchall()
    ids = [str(activity[0]) for activity in activities]

    final_sql += (
        "insert into activity_detail(created_by, activity_id, label, activity_detail_type, sort_order)\n"
        "select '00000000-0000-0000-0000-000000000000', activity_id, 'Environment', 'environment', 10\n"
        "from activity\n"
        f"where legacy_id in ({','.join(ids)});\n\n"
    )


def insert_activity_detail_integer():
    global final_sql

    mysql_cursor = old_db.cursor()
    mysql_cursor.execute(f'''
        select a.id,
            cast(coalesce(nullif(min_count , ''), 0) as signed) as min_count,
            cast(max_count as signed) as max_count
        from activities a
        where max_count <> ''
            and activity_type = 0
            and is_deleted <> 1
            and category_id in (1, 2, 3, 4, 6, 12)
            and measurement_id in (5, 6, 7)
            and id not in (52, 371)
    '''
    )

    activities = mysql_cursor.fetchall()

    final_sql += "insert into activity_detail(created_by, activity_id, label, activity_detail_type, sort_order, min_numeric, max_numeric, slider_interval) values\n"
    for activity in activities:
        id, min_count, max_count = activity
        activity_id = uuid.uuid5(namespace=uuid.NAMESPACE_URL, name=f"{uuid_namespace}/activity/{id}")
        final_sql += f"  ('00000000-0000-0000-0000-000000000000', '{activity_id}', 'Count', 'integer', 20, {min_count}, {max_count}, 1),\n"

    final_sql = final_sql[:-2]
    final_sql += ';\n\n'


def insert_weight():
    global final_sql

    activity_id = uuid.uuid5(namespace=uuid.NAMESPACE_URL, name=f"{uuid_namespace}/activity/{371}")
    final_sql += "insert into activity_detail(created_by, activity_id, label, activity_detail_type, sort_order, min_weight_in_kilograms, max_weight_in_kilograms, slider_interval, metric_uom, imperial_uom) values\n"
    final_sql += f"  ('00000000-0000-0000-0000-000000000000', '{activity_id}', 'Weight', 'weight', 30, 0, 181, 0.1, 'kilograms', 'pounds');\n\n"


def insert_water():
    global final_sql

    activity_id = uuid.uuid5(namespace=uuid.NAMESPACE_URL, name=f"{uuid_namespace}/activity/{502}")
    final_sql += "insert into activity_detail(created_by, activity_id, label, activity_detail_type, sort_order, min_liquid_volume_in_liters, max_liquid_volume_in_liters, slider_interval, metric_uom, imperial_uom) values\n"
    final_sql += f"  ('00000000-0000-0000-0000-000000000000', '{activity_id}', 'Volume', 'liquidVolume', 40, 0, 7.39, 1, 'milliliters', 'fluidOunces');\n\n"


def insert_activity_detail_duration():
    global final_sql
    
    mysql_cursor = old_db.cursor()
    mysql_cursor.execute(f'''
        select a.id,
            cast(coalesce(nullif(min_duration, ''), 0) as signed) as min_duration,
            cast(max_duration as signed) as max_duration 
        from activities a
        where max_duration <> ''
            and activity_type = 0
            and is_deleted <> 1
            and category_id in (1, 2, 3, 4, 6, 12)
    '''
    )

    activities = mysql_cursor.fetchall()
    
    final_sql += "insert into activity_detail(created_by, activity_id, label, activity_detail_type, sort_order, min_duration_in_sec, max_duration_in_sec, slider_interval) values\n"
    for activity in activities:
        id, min_duration, max_duration = activity
        activity_id = uuid.uuid5(namespace=uuid.NAMESPACE_URL, name=f"{uuid_namespace}/activity/{id}")
        final_sql += f"  ('00000000-0000-0000-0000-000000000000', '{activity_id}', 'Duration', 'duration', 50, {min_duration}, {max_duration}, 60),\n"
    
    final_sql = final_sql[:-2]
    final_sql += ';\n\n'


def insert_activity_detail_short_distance():
    global final_sql
    
    mysql_cursor = old_db.cursor()
    mysql_cursor.execute(f'''
        select a.id,
            cast(coalesce(nullif(min_distance, ''), 0) as signed) as min_distance,
            cast(max_distance as signed) as max_distance
        from activities a
        where max_distance <> ''
            and measurement_id = '3,4'
            and activity_type = 0
            and is_deleted <> 1
            and category_id in (1, 2, 3, 4, 6, 12)
    '''
    )

    activities = mysql_cursor.fetchall()
    
    final_sql += "insert into activity_detail(created_by, activity_id, label, activity_detail_type, sort_order, min_distance_in_meters, max_distance_in_meters, slider_interval, metric_uom, imperial_uom) values\n"
    for activity in activities:
        id, min_distance, max_distance = activity
        activity_id = uuid.uuid5(namespace=uuid.NAMESPACE_URL, name=f"{uuid_namespace}/activity/{id}")
        final_sql += f"  ('00000000-0000-0000-0000-000000000000', '{activity_id}', 'Distance', 'distance', 60, {min_distance}, {max_distance}, 0.1, 'meters', 'yards'),\n"
    
    final_sql = final_sql[:-2]
    final_sql += ';\n\n'


def insert_activity_detail_long_distance():
    global final_sql
    
    mysql_cursor = old_db.cursor()
    mysql_cursor.execute(f'''
        select a.id,
            cast(coalesce(nullif(min_distance, ''), 0) as signed) as min_distance,
            cast(max_distance as signed) as max_distance
        from activities a
        where max_distance <> ''
            and measurement_id = '1,2'
            and activity_type = 0
            and is_deleted <> 1
            and category_id in (1, 2, 3, 4, 6, 12)
    '''
    )

    activities = mysql_cursor.fetchall()
    
    final_sql += "insert into activity_detail(created_by, activity_id, label, activity_detail_type, sort_order, min_distance_in_meters, max_distance_in_meters, slider_interval, metric_uom, imperial_uom) values\n"
    for activity in activities:
        id, min_distance, max_distance = activity
        activity_id = uuid.uuid5(namespace=uuid.NAMESPACE_URL, name=f"{uuid_namespace}/activity/{id}")
        final_sql += f"  ('00000000-0000-0000-0000-000000000000', '{activity_id}', 'Distance', 'distance', 60, {min_distance * 1000}, {max_distance * 1000}, 0.1, 'kilometers', 'miles'),\n"
    
    final_sql = final_sql[:-2]
    final_sql += ';\n\n'


insert_categories()
insert_activities()
insert_sub_activities()
insert_activity_detail_environment()
insert_activity_detail_integer()
insert_weight()
insert_water()
insert_activity_detail_duration()
insert_activity_detail_short_distance()
insert_activity_detail_long_distance()

# Print the SQL statements
with open('../seed.sql', 'w') as file:
    file.write(
        "select vault.create_secret('http://host.docker.internal:54321/functions/v1', 'functions-endpoint');\n" +
        "select vault.create_secret('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU','service-role-key');\n\n" +
        "insert into auth.users(instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, recovery_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token)\n" +
        "values('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'admin@mylogly.app', crypt('Test123#', gen_salt('bf', 12)), now() at time zone 'utc', now() at time zone 'utc', now() at time zone 'utc', '{\"provider\":\"email\",\"providers\":[\"email\"]}', '{}', now() at time zone 'utc', now() at time zone 'utc', '', '', '', '');\n\n" +
        "insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)\n" +
        "values(gen_random_uuid(), '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', format('{\"sub\":\"%s\",\"email\":\"%s\"}', '00000000-0000-0000-0000-000000000000', 'admin@mylogly.app')::jsonb, 'email', now() at time zone 'utc', now() at time zone 'utc', now() at time zone 'utc');\n\n" +
        final_sql
    )
