import "@supabase/functions-js/edge-runtime.d.ts";
import { Hono } from 'jsr:@hono/hono';
import { snakeToCamel } from "../_utils/snakeToCamel.ts";
import { createUserClient } from "../_utils/supabaseClient.ts";
import { authMiddleware } from '../_utils/verifyJwt.ts';

const app = new Hono()

app.use(authMiddleware)

app.post('/activity/search', async (c) => {
  const { query } = await c.req.json();

  const session = new Supabase.ai.Session("gte-small");
  const embedding = await session.run(query, {
    mean_pool: true,
    normalize: true,
  });

  const supabase = createUserClient(c.req.raw);

  // Call hybrid_search Postgres function via RPC
  console.log('Activity Search Query', query);
  const { data: activities, error } = await supabase
    .rpc("hybrid_search_activities", {
      query_text: query,
      query_embedding: embedding,
      match_count: 5,
    })
    .select("*,activity_category(*)");

  console.log('Activity Search Result', activities);

  if (error) {
    console.log('Activity Search Error', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { "Content-Type": "application/json" },
        status: 500,
      },
    );
  }

  return new Response(JSON.stringify(activities), {
    headers: { "Content-Type": "application/json" },
  });
})

Deno.serve(app.fetch)