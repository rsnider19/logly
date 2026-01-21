import { Application, Router } from "jsr:@oak/oak";
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import revenueCatCallback from "./callback.ts";

const router = new Router();

router.post("/revenue-cat/callback", async (ctx) => {
  console.log('processing revenue cat callback');
  await revenueCatCallback(ctx.request, ctx.response);
});

const app = new Application();
app.use(router.routes());
app.use(router.allowedMethods());

await app.listen({ port: 8000 });
