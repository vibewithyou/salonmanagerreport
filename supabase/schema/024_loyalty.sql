-- AUFGABE 14: Loyalty – pro Salon Treuekarte vollständig (DB + Anzeige + Events)

create extension if not exists pgcrypto;

create table if not exists public.loyalty_cards (
  id uuid primary key default gen_random_uuid(),
  salon_id uuid not null,
  customer_id uuid not null,
  points integer not null default 0,
  visits integer not null default 0,
  level text not null default 'bronze',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (salon_id, customer_id)
);

create table if not exists public.loyalty_events (
  id uuid primary key default gen_random_uuid(),
  salon_id uuid not null,
  customer_id uuid not null,
  booking_id uuid null,
  invoice_id uuid null,
  delta_points integer not null default 0,
  delta_visits integer not null default 0,
  reason text not null,
  created_at timestamptz not null default now(),
  check (booking_id is not null or invoice_id is not null)
);

create table if not exists public.loyalty_levels (
  id uuid primary key default gen_random_uuid(),
  salon_id uuid not null,
  level text not null,
  threshold_points integer not null default 0,
  reward_type text null,
  reward_value numeric(10,2) null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (salon_id, level),
  unique (salon_id, threshold_points)
);

create unique index if not exists loyalty_events_invoice_unique
on public.loyalty_events (invoice_id)
where invoice_id is not null;

create unique index if not exists loyalty_events_booking_unique
on public.loyalty_events (booking_id)
where booking_id is not null;

create index if not exists loyalty_cards_salon_customer_idx on public.loyalty_cards (salon_id, customer_id);
create index if not exists loyalty_events_salon_customer_idx on public.loyalty_events (salon_id, customer_id, created_at desc);
create index if not exists loyalty_levels_salon_threshold_idx on public.loyalty_levels (salon_id, threshold_points desc);

create or replace function public.set_updated_at_loyalty()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_loyalty_cards_updated_at on public.loyalty_cards;
create trigger trg_loyalty_cards_updated_at
before update on public.loyalty_cards
for each row execute procedure public.set_updated_at_loyalty();

drop trigger if exists trg_loyalty_levels_updated_at on public.loyalty_levels;
create trigger trg_loyalty_levels_updated_at
before update on public.loyalty_levels
for each row execute procedure public.set_updated_at_loyalty();

alter table public.loyalty_cards enable row level security;
alter table public.loyalty_events enable row level security;
alter table public.loyalty_levels enable row level security;

