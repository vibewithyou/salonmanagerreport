import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface Suggestion {
  id: string;
  image_url: string;
  caption: string;
  color: string;
  hairstyle: string;
}

serve(async (req: Request) => {
  // Handle CORS
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Get JWT token from Authorization header
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Missing Authorization header" }), {
        status: 401,
        headers: corsHeaders,
      });
    }

    const token = authHeader.replace("Bearer ", "");

    // Initialize Supabase client with user token
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY");

    if (!supabaseUrl || !supabaseAnonKey) {
      throw new Error("Missing Supabase environment variables");
    }

    const supabase = createClient(supabaseUrl, supabaseAnonKey, {
      global: {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    });

    // Get current user
    const { data: userData, error: userError } = await supabase.auth.getUser(token);

    if (userError || !userData.user) {
      return new Response(JSON.stringify({ error: "Invalid token or user not found" }), {
        status: 401,
        headers: corsHeaders,
      });
    }

    const userId = userData.user.id;

    // Initialize admin client for database queries
    const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!supabaseServiceRoleKey) {
      throw new Error("Missing service role key");
    }

    const adminSupabase = createClient(supabaseUrl, supabaseServiceRoleKey);

    // Fetch user's liked images
    const { data: likedImages, error: likesError } = await adminSupabase
      .from("gallery_likes")
      .select("image_id")
      .eq("user_id", userId);

    if (likesError) {
      throw new Error(`Failed to fetch likes: ${likesError.message}`);
    }

    if (!likedImages || likedImages.length === 0) {
      // No likes yet - return empty suggestions
      return new Response(JSON.stringify({ suggestions: [] }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Get full data of liked images
    const likedImageIds = likedImages.map((l: any) => l.image_id);
    const { data: fullLikedImages, error: fullError } = await adminSupabase
      .from("gallery_images")
      .select("*")
      .in("id", likedImageIds);

    if (fullError) {
      throw new Error(`Failed to fetch liked images: ${fullError.message}`);
    }

    // Analyze favorite colors and styles
    const favoriteColors = extractFrequentColors(fullLikedImages || []);
    const favoriteStyles = extractFrequentStyles(fullLikedImages || []);

    // Find similar images (but not already liked)
    const likedIdsString = likedImageIds.map((id: string) => `'${id}'`).join(",");
    const { data: similarImages, error: similarError } = await adminSupabase
      .from("gallery_images")
      .select("*")
      .not("id", "in", `(${likedIdsString})`) // Exclude liked
      .limit(20);

    if (similarError) {
      throw new Error(`Failed to fetch similar images: ${similarError.message}`);
    }

    // Score and sort similar images
    const scoredImages = (similarImages || []).map((img: any) => {
      let score = 0;
      if (img.color && favoriteColors.includes(img.color)) score += 2;
      if (img.hairstyle && favoriteStyles.includes(img.hairstyle)) score += 2;
      return { ...img, score };
    });

    const topSuggestions: Suggestion[] = scoredImages
      .sort((a: any, b: any) => b.score - a.score)
      .slice(0, 3)
      .map((img: any) => ({
        id: img.id,
        image_url: img.image_url,
        caption: img.caption || "Hairstyle Recommendation",
        color: img.color || "unknown",
        hairstyle: img.hairstyle || "unknown",
      }));

    // Store recommendations in ai_suggestions
    if (topSuggestions.length > 0) {
      const { error: insertError } = await adminSupabase.from("ai_suggestions").insert({
        user_id: userId,
        source: "likes",
        source_data: {
          liked_count: likedImages.length,
          favorite_colors: favoriteColors,
          favorite_styles: favoriteStyles,
        },
        suggestion_images: topSuggestions.map((s) => s.image_url),
        metadata: { matched_count: topSuggestions.length },
      });

      if (insertError) {
        console.warn("Warning storing recommendations:", insertError);
      }
    }

    return new Response(JSON.stringify({ suggestions: topSuggestions }), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error: any) {
    console.error("Function error:", error);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});

function extractFrequentColors(images: any[]): string[] {
  const colorCounts: Record<string, number> = {};
  images.forEach((img) => {
    if (img.color) {
      colorCounts[img.color] = (colorCounts[img.color] || 0) + 1;
    }
  });
  return Object.entries(colorCounts)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 3)
    .map(([color]) => color);
}

function extractFrequentStyles(images: any[]): string[] {
  const styleCounts: Record<string, number> = {};
  images.forEach((img) => {
    if (img.hairstyle) {
      styleCounts[img.hairstyle] = (styleCounts[img.hairstyle] || 0) + 1;
    }
  });
  return Object.entries(styleCounts)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 3)
    .map(([style]) => style);
}