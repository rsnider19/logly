import * as jose from "jsr:@panva/jose@6";
import { createMiddleware } from "jsr:@hono/hono/factory";

const SUPABASE_JWT_ISSUER = Deno.env.get("SB_JWT_ISSUER") ??
  Deno.env.get("SUPABASE_URL") + "/auth/v1";

const SUPABASE_JWT_KEYS = jose.createRemoteJWKSet(
  new URL(Deno.env.get("SUPABASE_URL")! + "/auth/v1/.well-known/jwks.json"),
);

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

function verifySupabaseJWT(jwt: string) {
  return jose.jwtVerify(jwt, SUPABASE_JWT_KEYS, {
    issuer: SUPABASE_JWT_ISSUER,
  });
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
    const jwt = await verifySupabaseJWT(token);

    if (jwt?.payload?.sub) {
      c.set("userId", jwt.payload.sub);
      return await next();
    }

    return c.json({ msg: "Invalid JWT" }, 401);
  } catch (e) {
    return c.json({ msg: e?.toString() }, 401);
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
    const jwt = await verifySupabaseJWT(token);

    if (jwt?.payload?.sub) {
      return await next(req, jwt!.payload!.sub!)
    }

    return Response.json({ msg: "Invalid JWT" }, {
      status: 401,
    });
  } catch (e) {
    return Response.json({ msg: e?.toString() }, {
      status: 401,
    });
  }
}
