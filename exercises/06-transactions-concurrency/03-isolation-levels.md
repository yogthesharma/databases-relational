# Exercise: Isolation levels

Read: `notes/06-transactions-concurrency/03-isolation-levels.md`

## Tasks

1. What is Postgres’s default isolation level?
2. Show it with SQL (`SHOW`…).
3. Start a transaction at `REPEATABLE READ` (correct statement order).
4. In one sentence: how does Read Committed differ from Repeatable Read for two `SELECT`s of the same row in one txn?
5. What should your app do when it sees `could not serialize access`?

## Stretch

Does Postgres “Read Uncommitted” allow dirty reads? (Check docs/notes.)

---

## Solutions

1. **Read Committed**.
2. `SHOW transaction_isolation;` → `read committed`.
3.

```sql
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT balance FROM tx_lab.accounts WHERE name = 'alice';
COMMIT;
```

4. RC: second select can see new commits. RR: same snapshot for both.
5. **Retry** the whole transaction (and make it idempotent).

Stretch: No — in Postgres it’s treated like Read Committed; dirty reads don’t happen.
