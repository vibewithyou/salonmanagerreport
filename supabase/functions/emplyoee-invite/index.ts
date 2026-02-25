import { serve } from "https://deno.land/std@0.190.0/http/server.ts";

/*
 * Diese Edge-Funktion versendet eine Einladung an neue Mitarbeiter.
 * Erwartet im Request-Body: email, first_name, last_name, salonName, registrationUrl.
 * Erforderliche Umgebungsvariablen:
 *   RESEND_API_KEY – API-Schlüssel für Resend (Bearertoken)
 */

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY");

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // Preflight
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { email, first_name, last_name, salonName, registrationUrl } = await req.json();

    if (!email || !registrationUrl) {
      throw new Error("Missing required parameters");
    }

    const resolvedSalon = salonName ?? "SalonManager";

    const html = `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8" />
        <title>Einladung zu ${resolvedSalon}</title>
        <style>
          body { font-family: Arial, sans-serif; background-color: #0d0d0d; color: #d4af37; margin: 0; padding: 0; }
          .container { max-width: 600px; margin: 0 auto; background-color: #0d0d0d; padding: 20px; border-radius: 8px; }
          .logo { text-align: center; margin-bottom: 20px; }
          .button { display: inline-block; padding: 12px 24px; margin-top: 20px; background-color: #d4af37; color: #0d0d0d; text-decoration: none; border-radius: 4px; font-weight: bold; }
          .footer { margin-top: 30px; font-size: 12px; color: #888; text-align: center; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="logo">
            <img src="https://raw.githubusercontent.com/step2001/salonmanager-assets/main/logo-dark-small.png" alt="SalonManager Logo" style="max-width: 200px; height: auto;" />
          </div>
          <h1 style="color: #d4af37;">Willkommen bei ${resolvedSalon}</h1>
          <p style="color: #ffffff;">Hallo ${first_name ?? ""} ${last_name ?? ""},</p>
          <p style="color: #ffffff;">Sie wurden eingeladen, Teil des Teams von ${resolvedSalon} zu werden. Bitte legen Sie Ihren Account an, indem Sie auf den folgenden Button klicken:</p>
          <a href="${registrationUrl}" class="button">Account einrichten</a>
          <p style="color: #888;">Falls der Button nicht funktioniert, kopieren Sie diesen Link und fügen ihn in die Adresszeile Ihres Browsers ein:</p>
          <p style="color: #888; overflow-wrap: break-word; font-size: 12px;">${registrationUrl}</p>
          <div class="footer">
            <p style="color: #555;">© ${new Date().getFullYear()} ${resolvedSalon}. Alle Rechte vorbehalten.</p>
          </div>
        </div>
      </body>
      </html>
    `;

    const response = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${RESEND_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: "SalonManager <onboarding@resend.dev>",
        to: [email],
        subject: `Einladung zu ${resolvedSalon}`,
        html,
      }),
    });

    const result = await response.json();

    return new Response(JSON.stringify({ success: true, data: result }), {
      status: 200,
      headers: { "Content-Type": "application/json", ...corsHeaders },
    });
  } catch (error: any) {
    console.error("employee-invite error:", error);
    return new Response(
      JSON.stringify({ error: error.message ?? String(error) }),
      { status: 400, headers: { "Content-Type": "application/json", ...corsHeaders } },
    );
  }
});
