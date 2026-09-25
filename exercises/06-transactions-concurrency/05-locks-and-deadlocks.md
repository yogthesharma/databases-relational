# Exercise: Locks & deadlocks

Read: `notes/06-transactions-concurrency/05-locks-and-deadlocks.md`

Reset lab first.

## Tasks

1. Why is `SELECT … FOR UPDATE` weak in autocommit (no `BEGIN`)?
2. In a transaction, lock alice with `FOR UPDATE`, then update her balance by `-1`, then `COMMIT`.
3. Two-session: A locks alice with `FOR UPDATE` and holds the txn open. B runs `UPDATE … WHERE name = 'alice'`. What does B do until A finishes?
4. Difference between `FOR UPDATE` and `FOR SHARE` in one line.
5. What SQLSTATE do you retry on deadlock? What habit prevents many deadlocks?

## Stretch

Sketch (words) a deadlock between alice and bob locks.

---

## Solutions

1. The lock is released when the statement’s transaction ends — immediately in autocommit.
2.

```sql
BEGIN;
SELECT * FROM tx_lab.accounts WHERE name = 'alice' FOR UPDATE;
UPDATE tx_lab.accounts SET balance = balance - 1 WHERE name = 'alice';
COMMIT;
```

3. B **blocks** (waits) until A `COMMIT`/`ROLLBACK`.
4. `FOR UPDATE` = exclusive intent to write; `FOR SHARE` = shared read lock (writers wait).
5. `40P01`; lock resources in a **consistent order**.

Stretch: A locks alice then waits for bob; B locks bob then waits for alice → Postgres aborts one.
