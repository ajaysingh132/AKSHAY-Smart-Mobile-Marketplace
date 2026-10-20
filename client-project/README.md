# Maa Sharda General Marketplace — Client Project

This folder is the isolated staging package for the client-owned marketplace. It is intentionally separated from GBSBFORYOU products and must be moved to the dedicated repository `Maa-Sharda-General-Marketplace` before production handover.

## Product direction
- Brand: Maa Sharda General Marketplace
- Language: Hindi-first, mobile-first
- Visual identity: deep forest green, warm ivory, brass/gold accents, clean editorial typography, rounded commerce cards
- Branches:
  1. Wholesale marketplace (B2B)
  2. Retail marketplace (B2C)
  3. Admin panel (restricted access)
  4. Wholesale trader registration board

## Separation rules
- Do not reuse any GBSBFORYOU database or Supabase project.
- Create a dedicated Supabase project for this client.
- Never place service-role keys, passwords, or private secrets in frontend code or Git.
- Use Supabase Auth for administrator login and role-based authorization.
- Enable Row Level Security on every client data table.
- Public users may read only approved/published products and submit registration inquiries.
- Only authorized admins may approve traders, edit listings, view customer details, or manage orders.
- Use audit records for sensitive admin actions.
- Keep demo records clearly labelled as demo and never treat them as real merchants.

## Database modules planned
- profiles / roles
- trader_applications
- suppliers / merchants
- customers (private)
- product_categories
- products / product_images
- inventory_movements
- orders / order_items
- payments / payment_events
- audit_logs

## Delivery gates
1. Create a dedicated GitHub repository in the developer account.
2. Move this staging folder and the approved marketplace frontend into it.
3. Create and verify the dedicated Supabase project and cost plan.
4. Apply reviewed SQL migrations and RLS policies.
5. Connect frontend through environment-safe public project URL and publishable key only.
6. Configure Supabase Auth; create the first admin through an invitation/secure setup flow.
7. Test unauthenticated access, role boundaries, demo data replacement, backup/restore, mobile layouts, and deployment.
8. Transfer repository, hosting, Supabase ownership, and operating documentation to the client when agreed.

## Current status (updated 2026-10-20)
- Dedicated Supabase project created: `Maa-Sharda-General-Marketplace`.
- Supabase project reference: `bmetxrjywxpmgmilggop` (region: `ap-south-1`, status reported `ACTIVE_HEALTHY`).
- Initial migration applied successfully; verified tables: `user_profiles`, `suppliers`, `customers`, `products`, `trader_applications`, `orders`, `order_items`, `audit_logs`.
- Marketplace visual styling updated in `marketplace/index.html`.
- Dedicated GitHub repository is still pending; current files remain in the existing repository under `client-project/` and `marketplace/`.
- Supabase Auth is not yet connected to the frontend; no first admin has been provisioned. Do not use the current localStorage admin panel for sensitive live data.
- No production deployment, payment integration, backup/restore test, or client ownership transfer has been completed yet.

## Next implementation steps
1. Create the independent GitHub repository `Maa-Sharda-General-Marketplace` under `ajaysingh132` and move the approved source files into it.
2. Configure Supabase Auth and safe frontend configuration using only the publishable key (never the service-role key in the browser).
3. Set up a first administrator securely, test role restrictions and RLS from anonymous and authenticated sessions, and connect the four branches to the database.
4. Test backup/restore, mobile behavior, and deployment before accepting real customer data.
5. Transfer repository, hosting, Supabase ownership, and documentation to the client when agreed.
