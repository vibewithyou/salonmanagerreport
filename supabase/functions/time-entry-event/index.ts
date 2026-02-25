import { serve } from 'https://deno.land/std@0.192.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.37.0';

serve(async (req) => {
  // nur POST akzeptieren
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), { status: 405 });
  }

  const { tag_uid, event, minutes, pin } = await req.json();
  if (!tag_uid || !event) {
    return new Response(JSON.stringify({ error: 'tag_uid and event are required' }), { status: 400 });
  }

  const supabase = createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!);

  // Tag validieren
  const { data: tagData, error: tagError } = await supabase
    .from('nfc_tags')
    .select('id, employee_id, pin')
    .eq('tag_uid', tag_uid)
    .single();

  if (tagError || !tagData) {
    return new Response(JSON.stringify({ error: 'Invalid NFC tag' }), { status: 400 });
  }
  if (tagData.pin && tagData.pin !== pin) {
    return new Response(JSON.stringify({ error: 'Invalid PIN' }), { status: 401 });
  }

  // Offenen Zeiteintrag suchen
  const { data: openEntry, error: openError } = await supabase
    .from('time_entries')
    .select('*')
    .eq('employee_id', tagData.employee_id)
    .is('check_out', null)
    .single();

  if (event === 'start') {
    if (openEntry) {
      return new Response(JSON.stringify({ error: 'Already checked in' }), { status: 400 });
    }
    const { error: insertError } = await supabase.from('time_entries').insert({
      employee_id: tagData.employee_id,
      check_in: new Date().toISOString(),
      break_minutes: 0
    });
    if (insertError) {
      return new Response(JSON.stringify({ error: insertError.message }), { status: 500 });
    }
    return new Response(JSON.stringify({ success: true }), { status: 200 });
  }

  if (!openEntry) {
    return new Response(JSON.stringify({ error: 'No open time entry' }), { status: 400 });
  }

  if (event === 'pause') {
    const extra = minutes && minutes > 0 ? minutes : 0;
    const { error: updateError } = await supabase
      .from('time_entries')
      .update({ break_minutes: (openEntry.break_minutes || 0) + extra })
      .eq('id', openEntry.id);
    if (updateError) {
      return new Response(JSON.stringify({ error: updateError.message }), { status: 500 });
    }
    return new Response(JSON.stringify({ success: true }), { status: 200 });
  }

  if (event === 'end') {
    const { error: updateError } = await supabase
      .from('time_entries')
      .update({ check_out: new Date().toISOString() })
      .eq('id', openEntry.id);
    if (updateError) {
      return new Response(JSON.stringify({ error: updateError.message }), { status: 500 });
    }
    return new Response(JSON.stringify({ success: true }), { status: 200 });
  }

  return new Response(JSON.stringify({ error: 'Unsupported event type' }), { status: 400 });
});
