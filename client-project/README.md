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

## Current status
This is a planning/staging document, not a claim that the new repository, database, authentication, or production deployment already exists.
