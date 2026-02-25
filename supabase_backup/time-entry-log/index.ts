import { createClient } from "jsr:@supabase/supabase-js@2";
const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
function json(s: number, b: unknown) { return new Response(JSON.stringify(b), { status: s, headers: { "Content-Type": "application/json" } }); }
function bearer(req: Request) { const m=/^Bearer\\s+(.+)$/i.exec(req.headers.get("Authorization")??""); return m?.[1]; }
async function getUser(req: Request){ const t=bearer(req); if(!t) return {user:null,error:"Missing bearer token"}; const {data,error}=await supabase.auth.getUser(t); if(error||!data?.user) return {user:null,error:error?.message??"Unauthorized"}; return {user:data.user,error:null}; }

Deno.serve(async (req) => {
  if (req.method !== "POST") return json(405, { error: "Method not allowed" });
  const { user, error } = await getUser(req);
  if (!user) return json(401, { error });

  const { salon_id, employee_id, entry_type, notes } = await req.json().catch(() => ({}));
  if (!salon_id || !employee_id || !entry_type) return json(400, { error: "salon_id, employee_id, entry_type required" });

  // Check: ist Owner des Salons?
  const { data: salon, error: sErr } = await supabase.from("salons").select("id").eq("id", salon_id).eq("owner_id", user.id).maybeSingle();
  const isOwner = !!salon;
  const isSelf = user.id === employee_id;
  if (!isOwner && !isSelf) return json(403, { error: "Forbidden" });

  const { data, error: iErr } = await supabase
    .from("time_entries")
    .insert({ salon_id, employee_id, entry_type, notes, created_at: new Date().toISOString() })
    .select("id, created_at")
    .maybeSingle();

  if (iErr) return json(500, { error: iErr.message });
  return json(201, { id: data?.id, created_at: data?.created_at });
});