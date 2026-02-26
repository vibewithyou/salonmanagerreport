create extension if not exists pgcrypto;

create table if not exists public.leave_requests (
  id uuid primary key default gen_random_uuid(),
  salon_id uuid not null,
  staff_id uuid not null,
  type text not null check (type in ('vacation', 'sick', 'other')),
  start_at date not null,
  end_at date not null,
  reason text,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  decided_by uuid,
  decided_at timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists idx_leave_requests_salon_staff_start
  on public.leave_requests (salon_id, staff_id, start_at desc);

alter table public.leave_requests enable row level security;

drop policy if exists "leave_requests_select_own_or_manager" on public.leave_requests;
create policy "leave_requests_select_own_or_manager"
on public.leave_requests
for select
using (
  staff_id = auth.uid()
  or exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = leave_requests.salon_id
      and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
);

drop policy if exists "leave_requests_insert_own" on public.leave_requests;
create policy "leave_requests_insert_own"
on public.leave_requests
for insert
with check (
  staff_id = auth.uid()
  and exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = leave_requests.salon_id
  )
);

drop policy if exists "leave_requests_update_manager" on public.leave_requests;
create policy "leave_requests_update_manager"
on public.leave_requests
for update
using (
  exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = leave_requests.salon_id
      and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
)
with check (
  exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = leave_requests.salon_id
      and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
);