create or replace function public.customer_owns_profile(p_customer_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_is_owner boolean := false;
begin
  if v_uid is null then
    return false;
  end if;

  if to_regclass('public.customer_profiles') is null then
    return false;
  end if;

  execute 'select exists (select 1 from public.customer_profiles cp where cp.id = $1 and cp.user_id = $2)'
    into v_is_owner
    using p_customer_id, v_uid;

  return coalesce(v_is_owner, false);
end;
$$;

create or replace function public.has_salon_staff_access(p_salon_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_has_access boolean := false;
begin
  if v_uid is null then
    return false;
  end if;

  if to_regclass('public.salons') is not null then
    execute 'select exists (select 1 from public.salons s where s.id = $1 and s.owner_id = $2)'
      into v_has_access
      using p_salon_id, v_uid;

    if v_has_access then
      return true;
    end if;
  end if;

  if to_regclass('public.salon_employees') is not null then
    execute 'select exists (select 1 from public.salon_employees se where se.salon_id = $1 and se.user_id = $2 and coalesce(se.role, ''staff'') in (''staff'',''manager'',''owner''))'
      into v_has_access
      using p_salon_id, v_uid;

    if v_has_access then
      return true;
    end if;
  end if;

  if to_regclass('public.employees') is not null then
    execute 'select exists (select 1 from public.employees e where e.salon_id = $1 and e.user_id = $2 and coalesce(e.role, ''staff'') in (''staff'',''manager'',''owner''))'
      into v_has_access
      using p_salon_id, v_uid;

    if v_has_access then
      return true;
    end if;
  end if;

  return false;
end;
$$;

drop policy if exists loyalty_cards_customer_read_own on public.loyalty_cards;
create policy loyalty_cards_customer_read_own
on public.loyalty_cards for select
using (public.customer_owns_profile(customer_id));

drop policy if exists loyalty_cards_staff_manager_salonwide on public.loyalty_cards;
create policy loyalty_cards_staff_manager_salonwide
on public.loyalty_cards for all
using (public.has_salon_staff_access(salon_id))
with check (public.has_salon_staff_access(salon_id));

drop policy if exists loyalty_events_customer_read_own on public.loyalty_events;
create policy loyalty_events_customer_read_own
on public.loyalty_events for select
using (public.customer_owns_profile(customer_id));

drop policy if exists loyalty_events_staff_manager_salonwide on public.loyalty_events;
create policy loyalty_events_staff_manager_salonwide
on public.loyalty_events for all
using (public.has_salon_staff_access(salon_id))
with check (public.has_salon_staff_access(salon_id));

drop policy if exists loyalty_levels_staff_manager_salonwide on public.loyalty_levels;
create policy loyalty_levels_staff_manager_salonwide
on public.loyalty_levels for all
using (public.has_salon_staff_access(salon_id))
with check (public.has_salon_staff_access(salon_id));

create or replace function public.get_loyalty_level_for_points(
  p_salon_id uuid,
  p_points integer
)
returns text
language sql
stable
as $$
  select coalesce((
    select ll.level
    from public.loyalty_levels ll
    where ll.salon_id = p_salon_id
      and ll.threshold_points <= p_points
    order by ll.threshold_points desc
    limit 1
  ), 'bronze');
$$;

create or replace function public.apply_loyalty_event(
  p_salon_id uuid,
  p_customer_id uuid,
  p_booking_id uuid default null,
  p_invoice_id uuid default null,
  p_delta_points integer default 0,
  p_delta_visits integer default 0,
  p_reason text default 'manual'
)
returns public.loyalty_cards
language plpgsql
security definer
set search_path = public
as $$
declare
  v_existing_event uuid;
  v_card public.loyalty_cards;
  v_new_level text;
begin
  if p_booking_id is null and p_invoice_id is null then
    raise exception 'Either booking_id or invoice_id must be provided';
  end if;

  if p_invoice_id is not null then
    select id into v_existing_event
    from public.loyalty_events
    where invoice_id = p_invoice_id
    limit 1;
  elsif p_booking_id is not null then
    select id into v_existing_event
    from public.loyalty_events
    where booking_id = p_booking_id
    limit 1;
  end if;

  if v_existing_event is not null then
    select * into v_card
    from public.loyalty_cards
    where salon_id = p_salon_id and customer_id = p_customer_id;
    return v_card;
  end if;

  insert into public.loyalty_cards (salon_id, customer_id)
  values (p_salon_id, p_customer_id)
  on conflict (salon_id, customer_id) do nothing;

  insert into public.loyalty_events (
    salon_id,
    customer_id,
    booking_id,
    invoice_id,
    delta_points,
    delta_visits,
    reason
  ) values (
    p_salon_id,
    p_customer_id,
    p_booking_id,
    p_invoice_id,
    p_delta_points,
    p_delta_visits,
    p_reason
  );

  update public.loyalty_cards c
  set
    points = c.points + p_delta_points,
    visits = c.visits + p_delta_visits
  where c.salon_id = p_salon_id
    and c.customer_id = p_customer_id;

  select public.get_loyalty_level_for_points(p_salon_id, c.points)
  into v_new_level
  from public.loyalty_cards c
  where c.salon_id = p_salon_id
    and c.customer_id = p_customer_id;

  update public.loyalty_cards c
  set level = v_new_level
  where c.salon_id = p_salon_id
    and c.customer_id = p_customer_id;

  select * into v_card
  from public.loyalty_cards c
  where c.salon_id = p_salon_id
    and c.customer_id = p_customer_id;

  return v_card;
end;
$$;

create or replace function public.calculate_loyalty_auto_discount(
  p_salon_id uuid,
  p_customer_id uuid,
  p_subtotal numeric
)
returns table (
  discount_amount numeric,
  level text,
  reward_type text,
  reward_value numeric
)
language plpgsql
stable
as $$
declare
  v_points integer := 0;
  v_level text := 'bronze';
  v_reward_type text;
  v_reward_value numeric;
  v_discount numeric := 0;
begin
  select c.points, c.level
    into v_points, v_level
  from public.loyalty_cards c
  where c.salon_id = p_salon_id and c.customer_id = p_customer_id;

  select ll.reward_type, ll.reward_value
    into v_reward_type, v_reward_value
  from public.loyalty_levels ll
  where ll.salon_id = p_salon_id
    and ll.threshold_points <= coalesce(v_points, 0)
    and ll.reward_type is not null
    and ll.reward_value is not null
  order by ll.threshold_points desc
  limit 1;

  if v_reward_type = 'percentage' then
    v_discount := round((p_subtotal * coalesce(v_reward_value, 0) / 100.0)::numeric, 2);
  elsif v_reward_type = 'fixed' then
    v_discount := least(coalesce(v_reward_value, 0), p_subtotal);
  else
    v_discount := 0;
  end if;

  return query select v_discount, coalesce(v_level, 'bronze'), v_reward_type, v_reward_value;
end;
$$;

create or replace function public.handle_invoice_paid_loyalty()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_points integer;
begin
  if new.status = 'paid'
     and coalesce(old.status, '') <> 'paid'
     and new.customer_profile_id is not null then
    v_points := greatest(floor(coalesce(new.total_amount, 0))::integer, 1);

    perform public.apply_loyalty_event(
      new.salon_id,
      new.customer_profile_id,
      null,
      new.id,
      v_points,
      1,
      'invoice_paid'
    );
  end if;

  return new;
end;
$$;

create or replace function public.handle_booking_completed_loyalty()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_customer_id uuid;
  v_booking_id uuid;
  v_points integer := 10;
  v_salon_id uuid;
begin
  if new.status = 'completed' and coalesce(old.status, '') <> 'completed' then
    v_booking_id := new.id;
    v_salon_id := new.salon_id;

    if to_jsonb(new) ? 'customer_profile_id' then
      v_customer_id := new.customer_profile_id;
    elsif to_jsonb(new) ? 'customer_id' then
      v_customer_id := new.customer_id;
    end if;

    if v_customer_id is not null then
      perform public.apply_loyalty_event(
        v_salon_id,
        v_customer_id,
        v_booking_id,
        null,
        v_points,
        1,
        'booking_completed'
      );
    end if;
  end if;

  return new;
end;
$$;

do $$
begin
  if to_regclass('public.invoices') is not null then
    drop trigger if exists trg_invoice_paid_loyalty on public.invoices;
    create trigger trg_invoice_paid_loyalty
    after update on public.invoices
    for each row
    execute procedure public.handle_invoice_paid_loyalty();
  end if;

  if to_regclass('public.bookings') is not null then
    drop trigger if exists trg_booking_completed_loyalty on public.bookings;
    create trigger trg_booking_completed_loyalty
    after update on public.bookings
    for each row
    execute procedure public.handle_booking_completed_loyalty();
  elsif to_regclass('public.appointments') is not null then
    drop trigger if exists trg_appointment_completed_loyalty on public.appointments;
    create trigger trg_appointment_completed_loyalty
    after update on public.appointments
    for each row
    execute procedure public.handle_booking_completed_loyalty();
  end if;
end
$$;

insert into public.loyalty_levels (salon_id, level, threshold_points, reward_type, reward_value)
select s.id, l.level, l.threshold_points, l.reward_type, l.reward_value
from public.salons s
cross join (
  values
    ('bronze', 0, null::text, null::numeric),
    ('silver', 250, 'percentage'::text, 3::numeric),
    ('gold', 600, 'percentage'::text, 5::numeric),
    ('platinum', 1200, 'fixed'::text, 10::numeric)
) as l(level, threshold_points, reward_type, reward_value)
on conflict (salon_id, level) do nothing;
