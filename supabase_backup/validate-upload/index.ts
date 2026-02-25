// Supabase Edge Function: validate-upload

// CORS headers required for browser requests
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, x-client-info, apikey',
  'Content-Type': 'application/json',
};

Deno.serve(async (req: Request): Promise<Response> => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: corsHeaders,
    });
  }

  let payload: any;
  try {
    payload = await req.json();
  } catch (_err) {
    return new Response(JSON.stringify({ error: 'Invalid JSON body' }), {
      status: 400,
      headers: corsHeaders,
    });
  }

  const { fileName, mimeType, fileSize } = payload;
  
  // Define allowed MIME types
  const allowedTypes = ['image/png', 'image/jpeg', 'image/webp', 'image/gif'];
  
  // Define maximum size in bytes (5 MB)
  const maxSize = 5 * 1024 * 1024;

  if (!mimeType || typeof mimeType !== 'string' || !allowedTypes.includes(mimeType)) {
    return new Response(JSON.stringify({ error: 'Invalid file type' }), {
      status: 400,
      headers: corsHeaders,
    });
  }

  if (typeof fileSize !== 'number' || fileSize > maxSize) {
    return new Response(JSON.stringify({ error: 'File too large' }), {
      status: 400,
      headers: corsHeaders,
    });
  }

  return new Response(JSON.stringify({ success: true }), {
    status: 200,
    headers: corsHeaders,
  });
});