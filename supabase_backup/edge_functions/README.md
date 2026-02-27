# GDPR Edge Functions (lokal)

## Deploy / Serve lokal

```bash
supabase functions serve gdpr_export --env-file ./supabase/.env.local
supabase functions serve gdpr_delete --env-file ./supabase/.env.local
```

## DSGVO Workflow

1. App erstellt einen Datensatz in `gdpr_requests` (`type=export` oder `delete`, `status=pending`).
2. App ruft `gdpr_export` oder `gdpr_delete` auf.
3. Function setzt den Request auf `processing` und danach auf `done`.
4. `gdpr_export` schreibt JSON in Bucket `gdpr-exports` und setzt `download_url`.

## Voraussetzungen

- Bucket `gdpr-exports` muss existieren.
- Env vars: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`.
