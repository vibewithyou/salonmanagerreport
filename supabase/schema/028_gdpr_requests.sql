create table if not exists public.gdpr_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null check (type in ('export','delete')),
  status text not null default 'pending' check (status in ('pending','processing','done')),
  created_at timestamptz not null default now(),
  fulfilled_at timestamptz,
  download_url text
);

create index if not exists gdpr_requests_user_idx on public.gdpr_requests(user_id, created_at desc);

alter table public.gdpr_requests enable row level security;

create policy if not exists gdpr_requests_insert_own
on public.gdpr_requests
for insert
with check (auth.uid() = user_id);

create policy if not exists gdpr_requests_select_own
on public.gdpr_requests
for select
using (auth.uid() = user_id);
