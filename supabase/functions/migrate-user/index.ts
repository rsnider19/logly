import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { Client } from "https://deno.land/x/mysql@v2.12.1/mod.ts";
import { supabaseAdminClient } from "../_utils/supabaseAdmin.ts";
import { chunk } from "https://deno.land/x/lodash@4.17.15-es/lodash.js";

Deno.serve(async (req) => {
  const authHeader = req.headers.get("Authorization")!;
  const token = authHeader.replace("Bearer", "").trim();

  if (token != Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")) {
    return new Response(
      "Unauthorized",
      { status: 401 },
    );
  }

  const { id, email } = await req.json();

  console.log("migrate user", { id, email });
  if (!id || !email) {
    return new Response(
      "Body must contain `id` and `email`.",
      { status: 400 },
    );
  }

  const client = await new Client().connect({
    hostname: Deno.env.get("LEGACY_MYSQL_HOST"),
    port: parseInt(Deno.env.get("LEGACY_MYSQL_PORT") || "3306", 10),
    db: Deno.env.get("LEGACT_MYSQL_DB"),
    username: Deno.env.get("LEGACT_MYSQL_USER"),
    password: Deno.env.get("LEGACY_MYSQL_PASSWORD"),
  });

  const query = `
      select
        concat('00000000-0000-0000-0000-', lpad(ua.id, 12, '0')) as external_data_id,
        ? as user_id,
        'legacy' as external_data_source,
        json_object(
          'id', ua.id,
          'user_id', ua.user_id,
          'activity_id', coalesce(p.id, a.id),
          'activity_name', coalesce(p.name, a.name),
          'apple_health', ua.apple_health,
          'user_activity_profile_id', ua.user_activity_profile_id,
          'category_id', ua.category_id,
          'category_name', ca.name,
          'streak', ua.streak,
          'created_at', concat(date(ua.created_at), 'T12:00:00'),
          'updated_at', ua.updated_at,
          'distance', ua.distance,
          'distance_unit', ua.distanceUnit,
          'measurement_id', ua.measurement_id,
          'measurement_name', m.name,
          'duration', ua.duration,
          'environment_id', ua.environment_id,
          'comment', ua.comment,
          'title', ua.title,
          'pace', ua.pace,
          'pace_x', ua.pace_x,
          'pace_y', ua.pace_y,
          'pace_unit_x', ua.pace_unit_x,
          'pace_unit_y', ua.pace_unit_y,
          'classification_id', ua.classification_id,
          'classification_name', c.name,
          'step_count', ua.step_count,
          'calories', ua.calories,
          'location', ua.location,
          'is_hidden', ua.is_hidden,
          'sub_activity', ua.sub_activity,
          'name_override', ua.name_override,
          'latitude', ua.latitude,
          'longitude', ua.longitude,
          'start_date', concat(date(ua.start_date), 'T12:00:00'),
          'end_date', concat(date(ua.end_date), 'T12:00:00'),
          'is_deleted', ua.is_deleted
        ) as data
      from logly_live.user_activities ua
        join logly_live.activities a on ua.activity_id = a.id
        left join logly_live.activities p on p.id = a.activity_profile_id
        join logly_live.users u on ua.user_id = u.id
        left join logly_live.measurements m on ua.measurement_id = m.id
        left join logly_live.classifications c on ua.classification_id = c.id
        left join logly_live.categories ca on ua.category_id = ca.id
      where email = ?
        and ua.apple_health <> 1
        and ua.is_deleted <> 1;
    `;

  let resp = await client.query(
    query,
    [id, email],
  );

  console.log("records found", resp.length);

  resp = resp.map((record: any) => ({
    ...record,
    data: JSON.parse(record.data),
  }));

  const chunks = chunk(resp, 1000, undefined);
  try {
    await Promise.all(
      chunks.map(async (chunk) => {
        const { error, data } = await supabaseAdminClient
          .from("external_data")
          .upsert(chunk, { ignoreDuplicates: true });

        console.log("upserted", { error, data });

        if (error) {
          throw new Error(error.message);
        }
      }),
    );

    return new Response(
      JSON.stringify({}),
      { headers: { "Content-Type": "application/json" } },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({
        error: e.message,
      }),
      { status: 500 },
    );
  }
});
