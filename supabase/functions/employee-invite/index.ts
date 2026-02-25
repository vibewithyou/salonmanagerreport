import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

/**
 * Edge‑Function zum Versenden einer Einladung für neue Mitarbeitende.
 * Sie generiert einen Einladungs‑Link über Supabase Auth, markiert den
 * Datensatz als „sent“ und verschickt die Mail über Resend.
 */
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Max-Age": "86400",
};

interface InviteRequest {
  employeeId: string;
  salonId: string;
  email: string;
  first_name?: string;
  last_name?: string;
}

serve(async (req) => {
  // Preflight‑Anfrage abfangen
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error("Missing Supabase configuration");
    }
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Request‑Body einlesen
    const body: InviteRequest = await req.json();
    const { employeeId, salonId, email, first_name, last_name } = body;
    if (!employeeId || !salonId || !email) {
      throw new Error("employeeId, salonId und email sind Pflichtfelder");
    }

    // Redirect‑URL aus der ENV lesen (oder undefined, falls leer)
    const redirectTo = Deno.env.get("INVITE_REDIRECT_URL") || undefined;

    // Einladungs‑Link generieren
    const { data: linkData, error: linkError } = await supabase.auth.admin.generateLink({
      type: "invite",
      email,
      options: {
        redirectTo,
        data: {
          employee_id: employeeId,
          salon_id: salonId,
          first_name: first_name || null,
          last_name: last_name || null,
        },
      },
    });

    if (linkError || !linkData) {
      throw new Error(linkError?.message || "Supabase hat keinen Link erzeugt");
    }

    const inviteLink =
      (linkData as any).action_link ||
      (linkData as any).properties?.action_link ||
      null;

    if (!inviteLink) {
      console.error("generateLink response:", JSON.stringify(linkData, null, 2));
      throw new Error("Kein action_link in Supabase‑Antwort gefunden");
    }

    // Einladung als „sent“ markieren
    await supabase
      .from("employee_invitations")
      .update({ status: "sent" })
      .eq("employee_id", employeeId)
      .eq("email", email);

    // E‑Mail über Resend versenden, falls API‑Key gesetzt
    const resendApiKey = Deno.env.get("RESEND_API_KEY");
    if (resendApiKey) {
      const { data: salonData } = await supabase
        .from("salons")
        .select("name")
        .eq("id", salonId)
        .single();

      const salonName = salonData?.name || "SalonManager";
      const currentYear = new Date().getFullYear();

      const html = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Einladung zu ${salonName}</title>
  <style>
    body { font-family: Arial, sans-serif; background-color: #0d0d0d; color: #d4af37; margin: 0; padding: 0; }
    .container { max-width: 600px; margin: 0 auto; background-color: #0d0d0d; padding: 20px; border-radius: 8px; }
    .logo { text-align: center; margin-bottom: 20px; }
    .button { display: inline-block; padding: 12px 24px; margin-top: 20px; background-color: #d4af37;
              color: #0d0d0d; text-decoration: none; border-radius: 4px; font-weight: bold; }
    .footer { margin-top: 30px; font-size: 12px; color: #888; text-align: center; }
  </style>
</head>
<body>
  <div class="container">
    <div class="logo">
      <img src="https://raw.githubusercontent.com/step2001/salonmanager-assets/main/logo-dark-small.png"
           alt="SalonManager Logo" style="max-width: 200px; height: auto;" />
    </div>
    <h1 style="color: #d4af37;">Willkommen bei ${salonName}</h1>
    <p style="color: #ffffff;">Hallo ${first_name || ""} ${last_name || ""},</p>
    <p style="color: #ffffff;">Sie wurden eingeladen, Teil des Teams von ${salonName} zu werden.
    Bitte legen Sie Ihren Account an, indem Sie auf den folgenden Button klicken:</p>
    <a href="${inviteLink}" class="button">Account einrichten</a>
    <p style="color: #888;">Falls der Button nicht funktioniert, kopieren Sie diesen Link und fügen ihn in die Adresszeile Ihres Browsers ein:</p>
    <p style="color: #888; overflow-wrap: break-word; font-size: 12px;">${inviteLink}</p>
    <div class="footer">
      <p style="color: #555;">© ${currentYear} ${salonName}. Alle Rechte vorbehalten.</p>
    </div>
  </div>
</body>
</html>`;

      await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${resendApiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          from: `${salonName} <no-reply@allinonefriseur.online>`,
          to: [email],
          subject: `Einladung zu ${salonName}`,
          html,
        }),
      });
    }

    return new Response(
      JSON.stringify({ success: true, inviteLink }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  } catch (error: any) {
    console.error("employee-invite error:", error);
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }
});
