-- Maa Sharda General Marketplace — initial Supabase schema
-- REVIEW BEFORE APPLYING. This file is not yet applied to any database.
-- Security model: authenticated users only; admins are identified in public.user_profiles.
create extension if not exists pgcrypto;

create table if not exists public.user_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  role text not null default 'customer' check (role in ('customer','trader','admin')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.suppliers (
  id uuid primary key default gen_random_uuid(),
  business_name text not null check (length(trim(business_name)) between 2 and 160),
  contact_name text,
  phone text,
  city text,
  state text,
  categories text[] not null default '{}',
  verification_status text not null default 'pending' check (verification_status in ('pending','verified','rejected')),
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  display_name text not null check (length(trim(display_name)) between 2 and 160),
  phone text,
  city text,
  customer_type text not null default 'retail' check (customer_type in ('retail','wholesale','shopkeeper')),
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  supplier_id uuid references public.suppliers(id) on delete set null,
  name text not null check (length(trim(name)) between 2 and 180),
  category text not null,
  description text not null default '',
  wholesale_price numeric(12,2) check (wholesale_price is null or wholesale_price >= 0),
  retail_price numeric(12,2) check (retail_price is null or retail_price >= 0),
  unit_label text not null default 'piece',
  minimum_order numeric(12,2) not null default 1 check (minimum_order > 0),
  stock_quantity numeric(12,2) not null default 0 check (stock_quantity >= 0),
  is_published boolean not null default false,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.trader_applications (
  id uuid primary key default gen_random_uuid(),
  business_name text not null,
  owner_name text not null,
  phone text not null,
  city text not null,
  category text not null,
  supply_type text not null check (supply_type in ('wholesale','both')),
  details text not null default '',
  consent_at timestamptz not null default now(),
  status text not null default 'pending' check (status in ('pending','under_review','approved','rejected')),
  reviewed_by uuid references auth.users(id) on delete set null,
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  order_number text not null unique default ('MS-' || upper(substr(replace(gen_random_uuid()::text,'-',''),1,10))),
  customer_id uuid references public.customers(id) on delete set null,
  buyer_user_id uuid references auth.users(id) on delete set null,
  status text not null default 'inquiry' check (status in ('inquiry','confirmed','packed','shipped','delivered','cancelled')),
  subtotal numeric(12,2) not null default 0 check (subtotal >= 0),
  currency text not null default 'INR' check (currency = 'INR'),
  notes text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  product_name_snapshot text not null,
  unit_price numeric(12,2) not null check (unit_price >= 0),
  quantity numeric(12,2) not null check (quantity > 0),
  line_total numeric(12,2) generated always as (unit_price * quantity) stored
);

create table if not exists public.audit_logs (
  id bigint generated always as identity primary key,
  actor_user_id uuid references auth.users(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists products_public_category_idx on public.products(is_published, category);
create index if not exists products_supplier_idx on public.products(supplier_id);
create index if not exists applications_status_created_idx on public.trader_applications(status, created_at desc);
create index if not exists orders_buyer_created_idx on public.orders(buyer_user_id, created_at desc);
create index if not exists audit_logs_created_idx on public.audit_logs(created_at desc);

create or replace function public.is_marketplace_admin()
returns boolean language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.user_profiles p
    where p.id = (select auth.uid()) and p.role = 'admin'
  );
$$;

alter table public.user_profiles enable row level security;
alter table public.suppliers enable row level security;
alter table public.customers enable row level security;
alter table public.products enable row level security;
alter table public.trader_applications enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.audit_logs enable row level security;

-- Profiles: users may see/update their own profile, but cannot self-promote to admin.
drop policy if exists "profile_select_self_or_admin" on public.user_profiles;
create policy "profile_select_self_or_admin" on public.user_profiles for select to authenticated
using (id = (select auth.uid()) or public.is_marketplace_admin());
drop policy if exists "profile_update_self_non_admin" on public.user_profiles;
create policy "profile_update_self_non_admin" on public.user_profiles for update to authenticated
using (id = (select auth.uid()) and role <> 'admin')
with check (id = (select auth.uid()) and role <> 'admin');

-- Public visitors can only read published product listings and verified supplier business cards.
drop policy if exists "public_read_published_products" on public.products;
create policy "public_read_published_products" on public.products for select to anon, authenticated
using (is_published = true);
drop policy if exists "public_read_verified_suppliers" on public.suppliers;
create policy "public_read_verified_suppliers" on public.suppliers for select to anon, authenticated
using (verification_status = 'verified');

-- Admin-only operational data access.
drop policy if exists "admin_manage_suppliers" on public.suppliers;
create policy "admin_manage_suppliers" on public.suppliers for all to authenticated
using (public.is_marketplace_admin()) with check (public.is_marketplace_admin());
drop policy if exists "admin_manage_customers" on public.customers;
create policy "admin_manage_customers" on public.customers for all to authenticated
using (public.is_marketplace_admin()) with check (public.is_marketplace_admin());
drop policy if exists "admin_manage_products" on public.products;
create policy "admin_manage_products" on public.products for all to authenticated
using (public.is_marketplace_admin()) with check (public.is_marketplace_admin());
drop policy if exists "admin_manage_applications" on public.trader_applications;
create policy "admin_manage_applications" on public.trader_applications for all to authenticated
using (public.is_marketplace_admin()) with check (public.is_marketplace_admin());
drop policy if exists "admin_manage_orders" on public.orders;
create policy "admin_manage_orders" on public.orders for all to authenticated
using (public.is_marketplace_admin()) with check (public.is_marketplace_admin());
drop policy if exists "admin_manage_order_items" on public.order_items;
create policy "admin_manage_order_items" on public.order_items for all to authenticated
using (public.is_marketplace_admin()) with check (public.is_marketplace_admin());
drop policy if exists "admin_read_audit_logs" on public.audit_logs;
create policy "admin_read_audit_logs" on public.audit_logs for select to authenticated
using (public.is_marketplace_admin());

-- New applications are accepted only from signed-in users; public visitors cannot submit anonymous PII.
drop policy if exists "signed_in_submit_application" on public.trader_applications;
create policy "signed_in_submit_application" on public.trader_applications for insert to authenticated
with check (status = 'pending' and reviewed_by is null and reviewed_at is null);

-- Do not grant anon/authenticated direct writes to audit_logs. Record privileged actions through trusted server code.
comment on table public.audit_logs is 'Admin-readable audit trail; write only from trusted server-side service role.';
comment on table public.orders is 'Payment collection is intentionally not implemented in this initial schema.';
