# Transactions: BEGIN, COMMIT, ROLLBACK, savepoints

## What a transaction is

A **transaction** groups SQL so it either all lands (`COMMIT`) or none does (`ROLLBACK`). Until you commit, other sessions typically don’t see your writes (Postgres default: Read Committed).

```sql
BEGIN;

UPDATE tx_lab.accounts SET balance = balance - 20 WHERE name = 'alice';
UPDATE tx_lab.accounts SET balance = balance + 20 WHERE name = 'bob';

COMMIT;   -- both stick
-- or ROLLBACK;  -- both undone
```

Autocommit: each statement outside an explicit `BEGIN` is its own tiny transaction.

## ROLLBACK undoes uncommitted work

```sql
BEGIN;
UPDATE tx_lab.accounts SET balance = 0 WHERE name = 'alice';
SELECT balance FROM tx_lab.accounts WHERE name = 'alice';  -- 0 in this session
ROLLBACK;
SELECT balance FROM tx_lab.accounts WHERE name = 'alice';  -- back to 100
```

## Savepoints — partial undo inside a transaction

After an **error**, Postgres aborts the whole transaction until `ROLLBACK` (or `ROLLBACK TO savepoint`). Use savepoints to recover and keep going:

```sql
BEGIN;

UPDATE tx_lab.accounts SET balance = balance - 10 WHERE name = 'alice';

SAVEPOINT before_bad;
UPDATE tx_lab.accounts SET balance = balance - 1000 WHERE name = 'bob';
-- ERROR: check constraint (balance >= 0)  → transaction aborted

ROLLBACK TO before_bad;   -- undo only the bad update; alice -10 still pending

UPDATE tx_lab.accounts SET balance = balance + 10 WHERE name = 'carol';
COMMIT;
```

## Node angle

`pg` / pools: one client connection → one transaction. Don’t interleave two logical transactions on the same client. Prefer `BEGIN`…`COMMIT` around multi-step money moves.

## Takeaway

`BEGIN` / `COMMIT` / `ROLLBACK` for all-or-nothing. Savepoints after expected failures. Errors abort the txn until you roll back (to savepoint or fully).
