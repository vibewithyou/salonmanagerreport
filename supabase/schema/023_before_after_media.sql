-- Before/After media for booking detail and customer history
create table if not exists public.booking_media (
  id uuid primary key default gen_random_uuid(),
  appointment_id uuid not null references public.appointments(id) on delete cascade,
  customer_profile_id uuid not null references public.customer_profiles(id) on delete cascade,
  salon_id uuid not null references public.salons(id) on delete cascade,
  media_type text not null check (media_type in ('before', 'after')),
  file_url text not null,
  file_path text,
  mime_type text,
  file_size integer,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

create index if not exists idx_booking_media_customer on public.booking_media(customer_profile_id);
create index if not exists idx_booking_media_appointment on public.booking_media(appointment_id);

alter table public.booking_media enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'booking_media' and policyname = 'booking_media_select_authenticated'
  ) then
    create policy booking_media_select_authenticated
      on public.booking_media
      for select
      to authenticated
      using (true);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'booking_media' and policyname = 'booking_media_insert_authenticated'
  ) then
    create policy booking_media_insert_authenticated
      on public.booking_media
      for insert
      to authenticated
      with check (true);
  end if;
end $$;

insert into storage.buckets (id, name, public)
values ('booking_media', 'booking_media', true)
on conflict (id) do nothing;
