# Triggers

## Lab trigger

On `INSERT`/`UPDATE` of `title`/`body`, the trigger rebuilds `search_vector` and sets `updated_at`.

```sql
UPDATE feat_lab.articles
SET body = body || ' Updated.'
WHERE slug = 'postgres-jsonb'
RETURNING slug, updated_at, search_vector IS NOT NULL AS has_vector;
```

## Use sparingly

Good: audit columns, search vectors, enforce cross-row rules hard to express in CHECKs.  

Bad: hiding business workflows (“trigger sends email”), deep trigger chains (debugging hell).

## Statement vs row

`FOR EACH ROW` (lab) vs `FOR EACH STATEMENT`. Prefer row triggers for per-row derived data.

## Takeaway

Triggers maintain derived data next to the write. Keep them short, obvious, and tested — or use generated columns / app transactions instead.
