# Partial and expression indexes

## Partial indexes

Index only the rows you query:

```sql
CREATE INDEX orders_pending_created_idx
  ON perf_lab.orders (created_at)
  WHERE status = 'pending';

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, user_id, created_at
FROM perf_lab.orders
WHERE status = 'pending'
  AND created_at >= TIMESTAMPTZ '2024-01-01';
```

Smaller index, cheaper writes for non-pending rows. The `WHERE` in the query must match (or be implied by) the predicate.

## Expression indexes

When you search on an expression, index that expression:

```sql
CREATE INDEX users_email_lower_idx
  ON perf_lab.users (LOWER(email));

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, email FROM perf_lab.users
WHERE LOWER(email) = LOWER('user42@example.com');
```

`WHERE email = …` won’t use `LOWER(email)` index — the expression must match.

Soft-delete preview (from Module 4): unique live emails → partial unique index `WHERE deleted_at IS NULL`.

## Takeaway

Partial = “only rows I care about.” Expression = “index what I actually write in `WHERE`.”
