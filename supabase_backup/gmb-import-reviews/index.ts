import { serve } from 'https://deno.land/std@0.201.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.5';

// This edge function imports customer reviews from Google Business Profile into
// the reviews table. It expects a JSON body containing { salonId: string }.
// The function fetches the salon's GMB connection, refreshes the access token
// if necessary, retrieves reviews via the Google My Business API and upserts
// them into the reviews table. Only a high-level pseudo‑implementation is
// provided – you will need to adjust API endpoints and fields based on the
// current Google Business API documentation.

serve(async (req) => {
  const body = await req.json().catch(() => null);
  if (!body || !body.salonId) {
    return new Response('Missing salonId in body', { status: 400 });
  }
  const salonId = body.salonId as string;

  const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
  const supabase = createClient(supabaseUrl, serviceKey);

  // Look up the GMB connection for this salon
  const { data: conn, error: connErr } = await supabase
    .from('gmb_connections')
    .select('*')
    .eq('salon_id', salonId)
    .maybeSingle();
  if (connErr || !conn) {
    return new Response('No GMB connection found', { status: 400 });
  }

  let accessToken = conn.access_token as string | null;
  let tokenExpiresAt = conn.token_expires_at ? new Date(conn.token_expires_at) : null;
  const refreshToken = conn.refresh_token as string | null;

  // Refresh access token if expired or missing
  if (!accessToken || (tokenExpiresAt && tokenExpiresAt < new Date())) {
    if (!refreshToken) {
      return new Response('Missing refresh token', { status: 400 });
    }
    const clientId = Deno.env.get('GOOGLE_CLIENT_ID')!;
    const clientSecret = Deno.env.get('GOOGLE_CLIENT_SECRET')!;
    const tokenResp = await fetch('https://oauth2.googleapis.com/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        client_id: clientId,
        client_secret: clientSecret,
        refresh_token: refreshToken,
        grant_type: 'refresh_token',
      }),
    });
    const tokenJson = await tokenResp.json();
    if (tokenJson.error) {
      console.error('Error refreshing token', tokenJson);
      return new Response('Could not refresh token', { status: 400 });
    }
    accessToken = tokenJson.access_token as string;
    const expiresIn = tokenJson.expires_in as number;
    tokenExpiresAt = new Date(Date.now() + expiresIn * 1000);
    // Update the connection with the new tokens
    await supabase
      .from('gmb_connections')
      .update({ access_token: accessToken, token_expires_at: tokenExpiresAt.toISOString() })
      .eq('id', conn.id);
  }

  // Fetch reviews from Google Business API
  // NOTE: Adjust the endpoint and parsing based on the official API. The following
  // is a placeholder and may not match actual API responses.
  try {
    // You may need to know the account and location IDs; these could be stored in gmb_connections
    // For demonstration, we use a hypothetical endpoint
    const response = await fetch('https://mybusiness.googleapis.com/v4/accounts/*/locations/*/reviews', {
      headers: { Authorization: `Bearer ${accessToken}` },
    });
    const json = await response.json();
    const googleReviews = json.reviews || [];
    // Upsert each review into the reviews table
    for (const r of googleReviews) {
      const extId = r.reviewId || r.name || r.id;
      const author = r.reviewer?.displayName || null;
      const rating = r.starRating || r.rating || null;
      const text = r.comment || r.reviewText || null;
      const publishedAt = r.createTime || r.publishTime || null;
      await supabase
        .from('reviews')
        .upsert({
          salon_id: salonId,
          source: 'google',
          external_id: extId,
          author_name: author,
          rating: rating,
          text: text,
          published_at: publishedAt,
        }, { onConflict: 'external_id' });
    }
    return new Response(JSON.stringify({ imported: googleReviews.length }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  } catch (err) {
    console.error('Error fetching Google reviews', err);
    return new Response('Failed to import reviews', { status: 500 });
  }
});