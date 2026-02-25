import { createClient } from "jsr:@supabase/supabase-js@2";
const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
function json(s: number, b: unknown) { return new Response(JSON.stringify(b), { status: s, headers: { "Content-Type": "application/json" } }); }
function bearer(req: Request) { const m = /^Bearer\\s+(.+)$/i.exec(req.headers.get("Authorization") ?? ""); return m?.[1]; }
async function getUser(req: Request) { const t = bearer(req); if (!t) return { user: null, error: "Missing bearer token" }; const { data, error } = await supabase.auth.getUser(t); if (error || !data?.user) return { user: null, error: error?.message ?? "Unauthorized" }; return { user: data.user, error: null }; }
function six() { return Math.floor(100000 + Math.random() * 900000).toString(); }

Deno.serve(async (req) => {
  if (req.method !== "POST") return json(405, { error: "Method not allowed" });
  const { user, error } = await getUser(req);
  if (!user) return json(401, { error });

  const { data: row, error: rErr } = await supabase
    .from("employee_time_codes").select("id").eq("employee_id", user.id).maybeSingle();
  if (rErr) return json(500, { error: rErr.message });
  if (!row) return json(404, { error: "No time code row found" });

  for (let i = 0; i < 6; i++) {
    const code = six();
    const { data: upd, error: uErr } = await supabase
      .from("employee_time_codes")
      .update({ time_code: code, updated_at: new Date().toISOString() })
      .eq("id", row.id).select("time_code").maybeSingle();
    if (uErr && (uErr as any).code === "23505") continue;
    if (uErr) return json(500, { error: uErr.message });
    if (upd) return json(200, upd);
  }
  return json(409, { error: "Could not generate unique code" });
});