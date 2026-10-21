# GBSBFY Affiliate Credits — Pilot Plan

## Purpose
Pilot a closed-use digital credit ledger for eligible affiliate commissions earned from books sold through Maa Sharda General Market Place. This pilot is an internal accounting feature, not a deployed cryptocurrency or promise of cash value.

## Principles
- Initial pilot uses an off-chain ledger and free-tier tools; no blockchain deployment or paid service is required.
- Credit units may be redeemed only for services or products explicitly approved by GBSBFORYOU and listed in published terms.
- Credits are not automatically redeemable for cash, transferable to external wallets, or accepted as general payment.
- Any future cash redemption, transferability, on-chain token launch, or rupee peg requires separate legal, tax, accounting, and consumer-protection review.
- Affiliate commission eligibility is based on verified paid orders and the published affiliate policy; cancelled, fraudulent, or refunded orders may be adjusted under that policy.
- Keep a complete audit trail for credits issued, redeemed, reversed, and adjusted.

## Suggested pilot workflow
1. Record the order ID, book/product, sale amount, affiliate ID, commission rate, and order status.
2. Calculate commission only after the order qualifies under the affiliate terms.
3. Record a unique credit ledger entry with timestamp, amount, reason, and reference order ID.
4. Allow redemption only against approved GBSBFORYOU products/services through an authorized checkout flow.
5. On refunds or cancellations, record a reversal entry; do not silently delete ledger history.
6. Reconcile order, commission, and credit balances regularly.

## Ledger fields
- ledger_entry_id
- created_at
- affiliate_account_id
- order_reference
- entry_type (issue, redeem, reversal, adjustment)
- commission_amount_in_INR (accounting reference)
- credit_units
- reason
- status
- operator/reference note

Do not store passwords, private keys, seed phrases, or unnecessary personal data in the ledger. Restrict access to authorized administrators and publish a privacy notice.

## Example only
If a qualifying book order is ₹500 and the approved commission rate is 10%, the commission reference is ₹50. A policy could award 50 credit units, but this example does not establish that 1 credit equals ₹1 or has cash value. Final rates and redemption terms must be approved before launch.

## Status
Planning document only. No affiliate credit system is yet implemented by this file. Before production use, implement authentication, role-based access, validation, backups, audit logging, and test the refund/reversal workflow.
