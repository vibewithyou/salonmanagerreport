import "https://deno.land/x/cors/mod.ts";
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { prompt, user_id } = await req.json();

    if (!prompt || !user_id) {
      return new Response(
        JSON.stringify({ error: "prompt and user_id are required" }),
        { status: 400, headers: corsHeaders }
      );
    }

    // Call Anthropic Claude API
    const claudeResponse = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "x-api-key": Deno.env.get("ANTHROPIC_API_KEY") || "",
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        model: "claude-3-5-sonnet-20241022",
        max_tokens: 1024,
        system: `Du bist ein professioneller Friseur-Assistent. Wenn ein Kunde eine Frisur beschreibt, antworte mit einer strukturierten Analyse:

1. FRISURTYP: (z.B. bob, waves, braid, undercut, pixie, etc.)
2. LÄNGE: (kurz, mittel, lang)
3. FARBE: (blond, braun, rot, schwarz, etc.)
4. TEXTUR: (glatt, wellig, lockig, etc.)
5. SCHWIERIGKEITSGRAD: (einfach, mittel, schwer)
6. VERWANDTE_LOOKS: (3-5 ähnliche Frisuren)

Antworte im JSON-Format für einfache Parsing.`,
        messages: [
          {
            role: "user",
            content: `Analysiere diese Frisurbeschreibung und kategorisiere sie: "${prompt}"`,
          },
        ],
      }),
    });

    const claudeData = await claudeResponse.json();

    if (!claudeResponse.ok) {
      throw new Error(
        `Claude API error: ${claudeData.error?.message || "Unknown error"}`
      );
    }

    const analysisText =
      claudeData.content[0]?.type === "text"
        ? claudeData.content[0].text
        : "";

    // Parse response to extract hairstyle type
    const hairstyleMatch = analysisText.match(/FRISURTYP:\s*(\w+)/i);
    const hairstyleType = hairstyleMatch
      ? hairstyleMatch[1].toLowerCase()
      : "unknown";

    // Query Supabase for matching gallery images
    const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";

    const { data: images, error: dbError } = await fetch(
      `${supabaseUrl}/rest/v1/gallery_images?hairstyle=eq.${hairstyleType}&limit=3`,
      {
        headers: {
          Authorization: `Bearer ${supabaseKey}`,
          "Content-Type": "application/json",
          Prefer: "return=representation",
        },
      }
    ).then((r) => r.json());

    if (dbError) {
      console.error("Database error:", dbError);
    }

    // Store suggestion in ai_suggestions table
    const suggestionPayload = {
      user_id,
      source: "text",
      suggestion_images: images?.map((img: any) => img.id) || [],
      metadata: {
        prompt,
        analysis: analysisText,
        hairstyle_type: hairstyleType,
      },
    };

    const { error: insertError } = await fetch(
      `${supabaseUrl}/rest/v1/ai_suggestions`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${supabaseKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(suggestionPayload),
      }
    ).then((r) => r.json());

    if (insertError) {
      console.error("Insert error:", insertError);
    }

    return new Response(
      JSON.stringify({
        suggestions: images || [],
        analysis: analysisText,
        hairstyleType,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({
        error: error instanceof Error ? error.message : "Unknown error",
      }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});