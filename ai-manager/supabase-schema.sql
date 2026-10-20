-- माँ शारदा जनरल स्टोर AI Manager — initial Supabase schema draft
-- Apply only to the dedicated project after owner confirms the target project.
-- Owner-only RLS, no public/anonymous business-data access. No DELETE policies for financial records.
create extension if not exists pgcrypto;

create table if not exists public.shops (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid not null references auth.users(id) on delete restrict,
  business_name text not null default 'माँ शारदा जनरल स्टोर',
  proprietor text not null default 'मनोज गौर',
  mobile text not null default '9098682878',
  address text not null default 'बागसेवनिया, भोपाल, मध्य प्रदेश, भारत',
  gst_registered boolean not null default false,
  gstin text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete restrict,
  product_code text not null,
  name text not null,
  category text,
  unit text not null default 'नग',
  stock numeric(14,3) not null default 0 check (stock >= 0),
  cost_price numeric(14,2) not null default 0 check (cost_price >= 0),
  retail_price numeric(14,2) not null default 0 check (retail_price >= 0),
  wholesale_price numeric(14,2) not null default 0 check (wholesale_price >= 0),
  min_stock numeric(14,3) not null default 0 check (min_stock >= 0),
  gst_rate numeric(5,2) not null default 0 check (gst_rate >= 0 and gst_rate <= 100),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(shop_id, product_code),
  unique(shop_id, name)
);

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete restrict,
  name text not null,
  mobile text,
  address text,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.suppliers (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete restrict,
  name text not null,
  mobile text,
  address text,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.purchases (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete restrict,
  purchase_no text not null,
  supplier_id uuid references public.suppliers(id) on delete restrict,
  supplier_invoice_no text,
  purchase_date date not null default current_date,
  subtotal numeric(14,2) not null check (subtotal >= 0),
  tax_amount numeric(14,2) not null default 0 check (tax_amount >= 0),
  total numeric(14,2) not null check (total >= 0),
  paid_amount numeric(14,2) not null default 0 check (paid_amount >= 0 and paid_amount <= total),
  payment_mode text not null check (payment_mode in ('cash','upi','bank','credit','partial')),
  status text not null default 'posted' check (status in ('draft','posted','void')),
  notes text,
  created_by uuid references auth.users(id) on delete restrict,
  created_at timestamptz not null default now(),
  unique(shop_id, purchase_no)
);

create table if not exists public.purchase_items (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete restrict,
  purchase_id uuid not null references public.purchases(id) on delete restrict,
  product_id uuid not null references public.products(id) on delete restrict,
  quantity numeric(14,3) not null check (quantity > 0),
  unit_cost numeric(14,2) not null check (unit_cost >= 0),
  tax_rate numeric(5,2) not null default 0 check (tax_rate >= 0 and tax_rate <= 100),
  tax_amount numeric(14,2) not null default 0 check (tax_amount >= 0),
  line_total numeric(14,2) not null check (line_total >= 0)
);

create table if not exists public.sales (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete restrict,
  invoice_no text not null,
  customer_id uuid references public.customers(id) on delete restrict,
  sale_date date not null default current_date,
  sale_type text not null check (sale_type in ('retail','wholesale')),
  subtotal numeric(14,2) not null check (subtotal >= 0),
  discount_amount numeric(14,2) not null default 0 check (discount_amount >= 0),
  tax_amount numeric(14,2) not null default 0 check (tax_amount >= 0),
  total numeric(14,2) not null check (total >= 0),
  paid_amount numeric(14,2) not null default 0 check (paid_amount >= 0 and paid_amount <= total),
  payment_mode text not null check (payment_mode in ('cash','upi','bank','credit','partial')),
  status text not null default 'posted' check (status in ('draft','posted','void')),
  notes text,
  created_by uuid references auth.users(id) on delete restrict,
  created_at timestamptz not null default now(),
  unique(shop_id, invoice_no)
);

create table if not exists public.sale_items (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete restrict,
  sale_id uuid not null references public.sales(id) on delete restrict,
  product_id uuid not null references public.products(id) on delete restrict,
  product_name_snapshot text not null,
  quantity numeric(14,3) not null check (quantity > 0),
  unit_price numeric(14,2) not null check (unit_price >= 0),
  unit_cost_snapshot numeric(14,2) not null check (unit_cost_snapshot >= 0),
  tax_rate numeric(5,2) not null default 0 check (tax_rate >= 0 and tax_rate <= 100),
  tax_amount numeric(14,2) not null default 0 check (tax_amount >= 0),
  line_total numeric(14,2) not null check (line_total >= 0)
);

create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete restrict,
  entry_type text not null check (entry_type in ('expense','other_income')),
  category text not null,
  description text,
  amount numeric(14,2) not null check (amount > 0),
  payment_mode text not null check (payment_mode in ('cash','upi','bank')),
  entry_date date not null default current_date,
  created_by uuid references auth.users(id) on delete restrict,
  created_at timestamptz not null default now()
);

