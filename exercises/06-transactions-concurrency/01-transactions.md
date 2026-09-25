# Exercise: Transactions

Read: `notes/06-transactions-concurrency/01-transactions.md`

Reset the lab if balances look wrong.

## Tasks

1. In one transaction, move `10` from `alice` to `bob`, then `COMMIT`. Show both balances.
2. Start a transaction, set `carol`’s balance to `0`, `SELECT` it, then `ROLLBACK`. What is carol’s balance after?
3. Why do you need a `SAVEPOINT` after a failing statement inside a transaction?
4. Demo: `BEGIN` → subtract `1000` from `bob` (should fail CHECK) → without savepoint, try another `SELECT`. What happens? Fix with `ROLLBACK`.
5. Using a savepoint, subtract `5` from `alice`, attempt an overdraft on `bob`, roll back to the savepoint, add `5` to `carol`, and `COMMIT`.

## Stretch

What does autocommit mean for a single `UPDATE` outside `BEGIN`?

---

## Solutions

1.

```sql
BEGIN;
UPDATE tx_lab.accounts SET balance = balance - 10 WHERE name = 'alice';
UPDATE tx_lab.accounts SET balance = balance + 10 WHERE name = 'bob';
COMMIT;
SELECT name, balance FROM tx_lab.accounts WHERE name IN ('alice', 'bob') ORDER BY name;
```

2. After `ROLLBACK`, carol is still `25.00` (seed).

3. An error **aborts** the transaction; further commands fail until `ROLLBACK` / `ROLLBACK TO savepoint`.

4. You’ll see `current transaction is aborted` on the next command → `ROLLBACK;`.

5.

```sql
BEGIN;
UPDATE tx_lab.accounts SET balance = balance - 5 WHERE name = 'alice';
SAVEPOINT before_bad;
UPDATE tx_lab.accounts SET balance = balance - 1000 WHERE name = 'bob';  -- fails
ROLLBACK TO before_bad;
UPDATE tx_lab.accounts SET balance = balance + 5 WHERE name = 'carol';
COMMIT;
```

Stretch: each standalone statement is its own transaction (commits on success).
