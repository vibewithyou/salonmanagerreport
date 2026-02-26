-- Time tracking foundation schema (Slice S1)

create extension if not exists pgcrypto;

create table if not exists public.time_entries (
  id uuid primary key default gen_random_uuid(),
  salon_id uuid not null,
  staff_id uuid not null,
  clock_in timestamptz not null default now(),
  clock_out timestamptz,
  breaks_json jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_time_entries_salon_staff_clock_in
  on public.time_entries (salon_id, staff_id, clock_in desc);

create table if not exists public.time_entry_events (
  id uuid primary key default gen_random_uuid(),
  time_entry_id uuid not null references public.time_entries(id) on delete cascade,
  type text not null check (type in ('clock_in', 'clock_out', 'break_start', 'break_end')),
  created_at timestamptz not null default now()
);

create index if not exists idx_time_entry_events_time_entry
  on public.time_entry_events (time_entry_id, created_at desc);

create or replace function public.set_time_entries_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_time_entries_updated_at on public.time_entries;
create trigger trg_time_entries_updated_at
before update on public.time_entries
for each row
execute function public.set_time_entries_updated_at();

alter table public.time_entries enable row level security;
alter table public.time_entry_events enable row level security;

-- Staff can read own entries inside salon scope.
drop policy if exists "time_entries_select_own_or_manager" on public.time_entries;
create policy "time_entries_select_own_or_manager"
on public.time_entries
for select
using (
  staff_id = auth.uid()
  or exists (
    select 1
    from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = time_entries.salon_id
      and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
);

-- Staff can insert only own entry and only for own salon membership.
drop policy if exists "time_entries_insert_own" on public.time_entries;
create policy "time_entries_insert_own"
on public.time_entries
for insert
with check (
  staff_id = auth.uid()
  and exists (
    select 1
    from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = time_entries.salon_id
  )
);

-- Staff can update own open/closed entry fields; managers can update salon-wide.
drop policy if exists "time_entries_update_own_or_manager" on public.time_entries;
create policy "time_entries_update_own_or_manager"
on public.time_entries
for update
using (
  staff_id = auth.uid()
  or exists (
    select 1
    from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = time_entries.salon_id
      and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
)
with check (
  (
    staff_id = auth.uid()
    and salon_id in (
      select ur.salon_id
      from public.user_roles ur
      where ur.user_id = auth.uid()
    )
  )
  or exists (
    select 1
    from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = time_entries.salon_id
      and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
  )
);

-- Event visibility follows parent entry permissions.
drop policy if exists "time_entry_events_select_for_accessible_entries" on public.time_entry_events;
create policy "time_entry_events_select_for_accessible_entries"
on public.time_entry_events
for select
using (
  exists (
    select 1
    from public.time_entries te
    where te.id = time_entry_events.time_entry_id
      and (
        te.staff_id = auth.uid()
        or exists (
          select 1
          from public.user_roles ur
          where ur.user_id = auth.uid()
            and ur.salon_id = te.salon_id
            and ur.role in ('owner', 'platform_admin', 'salon_owner', 'salon_manager')
        )
      )
  )
);
