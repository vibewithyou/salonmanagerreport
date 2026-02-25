// supabase/functions/toggle-module/index.ts
// Deploy mit: supabase functions deploy toggle-module

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  try {
    const { configId, moduleName, newValue } = await req.json();
    const authHeader = req.headers.get("Authorization");
    
    if (!authHeader) {
      return new Response("Unauthorized", { status: 401 });
    }

    // Get the user from auth header
    const token = authHeader.replace("Bearer ", "");
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);
    
    if (authError || !user) {
      return new Response("Invalid token", { status: 401 });
    }

    // Get current config
    const { data: config, error: fetchError } = await supabase
      .from("salon_dashboard_config")
      .select("*, salons!inner(owner_id)")
      .eq("id", configId)
      .single();

    if (fetchError || !config) {
      return new Response("Config not found", { status: 404 });
    }

    // Check permissions
    const isOwner = config.salons.owner_id === user.id;
    if (!isOwner) {
      return new Response("Forbidden", { status: 403 });
    }

    // Update config
    const newModules = {
      ...config.enabled_modules,
      [moduleName]: newValue,
    };

    const { error: updateError } = await supabase
      .from("salon_dashboard_config")
      .update({ enabled_modules: newModules })
      .eq("id", configId);

    if (updateError) {
      console.error("Update error:", updateError);
      return new Response(JSON.stringify({ error: updateError.message }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    return new Response(JSON.stringify({ success: true, newModules }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("Error:", error);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});