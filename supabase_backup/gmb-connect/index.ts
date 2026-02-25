import { serve } from 'https://deno.land/std@0.201.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.5';

// This edge function exchanges a Google OAuth authorization code for access and
// refresh tokens and stores them in the gmb_connections table. It expects the
// OAuth `code` and a `state` parameter containing the salonId. After
// processing, it redirects back to the Local SEO settings page with a
// success indicator. Configure the following environment variables in
// Supabase:
//   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
//   GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET
//   GOOGLE_REDIRECT_URI (must match the OAuth consent redirect)
//   LOCAL_SEO_REDIRECT (URL of your local SEO page, e.g. https://salonmanager.app/#/local-seo)

serve(async (req) => {
  const url = new URL(req.url);
  const code = url.searchParams.get('code');
  const salonId = url.searchParams.get('state');
  if (!code || !salonId) {
    return new Response('Missing code or state parameter', { status: 400 });
  }

  const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
  const supabase = createClient(supabaseUrl, serviceKey);

  const clientId = Deno.env.get('GOOGLE_CLIENT_ID')!;
  const clientSecret = Deno.env.get('GOOGLE_CLIENT_SECRET')!;
  const redirectUri = Deno.env.get('GOOGLE_REDIRECT_URI')!;

  // Exchange authorization code for tokens
  const tokenResponse = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      code,
      client_id: clientId,
      client_secret: clientSecret,
      redirect_uri: redirectUri,
      grant_type: 'authorization_code',
    }),
  });
  const tokenJson = await tokenResponse.json();
  if (tokenJson.error) {
    console.error('OAuth error', tokenJson);
    return new Response(`OAuth error: ${tokenJson.error_description || tokenJson.error}`, { status: 400 });
  }
  const accessToken = tokenJson.access_token as string;
  const refreshToken = tokenJson.refresh_token as string;
  const expiresIn = tokenJson.expires_in as number;
  const tokenExpiresAt = new Date(Date.now() + expiresIn * 1000).toISOString();

  // Upsert into gmb_connections (one per salon)
  const { error } = await supabase.from('gmb_connections').upsert(
    {
      salon_id: salonId,
      access_token: accessToken,
      refresh_token: refreshToken,
      token_expires_at: tokenExpiresAt,
    },
    { onConflict: 'salon_id' },
  );
  if (error) {
    console.error('Supabase error', error);
    return new Response('Database error', { status: 500 });
  }

  // Redirect back to the local SEO page with a success parameter
  const redirect = Deno.env.get('LOCAL_SEO_REDIRECT') || 'https://salonmanager.app/#/local-seo';
  const dest = new URL(redirect);
  dest.searchParams.set('connected', 'true');
  return Response.redirect(dest.toString(), 302);
});