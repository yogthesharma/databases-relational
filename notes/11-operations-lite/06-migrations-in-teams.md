# Migrations in real teams

## Expand / contract (again)

Same idea as Module 4, now with teammates and prod traffic:

1. **Expand** — additive, compatible change  
2. **Migrate data** — backfill  
3. **Deploy app** that uses the new shape  
4. **Contract** — drop old columns when safe  

## Team practices

- Migrations reviewed like code  
- Applied in order per environment  
- Never hand-edit prod without a script in git  
- Rehearse on a staging copy  

Lab resets (`DROP SCHEMA CASCADE`) are **not** production migrations.

## Takeaway

Zero-downtime schema change is a process, not a single `ALTER`. Coordinate app deploys with expand/contract.
