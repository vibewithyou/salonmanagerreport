import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

interface AuthEmailRequest {
  type: "signup" | "recovery";
  email: string;
  password?: string;
  redirectTo?: string;
  name?: string;
  language?: "de" | "en";
  data?: Record<string, any>;
}

// CORS-Header für Browser-Anfragen
const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Max-Age": "86400",
};

// E-Mail-Vorlage erzeugen
function composeAuthEmail(
  type: "signup" | "recovery",
  link: string,
  name: string | undefined,
  language: "de" | "en",
) {
  const isGerman = language === "de";
  const recipient = name
    ? isGerman
      ? `Hallo ${name}`
      : `Hello ${name}`
    : isGerman
    ? "Hallo"
    : "Hello";
  const appName = "SalonManager";
  const greeting = `${recipient},`;

  if (type === "signup") {
    return {
      subject: isGerman
        ? `Willkommen bei ${appName}! Bitte bestätige deine E‑Mail`
        : `Welcome to ${appName}! Please confirm your email`,
      html: `
        <h1>${isGerman ? "Registrierung abschließen" : "Complete your registration"}</h1>
        <p>${greeting}</p>
        <p>${isGerman
          ? "Vielen Dank für deine Registrierung. Bitte klicke auf den folgenden Button, um deine E-Mail-Adresse zu bestätigen und ein Passwort festzulegen."
          : "Thank you for signing up. Please click the button below to confirm your email address and set a password."}</p>
        <a href="${link}" style="display:inline-block;padding:12px 24px;background-color:#d4af37;color:#0d0d0d;text-decoration:none;border-radius:4px;font-weight:bold;margin-top:16px;">
          ${isGerman ? "E‑Mail bestätigen" : "Confirm Email"}
        </a>
        <p style="margin-top:16px;font-size:12px;color:#888;">
          ${isGerman
            ? "Falls der Button nicht funktioniert, kopiere diesen Link in die Adresszeile deines Browsers:"
            : "If the button doesn't work, copy this link into your browser's address bar:"}
        </p>
        <p style="font-size:12px;color:#888;overflow-wrap:break-word;">${link}</p>
        <p style="margin-top:24px;color:#555;font-size:12px;">© ${new Date().getFullYear()} ${appName}. ${
        isGerman ? "Alle Rechte vorbehalten." : "All rights reserved."
      }</p>
      `,
    };
  } else {
    // recovery
    return {
      subject: isGerman
        ? `Passwort zurücksetzen – ${appName}`
        : `Reset your password – ${appName}`,
      html: `
        <h1>${isGerman ? "Passwort zurücksetzen" : "Reset your password"}</h1>
        <p>${greeting}</p>
        <p>${isGerman
          ? "Du hast eine Anfrage zum Zurücksetzen deines Passworts gestellt. Klicke auf den folgenden Button, um ein neues Passwort zu erstellen."
          : "You requested to reset your password. Click the button below to set a new password."}</p>
        <a href="${link}" style="display:inline-block;padding:12px 24px;background-color:#d4af37;color:#0d0d0d;text-decoration:none;border-radius:4px;font-weight:bold;margin-top:16px;">
          ${isGerman ? "Passwort zurücksetzen" : "Reset password"}
        </a>
        <p style="margin-top:16px;font-size:12px;color:#888;">
          ${isGerman
            ? "Falls der Button nicht funktioniert, kopiere diesen Link in die Adresszeile deines Browsers:"
            : "If the button doesn't work, copy this link into your browser's address bar:"}
        </p>
        <p style="font-size:12px;color:#888;overflow-wrap:break-word;">${link}</p>
        <p style="margin-top:24px;color:#555;font-size:12px;">© ${new Date().getFullYear()} ${appName}. ${
        isGerman ? "Alle Rechte vorbehalten." : "All rights reserved."
      }</p>
      `,
    };
  }
}

serve(async (req) => {
  // Preflight-Anfragen beantworten
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    const body: AuthEmailRequest = await req.json();
    const { type, email, password, redirectTo, name, language = "en", data } = body;

    // Validierung
    if (!email || (type === "signup" && !password)) {
      return new Response(
        JSON.stringify({ error: "Missing required fields" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    const resendApiKey = Deno.env.get("RESEND_API_KEY");
    if (!supabaseUrl || !serviceKey) {
      throw new Error("Missing Supabase configuration");
    }
    if (!resendApiKey) {
      throw new Error("Missing RESEND_API_KEY for sending emails");
    }

    const supabase = createClient(supabaseUrl, serviceKey);

    // Optionen für generateLink() vorbereiten
    const linkOptions: any = {};
    if (redirectTo) linkOptions.redirectTo = redirectTo;

    let generateOpts: any;
    if (type === "signup") {
      generateOpts = { type: "signup", email, password, options: { ...linkOptions } };
      if (data && typeof data === "object") {
        generateOpts.options.data = data;
      }
    } else {
      generateOpts = { type: "recovery", email, options: { ...linkOptions } };
    }

    // Link generieren
    const { data: linkData, error: linkError } =
      await supabase.auth.admin.generateLink(generateOpts);
    if (linkError || !linkData) {
      throw new Error(linkError?.message || "Failed to generate auth link");
    }

    // Action-Link auslesen (alte und neue Property unterstützen)
    const actionLink =
      (linkData as any).action_link ||
      (linkData as any).properties?.action_link;
    if (!actionLink) {
      console.error("generateLink response:", JSON.stringify(linkData, null, 2));
      throw new Error("No valid action_link in Supabase response");
    }

    // E-Mail zusammenbauen
    const { subject, html } = composeAuthEmail(type, actionLink, name, language);
    const fromEmail = Deno.env.get("AUTH_EMAIL_FROM") || "no-reply@salonmanager.app";
    const fromName = Deno.env.get("AUTH_EMAIL_NAME") || "SalonManager";

    // E-Mail über Resend verschicken
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${resendApiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: `${fromName} <${fromEmail}>`,
        to: [email],
        subject,
        html,
      }),
    });
    const emailResponse = await res.json();

    return new Response(JSON.stringify({ success: true, data: emailResponse }), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error: any) {
    console.error("send-auth-email error", error);
    return new Response(JSON.stringify({ error: error.message || "Unknown error" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
