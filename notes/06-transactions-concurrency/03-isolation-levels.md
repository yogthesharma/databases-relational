# Isolation levels

## Postgres levels (you’ll use these)

| Level | Default? | Rough promise |
|-------|----------|----------------|
| **Read Committed** | **Yes** | Each statement sees only committed data; later statements in the same txn can see new commits |
| **Repeatable Read** | | Snapshot at first query; stable reads; some write conflicts abort |
| **Serializable** | | Feels like serial execution; more aborts under contention |
| Read Uncommitted | | In Postgres, same as Read Committed (no dirty reads) |

```sql
SHOW transaction_isolation;  -- read committed

BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- … work …
COMMIT;
```

`SET TRANSACTION` must be the first statement after `BEGIN` (or use `START TRANSACTION ISOLATION LEVEL …`).

## What changes for you

- **Read Committed:** two `SELECT`s in one txn can see different committed values (non-repeatable read / phantoms possible).
- **Repeatable Read (Postgres):** snapshot from first query — stable reads, **no phantoms** here (stronger than SQL-standard RR); write conflicts / write skew still matter; may raise `could not serialize access`.
- **Serializable:** strongest against serialization anomalies (including write skew); treat failures as retryable.

## Node angle

Most Node apps run at default Read Committed and add `SELECT … FOR UPDATE` (or atomic `UPDATE`s) for critical rows. Bump isolation only when you understand the abort/retry path.

## Takeaway

Default Read Committed is fine for many apps. Use Repeatable Read / Serializable when you need snapshot stability — and **retry** on serialization errors.
