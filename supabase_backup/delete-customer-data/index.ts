import { serve } from 'https://deno.land/std@0.192.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.37.0';

serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), { status: 405 });
  }
  const { customer_profile_id, user_id } = await req.json();
  if (!customer_profile_id && !user_id) {
    return new Response(JSON.stringify({ error: 'customer_profile_id or user_id is required' }), { status: 400 });
  }
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );
  // Ermittele das Profil über die user_id, wenn nötig
  let profileId = customer_profile_id;
  if (!profileId && user_id) {
    const { data } = await supabase.from('customer_profiles').select('id').eq('user_id', user_id).maybeSingle();
    profileId = data?.id;
  }
  if (!profileId) return new Response(JSON.stringify({ error: 'Customer profile not found' }), { status: 404 });
  // Redemptions, loyalty accounts und Profil löschen
  await supabase.from('coupon_redemptions').delete().eq('customer_profile_id', profileId);
  await supabase.from('loyalty_accounts').delete().eq('customer_profile_id', profileId);
  await supabase.from('customer_profiles').delete().eq('id', profileId);
  return new Response(JSON.stringify({ success: true }), { status: 200 });
});
