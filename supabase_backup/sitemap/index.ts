// supabase/functions/sitemap/index.ts
//
// Diese Edge‑Function generiert eine XML‑Sitemap für SalonManager dynamisch.
// Sie liest alle aktiven Salons aus der Datenbank und gibt eine XML‑Datei
// mit den URLs der Salon‑Landing‑Pages sowie der Startseite und der
// Buchungskarte zurück.

import { serve } from "https://deno.land/std@0.201.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.5";

serve(async (_req) => {
  // Zugriff auf Umgebungsvariablen in der Supabase‑Function
  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const supabase = createClient(supabaseUrl, serviceRoleKey);

  // Alle aktiven Salons abrufen
  const { data: salons, error } = await supabase
    .from("salons")
    .select("id, updated_at, is_active")
    .eq("is_active", true);
  if (error) {
    console.error("Fehler beim Abruf der Salons:", error);
    return new Response("Internal Server Error", { status: 500 });
  }

  // Grundlegende URLs für Startseite und Buchungsseite
  const urls: { loc: string; lastmod?: string; changefreq?: string; priority?: number }[] = [
    { loc: "https://salonmanager.app/", changefreq: "weekly", priority: 1.0 },
    { loc: "https://salonmanager.app/#/booking-map", changefreq: "weekly", priority: 0.8 },
  ];

  // Für jeden aktiven Salon einen URL‑Eintrag generieren
  (salons || []).forEach((salon) => {
    const lastmod = salon.updated_at
      ? new Date(salon.updated_at).toISOString().split("T")[0]
      : undefined;
    urls.push({
      loc: `https://salonmanager.app/#/page/${salon.id}`,
      lastmod,
      changefreq: "weekly",
      priority: 0.8,
    });
  });

  // XML‑Dokument zusammensetzen
  let xml = '<?xml version="1.0" encoding="UTF-8"?>\n';
  xml += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n';
  for (const url of urls) {
    xml += "  <url>\n";
    xml += `    <loc>${url.loc}</loc>\n`;
    if (url.lastmod) xml += `    <lastmod>${url.lastmod}</lastmod>\n`;
    if (url.changefreq) xml += `    <changefreq>${url.changefreq}</changefreq>\n`;
    if (url.priority) xml += `    <priority>${url.priority.toFixed(1)}</priority>\n`;
    xml += "  </url>\n";
  }
  xml += "</urlset>\n";

  return new Response(xml, {
    status: 200,
    headers: {
      "Content-Type": "application/xml; charset=utf-8",
      // Suchmaschinen können die Sitemap cachen
      "Cache-Control": "public, max-age=3600",
    },
  });
});