create table if not exists public.settlements (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete restrict,
  party_type text not null check (party_type in ('customer','supplier')),
  customer_id uuid references public.customers(id) on delete restrict,
  supplier_id uuid references public.suppliers(id) on delete restrict,
  amount numeric(14,2) not null check (amount > 0),
  payment_mode text not null check (payment_mode in ('cash','upi','bank')),
  settlement_date date not null default current_date,
  note text,
  created_by uuid references auth.users(id) on delete restrict,
  created_at timestamptz not null default now(),
  check ((party_type='customer' and customer_id is not null and supplier_id is null)
      or (party_type='supplier' and supplier_id is not null and customer_id is null))
);

create table if not exists public.stock_movements (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete restrict,
  product_id uuid not null references public.products(id) on delete restrict,
  movement_type text not null check (movement_type in ('opening','purchase','sale','adjustment','return','void_reversal')),
  quantity_delta numeric(14,3) not null,
  reference_table text,
  reference_id uuid,
  note text,
  created_by uuid references auth.users(id) on delete restrict,
  created_at timestamptz not null default now()
);

create table if not exists public.audit_logs (
  id bigint generated always as identity primary key,
  shop_id uuid not null references public.shops(id) on delete restrict,
  actor_user_id uuid references auth.users(id) on delete restrict,
  action text not null,
  entity_type text not null,
  entity_id text,
  before_data jsonb,
  after_data jsonb,
  reason text,
  created_at timestamptz not null default now()
);

create index if not exists products_shop_category_idx on public.products(shop_id, category);
create index if not exists sales_shop_date_idx on public.sales(shop_id, sale_date desc);
create index if not exists purchases_shop_date_idx on public.purchases(shop_id, purchase_date desc);
create index if not exists expenses_shop_date_idx on public.expenses(shop_id, entry_date desc);
create index if not exists audit_shop_time_idx on public.audit_logs(shop_id, created_at desc);
create index if not exists stock_movements_shop_product_idx on public.stock_movements(shop_id, product_id, created_at desc);

-- RLS on every exposed business table. Access is limited to the shop owner.
do $$
declare t text;
begin
  foreach t in array array['shops','products','customers','suppliers','purchases','purchase_items','sales','sale_items','expenses','settlements','stock_movements','audit_logs']
  loop
    execute format('alter table public.%I enable row level security', t);
  end loop;
end $$;

drop policy if exists shops_owner_select on public.shops;
create policy shops_owner_select on public.shops for select to authenticated using (owner_user_id = (select auth.uid()));
drop policy if exists shops_owner_insert on public.shops;
create policy shops_owner_insert on public.shops for insert to authenticated with check (owner_user_id = (select auth.uid()));
drop policy if exists shops_owner_update on public.shops;
create policy shops_owner_update on public.shops for update to authenticated using (owner_user_id = (select auth.uid())) with check (owner_user_id = (select auth.uid()));

do $
declare t text;
begin
  -- Reference data can be edited by the owner.
  foreach t in array array['products','customers','suppliers']
  loop
    execute format('drop policy if exists owner_select on public.%I', t);
    execute format('create policy owner_select on public.%I for select to authenticated using (exists (select 1 from public.shops s where s.id = shop_id and s.owner_user_id = (select auth.uid())))', t);
    execute format('drop policy if exists owner_insert on public.%I', t);
    execute format('create policy owner_insert on public.%I for insert to authenticated with check (exists (select 1 from public.shops s where s.id = shop_id and s.owner_user_id = (select auth.uid())))', t);
    execute format('drop policy if exists owner_update on public.%I', t);
    execute format('create policy owner_update on public.%I for update to authenticated using (exists (select 1 from public.shops s where s.id = shop_id and s.owner_user_id = (select auth.uid()))) with check (exists (select 1 from public.shops s where s.id = shop_id and s.owner_user_id = (select auth.uid())))', t);
  end loop;
  -- Posted transactions, stock movements and audit logs are append-only to normal clients.
  -- Corrections must be implemented as explicit void/reversal records by a reviewed server-side workflow.
  foreach t in array array['purchases','purchase_items','sales','sale_items','expenses','settlements','stock_movements','audit_logs']
  loop
    execute format('drop policy if exists owner_select on public.%I', t);
    execute format('create policy owner_select on public.%I for select to authenticated using (exists (select 1 from public.shops s where s.id = shop_id and s.owner_user_id = (select auth.uid())))', t);
    execute format('drop policy if exists owner_insert on public.%I', t);
    execute format('create policy owner_insert on public.%I for insert to authenticated with check (exists (select 1 from public.shops s where s.id = shop_id and s.owner_user_id = (select auth.uid())))', t);
    execute format('drop policy if exists owner_update on public.%I', t);
    execute format('drop policy if exists owner_delete on public.%I', t);
  end loop;
end $;

-- Intentionally no DELETE policies for business records. Use void/reversal entries with a reason.
-- Production follow-up: enforce shop_id consistency across parent/child references with constraints/triggers,
-- implement atomic sale/purchase posting RPCs that update stock and write audit_logs,
-- add immutable audit log policies, server-side backups, and test GST invoice rules before live use.
