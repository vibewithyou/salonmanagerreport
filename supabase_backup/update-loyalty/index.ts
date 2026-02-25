import { serve } from 'https://deno.land/std@0.192.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.37.0';

serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), { status: 405 });
  }
  const { customer_profile_id, salon_id, amount } = await req.json();
  if (!customer_profile_id || !salon_id || amount === undefined) {
    return new Response(JSON.stringify({ error: 'customer_profile_id, salon_id and amount are required' }), { status: 400 });
  }
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    // SUPABASE_SERVICE_ROLE_KEY removed for security
  );
  const { error } = await supabase.rpc('update_loyalty_account', { customer_profile_id, salon_id, amount });
  if (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
  return new Response(JSON.stringify({ success: true }), { status: 200 });
});
