create table if not exists public.salon_tax_config (
  salon_id uuid primary key references public.salons(id) on delete cascade,
  default_rate numeric(5,4) not null default 0.19,
  reduced_rate numeric(5,4) not null default 0.07,
  updated_at timestamptz not null default now()
);

create table if not exists public.product_tax_overrides (
  product_id uuid primary key,
  tax_rate numeric(5,4) not null,
  updated_at timestamptz not null default now()
);

alter table public.salon_tax_config enable row level security;
alter table public.product_tax_overrides enable row level security;

create policy if not exists salon_tax_config_select_for_members
on public.salon_tax_config
for select
using (
  exists (
    select 1
    from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = salon_tax_config.salon_id
  )
);

create policy if not exists salon_tax_config_upsert_for_manager
on public.salon_tax_config
for all
using (
  exists (
    select 1
    from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = salon_tax_config.salon_id
      and ur.role in ('admin','owner','manager')
  )
)
with check (
  exists (
    select 1
    from public.user_roles ur
    where ur.user_id = auth.uid()
      and ur.salon_id = salon_tax_config.salon_id
      and ur.role in ('admin','owner','manager')
  )
);

create policy if not exists product_tax_overrides_select_for_members
on public.product_tax_overrides
for select
using (
  exists (
    select 1
    from public.services s
    join public.user_roles ur on ur.salon_id = s.salon_id
    where s.id = product_tax_overrides.product_id
      and ur.user_id = auth.uid()
  )
);

create policy if not exists product_tax_overrides_manage_for_manager
on public.product_tax_overrides
for all
using (
  exists (
    select 1
    from public.services s
    join public.user_roles ur on ur.salon_id = s.salon_id
    where s.id = product_tax_overrides.product_id
      and ur.user_id = auth.uid()
      and ur.role in ('admin','owner','manager')
  )
)
with check (
  exists (
    select 1
    from public.services s
    join public.user_roles ur on ur.salon_id = s.salon_id
    where s.id = product_tax_overrides.product_id
      and ur.user_id = auth.uid()
      and ur.role in ('admin','owner','manager')
  )
);
