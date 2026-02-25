// supabase/functions/set-employee-code/index.ts
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0";

function base64ToArrayBuffer(base64: string): ArrayBuffer {
  const binary = atob(base64);
  const len = binary.length;
  const bytes = new Uint8Array(len);
  for (let i = 0; i < len; i++) bytes[i] = binary.charCodeAt(i);
  return bytes.buffer;
}
function arrayBufferToBase64(buffer: ArrayBuffer): string {
  const bytes = new Uint8Array(buffer);
  let binary = '';
  for (let i = 0; i < bytes.byteLength; i++) binary += String.fromCharCode(bytes[i]);
  return btoa(binary);
}
async function getKey(): Promise<CryptoKey> {
  const keyB64 = Deno.env.get('ENCRYPTION_KEY');
  if (!keyB64) throw new Error('Missing ENCRYPTION_KEY');
  const keyBytes = base64ToArrayBuffer(keyB64);
  return crypto.subtle.importKey('raw', keyBytes, { name: 'AES-GCM' }, false, ['encrypt']);
}
async function encrypt(plaintext: string): Promise<{ iv: string; ciphertext: string }> {
  const key = await getKey();
  const iv = crypto.getRandomValues(new Uint8Array(12));
  const enc = new TextEncoder().encode(plaintext);
  const ct = await crypto.subtle.encrypt({ name: 'AES-GCM', iv }, key, enc);
  return { iv: arrayBufferToBase64(iv.buffer), ciphertext: arrayBufferToBase64(ct) };
}
function packEncrypted(payload: { iv: string; ciphertext: string }): string {
  return JSON.stringify(payload);
}
function generate6Digit(): string {
  return String(Math.floor(100000 + Math.random() * 900000));
}

serve(async (req) => {
  try {
    if (req.method !== 'POST') return new Response(JSON.stringify({ error: 'Method Not Allowed' }), { status: 405 });
    const { employee_id, code, regenerate } = await req.json();
    if (!employee_id) return new Response(JSON.stringify({ error: 'Missing employee_id' }), { status: 400 });

    const finalCode = regenerate ? generate6Digit() : code;
    if (!finalCode) return new Response(JSON.stringify({ error: 'Missing code' }), { status: 400 });

    const enc = await encrypt(finalCode);
    const stored = packEncrypted(enc);

    const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
    const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')!;
    const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

    const { error } = await supabase
      .from('employee_time_codes')
      .upsert({ employee_id, code_encrypted: stored, updated_at: new Date().toISOString() })
      .eq('employee_id', employee_id);

    if (error) return new Response(JSON.stringify({ error: error.message }), { status: 400 });

    return new Response(JSON.stringify({ ok: true, code: finalCode }), { status: 200 });
  } catch (e) {
    return new Response(JSON.stringify({ error: e?.message || 'Internal error' }), { status: 500 });
  }
});