create extension if not exists pgcrypto;

create table if not exists public.shifts (
  id uuid primary key default gen_random_uuid(),
  salon_id uuid not null,
  staff_id uuid not null,
  start_at timestamptz not null,
  end_at timestamptz not null,
  type text not null default 'work' check (type in ('work', 'break', 'training')),
  note text,
  created_at timestamptz not null default now()
);

create index if not exists idx_shifts_salon_staff_start
  on public.shifts (salon_id, staff_id, start_at asc);

alter table public.shifts enable row level security;

drop policy if exists "shifts_select_own_or_manager" on public.shifts;
create policy "shifts_select_own_or_manager"
on public.shifts
for select
using (
  staff_id = auth.uid()
  or exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = shifts.salon_id
      and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
);

drop policy if exists "shifts_insert_manager" on public.shifts;
create policy "shifts_insert_manager"
on public.shifts
for insert
with check (
  exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = shifts.salon_id
      and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
);

drop policy if exists "shifts_update_manager" on public.shifts;
create policy "shifts_update_manager"
on public.shifts
for update
using (
  exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = shifts.salon_id
      and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
)
with check (
  exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = shifts.salon_id
      and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
);

drop policy if exists "shifts_delete_manager" on public.shifts;
create policy "shifts_delete_manager"
on public.shifts
for delete
using (
  exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = shifts.salon_id
      and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
);
