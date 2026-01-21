export function requireServiceRole(
  handler: (req: Request) => Promise<Response>,
) {
  return async (req: Request): Promise<Response> => {
    const authHeader = req.headers.get("x-sb-secret");
    const serviceRoleKey = Deno.env.get("SB_SECRET");

    if (!authHeader || authHeader !== serviceRoleKey) {
      return new Response("Unauthorized", { status: 401 });
    }

    return await handler(req);
  };
}
