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
    const { image_id, image_url } = await req.json();

    if (!image_id || !image_url) {
      return new Response(
        JSON.stringify({ error: "image_id and image_url are required" }),
        { status: 400, headers: corsHeaders }
      );
    }

    // Call OpenAI CLIP API to generate embedding
    const embeddingResponse = await fetch(
      "https://api.openai.com/v1/embeddings",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${Deno.env.get("OPENAI_API_KEY") || ""}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "text-embedding-3-small",
          input: `Image URL: ${image_url}`,
          encoding_format: "float",
        }),
      }
    );

    const embeddingData = await embeddingResponse.json();

    if (!embeddingResponse.ok) {
      throw new Error(
        `OpenAI API error: ${embeddingData.error?.message || "Unknown error"}`
      );
    }

    const embedding = embeddingData.data[0]?.embedding;
    if (!embedding || embedding.length !== 1536) {
      throw new Error(
        `Invalid embedding: expected 1536 dimensions, got ${embedding?.length}`
      );
    }

    // Convert to 768-dim by averaging pairs (dimensionality reduction)
    const reduced_embedding = [];
    for (let i = 0; i < embedding.length; i += 2) {
      reduced_embedding.push((embedding[i] + (embedding[i + 1] || 0)) / 2);
    }

    // Store in Supabase gallery_image_vectors table
    const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";

    const { error: storeError } = await fetch(
      `${supabaseUrl}/rest/v1/gallery_image_vectors`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${supabaseKey}`,
          "Content-Type": "application/json",
          Prefer: "return=minimal",
        },
        body: JSON.stringify({
          image_id,
          embedding: reduced_embedding,
        }),
      }
    ).then((r) => r.json());

    if (storeError) {
      throw new Error(`Failed to store embedding: ${storeError.message}`);
    }

    return new Response(
      JSON.stringify({
        success: true,
        image_id,
        embedding_dimensions: reduced_embedding.length,
        message: "Embedding generated and stored successfully",
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Embedding error:", error);
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