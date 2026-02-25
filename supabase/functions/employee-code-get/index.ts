import { createClient } from "jsr:@supabase/supabase-js@2";

const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

function json(status: number, body: unknown) {
  return new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });
}
function bearer(req: Request) {
  const m = /^Bearer\\s+(.+)$/i.exec(req.headers.get("Authorization") ?? "");
  return m?.[1];
}
async function getUser(req: Request) {
  const token = bearer(req);
  if (!token) return { user: null, error: "Missing bearer token" };
  const { data, error } = await supabase.auth.getUser(token);
  if (error || !data?.user) return { user: null, error: error?.message ?? "Unauthorized" };
  return { user: data.user, error: null };
}

Deno.serve(async (req) => {
  if (req.method !== "GET") return json(405, { error: "Method not allowed" });
  const { user, error } = await getUser(req);
  if (!user) return json(401, { error });

  const { data, error: qErr } = await supabase
    .from("employee_time_codes")
    .select("time_code, salon_id, updated_at")
    .eq("employee_id", user.id)
    .maybeSingle();

  if (qErr) return json(500, { error: qErr.message });
  if (!data) return json(404, { error: "No time code found" });
  return json(200, data);
});