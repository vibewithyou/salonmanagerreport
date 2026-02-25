import { createClient } from "jsr:@supabase/supabase-js@2";
// SUPABASE_SERVICE_ROLE_KEY removed for security
function json(s: number, b: unknown) { return new Response(JSON.stringify(b), { status: s, headers: { "Content-Type": "application/json" } }); }

Deno.serve(async (req) => {
  if (req.method !== "POST") return json(405, { error: "Method not allowed" });
  const { salon_id, code } = await req.json().catch(() => ({}));
  if (!salon_id || !code) return json(400, { error: "salon_id and code required" });

  const { data, error } = await supabase.rpc("verify_salon_code", { p_salon_id: salon_id, p_code: code });
  if (error) return json(500, { error: error.message });
  return data ? json(200, { ok: true, salon_id }) : json(401, { ok: false });
});