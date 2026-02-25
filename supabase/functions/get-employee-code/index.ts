// supabase/functions/get-employee-code/index.ts
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0";

function base64ToArrayBuffer(base64: string): ArrayBuffer {
  const binary = atob(base64);
  const len = binary.length;
  const bytes = new Uint8Array(len);
  for (let i = 0; i < len; i++) bytes[i] = binary.charCodeAt(i);
  return bytes.buffer;
}
async function getKey(): Promise<CryptoKey> {
  const keyB64 = Deno.env.get('ENCRYPTION_KEY');
  if (!keyB64) throw new Error('Missing ENCRYPTION_KEY');
  const keyBytes = base64ToArrayBuffer(keyB64);
  return crypto.subtle.importKey('raw', keyBytes, { name: 'AES-GCM' }, false, ['decrypt']);
}
async function decrypt(ivB64: string, ciphertextB64: string): Promise<string> {
  const key = await getKey();
  const iv = new Uint8Array(base64ToArrayBuffer(ivB64));
  const ct = base64ToArrayBuffer(ciphertextB64);
  const dec = await crypto.subtle.decrypt({ name: 'AES-GCM', iv }, key, ct);
  return new TextDecoder().decode(dec);
}
function unpackEncrypted(stored: string): { iv: string; ciphertext: string } {
  const obj = JSON.parse(stored);
  if (!obj?.iv || !obj?.ciphertext) throw new Error('Invalid encrypted payload');
  return obj;
}

serve(async (req) => {
  try {
    if (req.method !== 'POST') return new Response(JSON.stringify({ error: 'Method Not Allowed' }), { status: 405 });
    const { employee_id } = await req.json();
    if (!employee_id) return new Response(JSON.stringify({ error: 'Missing employee_id' }), { status: 400 });

    const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
    const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')!;
    const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

    const { data: row, error } = await supabase
      .from('employee_time_codes')
      .select('code_encrypted')
      .eq('employee_id', employee_id)
      .single();

    if (error || !row || !row.code_encrypted) return new Response(JSON.stringify({ error: 'Not found' }), { status: 404 });

    const payload = unpackEncrypted(row.code_encrypted);
    const code = await decrypt(payload.iv, payload.ciphertext);

    return new Response(JSON.stringify({ code }), { status: 200 });
  } catch (e) {
    return new Response(JSON.stringify({ error: e?.message || 'Internal error' }), { status: 500 });
  }
});