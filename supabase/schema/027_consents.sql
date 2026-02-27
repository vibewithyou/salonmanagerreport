create table if not exists public.consents (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null,
  granted boolean not null,
  version text not null default 'v1',
  created_at timestamptz not null default now()
);

create index if not exists consents_user_id_idx on public.consents(user_id);
create index if not exists consents_type_idx on public.consents(type);

alter table public.consents enable row level security;

create policy if not exists consents_insert_own
on public.consents
for insert
with check (auth.uid() = user_id);

create policy if not exists consents_select_own
on public.consents
for select
using (auth.uid() = user_id);
