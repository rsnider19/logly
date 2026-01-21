import "@supabase/functions-js/edge-runtime.d.ts";
import { createUserClient } from "../_utils/supabaseClient.ts";
import { snakeToCamel } from "../_utils/snakeToCamel.ts";

Deno.serve(async (req) => {
  const { query } = await req.json();

  const session = new Supabase.ai.Session("gte-small");
  const embedding = await session.run(query, {
    mean_pool: true,
    normalize: true,
  });

  const supabase = createUserClient(req);

  // Call hybrid_search Postgres function via RPC
  const { data: activities, error } = await supabase
    .rpc("hybrid_search_activities", {
      query_text: query,
      query_embedding: embedding,
      match_count: 5,
    })
    .select("*,activity_category(*)");

  if (error) {
    console.log(error);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { "Content-Type": "application/json" },
        status: 500,
      },
    );
  }
  
  const result = snakeToCamel(activities);
  result.forEach((activity: any) => {
    activity.__typename = 'Activity';
    activity.activityCategory.__typename = "ActivityCategory";
  });

  return new Response(JSON.stringify(result), {
    headers: { "Content-Type": "application/json" },
  });
});
