import { createClient } from "jsr:@supabase/supabase-js";
import { Database } from "../database.types.ts";

export const createUserClient = (req: Request) => {
  return createClient<Database>(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    {
      global: {
        headers: {
          Authorization: `Bearer ${
            req.headers.get("authorization")?.replace("Bearer ", "")
          }`,
        },
      },
    },
  );
};
