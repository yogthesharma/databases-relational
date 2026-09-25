# Locks and deadlocks

## Row locks you’ll use

| Clause | Effect |
|--------|--------|
| `SELECT … FOR UPDATE` | Lock rows as if updating; others’ `FOR UPDATE` / `UPDATE` wait |
| `SELECT … FOR SHARE` | Shared lock; readers can share; writers wait |
| `UPDATE` / `DELETE` | Take row locks automatically |

```sql
BEGIN;
SELECT * FROM tx_lab.accounts WHERE name = 'alice' FOR UPDATE;
-- critical section: only this txn holds the row
UPDATE tx_lab.accounts SET balance = balance - 10 WHERE name = 'alice';
COMMIT;  -- lock released
```

`FOR UPDATE` without a transaction is almost useless (lock released at end of statement in autocommit).

## Blocking vs deadlocks

- **Blocking:** B waits until A commits/rolls back — normal.
- **Deadlock:** A waits for B and B waits for A → Postgres aborts one with `deadlock detected` (SQLSTATE `40P01`). **Retry** the loser.

### Mini deadlock sketch (two sessions)

Lock order matters. If A locks alice then bob, B should too — not bob then alice.

Session A:

```sql
BEGIN;
SELECT * FROM tx_lab.accounts WHERE name = 'alice' FOR UPDATE;
-- then later: lock bob
```

Session B:

```sql
BEGIN;
SELECT * FROM tx_lab.accounts WHERE name = 'bob' FOR UPDATE;
-- then tries alice → deadlock if A is waiting on bob
```

## Takeaway

`FOR UPDATE` serializes critical rows inside a transaction. Consistent lock ordering reduces deadlocks; always retry `40P01`.
