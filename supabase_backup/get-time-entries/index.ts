import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

/*
 * Gibt alle Zeiteinträge eines Salons inklusive Mitarbeiter-Liste zurück.
 * Request-Body: { salonId: UUID }
 * Erforderliche Umgebungsvariablen:
 *   SUPABASE_URL             – Ihr Supabase-Projekt
 *   SUPABASE_SERVICE_ROLE_KEY – Service-Rolle zur Umgehung der RLS
 */

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { salonId } = await req.json();
    if (!salonId) {
      throw new Error("Missing salonId");
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, serviceKey);

    // Mitarbeiter abrufen
    const { data: employees, error: empErr } = await supabase
      .from("employees")
      .select("id, display_name")
      .eq("salon_id", salonId);

    if (empErr) {
      throw empErr;
    }

    const employeeIds = employees?.map((e) => e.id) ?? [];
    let entries: any[] = [];

    if (employeeIds.length > 0) {
      const { data: timeData, error: timeErr } = await supabase
        .from("time_entries")
        .select("*")
        .in("employee_id", employeeIds)
        .order("check_in", { ascending: false });

      if (timeErr) {
        throw timeErr;
      }
      entries = timeData ?? [];
    }

    return new Response(JSON.stringify({ entries, employees }), {
      status: 200,
      headers: { "Content-Type": "application/json", ...corsHeaders },
    });
  } catch (error: any) {
    console.error("get-time-entries error:", error);
    return new Response(
      JSON.stringify({ error: error.message ?? String(error) }),
      { status: 400, headers: { "Content-Type": "application/json", ...corsHeaders } },
    );
  }
});
