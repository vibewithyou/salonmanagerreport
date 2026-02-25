import { serve } from 'https://deno.land/std@0.192.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.37.0';

serve(async (req) => {
  if (req.method !== 'GET' && req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), { status: 405 });
  }
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );

  // Alle Inventarartikel abfragen
  const { data: inventoryItems, error: invError } = await supabase
    .from('inventory')
    .select('id, quantity, min_quantity, supplier_id');
  if (invError) {
    return new Response(JSON.stringify({ error: invError.message }), { status: 500 });
  }
  const suggestions: any[] = [];
  for (const item of inventoryItems ?? []) {
    const qty = item.quantity ?? 0;
    const minQty = item.min_quantity ?? 0;
    if (minQty <= 0 || qty > minQty || !item.supplier_id) continue;
    // Existiert bereits eine offene Bestellung?
    const { data: existing } = await supabase
      .from('order_suggestions')
      .select('id')
      .eq('inventory_id', item.id)
      .eq('status', 'pending')
      .maybeSingle();
    if (existing) continue;
    const reorderQty = Math.max(minQty * 2 - qty, minQty - qty);
    const { data: newSuggestion, error: insertError } = await supabase
      .from('order_suggestions')
      .insert({
        inventory_id: item.id,
        supplier_id: item.supplier_id,
        quantity: reorderQty,
        status: 'pending',
      })
      .select()
      .single();
    if (!insertError && newSuggestion) {
      suggestions.push(newSuggestion);
    }
  }
  return new Response(JSON.stringify({ suggestions }), { status: 200 });
});
