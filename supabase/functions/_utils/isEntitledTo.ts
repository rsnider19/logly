import { Client } from "jsr:@db/postgres";

type IsEntitledToArgs = {
  entitlement: string;
} & (
  | { userId: string; req?: never }
  | { req: Request; userId?: never }
);

/**
 * Check if a user is entitled to a feature.
 * Prefer passing `userId` directly from verified JWT (via requireAuth middleware)
 * rather than `req` which uses deprecated unverified extraction.
 */
export async function isEntitledTo(args: IsEntitledToArgs) {
  const { entitlement } = args;

  let userId: string;
  if ('userId' in args && args.userId) {
    userId = args.userId;
  } else if ('req' in args && args.req) {
    // Fallback: extract from request header (deprecated, unverified)
    const authHeader = args.req.headers.get("Authorization");
    if (!authHeader) throw new Error("Authorization header is missing");
    const jwt = authHeader.split(" ")[1];
    userId = JSON.parse(atob(jwt.split(".")[1])).sub;
  } else {
    throw new Error("Either userId or req must be provided");
  }

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
