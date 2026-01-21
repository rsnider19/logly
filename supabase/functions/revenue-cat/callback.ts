import { Request, Response } from "jsr:@oak/oak";
import { Client } from "jsr:@db/postgres";

export default async function revenueCatCallback(req: Request, resp: Response) {
  try {
    // 1. Validate webhook secret
    const revenueCatProjectId = Deno.env.get("REVENUE_CAT_PROJECT_ID");
    const secret = Deno.env.get("REVENUE_CAT_WEBHOOK_SECRET");
    const authHeader = req.headers.get("Authorization");

    if (!secret) {
      resp.status = 500;
      resp.body = { "error": "Server misconfiguration" };
      return;
    }

    if (secret !== authHeader) {
      resp.status = 401;
      resp.body = { error: "Unauthorized" };
      return;
    }

    // 2. Read JSON payload from RevenueCat
    const payload = await req.body.json();

    // 3. Extract user_id and entitlement tier from RevenueCat
    const userId = payload?.event?.app_user_id;
    const eventId = payload?.event?.id;
    console.log("processing webhook for user:", userId, "event id:", eventId);

    // 4. Store raw webhook payload using Postgres client
    const pgClient = new Client(Deno.env.get("SUPABASE_DB_URL"));
    await pgClient.connect();
    try {
      await pgClient.queryObject`
        insert into revenue_cat.webhook_event (webhook_event_id, user_id, raw_payload)
        values (${eventId}, ${userId}, ${payload})
        on conflict (webhook_event_id) do update
          set
            raw_payload = excluded.raw_payload,
            received_at = now()
      `;
    } catch (err) {
      console.error("Insert error:", err);
      await pgClient.end();
      resp.status = 400;
      resp.body = { error: "Failed to store webhook payload" };
      return;
    }

    const customerInfoResp = await fetch(
      `https://api.revenuecat.com/v2/projects/${revenueCatProjectId}/customers/${userId}/active_entitlements`,
      {
        method: "GET",
        headers: {
          "Authorization": `Bearer ${Deno.env.get("REVENUE_CAT_API_KEY")}`,
          "Content-Type": "application/json",
        },
      },
    );

    if (customerInfoResp.status !== 200) {
      console.log(
        "Failed to fetch customer info:",
        customerInfoResp.statusText,
      );
      await pgClient.end();
      resp.status = 500;
      resp.body = { error: "Failed to fetch customer info from RevenueCat" };
      return;
    }

    const customerInfo = await customerInfoResp.json();
    const customerEntitlements = customerInfo.items;

    if (customerEntitlements.length == 0) {
      // Remove user entitlement record if no active entitlements
      try {
        await pgClient.queryObject`
          delete from revenue_cat.user_entitlement where user_id = ${userId}
        `;
        await pgClient.end();
        resp.status = 200;
        resp.body = {
          userId: userId,
          message: "User entitlement removed due to cancellation.",
        };
        return;
      } catch (err) {
        console.error("Delete entitlement error:", err);
        await pgClient.end();
        resp.status = 500;
        resp.body = { error: "Failed to remove user entitlement" };
        return;
      }
    } else {
      try {
        const entitlement = customerEntitlements[0]
        await pgClient.queryObject`
          insert into revenue_cat.user_entitlement (user_id, entitlement_id, active_until, updated_at)
          values (${userId}, ${entitlement.entitlement_id}, ${new Date(entitlement.expires_at)}, ${new Date().toISOString()})
          on conflict (user_id) do update
            set
              entitlement_id = excluded.entitlement_id,
              active_until = excluded.active_until,
              updated_at = excluded.updated_at
        `;
        await pgClient.end();
        resp.status = 200;
        resp.body = { message: "Webhook processed successfully." };
        return;
      } catch (err) {
        console.error("Supabase upsert error:", err);
        await pgClient.end();
        resp.status = 500;
        resp.body = { error: "Failed to update user entitlement" };
        return;
      }
    }
  } catch (e) {
    console.error("Error parsing webhook:", e);
    resp.status = 500;
    resp.body = { error: "Internal server error" };
    return;
  }
}
