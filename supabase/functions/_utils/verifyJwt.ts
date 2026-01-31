import { createMiddleware } from "jsr:@hono/hono/factory";
import { supabaseAdminClient } from "./supabaseAdmin.ts";

function getAuthToken(req: Request) {
  const authHeader = req.headers.get("authorization");
  if (!authHeader) {
    throw new Error("Missing authorization header");
  }
  const [bearer, token] = authHeader.split(" ");
  if (bearer !== "Bearer") {
    throw new Error(`Auth header is not 'Bearer {token}'`);
  }

  return token;
}

// Type for Hono context variables
export type AuthEnv = {
  Variables: {
    userId: string;
  };
};

// Hono middleware for JWT authentication
export const authMiddleware = createMiddleware<AuthEnv>(async (c, next) => {
  if (c.req.method === "OPTIONS") {
    return await next();
  }

  try {
    const token = getAuthToken(c.req.raw);
    const { data, error } = await supabaseAdminClient.auth.getClaims(token)
    const userId = data?.claims.sub;

    if (!userId || error) {
      return c.json({ msg: 'Invalid JWT' }, { status: 401 })
    }

    c.set("userId", userId);
    return await next();
  } catch (e) {
    return c.json({ msg: e?.toString() }, { status: 401 });
  }
});

// Validates authorization header (legacy, for non-Hono usage)
export async function AuthMiddleware(
  req: Request,
  next: (req: Request, userId?: string) => Promise<Response>,
) {
  if (req.method === "OPTIONS") return await next(req);

  try {
    const token = getAuthToken(req);
    const { data, error } = await supabaseAdminClient.auth.getClaims(token)
    const userId = data?.claims.sub;

    if (!userId || error) {
      return Response.json({ msg: 'Invalid JWT' }, { status: 401, })
    }

    return await next(req, userId);
  } catch (e) {
    return Response.json({ msg: e?.toString() }, { status: 401, });
  }
}
