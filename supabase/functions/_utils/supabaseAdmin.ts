import { createClient } from "jsr:@supabase/supabase-js@2.49.8";
import { Database } from "../database.types.ts";

export const supabaseAdminClient = createClient<Database>(
  Deno.env.get("SUPABASE_URL") ?? "",
  Deno.env.get("SB_SECRET") ?? "",
);
