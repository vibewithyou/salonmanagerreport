// Deno Edge Function: verify-salon-code
// Input: { salon_id: string, code: string }
// Output: { is_valid: boolean, salon_id?: string, salon_name?: string }

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0";

// Inline AES-GCM helpers to avoid cross-folder imports
function base64ToArrayBuffer(base64: string): ArrayBuffer {
  const binary = atob(base64);
  const len = binary.length;
  const bytes = new Uint8Array(len);
  for (let i = 0; i < len; i++) bytes[i] = binary.charCodeAt(i);
  return bytes.buffer;
}
async function getKey(): Promise<CryptoKey> {
  const keyB64 = Deno.env.get('ENCRYPTION_KEY');
  if (!keyB64) throw new Error('Missing SUPABASE_ENCRYPTION_KEY');
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
    if (req.method !== 'POST') return new Response(JSON.stringify({ error: 'Method Not Allowed' }), { status: 405 })
    const { salon_id, code } = await req.json()
    if (!salon_id || !code) return new Response(JSON.stringify({ error: 'Missing parameters' }), { status: 400 })

    const normalizedSalonId = String(salon_id).trim()
    const normalizedCode = String(code).trim().toUpperCase()

    const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
    const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
    if (!SERVICE_ROLE_KEY) throw new Error('Missing SUPABASE_SERVICE_ROLE_KEY')
    const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY)

    const verifyWithLegacyHash = async () => {
      const { data: legacyData, error: legacyError } = await supabase.rpc('verify_salon_code', {
        p_salon_id: normalizedSalonId,
        p_code: normalizedCode,
      })

      if (legacyError) return null

      const legacyRow = Array.isArray(legacyData) ? legacyData[0] : legacyData
      if (!legacyRow?.is_valid) return null

      return {
        is_valid: true,
        salon_id: legacyRow.salon_id || normalizedSalonId,
        salon_name: legacyRow.salon_name || '',
      }
    }

    const { data: salonCodeRow, error: codeErr } = await supabase
      .from('salon_codes')
      .select('code_encrypted, code, salon_id')
      .eq('salon_id', normalizedSalonId)
      .single()

    if (codeErr || !salonCodeRow) {
      const legacyResult = await verifyWithLegacyHash()
      if (legacyResult) {
        return new Response(JSON.stringify(legacyResult), { status: 200 })
      }
      return new Response(JSON.stringify({ is_valid: false, error: 'Code not found' }), { status: 404 })
    }

    let storedCode: string | null = null

    if (salonCodeRow.code_encrypted) {
      const payload = unpackEncrypted(salonCodeRow.code_encrypted)
      storedCode = await decrypt(payload.iv, payload.ciphertext)
    } else if (salonCodeRow.code) {
      storedCode = salonCodeRow.code
    }

    if (!storedCode) {
      const legacyResult = await verifyWithLegacyHash()
      if (legacyResult) {
        return new Response(JSON.stringify(legacyResult), { status: 200 })
      }
      return new Response(JSON.stringify({ is_valid: false, error: 'Code not found' }), { status: 404 })
    }

    const isValid = String(storedCode).trim().toUpperCase() === normalizedCode

    if (!isValid) {
      const legacyResult = await verifyWithLegacyHash()
      if (legacyResult) {
        return new Response(JSON.stringify(legacyResult), { status: 200 })
      }
      return new Response(JSON.stringify({ is_valid: false }), { status: 200 })
    }

    const { data: salon, error: salonErr } = await supabase
      .from('salons')
      .select('id, name')
      .eq('id', normalizedSalonId)
      .single()

    if (salonErr || !salon) {
      return new Response(JSON.stringify({ is_valid: true, salon_id: normalizedSalonId, salon_name: '' }), { status: 200 })
    }

    return new Response(JSON.stringify({ is_valid: true, salon_id: salon.id, salon_name: salon.name }), { status: 200 })
  } catch (e) {
    return new Response(JSON.stringify({ error: e?.message || 'Internal error' }), { status: 500 })
  }
});