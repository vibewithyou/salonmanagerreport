-- Aufgabe 15: POS MVP (Invoice + Payment)

create extension if not exists pgcrypto;

create table if not exists public.invoices (
  id uuid primary key default gen_random_uuid(),
  salon_id uuid not null references public.salons(id) on delete cascade,
  number text not null,
  customer_id uuid null references public.customers(id) on delete set null,
  subtotal numeric(12,2) not null default 0,
  tax numeric(12,2) not null default 0,
  total numeric(12,2) not null default 0,
  status text not null default 'open' check (status in ('open', 'paid', 'partial', 'refunded')),
  created_at timestamptz not null default now()
);

create table if not exists public.invoice_items (
  id uuid primary key default gen_random_uuid(),
  invoice_id uuid not null references public.invoices(id) on delete cascade,
  type text not null check (type in ('service', 'product')),
  ref_id uuid not null,
  qty int not null check (qty > 0),
  unit_price numeric(12,2) not null,
  tax_rate numeric(5,4) not null default 0.19,
  total numeric(12,2) not null
);

create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),
  invoice_id uuid not null references public.invoices(id) on delete cascade,
  amount numeric(12,2) not null,
  method text not null check (method in ('cash', 'card')),
  status text not null default 'succeeded' check (status in ('succeeded', 'failed')),
  created_at timestamptz not null default now()
);

create index if not exists idx_invoices_salon_id on public.invoices(salon_id);
create index if not exists idx_invoices_customer_id on public.invoices(customer_id);
create index if not exists idx_invoice_items_invoice_id on public.invoice_items(invoice_id);
create index if not exists idx_payments_invoice_id on public.payments(invoice_id);

alter table public.invoices enable row level security;
alter table public.invoice_items enable row level security;
alter table public.payments enable row level security;

create policy "invoices staff manager salonwide crud"
  on public.invoices
  for all
  using (
    salon_id in (
      select e.salon_id
      from public.employees e
      where e.user_id = auth.uid()
    )
    or salon_id in (
      select s.id
      from public.salons s
      where s.owner_id = auth.uid()
    )
  )
  with check (
    salon_id in (
      select e.salon_id
      from public.employees e
      where e.user_id = auth.uid()
    )
    or salon_id in (
      select s.id
      from public.salons s
      where s.owner_id = auth.uid()
    )
  );

create policy "invoice items staff manager salonwide crud"
  on public.invoice_items
  for all
  using (
    invoice_id in (
      select i.id
      from public.invoices i
      where i.salon_id in (
        select e.salon_id
        from public.employees e
        where e.user_id = auth.uid()
      )
      or i.salon_id in (
        select s.id
        from public.salons s
        where s.owner_id = auth.uid()
      )
    )
  )
  with check (
    invoice_id in (
      select i.id
      from public.invoices i
      where i.salon_id in (
        select e.salon_id
        from public.employees e
        where e.user_id = auth.uid()
      )
      or i.salon_id in (
        select s.id
        from public.salons s
        where s.owner_id = auth.uid()
      )
    )
  );

create policy "payments staff manager salonwide crud"
  on public.payments
  for all
  using (
    invoice_id in (
      select i.id
      from public.invoices i
      where i.salon_id in (
        select e.salon_id
        from public.employees e
        where e.user_id = auth.uid()
      )
      or i.salon_id in (
        select s.id
        from public.salons s
        where s.owner_id = auth.uid()
      )
    )
  )
  with check (
    invoice_id in (
      select i.id
      from public.invoices i
      where i.salon_id in (
        select e.salon_id
        from public.employees e
        where e.user_id = auth.uid()
      )
      or i.salon_id in (
        select s.id
        from public.salons s
        where s.owner_id = auth.uid()
      )
    )
  );

create policy "customers can read own invoices"
  on public.invoices
  for select
  using (
    customer_id in (
      select c.id
      from public.customers c
      where c.user_id = auth.uid()
    )
  );
