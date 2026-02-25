import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface Payload {
  user_id: string;
  name: string;
  description?: string | null;
  address?: string | null;
  city?: string | null;
  postal_code?: string | null;
  phone?: string | null;
  email?: string | null;
  opening_hours?: any;
  price_range?: string | null;
}

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!supabaseUrl || !supabaseServiceKey) throw new Error("Missing Supabase configuration");
    const supabase = createClient(supabaseUrl, supabaseServiceKey as string);

    const body: Payload = await req.json();
    const { user_id, name } = body as any;
    if (!user_id || !name) throw new Error("user_id and name are required");

    const salonPayload = {
      name: body.name,
      description: body.description ?? null,
      address: body.address ?? null,
      city: body.city ?? null,
      postal_code: body.postal_code ?? null,
      phone: body.phone ?? null,
      email: body.email ?? null,
      opening_hours: body.opening_hours ?? null,
      price_range: body.price_range ?? null,
      is_active: true,
    };

    const { data: salonData, error: salonError } = await supabase.from('salons').insert(salonPayload).select('id').maybeSingle();
    if (salonError || !salonData) throw new Error(salonError?.message || 'Failed to create salon');
    const salonId = (salonData as any).id;

    const empPayload = {
      salon_id: salonId,
      user_id: user_id,
      position: 'Owner',
      is_active: true,
      display_name: 'Owner',
    };
    const { error: empError } = await supabase.from('employees').insert(empPayload);
    if (empError) {
      await supabase.from('salons').delete().eq('id', salonId);
      throw new Error(empError.message);
    }

    const { error: roleError } = await supabase.from('user_roles').upsert({ user_id, role: 'admin' }, { onConflict: 'user_id' });
    if (roleError) {
      await supabase.from('employees').delete().eq('salon_id', salonId).eq('user_id', user_id);
      await supabase.from('salons').delete().eq('id', salonId);
      throw new Error(roleError.message);
    }

    return new Response(JSON.stringify({ success: true, salonId }), { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } });
  } catch (err: any) {
    console.error('create-salon-with-owner edge error:', err);
    return new Response(JSON.stringify({ success: false, error: err.message }), { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } });
  }
});