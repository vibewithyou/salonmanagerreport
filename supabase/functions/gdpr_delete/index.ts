import { serve } from 'https://deno.land/std@0.192.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.37.0';

serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), { status: 405 });
  }

  const authHeader = req.headers.get('Authorization') ?? '';
  const token = authHeader.replace('Bearer ', '').trim();

  const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
  const anonKey = Deno.env.get('SUPABASE_ANON_KEY')!;
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

  const authClient = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: `Bearer ${token}` } },
  });

  const { data: authData } = await authClient.auth.getUser();
  const userId = authData.user?.id;
  if (!userId) {
    return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401 });
  }

  const supabase = createClient(supabaseUrl, serviceKey);

  const { data: requestRow } = await supabase
    .from('gdpr_requests')
    .update({ status: 'processing' })
    .eq('user_id', userId)
    .eq('type', 'delete')
    .eq('status', 'pending')
    .order('created_at', { ascending: false })
    .limit(1)
    .select()
    .maybeSingle();

  // Minimal irreversible anonymization
  await supabase
    .from('customer_profiles')
    .update({
      first_name: 'Deleted',
      last_name: 'User',
      email: `deleted+${userId}@example.invalid`,
      phone: null,
    })
    .eq('user_id', userId);

  await supabase
    .from('consents')
    .update({ version: 'deleted' })
    .eq('user_id', userId);

  if (requestRow?.id) {
    await supabase
      .from('gdpr_requests')
      .update({ status: 'done', fulfilled_at: new Date().toISOString() })
      .eq('id', requestRow.id);
  }

  return new Response(JSON.stringify({ success: true, user_id: userId }), {
    status: 200,
  });
});
