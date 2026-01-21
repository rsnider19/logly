import { getUserId } from "./getUserId.ts";
import { Client } from "jsr:@db/postgres";

export async function isEntitledTo(args: {
  req: Request;
  entitlement: string;
}) {
  const { req, entitlement } = args;
  const userId = getUserId(req);

  try {
    const pgClient = new Client(Deno.env.get("SUPABASE_DB_URL"));
    await pgClient.connect();
    const result = await pgClient.queryObject`
      SELECT revenue_cat.user_has_feature(${userId}, ${entitlement}) AS entitled
    `;
    return result.rows[0]?.entitled;
  } catch (error) {
    console.log('error checking isEntitled', error);
    return false;
  }
}
