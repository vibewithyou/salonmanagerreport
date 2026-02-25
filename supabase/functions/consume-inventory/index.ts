import { serve } from 'https://deno.land/std@0.192.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.37.0';

serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), { status: 405 });
  }
  const { appointment_id, service_ids } = await req.json();
  if (!appointment_id) {
    return new Response(JSON.stringify({ error: 'appointment_id is required' }), { status: 400 });
  }
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );
  const { data: appointment, error: aptError } = await supabase
    .from('appointments')
    .select('id, service_id')
    .eq('id', appointment_id)
    .single();
  if (aptError || !appointment) {
    return new Response(JSON.stringify({ error: 'Appointment not found' }), { status: 404 });
  }
  const services = Array.isArray(service_ids) && service_ids.length > 0
    ? service_ids
    : appointment.service_id
      ? [appointment.service_id]
      : [];
  const errors: any[] = [];
  for (const svcId of services) {
    try {
      await supabase.rpc('consume_inventory', { service_id: svcId });
    } catch (err) {
      errors.push({ service_id: svcId, error: String(err) });
    }
  }
  if (errors.length > 0) {
    return new Response(JSON.stringify({ success: false, errors }), { status: 500 });
  }
  return new Response(JSON.stringify({ success: true }), { status: 200 });
});
