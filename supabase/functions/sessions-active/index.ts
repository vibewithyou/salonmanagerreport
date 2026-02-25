import { createClient } from "jsr:@supabase/supabase-js@2";
const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
function json(s: number, b: unknown) { return new Response(JSON.stringify(b), { status: s, headers: { "Content-Type": "application/json" } }); }
function bearer(req: Request) { const m=/^Bearer\\s+(.+)$/i.exec(req.headers.get("Authorization")??""); return m?.[1]; }
async function getUser(req: Request){ const t=bearer(req); if(!t) return {user:null,error:"Missing bearer token"}; const {data,error}=await supabase.auth.getUser(t); if(error||!data?.user) return {user:null,error:error?.message??"Unauthorized"}; return {user:data.user,error:null}; }

Deno.serve(async (req) => {
  if (req.method !== "GET") return json(405, { error: "Method not allowed" });
  const { user, error } = await getUser(req);
  if (!user) return json(401, { error });

  const url = new URL(req.url);
  const salon_id = url.searchParams.get("salon_id");
  if (!salon_id) return json(400, { error: "salon_id required" });

  // Nur Salon-Owner darf abfragen
  const { data: salon, error: sErr } = await supabase.from("salons").select("id").eq("id", salon_id).eq("owner_id", user.id).maybeSingle();
  if (sErr) return json(500, { error: sErr.message });
  if (!salon) return json(403, { error: "Forbidden" });

  // Letzte Einträge pro Mitarbeiter holen (vereinfachte Heuristik)
  const { data: entries, error: eErr } = await supabase
    .from("time_entries")
    .select("employee_id, entry_type, timestamp")
    .eq("salon_id", salon_id)
    .order("timestamp", { ascending: false })
    .limit(1000);
  if (eErr) return json(500, { error: eErr.message });

  const seen = new Set<string>();
  const active: Array<{ employee_id: string; last_event: string; timestamp: string; }> = [];
  for (const row of entries ?? []) {
    if (seen.has(row.employee_id)) continue;
    seen.add(row.employee_id);
    if (row.entry_type === "clock_in") {
      active.push({ employee_id: row.employee_id, last_event: row.entry_type, timestamp: row.timestamp });
    }
  }
  return json(200, { active });
});