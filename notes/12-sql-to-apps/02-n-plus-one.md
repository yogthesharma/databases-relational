# N+1 queries and batching

## The bug

```text
SELECT * FROM orders WHERE user_id = $1;   -- 1 query
-- then for each order:
SELECT * FROM items WHERE order_id = $1;   -- N queries
```

Looks fine locally with 3 rows. Melts in production with thousands.

## Fixes

| Fix | Idea |
|-----|------|
| Join / subquery | One round-trip returns parent + children |
| `WHERE id = ANY($1)` | Batch load by PK list |
| DataLoader / loader | App-layer batching (GraphQL common) |
| ORM `include` / `prefetch` | Only if you verify the SQL |

## How to spot it

Log SQL in tests/dev. Count statements per request. If it grows with list length → N+1.

## Takeaway

N+1 is the #1 ORM footgun. Measure query count; batch or join.
