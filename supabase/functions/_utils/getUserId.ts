export function getUserId(req: Request) {
  const authHeader = req.headers.get("Authorization");
  if (!authHeader) throw new Error("Authorization header is missing");

  const jwt = authHeader.split(" ")[1];
  return JSON.parse(atob(jwt.split(".")[1])).sub;
}
