import { createClient } from "jsr:@supabase/supabase-js@2";
// SUPABASE_SERVICE_ROLE_KEY removed for security
function json(s: number, b: unknown) { return new Response(JSON.stringify(b), { status: s, headers: { "Content-Type": "application/json" } }); }

Deno.serve(async (req) => {
  if (req.method !== "POST") return json(405, { error: "Method not allowed" });
  const { salon_id, time_code } = await req.json().catch(() => ({}));
  if (!salon_id || !time_code) return json(400, { error: "salon_id and time_code required" });

  const { data, error } = await supabase
    .from("employee_time_codes")
    .select("employee_id")
    .eq("salon_id", salon_id)
    .eq("time_code", time_code)
    .maybeSingle();

  if (error) return json(500, { error: error.message });
  if (!data) return json(404, { error: "Invalid code" });
  return json(200, { employee_id: data.employee_id });
});