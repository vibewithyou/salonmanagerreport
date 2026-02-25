import { serve } from 'https://deno.land/std@0.192.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.37.0';

serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), { status: 405 });
  }
  const { customer_profile_id } = await req.json();
  if (!customer_profile_id) {
    return new Response(JSON.stringify({ error: 'customer_profile_id is required' }), { status: 400 });
  }
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );
  const [profile, accounts, redemptions] = await Promise.all([
    supabase.from('customer_profiles').select('*').eq('id', customer_profile_id).maybeSingle(),
    supabase.from('loyalty_accounts').select('*').eq('customer_profile_id', customer_profile_id),
    supabase.from('coupon_redemptions').select('*').eq('customer_profile_id', customer_profile_id)
  ]);
  return new Response(JSON.stringify({ profile: profile.data, accounts: accounts.data, redemptions: redemptions.data }), { status: 200 });
});
