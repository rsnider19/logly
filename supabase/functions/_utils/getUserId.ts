/**
 * @deprecated Use `requireAuth` middleware from `./requireAuth.ts` instead.
 * This function only decodes the JWT payload without cryptographic verification.
 * The `requireAuth` middleware provides proper JWT signature verification via JWKS.
 */
export function getUserId(req: Request) {
  const authHeader = req.headers.get("Authorization");
  if (!authHeader) throw new Error("Authorization header is missing");

  const jwt = authHeader.split(" ")[1];
  return JSON.parse(atob(jwt.split(".")[1])).sub;
}
