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
    .eq('type', 'export')
    .eq('status', 'pending')
    .order('created_at', { ascending: false })
    .limit(1)
    .select()
    .maybeSingle();

  const [profile, appointments, consents] = await Promise.all([
    supabase.from('customer_profiles').select('*').eq('user_id', userId).maybeSingle(),
    supabase.from('appointments').select('*').eq('customer_id', userId),
    supabase.from('consents').select('*').eq('user_id', userId),
  ]);

  const payload = {
    exported_at: new Date().toISOString(),
    user_id: userId,
    profile: profile.data,
    appointments: appointments.data ?? [],
    consents: consents.data ?? [],
  };

  const filePath = `exports/${userId}/${Date.now()}.json`;
  const { error: uploadError } = await supabase.storage
    .from('gdpr-exports')
    .upload(filePath, JSON.stringify(payload, null, 2), {
      contentType: 'application/json',
      upsert: true,
    });

  if (uploadError) {
    return new Response(JSON.stringify({ error: uploadError.message }), {
      status: 500,
    });
  }

  const { data: signed } = await supabase.storage
    .from('gdpr-exports')
    .createSignedUrl(filePath, 60 * 60 * 24);

  if (requestRow?.id) {
    await supabase
      .from('gdpr_requests')
      .update({
        status: 'done',
        fulfilled_at: new Date().toISOString(),
        download_url: signed?.signedUrl,
      })
      .eq('id', requestRow.id);
  }

  return new Response(
    JSON.stringify({ success: true, download_url: signed?.signedUrl }),
    { status: 200 },
  );
});
